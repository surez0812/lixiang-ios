import XCTest
@testable import Lixiang
import CoreGraphics

final class R14DailyLayoutTests: XCTestCase {
    func testDailyWideBreakpoints() {
        XCTAssertTrue(DailyLayout.isWide(CGSize(width: 1194, height: 834)))
        XCTAssertTrue(DailyLayout.isWide(CGSize(width: 1366, height: 1024)))
        XCTAssertFalse(DailyLayout.isWide(CGSize(width: 834, height: 1194)))
        XCTAssertFalse(DailyLayout.isWide(CGSize(width: 375, height: 812)))
        XCTAssertFalse(DailyLayout.isWide(CGSize(width: 900, height: 900)))
    }
}
