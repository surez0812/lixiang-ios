import XCTest
import LixiangCalendarCore
@testable import Lixiang

final class SelectionEngineTests: XCTestCase {
    private let engine = SelectionEngine()

    func testInvertedRangeReturnsEmpty() {
        let p = SelectionPreferences(matter: .travel, start: LocalDate(2026, 11, 20), end: LocalDate(2026, 11, 10))
        XCTAssertTrue(engine.candidates(p).isEmpty)
    }

    func testCandidatesAreWithinRangeAndAuspicious() {
        let p = SelectionPreferences(matter: .travel, start: LocalDate(2026, 11, 1), end: LocalDate(2026, 11, 30))
        let out = engine.candidates(p)
        for r in out {
            XCTAssertTrue(r.date >= p.start && r.date <= p.end)
            XCTAssertTrue(engine.isAuspicious(r.almanac, for: .travel))
        }
    }

    func testWeekendOnly() {
        let p = SelectionPreferences(matter: .travel, start: LocalDate(2026, 11, 1), end: LocalDate(2026, 11, 30), weekendOnly: true)
        for r in engine.candidates(p) {
            XCTAssertTrue(r.date.weekdayIndex == 0 || r.date.weekdayIndex == 6)
        }
    }

    func testAvoidAnniversary() {
        let a = Anniversary(title: "生日", calendar: .gregorian, month: 11, day: 20, repeatRule: .yearly, reminderEnabled: false)
        let e = SelectionEngine(anniversaries: [a])
        let p = SelectionPreferences(matter: .travel, start: LocalDate(2026, 11, 1), end: LocalDate(2026, 11, 30), avoidAnniversaries: true)
        XCTAssertFalse(e.candidates(p).contains { $0.date == LocalDate(2026, 11, 20) })
    }

    func testKnownAuspiciousDay() {
        // 2026-11-12 设计样本：宜 出行/会友；只断言该日判定与数据一致，不依赖固定 fixture 作生产。
        let a = LunarSwiftEngine().almanac(LocalDate(2026, 11, 12), hour: 12)
        let expected = SelectionEngine().isAuspicious(a, for: .travel)
        XCTAssertEqual(expected, a.yi.contains { $0.contains("出行") } && !a.ji.contains { $0.contains("出行") })
    }
}
