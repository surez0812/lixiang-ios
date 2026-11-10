import Foundation
import LixiangCalendarCore
import CryptoKit

enum ContentNetworkMode: String { case normal, offline, error, slow, hang }

struct ContentPage: Sendable {
    var slug: String
    var html: String
    var entry: ManifestEntry
}

enum ContentSourceError: Error { case notPublished, network, malformed }

protocol ContentSource: Sendable {
    func manifest() async throws -> ContentManifest
    func page(slug: String) async throws -> ContentPage
    var siteBaseURL: URL { get }
}

/// 本地 mock（不依赖 ops /ceremony/）：由 P1 示例内容生成 manifest + HTML，模拟 404/离线/错误/慢网
struct SandboxContentSource: ContentSource {
    let engine: any CalendarEngine
    let now: LocalDate
    let mode: ContentNetworkMode
    let versionOverride: String?

    let siteBaseURL = URL(string: "https://lixiang.zhaoyao.xin/ceremony/")!

    private func unlockDate(for item: ContentItem) -> LocalDate {
        let resolution = ContentResolver.resolve(items: [item], now: now, engine: engine, pastDays: 370, futureDays: 420).first
        let region = item.regionalDates?.first?.id ?? "default"
        return resolution?.stateInfo(regionID: region, now: now)?.anchor
            ?? resolution?.regions.first.flatMap { resolution?.unlocks[$0.id]?.sorted().first }
            ?? item.dateRuleFallbackDate(now: now, engine: engine)
    }

    private func version() -> String { versionOverride ?? "v1.0.3" }

    private func html(for item: ContentItem) -> String {
        Self.renderHTML(item: item, version: version(), updatedAt: "2026-11-11")
    }

    private func manifestObject() -> ContentManifest {
        let items = ContentFixtures.all.map { item -> ManifestEntry in
            let html = html(for: item)
            return ManifestEntry(slug: item.id, title: item.title,
                                 unlockDate: unlockDate(for: item),
                                 contentVersion: version(), sha256: SHA256.hex(html),
                                 updatedAt: "2026-11-11T00:00:00+08:00")
        }
        return ContentManifest(schemaVersion: 1, generatedAt: "2026-11-11T00:00:00+08:00", items: items)
    }

    private func delayIfSlow() async throws {
        if mode == .slow { try? await Task.sleep(nanoseconds: 1_500_000_000) }
        if mode == .hang { try? await Task.sleep(nanoseconds: 9_000_000_000) }
        if mode == .offline { throw ContentSourceError.network }
        if mode == .error { throw ContentSourceError.network }
    }

    func manifest() async throws -> ContentManifest {
        try await delayIfSlow()
        return manifestObject()
    }

    func page(slug: String) async throws -> ContentPage {
        try await delayIfSlow()
        guard let item = ContentFixtures.all.first(where: { $0.id == slug }) else { throw ContentSourceError.notPublished }
        let unlock = unlockDate(for: item)
        // 服务端只发布已解锁正文：未解锁 → 404
        guard ContentUnlock.state(unlockDate: unlock, now: now) != .locked else { throw ContentSourceError.notPublished }
        let html = html(for: item)
        let entry = ManifestEntry(slug: slug, title: item.title, unlockDate: unlock,
                                  contentVersion: version(), sha256: SHA256.hex(html),
                                  updatedAt: "2026-11-11T00:00:00+08:00")
        return ContentPage(slug: slug, html: html, entry: entry)
    }

    // MARK: - HTML（本地示例正文；非最终内容）
    static func renderHTML(item: ContentItem, version: String, updatedAt: String) -> String {
        let sections = item.sections.map { section in
            """
            <section><h2>\(escape(section.title))</h2>
            \(section.paragraphs.map { "<p>\(escape($0))</p>" }.joined(separator: "\n"))
            </section>
            """
        }.joined(separator: "\n")
        return """
        <!doctype html><html lang="zh-Hans"><head><meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
        :root { color-scheme: light dark; }
        html { font-size: calc(16px * var(--scale, 1)); -webkit-text-size-adjust: 100%; }
        body { margin: 0; padding: 8px 4px 24px; background: transparent; color: #3A3028; font-family: -apple-system, "PingFang SC", sans-serif; line-height: 1.85; font-size: 0.66rem; }
        h1 { font-family: "Songti SC", serif; font-size: calc(1.4em * min(var(--scale, 1), 1.4)); margin: 0 0 10px; color: #3A3028; }
        h2 { font-family: "Songti SC", serif; font-size: 1.05em; margin: 20px 0 6px; color: #3A3028; }
        p { margin: 0 0 8px; color: #5C544A; }
        figure { margin: 14px 0; }
        .img { aspect-ratio: 16 / 9; border-radius: 14px; background: rgba(222,155,120,.14);
               display: flex; align-items: center; justify-content: center; color: #8A7462; font-size: 11px; }
        figcaption { font-size: 0.6em; color: #8A7462; margin-top: 4px; }
        footer { margin-top: 20px; font-size: 0.58em; color: #8A7462; }
        @media (prefers-color-scheme: dark) {
          body { color: #F3E8DA; } h1, h2 { color: #F3E8DA; } p { color: #C7B5A2; }
          .img { background: rgba(232,168,134,.14); color: #9A8774; }
          figcaption, footer { color: #9A8774; }
        }
        @media (prefers-color-scheme: dark) { body { background: transparent; } }
        </style></head><body>
        <h1>\(escape(item.title))</h1>
        <figure><div class="img" role="img" aria-label="配图占位（16:9）：待内容团队提供并登记许可">配图 16:9 · 待内容团队提供</div>
        <figcaption>图位 16:9 · 无来源不明图片</figcaption></figure>
        \(sections)
        <footer>内容版本 \(escape(version)) · 更新于 \(escape(updatedAt)) · 北京时间解锁 · 网页静态发布（B′）</footer>
        </body></html>
        """
    }

    private static func escape(_ text: String) -> String {
        text.replacingOccurrences(of: "&", with: "&amp;")
            .replacingOccurrences(of: "<", with: "&lt;")
            .replacingOccurrences(of: ">", with: "&gt;")
    }
}

extension ContentItem {
    func dateRuleFallbackDate(now: LocalDate, engine: any CalendarEngine) -> LocalDate {
        now
    }
}

/// 真内容（ops /ceremony/ 就绪后启用；本轮不依赖）
struct HTTPContentSource: ContentSource {
    let siteBaseURL: URL
    let session: URLSession = .shared

    func manifest() async throws -> ContentManifest {
        let url = siteBaseURL.appendingPathComponent("manifest.json")
        var request = URLRequest(url: url); request.cachePolicy = .reloadIgnoringLocalCacheData
        let (data, response) = try await session.data(for: request)
        guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw ContentSourceError.network }
        return try ManifestParser.parse(data)
    }

    func page(slug: String) async throws -> ContentPage {
        let url = siteBaseURL.appendingPathComponent(slug)
        let (data, response) = try await session.data(from: url)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        if status == 404 { throw ContentSourceError.notPublished }
        guard status == 200 else { throw ContentSourceError.network }
        guard let html = String(data: data, encoding: .utf8) else { throw ContentSourceError.malformed }
        let manifest = try await manifest()
        guard let entry = manifest.entry(slug: slug) else { throw ContentSourceError.malformed }
        guard SHA256.matches(html, expected: entry.sha256) else { throw ContentSourceError.malformed }
        return ContentPage(slug: slug, html: html, entry: entry)
    }
}
