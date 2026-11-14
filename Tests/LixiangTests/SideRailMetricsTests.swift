import XCTest
@testable import Lixiang

final class SideRailMetricsTests: XCTestCase {
    func testDesignGeometryConstants() {
        XCTAssertEqual(R14SideRail.right, 23)
        XCTAssertEqual(R14SideRail.width, 50)
        XCTAssertEqual(R14SideRail.height, 252)
        XCTAssertEqual(R14SideRail.top, 401)
        XCTAssertEqual(R14SideRail.slotHeight, 48)
        XCTAssertEqual(R14SideRail.tabWidth, 44)
        XCTAssertEqual(R14SideRail.icon, 25)
    }

    func testExpectedXSceneCoordinates() {
        XCTAssertEqual(R14SideRail.expectedX(sceneWidth: 951), 878, "设计 scene 951：x=878（right=23）")
        XCTAssertEqual(R14SideRail.expectedX(sceneWidth: 1032), 959)
    }

    func testDerivedTotalsMatchDesign() {
        // 5 slots 等高 + 上下 padding = 252
        XCTAssertEqual(R14SideRail.slotHeight * 5 + R14SideRail.verticalPadding * 2, R14SideRail.height)
        // tab 44 居中在 50 宽胶囊内
        XCTAssertEqual(R14SideRail.tabWidth + R14SideRail.horizontalPadding * 2, R14SideRail.width)
        XCTAssertGreaterThanOrEqual(R14SideRail.reservedWidth, R14SideRail.width + 8)
    }
}
