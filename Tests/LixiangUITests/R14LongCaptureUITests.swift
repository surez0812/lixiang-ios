import XCTest

/// 行 170-174：逐屏滚动截图，供 scripts/r14-longshot.py 拼接长图。
/// 不是完整长图本身；长图由脚本按重叠区拼接 + manifest 记录每帧 offset。
final class R14LongCaptureUITests: XCTestCase {
    private var frames = 0

    private struct Page { let name: String; let args: [String]; let maxSwipes: Int; let readyMarkers: [String] }
    private let pages: [Page] = [
        Page(name: "home", args: ["-LixiangTab", "0"], maxSwipes: 10, readyMarkers: ["今日黄历"]),
        Page(name: "almanac", args: ["-LixiangTab", "0", "-LixiangR14Route", "almanac"], maxSwipes: 12, readyMarkers: ["宜忌"]),
        Page(name: "daily", args: ["-LixiangTab", "0", "-LixiangR14Route", "daily"], maxSwipes: 28, readyMarkers: ["这篇句话在说什么", "这句话在说什么", "每日一句"]),
        Page(name: "folklore-detail", args: ["-LixiangTab", "1", "-LixiangR14Route", "folkloreDetail"], maxSwipes: 10, readyMarkers: ["内容准备中", "一段来由 · 一点日常", "谢灶", "分享"]),
    ]

    private func waitForContent(_ page: Page, _ app: XCUIApplication) -> Bool {
        // 轮询内容 ready：排除 loading/“正在准备”
        for _ in 0..<45 {
            if app.staticTexts["正在准备今日"].exists || app.staticTexts["历象 · 正在准备今日"].exists {
                sleep(1); continue
            }
            for m in page.readyMarkers where app.staticTexts[m].exists {
                return true
            }
            sleep(1)
        }
        return false
    }

    func testLongCapture() throws {
        var report: [[String: Any]] = []
        for page in pages {
            let app = XCUIApplication()
            app.launchArguments = page.args
            app.launch()
            XCTAssertTrue(app.wait(for: .runningForeground, timeout: 30))
            XCTAssertTrue(waitForContent(page, app), "\(page.name) 30s 内未进入内容态（loading/未 ready）")
            // 回到顶部，保证首帧含页面顶部
            for _ in 0..<6 { app.swipeDown() }
            sleep(1)
            capture(page: page.name, index: 0)
            report.append(["page": page.name, "ready": true])
            var last = Data()
            for i in 1...page.maxSwipes {
                let before = XCUIScreen.main.screenshot().pngRepresentation
                dragScroll(app)
                sleep(1)
                let after = XCUIScreen.main.screenshot().pngRepresentation
                if after == before || after == last { break }
                last = after
                capture(page: page.name, index: i)
            }
            app.terminate()
        }
        let data = try JSONSerialization.data(withJSONObject: report, options: [])
        let att = XCTAttachment(data: data, uniformTypeIdentifier: "public.json")
        att.name = "long-capture-report.json"
        att.lifetime = .keepAlways
        add(att)
    }

    /// 固定距离拖动（约 0.55 屏），保证相邻帧 ~45% 重叠，便于稳定拼接。
    private func dragScroll(_ app: XCUIApplication) {
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.82))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.28))
        start.press(forDuration: 0.05, thenDragTo: end)
    }

    private func capture(page: String, index: Int) {
        frames += 1
        let a = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        a.name = String(format: "long-%@-%02d", page, index)
        a.lifetime = .keepAlways
        add(a)
    }
}
