import XCTest
@testable import Lixiang
import LixiangCalendarCore

@MainActor
final class R14HomeAlmanacCompassTests: XCTestCase {
    func testAlmanacLayoutBreakpoint() {
        XCTAssertEqual(AlmanacLayout.columns(width: 375), 1)
        XCTAssertEqual(AlmanacLayout.columns(width: 743), 1)
        XCTAssertEqual(AlmanacLayout.columns(width: 744), 2)
        XCTAssertEqual(AlmanacLayout.columns(width: 1194), 2)
    }

    func testCalendarGridMondayFirstAnd42Cells() {
        let grid = R14CalendarGrid().cells(for: LocalDate(2026, 11, 13))
        XCTAssertEqual(grid.count, 42)
        XCTAssertEqual(grid.first, LocalDate(2026, 10, 26)) // 2026-11-01 周日 → 周一开头补 6 天
        XCTAssertTrue(grid.contains(LocalDate(2026, 11, 13)))
        XCTAssertEqual(grid[41], LocalDate(2026, 12, 6))
    }

    func testCompassLayoutMatchesAlmanacAndSha() {
        let engine = LunarSwiftEngine(festivalScope: .cn)
        let date = LocalDate(2026, 12, 22)
        let a = engine.almanac(date, hour: 12)
        let layout = CompassBuilder.layout(for: a)
        XCTAssertEqual(layout.present.count + layout.missing.count, Deity.allCases.count)
        XCTAssertEqual(layout.sha, a.sha)
        XCTAssertEqual(Set(layout.present.map(\.deity)).union(layout.missing), Set(Deity.allCases))
    }

    func testAlmanacSelectedDayFieldsComplete() {
        let store = SelectedDayStore(today: LocalDate(2026, 12, 22), hourProvider: { 12 })
        XCTAssertFalse(store.almanac.yi.isEmpty)
        XCTAssertFalse(store.almanac.ji.isEmpty)
        XCTAssertFalse(store.almanac.tianShen.isEmpty)
        XCTAssertFalse(store.almanac.chongDesc.isEmpty)
        XCTAssertFalse(store.almanac.taiShen.isEmpty)
        XCTAssertFalse(store.almanac.pengZuGan.isEmpty)
        XCTAssertFalse(store.almanac.xiu.isEmpty)
        XCTAssertFalse(store.almanac.zhiXing.isEmpty)
        XCTAssertEqual(store.shichen.count, 13)
        XCTAssertEqual(store.matchedFestivals, store.almanac.festivals)
    }

    func testHourCompassUsesHourShaWhenAvailable() {
        let engine = LunarSwiftEngine(festivalScope: .cn)
        let a = engine.almanac(LocalDate(2026, 11, 11), hour: 12)
        let hasHourSha = a.hours.contains { $0.sha != nil }
        XCTAssertTrue(hasHourSha || a.sha != nil, "至少日/时煞方之一可用，不允许空白")
    }
}
