import XCTest
@testable import Lixiang
import LixiangCalendarCore

private struct SlowEngine: CalendarEngine {
    let base = LunarSwiftEngine(festivalScope: .cn)
    var festivalScope: FestivalScope { base.festivalScope }
    func lunarDate(_ date: LocalDate, hour: Int) -> LunarDate { base.lunarDate(date, hour: hour) }
    func almanac(_ date: LocalDate, hour: Int) -> AlmanacDay {
        Thread.sleep(forTimeInterval: 0.25)   // 模拟 Duo 首次慢计算
        return base.almanac(date, hour: hour)
    }
}

@MainActor
final class SelectedDayPrepareRaceTests: XCTestCase {
    func testStalePrepareDoesNotOverwriteNewSelection() async {
        let old = LocalDate(2026, 11, 14)
        let new = LocalDate(2026, 12, 22)
        let store = SelectedDayStore(engine: SlowEngine(), today: old, hourProvider: { 12 }, deferCompute: true)
        let task = Task { await store.prepare() }
        await Task.yield()
        store.select(new)
        await task.value
        XCTAssertEqual(store.selectedDate, new)
        XCTAssertEqual(store.almanac.date, new, "旧 prepare 不得覆写新日期缓存")
        XCTAssertEqual(store.festivals, store.almanac.festivals)
        XCTAssertTrue(store.ready)
    }
}
