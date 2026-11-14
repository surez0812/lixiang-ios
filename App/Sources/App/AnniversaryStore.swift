import Foundation
import LixiangCalendarCore

/// 倒计日（内部类型仍为 Anniversary，Sure 2026-11-11 改名）
@MainActor
final class AnniversaryStore: ObservableObject {
    @Published private(set) var items: [Anniversary] = []
    @Published var notificationDenied = false

    private let key = "countdown.items.v1"
    private let deniedKey = "countdown.notificationDenied"

    init(seed: Bool = false) {
        load()
        notificationDenied = UserDefaults.standard.bool(forKey: deniedKey)
        if seed { seedSamples() }   // DEBUG: 每次覆盖为固定样例，确保月历 icon/路由可复现
    }

    func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Anniversary].self, from: data) else { return }
        items = decoded
    }

    func save() {
        if let data = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func add(_ item: Anniversary) { items.append(item); save() }
    func delete(_ item: Anniversary) { items.removeAll { $0.id == item.id }; save() }
    func update(_ item: Anniversary) {
        if let i = items.firstIndex(where: { $0.id == item.id }) { items[i] = item; save() }
    }

    func markNotificationDenied(_ denied: Bool) {
        notificationDenied = denied
        UserDefaults.standard.set(denied, forKey: deniedKey)
    }

    func exportURL() -> URL? {
        guard let data = try? JSONEncoder().encode(items) else { return nil }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("lixiang-countdown-\(Int(Date().timeIntervalSince1970)).json")
        try? data.write(to: url)
        return url
    }

    private func seedSamples() {
        items = [
            Anniversary(title: "生日", calendar: .lunar, month: 1, day: 1, repeatRule: .yearly,
                        reminderEnabled: true, note: "农历正月初一"),
            Anniversary(title: "纪念日", calendar: .gregorian, month: 12, day: 22, repeatRule: .yearly,
                        reminderEnabled: false),
            Anniversary(title: "出行", calendar: .gregorian, month: 11, day: 20, repeatRule: .yearly,
                        reminderEnabled: false, icon: "airplane")
        ]
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains("-LixiangSeedReminderOff") {
            items = items.map { item in
                var copy = item
                copy.reminderEnabled = false
                return copy
            }
        }
        #endif
        save()
    }
}
