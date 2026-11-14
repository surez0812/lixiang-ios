import XCTest
@testable import Lixiang
import LixiangCalendarCore

@MainActor
final class FolklorePastReadabilityTests: XCTestCase {
    private let engine = LunarSwiftEngine(festivalScope: .cn)

    func testPastFestivalIsReadableAndNotLocked() throws {
        let now = LocalDate(2026, 11, 14)   // 重阳 2026-10-18，过去 27 天
        let items = ContentCatalog.all
        let resolved = ContentResolver.resolve(items: items, now: now, engine: engine)
        let row = try XCTUnwrap(resolved.first { $0.item.id == "chongyang" })
        let info = try XCTUnwrap(row.stateInfo(regionID: nil, now: now))
        XCTAssertEqual(info.state, .past)
        XCTAssertTrue(FolkloreReadability.isReadable(info), "过去节日必须可读，不能被判 locked")
        XCTAssertEqual(FolkloreReadability.offsetText(info), "已过去")
        XCTAssertEqual(FolkloreReadability.statusText(isReadable: true, info: info), "已解锁")
    }

    func testFutureBeyondTenDaysStaysLocked() throws {
        let now = LocalDate(2026, 11, 14)
        let resolved = ContentResolver.resolve(items: ContentCatalog.all, now: now, engine: engine)
        let future = try XCTUnwrap(resolved.first { ($0.stateInfo(regionID: nil, now: now)?.daysUntil ?? 0) > 10 })
        let info = try XCTUnwrap(future.stateInfo(regionID: nil, now: now))
        XCTAssertFalse(FolkloreReadability.isReadable(info), "未来 >10 天仍 locked")
        XCTAssertEqual(FolkloreReadability.statusText(isReadable: false, info: info), "未解锁")
    }
}
