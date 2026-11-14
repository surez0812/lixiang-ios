import Foundation
import LixiangCalendarCore

/// 内容目录：优先读取 App/Resources/Content/events.json（envelope `{version, items}` 或裸数组），
/// 缺失/解析失败回退内置 ContentFixtures（示例/version 0，保持“内容准备中”）。
/// 门禁：仅 `reviewStatus == "approved"` 且 `version > 0` 视为正式可读正文；其余条目可列表显示但详情走 pending。
enum ContentCatalog {
    struct LoadResult {
        var items: [ContentItem]
        var approvedIDs: Set<String>
        var source: String
        var version: Int? = nil
    }

    static let result: LoadResult = load()
    static var all: [ContentItem] { result.items }
    static var approvedIDs: Set<String> { result.approvedIDs }

    static func isApproved(id: String) -> Bool { result.approvedIDs.contains(id) }
    static func isApproved(_ item: ContentItem) -> Bool { item.version > 0 && item.reviewStatus == "approved" }

    static func load(bundle: Bundle = .main) -> LoadResult {
        let urls = [
            bundle.url(forResource: "events", withExtension: "json", subdirectory: "Content"),
            bundle.url(forResource: "events", withExtension: "json"),
        ].compactMap { $0 }
        for url in urls {
            if let data = try? Data(contentsOf: url), let parsed = parse(data), !parsed.items.isEmpty {
                return parsed
            }
        }
        // fallback：内置 fixtures（示例 content，不 approved）
        return LoadResult(items: ContentFixtures.all, approvedIDs: [], source: "fixtures-fallback")
    }

    static func parse(_ data: Data) -> LoadResult? {
        let items: [ContentItem]
        if let env = try? JSONDecoder().decode(Envelope.self, from: data) {
            items = env.items
        } else if let arr = try? JSONDecoder().decode([ContentItem].self, from: data) {
            items = arr
        } else {
            return nil
        }
        guard !items.isEmpty else { return nil }
        let approved = Set(items.filter { isApproved($0) }.map { $0.id })
        let version: Int?
        if let env = try? JSONDecoder().decode(Envelope.self, from: data) { version = env.version } else { version = nil }
        return LoadResult(items: items, approvedIDs: approved, source: "events.json", version: version)
    }

    private struct Envelope: Decodable {
        var version: Int?
        var items: [ContentItem]
    }
}
