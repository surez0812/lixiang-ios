import XCTest

/// A21 VoiceOver 文本替身/朗读顺序证据（CEO 选项 A：模拟器 + XCUITest 导出无障碍元素顺序）
/// 运行：xcodebuild test -only-testing:LixiangUITests/A11yOrderTests ...
final class A11yOrderTests: XCTestCase {
    func testCompassA11yTreeOrder() throws {
        let app = XCUIApplication()
        app.launchArguments = [
            "-LixiangScreen", "compass",
            "-LixiangDebugDate", "2026-11-11"
        ]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 20))

        // 图例是文本替身：抓取可访问元素（label + identifier），按树顺序输出
        let all = app.descendants(matching: .any).allElementsBoundByIndex
        var lines: [String] = []
        for e in all {
            let label = e.label.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !label.isEmpty else { continue }
            lines.append("\(e.elementType.rawValue)\t\(label)")
        }
        let joined = lines.joined(separator: "\n")
        print("A11Y_TREE_BEGIN")
        print(joined)
        print("A11Y_TREE_END")
        // 断言：五神与煞方文本替身存在，且顺序中喜在财前、煞在最后
        let idx: (String) -> Int = { key in lines.firstIndex { $0.contains(key) } ?? -1 }
        XCTAssertTrue(idx("喜神") >= 0, "缺 喜神 label")
        XCTAssertTrue(idx("财神") >= 0, "缺 财神 label")
        XCTAssertTrue(idx("福神") >= 0, "缺 福神 label")
        XCTAssertTrue(idx("阳贵") >= 0, "缺 阳贵 label")
        XCTAssertTrue(idx("阴贵") >= 0, "缺 阴贵 label")
        XCTAssertTrue(idx("煞方") >= 0, "缺 煞方 label")
        XCTAssertTrue(idx("喜神") < idx("财神"))
        XCTAssertTrue(idx("财神") < idx("福神"))
        XCTAssertTrue(idx("福神") < idx("阳贵"))
        XCTAssertTrue(idx("阳贵") < idx("阴贵"))
        XCTAssertTrue(idx("阴贵") < idx("煞方"))
    }
}
