import XCTest

/// UI-001：浮动 tab 胶囊 overlay 在内容上，无全宽纯色底板；首屏/中段/底部三态、浅/深色。
final class R14TabBarOverlayUITests: XCTestCase {
    private func shot(_ name: String) {
        let a = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        a.name = name; a.lifetime = .keepAlways; add(a)
    }

    func testiPhoneTabBarOverlayLightAndDark() throws {
        for (theme, tag) in [("light", "light"), ("dark", "dark")] {
            let app = XCUIApplication()
            app.launchArguments = theme == "dark" ? ["-LixiangTheme", "dark"] : []
            app.launch()
            XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
            XCTAssertTrue(app.staticTexts["今日黄历"].waitForExistence(timeout: 40))
            XCTAssertTrue(app.buttons["日历"].exists, "5 Tab 胶囊应可见")
            shot("r14-tabbar-\(tag)-first")
            app.swipeUp(); sleep(1)
            app.swipeUp(); sleep(1)
            shot("r14-tabbar-\(tag)-mid")
            for _ in 0..<8 { app.swipeUp() }
            sleep(1)
            shot("r14-tabbar-\(tag)-bottom")
            app.terminate()
        }
    }
}
