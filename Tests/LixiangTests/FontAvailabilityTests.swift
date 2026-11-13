import XCTest
@testable import Lixiang

final class FontAvailabilityTests: XCTestCase {
    func testFontAvailabilityReport() {
        let report = D1Typography.availabilityReport()
        print("FONT_AVAILABILITY_BEGIN\n\(report)\nFONT_AVAILABILITY_END")
        XCTAssertFalse(report.isEmpty)
    }
}
