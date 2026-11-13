import Foundation
import LixiangCalendarCore

/// 岁时未读：按 `eventID@contentVersion` 记录；进入 Tab 不清空，只在指定版本内容成功展示后标读。
@MainActor
final class FolkloreUnreadStore: ObservableObject {
    static let shared = FolkloreUnreadStore()

    @Published private(set) var readKeys: Set<String>
    private let defaults: UserDefaults
    private let storageKey = "folklore.read.keys.v1"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if let data = defaults.data(forKey: storageKey),
           let keys = try? JSONDecoder().decode([String].self, from: data) {
            readKeys = Set(keys)
        } else {
            readKeys = []
        }
    }

    static func key(itemID: String, version: Int) -> String { "\(itemID)@\(version)" }
    static func key(_ item: ContentItem) -> String { key(itemID: item.id, version: item.version) }

    func isRead(_ item: ContentItem) -> Bool { readKeys.contains(Self.key(item)) }
    func isRead(itemID: String, version: Int) -> Bool { readKeys.contains(Self.key(itemID: itemID, version: version)) }

    /// 仅在正文成功展示后调用。
    func markRead(_ item: ContentItem) {
        let key = Self.key(item)
        guard !readKeys.contains(key) else { return }
        readKeys.insert(key)
        persist()
    }

    func unreadCount(_ items: [ContentItem]) -> Int {
        items.reduce(0) { $0 + (isRead($1) ? 0 : 1) }
    }

    func resetAll() {
        readKeys = []
        persist()
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(Array(readKeys).sorted()) {
            defaults.set(data, forKey: storageKey)
        }
    }
}
