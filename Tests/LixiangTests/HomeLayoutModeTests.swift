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

    func testWideIPadUsesWide() {
        XCTAssertEqual(R14HomeLayoutMode.mode(width: 744, height: 1024), .wide)
        XCTAssertEqual(R14HomeLayoutMode.mode(width: 1024, height: 768), .wide)
    }

    func testDebugForceOnly() {
        XCTAssertEqual(R14HomeLayoutMode.mode(width: 402, height: 874, forceCompact: true), .compact)
    }
}
