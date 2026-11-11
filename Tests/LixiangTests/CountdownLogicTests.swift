import XCTest
import LixiangCalendarCore
@testable import Lixiang

/// 倒计日逻辑用例（QA NOTRUN 补齐：2-29/闰月/导出导入/提醒拒绝态）
@MainActor
final class CountdownLogicTests: XCTestCase {
    private let engine = LunarSwiftEngine(festivalScope: .cn)

    func testFeb29PolicyDefaultsAndSwitch() {
        func item(_ policy: Feb29Policy) -> Anniversary {
            Anniversary(title: "2/29", calendar: .gregorian, month: 2, day: 29, repeatRule: .yearly, feb29Policy: policy)
        }
        let now = LocalDate(2027, 1, 1)          // 2027 非闰年
        XCTAssertEqual(AnniversaryResolver.occurrence(for: item(.feb28), now: now, engine: engine)?.date, LocalDate(2027, 2, 28))
        XCTAssertEqual(AnniversaryResolver.occurrence(for: item(.mar01), now: now, engine: engine)?.date, LocalDate(2027, 3, 1))
        XCTAssertEqual(AnniversaryResolver.occurrence(for: item(.skip), now: now, engine: engine)?.date, LocalDate(2028, 2, 29))
        let leap = LocalDate(2028, 1, 1)         // 2028 闰年仍 2/29
        XCTAssertEqual(AnniversaryResolver.occurrence(for: item(.feb28), now: leap, engine: engine)?.date, LocalDate(2028, 2, 29))
    }

    func testLunarLeapMonthOccurrence() {
        let leap = Anniversary(title: "闰六月", calendar: .lunar, month: 6, day: 1, isLeapMonth: true, repeatRule: .yearly)
        let occ = AnniversaryResolver.occurrence(for: leap, now: LocalDate(2025, 1, 1), engine: engine)
        XCTAssertEqual(occ?.date, LocalDate(2025, 7, 25))
        XCTAssertNil(AnniversaryResolver.occurrence(for: leap, now: LocalDate(2026, 1, 1), engine: engine))
    }

    func testExportImportRoundTripKeepsFields() throws {
        let items = [
            Anniversary(title: "生日", calendar: .lunar, month: 1, day: 1, isLeapMonth: false,
                        repeatRule: .yearly, reminderEnabled: true, reminderHour: 9, note: "农历"),
            Anniversary(title: "2/29", calendar: .gregorian, month: 2, day: 29,
                        repeatRule: .once, feb29Policy: .mar01, reminderEnabled: false)
        ]
        let data = try JSONEncoder().encode(items)
        let decoded = try JSONDecoder().decode([Anniversary].self, from: data)
        XCTAssertEqual(decoded, items)   // 字段不丢（农历/闰月/2-29/提醒/备注）
    }

    func testStorePersistenceAndReminderDenied() {
        let store = AnniversaryStore(seed: false)
        let before = store.items.count
        let item = Anniversary(title: "测试条目", calendar: .gregorian, month: 12, day: 31, repeatRule: .once)
        store.add(item)
        XCTAssertEqual(store.items.count, before + 1)
        let reloaded = AnniversaryStore(seed: false)
        XCTAssertTrue(reloaded.items.contains { $0.id == item.id })
        store.delete(item)
        XCTAssertFalse(store.items.contains { $0.id == item.id })
        store.markNotificationDenied(true)
        XCTAssertTrue(AnniversaryStore(seed: false).notificationDenied)
        store.markNotificationDenied(false)
    }
}
