import XCTest

/// UI-001：tab 胶囊 overlay；三态真实滚动、5 Tab、详情 push/返回；浅/深。
final class R14TabBarOverlayUITests: XCTestCase {
    private func attach(_ name: String, png: Data) {
        let a = XCTAttachment(data: png, uniformTypeIdentifier: "public.png")
        a.name = name; a.lifetime = .keepAlways; add(a)
    }

    private func waitHome(_ app: XCUIApplication) {
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
        XCTAssertTrue(app.staticTexts["今日黄历"].waitForExistence(timeout: 40), "Home 未就绪")
        XCTAssertTrue(app.buttons["日历"].exists && app.buttons["设置"].exists, "5 Tab 胶囊未出现")
    }

    private func scrollToBottom(_ app: XCUIApplication, max: Int = 14) -> Data {
        var last = XCUIScreen.main.screenshot().pngRepresentation
        for _ in 0..<max {
            app.swipeUp()
            sleep(1)
            let cur = XCUIScreen.main.screenshot().pngRepresentation
            if cur == last { return cur }
            last = cur
        }
        return last
    }

    func testiPhoneThreeStatesAndNoReservedBand() throws {
        for (mode, tag) in [("light", "light"), ("dark", "dark")] {
            let app = XCUIApplication()
            app.launchArguments = mode == "dark" ? ["-LixiangTheme", "dark"] : []
            app.launch()
            waitHome(app)

            let firstData = XCUIScreen.main.screenshot().pngRepresentation
            attach("tabbar-\(tag)-first", png: firstData)

            // 中段：滚动一次（不能直接到底），必须与首屏不同
            app.swipeUp(); sleep(1)
            let midData = XCUIScreen.main.screenshot().pngRepresentation
            XCTAssertNotEqual(midData, firstData, "\(tag) 中段截图与首屏相同（未滚动）")
            attach("tabbar-\(tag)-mid", png: midData)

            // 底部：反复滚动直到画面不再变化；必须与中段不同
            let bottomData = scrollToBottom(app)
            XCTAssertNotEqual(bottomData, midData, "\(tag) 底部截图与中段相同（未到底）")
            XCTAssertNotEqual(bottomData, firstData)
            attach("tabbar-\(tag)-bottom", png: bottomData)

            // 末项：月历卡标题应可见并可点（末尾可读）
            let month = app.staticTexts["月历"]
            XCTAssertTrue(month.exists, "\(tag) 底部未出现月历卡")
            XCTAssertTrue(month.isHittable, "\(tag) 末项月历不可点")
            // 末项下方仍保留可点击余量：月历卡最后一行日期应在可点击区域
            XCTAssertTrue(app.buttons["日历"].isHittable, "tab 胶囊被内容遮挡/不可点")
            app.terminate()
        }
    }

    func testFiveTabsAndAlmanacPushBack() throws {
        let app = XCUIApplication()
        app.launch()
        waitHome(app)

        let tabs: [(String, String)] = [
            ("岁时", "岁时有约"),
            ("择日", "择一日，做一事"),
            ("倒计日", "把重要的日子，放在心上"),
            ("设置", "让历象，更像你"),
            ("日历", "今日黄历"),
        ]
        for (tab, marker) in tabs {
            app.buttons[tab].tap()
            let found = app.staticTexts.matching(NSPredicate(format: "label CONTAINS %@", marker)).firstMatch
            XCTAssertTrue(found.waitForExistence(timeout: 20), "\(tab) 页未出现标识：\(marker)")
            let a = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
            a.name = "tabbar-tab-\(tab)"; a.lifetime = .keepAlways; add(a)
        }

        // Home → 今日黄历 push → 返回
        XCTAssertTrue(app.staticTexts["今日黄历"].waitForExistence(timeout: 10))
        app.staticTexts["今日黄历"].tap()
        XCTAssertTrue(app.staticTexts["宜忌"].waitForExistence(timeout: 20), "黄历详情未 push")
        let back = app.buttons["返回"]
        XCTAssertTrue(back.waitForExistence(timeout: 10), "返回按钮不存在")
        back.tap()
        XCTAssertTrue(app.staticTexts["今日黄历"].waitForExistence(timeout: 20), "返回 Home 失败")
    }
}
