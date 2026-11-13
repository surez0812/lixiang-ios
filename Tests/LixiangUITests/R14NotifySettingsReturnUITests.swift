import XCTest

/// B/166-169 注入复测：settingsReturn 详情创建后 3s 迁移，marker toggle=1 + 开关 enabled。
final class R14NotifySettingsReturnUITests: XCTestCase {
    private func shot(_ name: String) {
        let a = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        a.name = name; a.lifetime = .keepAlways; add(a)
    }

    func testSettingsReturnAuthorizedMarkerAndToggle() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangTab", "3", "-LixiangR14Route", "countdownDetail", "-LixiangSeedCountdown", "1", "-LixiangNotifySettingsReturn"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))

        let marker = app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH 'notify.status='")).firstMatch
        // 详情创建后先出现 denied marker
        var sawDenied = false
        for _ in 0..<50 {
            if marker.exists, marker.label.contains("denied") { sawDenied = true; break }
            sleep(1)
        }
        if sawDenied { shot("notify-settingsreturn-denied") }

        // 以 authorized marker 为准，再断言开关 = 1 / enabled
        let authorized = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'notify.status=authorized' AND label CONTAINS 'toggle=1'")).firstMatch
        XCTAssertTrue(authorized.waitForExistence(timeout: 40), "40s 未见 authorized + toggle=1 marker")
        let toggle = app.switches["notify.toggle"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 10))
        XCTAssertEqual(toggle.value as? String, "1", "authorized 后开关必须为开")
        XCTAssertTrue(toggle.isEnabled, "authorized 后开关必须可操作")
        shot("notify-settingsreturn-authorized")
    }
}
