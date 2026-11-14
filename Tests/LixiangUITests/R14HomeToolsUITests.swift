import XCTest

/// HOME-TOOLS：双卡等高/标题行对齐/操作 ≥44pt；Dynamic Type xLarge。
final class R14HomeToolsUITests: XCTestCase {
    private func element(_ app: XCUIApplication, _ id: String) -> XCUIElement {
        app.descendants(matching: .any).matching(identifier: id).firstMatch
    }

    private func assertTools(_ app: XCUIApplication, label: String) {
        let fortune = app.staticTexts["每日一签"]
        let weather = app.staticTexts["今日天气"]
        XCTAssertTrue(fortune.waitForExistence(timeout: 40), "\(label) 每日一签未出现")
        XCTAssertTrue(weather.waitForExistence(timeout: 20), "\(label) 今日天气未出现")
        XCTAssertEqual(fortune.frame.midY, weather.frame.midY, accuracy: 2, "\(label) 标题行未水平对齐")

        // final adaptive：两卡等高、居中、下方 16pt
        let fortuneCard = element(app, "home.tool.fortune")
        let weatherCard = element(app, "home.tool.weather")
        let almanac = element(app, "home.card.almanac")
        XCTAssertTrue(fortuneCard.waitForExistence(timeout: 10), "\(label) 签卡容器缺失")
        XCTAssertTrue(weatherCard.exists, "\(label) 天气卡容器缺失")
        XCTAssertTrue(almanac.exists, "\(label) 黄历卡容器缺失")
        XCTAssertEqual(fortuneCard.frame.height, weatherCard.frame.height, accuracy: 1, "\(label) 两卡不等高")
        // 标题为 icon+文字组居中：文字中心相对卡中心偏移 (22+8)/2 = 15
        XCTAssertEqual(fortune.frame.midX - 15, fortuneCard.frame.midX, accuracy: 2.5, "\(label) 签标题组未居中")
        XCTAssertEqual(weather.frame.midX - 15, weatherCard.frame.midX, accuracy: 2.5, "\(label) 天气标题组未居中")
        let gap = almanac.frame.minY - max(fortuneCard.frame.maxY, weatherCard.frame.maxY)
        XCTAssertEqual(gap, 16, accuracy: 3, "\(label) 双卡下方间距不是 16pt：\(gap)")

        let action = app.buttons["开启定位"]
        XCTAssertTrue(action.exists, "\(label) 操作按钮未出现")
        XCTAssertGreaterThanOrEqual(action.frame.height, 44, "\(label) 操作点击区域 <44pt")
        XCTAssertEqual(action.frame.midX, weatherCard.frame.midX, accuracy: 2, "\(label) 操作行未居中")
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
