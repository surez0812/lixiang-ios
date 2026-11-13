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

    func testCountdownNotificationPrompt() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangDeepLink", "lixiang://countdown/first", "-LixiangSeedCountdown", "1"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 25))
        sleep(4)
        let toggle = app.switches["本地通知提醒"]
        if toggle.waitForExistence(timeout: 8) {
            toggle.tap()
            sleep(2)
            shot("countdown-notification-prompt")
        } else {
            shot("countdown-notification-missing")
        }
    }

    func testWeatherDeniedToSettings() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangWeatherState", "denied"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 25))
        sleep(4)
        let button = app.buttons["去设置开启"]
        if button.waitForExistence(timeout: 8) {
            button.tap()
            sleep(3)
            shot("weather-denied-settings")
        } else {
            shot("weather-denied-button-missing")
        }
    }

    func testDailySharePreview() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangR14Route", "daily"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 25))
        sleep(4)
        let share = app.buttons["分享今日一句"]
        XCTAssertTrue(share.waitForExistence(timeout: 8), "分享按钮未出现")
        share.tap()
        sleep(5)
        shot("iphone-daily-share")
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

    func testCountdownNewForm() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangTab", "3"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 25))
        sleep(4)
        let add = app.buttons["记下一个日子"]
        XCTAssertTrue(add.waitForExistence(timeout: 8), "新增按钮未出现")
        add.tap()
        sleep(3)
        shot("countdown-new-form-empty")
        let field = app.textFields["例如：生日、结婚纪念日"]
        if field.waitForExistence(timeout: 6) {
            field.tap()
            field.typeText("测试纪念日")
            sleep(1)
            shot("countdown-new-form-filled")
        }
    }


    func testSeededCountdownDetailRoute() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangSeedCountdown", "1", "-LixiangR14Route", "countdownDetail"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 25))
        sleep(4)
        XCTAssertTrue(app.staticTexts["生日"].waitForExistence(timeout: 20), "seeded countdownDetail 未进入真实详情")
        XCTAssertFalse(app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "页面待实现")).firstMatch.exists, "仍显示占位页")
    }

    func testCountdownListTapDetail() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangTab", "3", "-LixiangSeedCountdown", "1"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 25))
        sleep(4)
        let card = app.buttons.matching(NSPredicate(format: "label CONTAINS %@", "生日")).firstMatch
        XCTAssertTrue(card.waitForExistence(timeout: 10), "列表未见生日卡")
        card.tap()
        sleep(3)
        XCTAssertTrue(app.staticTexts["生日"].waitForExistence(timeout: 10), "列表点击未进入详情")
        XCTAssertFalse(app.staticTexts.containing(NSPredicate(format: "label CONTAINS %@", "页面待实现")).firstMatch.exists)
    }

}
