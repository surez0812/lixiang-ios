import XCTest

/// iPad：竖屏单列 / 横屏两栏 / 详情 left-summary+right-article。
final class R14IPadLayoutUITests: XCTestCase {
    private func shot(_ name: String) {
        let a = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        a.name = name; a.lifetime = .keepAlways; add(a)
    }

    func testIPadPortraitSingleAndLandscapeTwoColumn() throws {
        XCUIDevice.shared.orientation = .portrait
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.staticTexts["今日黄历"].waitForExistence(timeout: 40))
        shot("ipad-portrait-home")
        XCTAssertTrue(app.buttons["日历"].exists)

        XCUIDevice.shared.orientation = .landscapeLeft
        sleep(2)
        XCTAssertTrue(app.staticTexts["今日黄历"].waitForExistence(timeout: 20))
        shot("ipad-landscape-home")
        app.terminate()

        // 详情横屏：左 summary / 右 hero+正文
        XCUIDevice.shared.orientation = .landscapeLeft
        let detail = XCUIApplication()
        detail.launchArguments = ["-LixiangTab", "1", "-LixiangR14Route", "chongyangDetail"]
        detail.launch()
        XCTAssertTrue(detail.staticTexts["重阳节"].waitForExistence(timeout: 40))
        XCTAssertTrue(detail.staticTexts["传统节日"].exists || detail.staticTexts["分享"].exists)
        shot("ipad-landscape-detail")
        detail.terminate()
        XCUIDevice.shared.orientation = .portrait
    }
}
