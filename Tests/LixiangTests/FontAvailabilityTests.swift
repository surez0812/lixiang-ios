import XCTest
@testable import Lixiang

final class FontAvailabilityTests: XCTestCase {
    func testFontAvailabilityReport() {
        let report = D1Typography.availabilityReport()
        print("FONT_AVAILABILITY_BEGIN\n\(report)\nFONT_AVAILABILITY_END")
        XCTAssertFalse(report.isEmpty)
        XCTAssertNotNil(UIFont(name: D1Typography.notoSerifRegular, size: 17), "Noto Serif SC Regular 必须随 App 打包")
        XCTAssertNotNil(UIFont(name: D1Typography.notoSerifBold, size: 17), "Noto Serif SC Bold 必须随 App 打包")
        XCTAssertTrue(report.contains("noto_serif=true"), "字体报告应显示 Noto Serif 可用")
        XCTAssertEqual(D1Typography.serifStrategy, "NotoSerifCJKsc-fixedSize", "实际应加载 Noto Serif 且 fixedSize 路径")
        XCTAssertFalse(D1Typography.forceSerifFallback)
    }
}
