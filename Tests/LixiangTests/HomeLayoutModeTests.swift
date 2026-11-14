import XCTest
@testable import Lixiang

final class HomeLayoutModeTests: XCTestCase {
    func testClosedLandscapeTriggersCompact() {
        // Duo Closed Landscape 运行宽度约 594，高度小于宽
        XCTAssertEqual(R14HomeLayoutMode.mode(width: 594, height: 360), .compact)
        XCTAssertEqual(R14HomeLayoutMode.mode(width: 480, height: 320), .compact)
        XCTAssertEqual(R14HomeLayoutMode.mode(width: 700, height: 400), .compact)
    }

    func testPhonePortraitStaysStandard() {
        XCTAssertEqual(R14HomeLayoutMode.mode(width: 402, height: 874), .standard)
        XCTAssertEqual(R14HomeLayoutMode.mode(width: 479, height: 320), .standard)
    }

    func testWideIPadLandscapeUsesWide() {
        XCTAssertEqual(R14HomeLayoutMode.mode(width: 1024, height: 768), .wide)
        XCTAssertEqual(R14HomeLayoutMode.mode(width: 1376, height: 1032), .wide)
        XCTAssertEqual(R14HomeLayoutMode.mode(width: 744, height: 500), .wide)
    }

    func testIPadPortraitStaysSingleColumn() {
        XCTAssertEqual(R14HomeLayoutMode.mode(width: 1032, height: 1376), .standard)
        XCTAssertEqual(R14HomeLayoutMode.mode(width: 744, height: 1024), .standard)
    }

    func testDebugForceOnly() {
        XCTAssertEqual(R14HomeLayoutMode.mode(width: 402, height: 874, forceCompact: true), .compact)
    }
}
