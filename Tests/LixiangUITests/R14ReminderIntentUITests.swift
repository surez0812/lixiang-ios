import XCTest

/// P1 集成断言：authorized 不覆写用户关闭的逐条提醒；手动开启/关闭可持久化。
final class R14ReminderIntentUITests: XCTestCase {
    private func shot(_ name: String) {
        let a = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        a.name = name; a.lifetime = .keepAlways; add(a)
    }

    /// settingsReturn：初始 denied →（详情创建后 3s）authorized；desired=false 仍不得开启
    func testSettingsReturnDoesNotEnableUserDisabledItem() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangTab", "3", "-LixiangR14Route", "countdownDetail",
                               "-LixiangSeedCountdown", "1", "-LixiangSeedReminderOff",
                               "-LixiangNotifySettingsReturn"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
        let marker = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'notify.status=authorized' AND label CONTAINS 'item=0'")).firstMatch
        XCTAssertTrue(marker.waitForExistence(timeout: 50), "settingsReturn 迁移后不得覆写 false item")
        let toggle = app.switches["notify.toggle"]
        XCTAssertEqual(toggle.value as? String, "0")
        XCTAssertTrue(toggle.isEnabled)
        shot("reminder-intent-settingsreturn-off")
    }

    /// settingsReturn：desired=true（用户原开启）→ authorized 后恢复为开
    func testSettingsReturnRestoresDesiredTrueItem() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangTab", "3", "-LixiangR14Route", "countdownDetail",
                               "-LixiangSeedCountdown", "1", "-LixiangNotifySettingsReturn"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
        let marker = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'notify.status=authorized' AND label CONTAINS 'toggle=1' AND label CONTAINS 'item=1'")).firstMatch
        XCTAssertTrue(marker.waitForExistence(timeout: 50), "desired=true 应在 authorized 后恢复")
        XCTAssertEqual(app.switches["notify.toggle"].value as? String, "1")
        shot("reminder-intent-settingsreturn-on")
    }

    /// 手动开启后重启（不 seed）仍保持 item=1
    func testManualEnablePersistsAcrossRelaunch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangTab", "3", "-LixiangR14Route", "countdownDetail",
                               "-LixiangSeedCountdown", "1", "-LixiangSeedReminderOff",
                               "-LixiangNotifyAuthorized"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
        let toggle = app.switches["notify.toggle"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 40))
        toggle.tap()
        let allow = app.alerts.buttons["去开启"]
        XCTAssertTrue(allow.waitForExistence(timeout: 10)); allow.tap()
        let onMarker = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'toggle=1' AND label CONTAINS 'item=1'")).firstMatch
        XCTAssertTrue(onMarker.waitForExistence(timeout: 15))
        // 重启（不 seed，读磁盘）
        app.terminate()
        app.launchArguments = ["-LixiangTab", "3", "-LixiangR14Route", "countdownDetail", "-LixiangNotifyAuthorized"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
        let persisted = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'item=1'")).firstMatch
        XCTAssertTrue(persisted.waitForExistence(timeout: 30), "重启后 item=1 应持久化")
        XCTAssertEqual(app.switches["notify.toggle"].value as? String, "1")
        shot("reminder-intent-relaunch-persisted")
    }

    /// 1→0 关闭持久化：seed reminder on → 断言 1 → 手动关 → 断言 0 → 重启无 seed 仍 0
    func testManualDisablePersistsAcrossRelaunch() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangTab", "3", "-LixiangR14Route", "countdownDetail",
                               "-LixiangSeedCountdown", "1", "-LixiangNotifyAuthorized"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
        let toggle = app.switches["notify.toggle"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 40))
        let onMarker = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'toggle=1' AND label CONTAINS 'item=1'")).firstMatch
        XCTAssertTrue(onMarker.waitForExistence(timeout: 20), "初始应为 ON（seed reminderOn）")
        XCTAssertEqual(toggle.value as? String, "1")
        shot("reminder-intent-disable-start-on")

        toggle.tap()   // 1 → 0，用户明确关闭
        let offMarker = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'toggle=0' AND label CONTAINS 'item=0'")).firstMatch
        XCTAssertTrue(offMarker.waitForExistence(timeout: 10), "手动关闭后应立即持久化 item=0")
        XCTAssertEqual(toggle.value as? String, "0")
        shot("reminder-intent-disabled")

        // 重启（不 seed，读磁盘）
        app.terminate()
        app.launchArguments = ["-LixiangTab", "3", "-LixiangR14Route", "countdownDetail", "-LixiangNotifyAuthorized"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
        let persistedOff = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'toggle=0' AND label CONTAINS 'item=0'")).firstMatch
        XCTAssertTrue(persistedOff.waitForExistence(timeout: 30), "重启后仍应为 item=0")
        XCTAssertEqual(app.switches["notify.toggle"].value as? String, "0")
        shot("reminder-intent-relaunch-off-persisted")
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

        // 手动开启路径与持久化由 testManualEnablePersistsAcrossRelaunch 覆盖
        shot("reminder-intent-authorized-off")

        // 手动关闭 → 持久化 false
        toggle.tap()
        let offMarker = app.staticTexts.matching(NSPredicate(format: "label CONTAINS 'toggle=0' AND label CONTAINS 'item=0'")).firstMatch
        XCTAssertTrue(offMarker.waitForExistence(timeout: 10), "手动关闭后未持久化 item=0")
        XCTAssertEqual(toggle.value as? String, "0")
        shot("reminder-intent-disabled")
    }
}
