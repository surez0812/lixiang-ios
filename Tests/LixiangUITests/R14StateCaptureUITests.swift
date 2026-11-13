import XCTest

/// 捕获需要交互才能到达的 R14 状态：择日结果、倒计日详情。
final class R14StateCaptureUITests: XCTestCase {
    private func shot(_ name: String) {
        let a = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        a.name = name
        a.lifetime = .keepAlways
        add(a)
    }

    func testSelectionResults() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangTab", "2"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 25))
        sleep(3)
        let button = app.buttons["看看可参考的日期"]
        XCTAssertTrue(button.waitForExistence(timeout: 8), "择日按钮未出现")
        button.tap()
        sleep(3)
        app.swipeUp()
        sleep(1)
        app.swipeUp()
        sleep(1)
        shot("iphone-selection-results")
    }

    func testCountdownDetail() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangTab", "3"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 25))
        sleep(3)
        // 第一张倒计日卡（含标题/日期文本），优先点含“天后/今天”的按钮
        let candidates = app.buttons.allElementsBoundByIndex.filter { $0.label.contains("天后") || $0.label.contains("今天") }
        if let first = candidates.first {
            first.tap()
        } else if app.buttons.count > 1 {
            app.buttons.element(boundBy: 1).tap()
        }
        sleep(3)
        shot("iphone-countdown-detail")
    }
}
