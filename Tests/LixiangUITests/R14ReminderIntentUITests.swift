import XCTest

/// P1 集成断言：authorized 不覆写用户关闭的逐条提醒；手动开启/关闭可持久化。
final class R14ReminderIntentUITests: XCTestCase {
    private func shot(_ name: String) {
        let a = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        a.name = name; a.lifetime = .keepAlways; add(a)
    }

    func testAuthorizedDoesNotOverrideSeededReminderOff() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangTab", "3", "-LixiangR14Route", "countdownDetail",
                               "-LixiangSeedCountdown", "1", "-LixiangSeedReminderOff",
                               "-LixiangNotifyAuthorized"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))

        let toggle = app.switches["notify.toggle"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 40), "详情开关未出现")
        // 初始：authorized 但 item 原本关闭 → value=0，item=0
        let initialMarker = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'notify.status=authorized' AND label CONTAINS 'item=0'")).firstMatch
        XCTAssertTrue(initialMarker.waitForExistence(timeout: 20), "authorized 不得把 item 覆写为 1")
        XCTAssertEqual(toggle.value as? String, "0", "authorized 不得覆写用户关闭的开关")
        XCTAssertTrue(toggle.isEnabled)
        shot("reminder-intent-initial-off")

        // 手动开启 → preprompt → 去开启（注入 authorized）
        toggle.tap()
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.waitForExistence(timeout: 10), "未出现请求前说明")
        shot("reminder-intent-preprompt")
        let allow = alert.buttons["去开启"]
        XCTAssertTrue(allow.waitForExistence(timeout: 5))
        allow.tap()

        let onMarker = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'toggle=1' AND label CONTAINS 'item=1'")).firstMatch
        XCTAssertTrue(onMarker.waitForExistence(timeout: 15), "手动开启后未持久化 item=1")
        XCTAssertEqual(toggle.value as? String, "1")
        shot("reminder-intent-enabled")

        // 手动关闭 → 持久化 false
        toggle.tap()
        let offMarker = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'toggle=0' AND label CONTAINS 'item=0'")).firstMatch
        XCTAssertTrue(offMarker.waitForExistence(timeout: 10), "手动关闭后未持久化 item=0")
        XCTAssertEqual(toggle.value as? String, "0")
        shot("reminder-intent-disabled")
    }
}
