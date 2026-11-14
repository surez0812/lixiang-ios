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

        // forced fallback：实际字体解析必须为 nil → 使用 system serif（不只断言 strategy）
        XCTAssertNil(D1Typography.serifFontName(weight: .regular, forceFallback: true))
        XCTAssertEqual(D1Typography.serifStrategy(forceFallback: true), "system-serif-forced")
        let forcedFont = D1Typography.serifFont(size: 17, weight: .regular, forceFallback: true)
        XCTAssertEqual(forcedFont, .system(size: 17, weight: .regular, design: .serif), "forced 时实际 Font 必须为 system serif")
        XCTAssertNotNil(D1Typography.serifFontName(weight: .regular, forceFallback: false), "正常时应有实际自定义字体")
        XCTAssertEqual(D1Typography.serifStrategy(forceFallback: false), "NotoSerifCJKsc-fixedSize")
    }
}
