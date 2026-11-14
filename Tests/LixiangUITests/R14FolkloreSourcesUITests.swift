import XCTest

/// 12 页抽检：详情 footer 必须列出全部 sources（chongyang 有 2 条）。
final class R14FolkloreSourcesUITests: XCTestCase {
    func testChongyangDetailListsAllSources() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangTab", "1", "-LixiangR14Route", "chongyangDetail"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
        XCTAssertTrue(app.staticTexts["重阳节"].waitForExistence(timeout: 40))
        for _ in 0..<14 { app.swipeUp() }
        sleep(1)
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS '維基百科·重陽節'")).firstMatch.exists, "footer 应显示第一条来源")
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label CONTAINS '維基百科·菊花'")).firstMatch.exists, "footer 应显示第二条来源（不得只显示首条）")
        let a = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        a.name = "r14-folklore-sources"; a.lifetime = .keepAlways; add(a)
    }
}
