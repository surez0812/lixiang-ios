import XCTest

/// UI-001 iPad：真实滚动三态（first/mid/bottom）必须不同图。
final class R14IPadThreeStatesUITests: XCTestCase {
    private func attach(_ name: String, _ data: Data) {
        let a = XCTAttachment(data: data, uniformTypeIdentifier: "public.png")
        a.name = name; a.lifetime = .keepAlways; add(a)
    }

    func testIPadPortraitThreeStatesDistinct() throws {
        XCUIDevice.shared.orientation = .portrait
        let app = XCUIApplication()
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
        XCTAssertTrue(app.staticTexts["今日黄历"].waitForExistence(timeout: 50), "iPad Home 未就绪")
        XCTAssertTrue(app.buttons["日历"].exists)

        let first = XCUIScreen.main.screenshot().pngRepresentation
        attach("ipad-3state-first", first)

        // iPad 视口高，一次整屏 swipe 可能直接到底；用短拖拽制造中段
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.72))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.66))
        start.press(forDuration: 0.05, thenDragTo: end)
        sleep(1)
        let mid = XCUIScreen.main.screenshot().pngRepresentation
        XCTAssertNotEqual(mid, first, "iPad mid 与 first 同图（未滚动）")
        attach("ipad-3state-mid", mid)

        var last = mid
        for _ in 0..<18 {
            app.swipeUp(); sleep(1)
            let cur = XCUIScreen.main.screenshot().pngRepresentation
            if cur == last { break }
            last = cur
        }
        let bottom = last
        XCTAssertNotEqual(bottom, mid, "iPad bottom 与 mid 同图（未到底）")
        XCTAssertNotEqual(bottom, first)
        attach("ipad-3state-bottom", bottom)
        XCTAssertTrue(app.staticTexts["月历"].exists, "iPad 底部未出现月历")
        XCTAssertTrue(app.buttons["日历"].isHittable)
    }
}
