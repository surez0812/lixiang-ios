import Foundation
import LixiangCalendarCore

enum ContentPhase: Equatable {
    case loading
    case locked
    case ready
    case offlineCached
    case offlineUncached
    case error
}

struct ContentLoadResult: Equatable {
    var phase: ContentPhase
    var entry: ManifestEntry?
    var html: String?
    var cached: Bool = false
    var message: String?
}

/// B′ 内容仓库：manifest + 整页缓存（slug+version+sha256）+ sha256 校验 + 静默刷新
actor ContentRepository {
    private let source: ContentSource
    private let now: LocalDate
    private let mode: ContentNetworkMode
    private let cacheRoot: URL
    private let typeScale: Double

    init(source: ContentSource, now: LocalDate, mode: ContentNetworkMode, typeScale: Double = 1.0) {
        self.source = source
        self.now = now
        self.mode = mode
        self.typeScale = typeScale
        let base = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSTemporaryDirectory())
        self.cacheRoot = base.appendingPathComponent("LixiangContentCache", isDirectory: true)
        try? FileManager.default.createDirectory(at: cacheRoot, withIntermediateDirectories: true)
        if ProcessInfo.processInfo.arguments.contains("-LixiangCacheState"),
           let idx = ProcessInfo.processInfo.arguments.firstIndex(of: "-LixiangCacheState"),
           idx + 1 < ProcessInfo.processInfo.arguments.count,
           ProcessInfo.processInfo.arguments[idx + 1] == "empty" {
            try? FileManager.default.removeItem(at: cacheRoot)
            try? FileManager.default.createDirectory(at: cacheRoot, withIntermediateDirectories: true)
        }
    }

    func load(slug: String) async -> ContentLoadResult {
        // 1) manifest（离线时用已缓存 manifest）
        var manifest: ContentManifest?
        var usedCachedManifest = false
        do {
            manifest = try await source.manifest()
            if let manifest { try? saveManifest(manifest) }
        } catch {
            manifest = loadCachedManifest()
            usedCachedManifest = manifest != nil
        }
        guard let manifest, let entry = manifest.entry(slug: slug) else {
            return ContentLoadResult(phase: mode == .offline ? .offlineUncached : .error)
        }
        // 2) App 侧 UTC+8 解锁判定（离线不改）
        if ContentUnlock.state(unlockDate: entry.unlockDate, now: now) == .locked {
            return ContentLoadResult(phase: .locked, entry: entry)
        }
        // 3) 缓存命中（sha256 校验）
        let key = ContentCacheKey(slug: slug, contentVersion: entry.contentVersion, sha256: entry.sha256)
        if let cachedHTML = readCache(key), SHA256.matches(cachedHTML, expected: entry.sha256) {
            if mode == .offline {
                return ContentLoadResult(phase: .offlineCached, entry: entry, html: injectScale(cachedHTML), cached: true)
            }
            // 静默刷新：后台拉新版，下次打开替换
            Task { [weak self] in await self?.refreshInBackground(slug: slug, current: entry) }
            return ContentLoadResult(phase: .ready, entry: entry, html: injectScale(cachedHTML), cached: true)
        }
        // 4) 未缓存
        if mode == .offline {
            return ContentLoadResult(phase: .offlineUncached, entry: entry)
        }
        do {
            let page = try await source.page(slug: slug)
            guard SHA256.matches(page.html, expected: page.entry.sha256) else {
                return ContentLoadResult(phase: .error, entry: entry, message: "内容校验失败，请重试")
            }
            let pageKey = ContentCacheKey(slug: slug, contentVersion: page.entry.contentVersion, sha256: page.entry.sha256)
            try? writeCache(pageKey, html: page.html)
            return ContentLoadResult(phase: .ready, entry: page.entry, html: injectScale(page.html), cached: false)
        } catch ContentSourceError.notPublished {
            return ContentLoadResult(phase: .locked, entry: entry)
        } catch {
            return ContentLoadResult(phase: mode == .offline ? .offlineUncached : .error, entry: entry)
        }
    }

    private func refreshInBackground(slug: String, current: ManifestEntry) async {
        guard let page = try? await source.page(slug: slug) else { return }
        guard page.entry.contentVersion != current.contentVersion || page.entry.sha256 != current.sha256 else { return }
        let key = ContentCacheKey(slug: slug, contentVersion: page.entry.contentVersion, sha256: page.entry.sha256)
        try? writeCache(key, html: page.html)
        pruneOldVersions(slug: slug, keep: page.entry.contentVersion)
    }

    // MARK: - 缓存读写
    private func url(_ key: ContentCacheKey) -> URL { cacheRoot.appendingPathComponent(key.fileName) }
    private func readCache(_ key: ContentCacheKey) -> String? {
        try? String(contentsOf: url(key), encoding: .utf8)
    }
    private func writeCache(_ key: ContentCacheKey, html: String) throws {
        try html.write(to: url(key), atomically: true, encoding: .utf8)
    }
    private func pruneOldVersions(slug: String, keep version: String) {
        guard let files = try? FileManager.default.contentsOfDirectory(at: cacheRoot, includingPropertiesForKeys: nil) else { return }
        for file in files where file.lastPathComponent.hasPrefix(slug + "_") && !file.lastPathComponent.contains(version) {
            try? FileManager.default.removeItem(at: file)
        }
    }
    private var manifestFile: URL { cacheRoot.appendingPathComponent("manifest.json") }
    private func saveManifest(_ manifest: ContentManifest) throws {
        let data = try JSONEncoder().encode(manifest)
        try data.write(to: manifestFile, options: .atomic)
    }
    private func loadCachedManifest() -> ContentManifest? {
        guard let data = try? Data(contentsOf: manifestFile) else { return nil }
        return try? JSONDecoder().decode(ContentManifest.self, from: data)
    }
    private func injectScale(_ html: String) -> String {
        html.replacingOccurrences(of: "<body>", with: "<body style=\"--scale:\(String(format: "%.2f", typeScale))\">")
    }
}

@MainActor
final class ContentViewModel: ObservableObject {
    @Published var result = ContentLoadResult(phase: .loading)
    private let repository: ContentRepository
    private let primer: ContentRepository?
    private let slug: String

    init(source: ContentSource, primeSource: ContentSource?, slug: String, now: LocalDate,
         mode: ContentNetworkMode, typeScale: Double) {
        self.slug = slug
        self.repository = ContentRepository(source: source, now: now, mode: mode, typeScale: typeScale)
        if let primeSource {
            self.primer = ContentRepository(source: primeSource, now: now, mode: .normal, typeScale: typeScale)
        } else {
            self.primer = nil
        }
    }

    func load() async {
        result.phase = .loading
        if let primer { _ = await primer.load(slug: slug) }   // 模拟“此前访问过”的缓存
        let loaded = await repository.load(slug: slug)
        self.result = loaded
    }
}
