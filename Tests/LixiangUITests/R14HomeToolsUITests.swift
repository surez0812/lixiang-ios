import XCTest

/// HOME-TOOLS：双卡等高/标题行对齐/操作 ≥44pt；Dynamic Type xLarge。
final class R14HomeToolsUITests: XCTestCase {
    private func assertTools(_ app: XCUIApplication, label: String) {
        let fortune = app.staticTexts["每日一签"]
        let weather = app.staticTexts["今日天气"]
        XCTAssertTrue(fortune.waitForExistence(timeout: 40), "\(label) 每日一签未出现")
        XCTAssertTrue(weather.waitForExistence(timeout: 20), "\(label) 今日天气未出现")
        XCTAssertEqual(fortune.frame.midY, weather.frame.midY, accuracy: 2, "\(label) 标题行未水平对齐")
        let action = app.buttons["开启定位"]
        XCTAssertTrue(action.exists, "\(label) 操作按钮未出现")
        XCTAssertGreaterThanOrEqual(action.frame.height, 44, "\(label) 操作点击区域 <44pt")
        let a = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        a.name = "hometools-\(label)"; a.lifetime = .keepAlways; add(a)
    }

    func testToolsPhoneAndXL() throws {
        for (args, tag) in [([], "phone"), (["-LixiangTypeScale", "xl"], "xl")] {
            let app = XCUIApplication()
            app.launchArguments = args
            app.launch()
            XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
            assertTools(app, label: tag)
            app.terminate()
        }
    }
}
