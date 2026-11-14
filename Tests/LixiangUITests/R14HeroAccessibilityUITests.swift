import XCTest

/// hero2：图片 fallback 时 accessibility label 必须中性（不能播报原 alt）。
final class R14HeroAccessibilityUITests: XCTestCase {
    private func anyElement(_ app: XCUIApplication, label: String) -> XCUIElement {
        app.descendants(matching: .any).matching(NSPredicate(format: "label == %@", label)).firstMatch
    }

    func testHeroLabelFollowsImageResolution() throws {
        // 正常：原 alt
        var app = XCUIApplication()
        app.launchArguments = ["-LixiangTab", "1", "-LixiangR14Route", "chongyangDetail"]
        app.launch()
        XCTAssertTrue(app.staticTexts["重阳节"].waitForExistence(timeout: 40))
        XCTAssertTrue(anyElement(app, label: "重阳，菊花与秋山").waitForExistence(timeout: 10), "正常 hero 应播报原 alt")
        app.terminate()

        // forced missing：fallback 图 + 中性 label
        app = XCUIApplication()
        app.launchArguments = ["-LixiangTab", "1", "-LixiangR14Route", "chongyangDetail", "-LixiangForceMissingHero"]
        app.launch()
        XCTAssertTrue(app.staticTexts["重阳节"].waitForExistence(timeout: 40))
        XCTAssertTrue(anyElement(app, label: "岁时插画").waitForExistence(timeout: 10), "fallback 应使用中性 label")
        XCTAssertFalse(anyElement(app, label: "重阳，菊花与秋山").exists, "fallback 不得继续播报原 alt")
        let a = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        a.name = "hero-fallback-label"; a.lifetime = .keepAlways; add(a)
    }
}
