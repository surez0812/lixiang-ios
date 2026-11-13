import XCTest

/// 行 170-174：逐屏滚动截图，供 scripts/r14-longshot.py 拼接长图。
/// 不是完整长图本身；长图由脚本按重叠区拼接 + manifest 记录每帧 offset。
final class R14LongCaptureUITests: XCTestCase {
    private var frames = 0

    private struct Page { let name: String; let args: [String]; let maxSwipes: Int }
    private let pages: [Page] = [
        Page(name: "home", args: ["-LixiangTab", "0"], maxSwipes: 6),
        Page(name: "almanac", args: ["-LixiangTab", "0", "-LixiangR14Route", "almanac"], maxSwipes: 8),
        Page(name: "daily", args: ["-LixiangTab", "0", "-LixiangR14Route", "daily"], maxSwipes: 24),
        Page(name: "folklore-detail", args: ["-LixiangTab", "1", "-LixiangR14Route", "folkloreDetail"], maxSwipes: 6),
    ]

    func testLongCapture() throws {
        for page in pages {
            let app = XCUIApplication()
            app.launchArguments = page.args
            app.launch()
            XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
            sleep(4)
            capture(page: page.name, index: 0)
            var last = Data()
            for i in 1...page.maxSwipes {
                let before = XCUIScreen.main.screenshot().pngRepresentation
                app.swipeUp()
                sleep(1)
                let after = XCUIScreen.main.screenshot().pngRepresentation
                if after == before || after == last { break }
                last = after
                capture(page: page.name, index: i)
            }
            app.terminate()
        }
    }

    private func capture(page: String, index: Int) {
        frames += 1
        let a = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        a.name = String(format: "long-%@-%02d", page, index)
        a.lifetime = .keepAlways
        add(a)
    }
}
