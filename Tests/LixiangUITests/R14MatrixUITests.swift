import XCTest

/// R14 设备矩阵补充：iPad 横屏（simctl 无旋转，用 XCUITest 旋转并截图）。
final class R14MatrixUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    func testIPadPortraitRoutes() throws {
        XCUIDevice.shared.orientation = .portrait
        let routes: [(String, String)] = [
            ("almanac", "almanac"), ("compass", "compass"), ("daily", "daily"),
            ("fortune", "fortune"), ("selection", "selection")
        ]
        for (route, name) in routes {
            let app = XCUIApplication()
            app.launchArguments = ["-LixiangR14Route", route]
            app.launch()
            XCTAssertTrue(app.wait(for: .runningForeground, timeout: 25))
            sleep(4)
            let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
            attachment.name = "ipad-portrait-\(name)"
            attachment.lifetime = .keepAlways
            add(attachment)
            app.terminate()
        }
    }

    func testIPadLandscapeRoutes() throws {
        XCUIDevice.shared.orientation = .landscapeRight
        let routes: [(String, String)] = [
            ("almanac", "almanac"), ("compass", "compass"), ("daily", "daily"),
            ("fortune", "fortune"), ("selection", "selection")
        ]
        for (route, name) in routes {
            let app = XCUIApplication()
            app.launchArguments = ["-LixiangR14Route", route]
            app.launch()
            XCTAssertTrue(app.wait(for: .runningForeground, timeout: 25))
            sleep(4)
            let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
            attachment.name = "ipad-landscape-\(name)"
            attachment.lifetime = .keepAlways
            add(attachment)
            app.terminate()
        }
        XCUIDevice.shared.orientation = .portrait
    }

    func testIPadPortraitTabs() throws {
        XCUIDevice.shared.orientation = .portrait
        for tab in 0..<5 {
            let app = XCUIApplication()
            app.launchArguments = ["-LixiangTab", "\(tab)"]
            app.launch()
            XCTAssertTrue(app.wait(for: .runningForeground, timeout: 25))
            sleep(4)
            let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
            attachment.name = "ipad-portrait-tab\(tab)"
            attachment.lifetime = .keepAlways
            add(attachment)
            app.terminate()
        }
    }

    func testIPadLandscapeTabs() throws {
        XCUIDevice.shared.orientation = .landscapeRight
        for tab in 0..<5 {
            let app = XCUIApplication()
            app.launchArguments = ["-LixiangTab", "\(tab)"]
            app.launch()
            XCTAssertTrue(app.wait(for: .runningForeground, timeout: 25))
            sleep(4)
            let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
            attachment.name = "ipad-landscape-tab\(tab)"
            attachment.lifetime = .keepAlways
            add(attachment)
            app.terminate()
        }
        XCUIDevice.shared.orientation = .portrait
    }
}
