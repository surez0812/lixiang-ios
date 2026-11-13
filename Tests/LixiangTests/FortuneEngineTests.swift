import XCTest
@testable import Lixiang

final class FortuneEngineTests: XCTestCase {
    private func sign(_ id: String, _ no: Int) -> FortuneSign {
        FortuneSign(id: id, type: "lixiang-original", no: no, level: "上", title: "题\(no)",
                    poem: ["一", "二", "三", "四"], explain: "解释", advice: "建议", keywords: [])
    }

    func testDayKeyUsesAsiaShanghai() {
        let f = ISO8601DateFormatter()
        // 2026-11-12T16:30:00Z = 2026-11-13 00:30 +0800
        let date = f.date(from: "2026-11-12T16:30:00Z")!
        XCTAssertEqual(FortuneEngine.dayKey(for: date), "2026-11-13")
        let date2 = f.date(from: "2026-11-12T15:30:00Z")!
        XCTAssertEqual(FortuneEngine.dayKey(for: date2), "2026-11-12")
    }

    func testPickIsDeterministic() {
        let signs = (1...10).map { sign("s\($0)", $0) }
        let a = FortuneEngine.pick(dayKey: "2026-11-13", contentVersion: "v1", signs: signs)
        let b = FortuneEngine.pick(dayKey: "2026-11-13", contentVersion: "v1", signs: signs)
        XCTAssertEqual(a?.id, b?.id)
        XCTAssertNotNil(a)
    }

    func testPickVariesAcrossDays() {
        let signs = (1...10).map { sign("s\($0)", $0) }
        let ids = (1...20).map { d in
            FortuneEngine.pick(dayKey: "2026-11-\(String(format: "%02d", d))", contentVersion: "v1", signs: signs)?.id
        }
        XCTAssertGreaterThan(Set(ids.compactMap { $0 }).count, 1)
    }

    func testPickEmptySignsReturnsNil() {
        XCTAssertNil(FortuneEngine.pick(dayKey: "2026-11-13", contentVersion: "v1", signs: []))
    }
}
