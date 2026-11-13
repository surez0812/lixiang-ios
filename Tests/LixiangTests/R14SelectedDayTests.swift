import XCTest
@testable import Lixiang
import LixiangCalendarCore

@MainActor
final class R14SelectedDayTests: XCTestCase {
    private func makeStore(_ date: LocalDate) -> SelectedDayStore {
        SelectedDayStore(today: date, hourProvider: { 12 })
    }

    func testSelectRecomputesAlmanacFestivalsAndSha() {
        let store = makeStore(LocalDate(2026, 12, 22))
        XCTAssertEqual(store.selectedDate, LocalDate(2026, 12, 22))
        let firstGanZhi = store.almanac.lunar.dayGanZhi
        let firstSha = store.sha

        store.nextDay()
        XCTAssertEqual(store.selectedDate, LocalDate(2026, 12, 23))
        XCTAssertNotEqual(store.almanac.lunar.dayGanZhi, firstGanZhi, "改日必须整组重算黄历")
        XCTAssertTrue(store.shichen.count == 13, "时辰需随所选日重新生成")
        XCTAssertEqual(store.festivals, store.almanac.festivals)

        store.previousDay()
        XCTAssertEqual(store.selectedDate, LocalDate(2026, 12, 22))
        XCTAssertEqual(store.almanac.lunar.dayGanZhi, firstGanZhi)
        _ = firstSha
    }

    func testMonthAndYearBoundary() {
        let store = makeStore(LocalDate(2026, 12, 31))
        store.nextDay()
        XCTAssertEqual(store.selectedDate, LocalDate(2027, 1, 1))
        store.previousDay()
        XCTAssertEqual(store.selectedDate, LocalDate(2026, 12, 31))
    }

    func testLeapYearBoundary() {
        let store = makeStore(LocalDate(2028, 2, 28))
        store.nextDay()
        XCTAssertEqual(store.selectedDate, LocalDate(2028, 2, 29))
        store.nextDay()
        XCTAssertEqual(store.selectedDate, LocalDate(2028, 3, 1))
        store.previousDay()
        XCTAssertEqual(store.selectedDate, LocalDate(2028, 2, 29))
    }

    func testBeijingTodayAcrossTimeZoneBoundary() {
        // 2026-12-31 16:30 UTC = 2027-01-01 00:30 北京
        let utc = ISO8601DateFormatter().date(from: "2026-12-31T16:30:00Z")!
        XCTAssertEqual(LocalDate.beijingToday(now: utc), LocalDate(2027, 1, 1))
        let utc2 = ISO8601DateFormatter().date(from: "2026-12-31T15:59:00Z")!
        XCTAssertEqual(LocalDate.beijingToday(now: utc2), LocalDate(2026, 12, 31))
    }

    func testFestivalsStrictlyMatchSelectedDay() {
        let store = makeStore(LocalDate(2026, 12, 22))
        XCTAssertEqual(store.festivals, store.almanac.festivals)
        store.select(LocalDate(2026, 12, 25))
        XCTAssertEqual(store.festivals, store.almanac.festivals)
    }
}
