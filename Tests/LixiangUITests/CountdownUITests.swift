import XCTest

/// 倒计日 UI 冒烟（QA NOTRUN 补齐）：新增表单保存后列表出现；导出入口存在
final class CountdownUITests: XCTestCase {
    func testAddCountdownAppearsInList() {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangScreen", "anniversary", "-LixiangDebugDate", "2026-11-11"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 20))
        // 清空已有数据依赖 fresh install；直接点新增
        let addEmpty = app.buttons["countdown-add-empty"]
        let add = app.buttons["countdown-add"]
        if addEmpty.waitForExistence(timeout: 3) { addEmpty.tap() } else { XCTAssertTrue(add.waitForExistence(timeout: 3)); add.tap() }
        let titleField = app.textFields["countdown-title"]
        XCTAssertTrue(titleField.waitForExistence(timeout: 5))
        titleField.tap(); titleField.typeText("QA 用例")
        app.buttons["countdown-save"].tap()
        XCTAssertTrue(app.staticTexts["countdown-row-QA 用例"].waitForExistence(timeout: 8))
    }

    func testExportEntryExists() {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangScreen", "anniversary", "-LixiangDebugDate", "2026-11-11", "-LixiangSeedCountdown", "1"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 20))
        XCTAssertTrue(app.buttons["countdown-export"].waitForExistence(timeout: 8))
    }
}
