import Foundation
import CryptoKit

/// B′ 静态发布 manifest（FRD v1.3 / P2-F7-WEBVIEW §1）
public struct ManifestEntry: Codable, Hashable, Sendable, Identifiable {
    public var slug: String
    public var title: String
    public var unlockDate: LocalDate        // UTC+8 日期（YYYY-MM-DD）
    public var contentVersion: String       // 如 v1.0.3
    public var sha256: String               // 正文 HTML 的 sha256（hex）
    public var updatedAt: String            // ISO8601
    public var id: String { slug }

    public init(slug: String, title: String, unlockDate: LocalDate,
                contentVersion: String, sha256: String, updatedAt: String) {
        self.slug = slug; self.title = title; self.unlockDate = unlockDate
        self.contentVersion = contentVersion; self.sha256 = sha256; self.updatedAt = updatedAt
    }

    enum CodingKeys: String, CodingKey { case slug, title, unlockDate, contentVersion, sha256, updatedAt }

    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        slug = try c.decode(String.self, forKey: .slug)
        title = try c.decode(String.self, forKey: .title)
        let raw = try c.decode(String.self, forKey: .unlockDate)
        guard let date = LocalDate(raw) else { throw ManifestError.malformed }
        unlockDate = date
        contentVersion = try c.decode(String.self, forKey: .contentVersion)
        sha256 = try c.decode(String.self, forKey: .sha256)
        updatedAt = try c.decode(String.self, forKey: .updatedAt)
    }

    public func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(slug, forKey: .slug)
        try c.encode(title, forKey: .title)
        try c.encode(unlockDate.iso, forKey: .unlockDate)
        try c.encode(contentVersion, forKey: .contentVersion)
        try c.encode(sha256, forKey: .sha256)
        try c.encode(updatedAt, forKey: .updatedAt)
    }
}

public struct ContentManifest: Codable, Hashable, Sendable {
    public var schemaVersion: Int
    public var generatedAt: String
    public var items: [ManifestEntry]

    public init(schemaVersion: Int, generatedAt: String, items: [ManifestEntry]) {
        self.schemaVersion = schemaVersion
        self.generatedAt = generatedAt
        self.items = items
    }

    public func entry(slug: String) -> ManifestEntry? { items.first { $0.slug == slug } }
}

public enum ManifestError: Error, Equatable {
    case malformed
    case missingEntry
}

public enum ManifestParser {
    public static func parse(_ data: Data) throws -> ContentManifest {
        struct RawEntry: Decodable {
            var slug: String
            var title: String
            var unlockDate: String
            var contentVersion: String
            var sha256: String
            var updatedAt: String
        }
        struct Raw: Decodable {
            var schemaVersion: Int?
            var generatedAt: String?
            var items: [RawEntry]
        }
        guard let raw = try? JSONDecoder().decode(Raw.self, from: data) else { throw ManifestError.malformed }
        var entries: [ManifestEntry] = []
        for e in raw.items {
            guard let date = LocalDate(e.unlockDate), e.sha256.count == 64 else { throw ManifestError.malformed }
            entries.append(ManifestEntry(slug: e.slug, title: e.title, unlockDate: date,
                                         contentVersion: e.contentVersion, sha256: e.sha256, updatedAt: e.updatedAt))
        }
        return ContentManifest(schemaVersion: raw.schemaVersion ?? 1,
                               generatedAt: raw.generatedAt ?? "",
                               items: entries)
    }
}

/// App 侧解锁判定（UTC+8 日期；服务端只发布已解锁正文，未解锁返回 404）
public enum ContentUnlock {
    public enum State: String, Sendable, Hashable {
        case locked, unlocked, past
    }
    public static func state(unlockDate: LocalDate, now: LocalDate) -> State {
        if now < unlockDate { return .locked }
        if now == unlockDate { return .unlocked }
        return .past
    }
    /// 解锁日期距今（正=未来，负=已过）
    public static func daysUntil(unlockDate: LocalDate, now: LocalDate) -> Int {
        now.daysBetween(unlockDate)
    }
}

/// 整页缓存键 = slug + contentVersion + sha256
public struct ContentCacheKey: Hashable, Sendable {
    public var slug: String
    public var contentVersion: String
    public var sha256: String
    public init(slug: String, contentVersion: String, sha256: String) {
        self.slug = slug; self.contentVersion = contentVersion; self.sha256 = sha256
    }
    public var fileName: String {
        let short = String(sha256.prefix(12))
        return "\(slug)_\(contentVersion)_\(short).html"
    }
}

public enum SHA256 {
    public static func hex(_ string: String) -> String {
        let digest = CryptoKit.SHA256.hash(data: Data(string.utf8))
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    public static func hex(_ data: Data) -> String {
        CryptoKit.SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }
    public static func matches(_ text: String, expected: String) -> Bool {
        hex(text).caseInsensitiveCompare(expected) == .orderedSame
    }
}
