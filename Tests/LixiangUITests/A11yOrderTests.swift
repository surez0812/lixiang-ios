import XCTest

/// A21 VoiceOver 文本替身/朗读顺序证据（CEO 选项 A：模拟器 + XCUITest 导出无障碍元素顺序）
final class A11yOrderTests: XCTestCase {

    private func tree(_ app: XCUIApplication) -> [String] {
        var lines: [String] = []
        for e in app.descendants(matching: .any).allElementsBoundByIndex {
            let label = e.label.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !label.isEmpty else { continue }
            lines.append("\(e.elementType.rawValue)\t\(label)")
        }
        return lines
    }

    func testCompassA11yTreeOrder() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangScreen", "compass", "-LixiangDebugDate", "2026-11-11"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 20))
        let lines = tree(app)
        print("A11Y_TREE_BEGIN\n" + lines.joined(separator: "\n") + "\nA11Y_TREE_END")
        let legendRows = lines.filter { line in
            let body = line.split(separator: "\t", maxSplits: 1).last.map(String.init) ?? line
            guard !body.contains("/"), !body.contains("只讲") else { return false }
            return ["喜神，", "财神，", "福神，", "阳贵，", "阴贵，", "煞方，"].contains { body.hasPrefix($0) }
        }
        print("A11Y_LEGEND_ROWS_BEGIN\n" + legendRows.joined(separator: "\n") + "\nA11Y_LEGEND_ROWS_END")
        let idx: (String) -> Int = { key in legendRows.firstIndex { $0.contains("\(key)，") } ?? -1 }
        for key in ["喜神", "财神", "福神", "阳贵", "阴贵", "煞方"] {
            XCTAssertTrue(idx(key) >= 0, "缺 \(key) label")
        }
        XCTAssertTrue(idx("喜神") < idx("财神"))
        XCTAssertTrue(idx("财神") < idx("福神"))
        XCTAssertTrue(idx("福神") < idx("阳贵"))
        XCTAssertTrue(idx("阳贵") < idx("阴贵"))
        XCTAssertTrue(idx("阴贵") < idx("煞方"))
        // 无双读：每神/煞的「图例行 label」只出现一次（页脚说明含「喜神/财神/…」不计）
        for key in ["喜神", "财神", "福神", "阳贵", "阴贵", "煞方"] {
            XCTAssertEqual(legendRows.filter { $0.contains("\(key)，") }.count, 1, "\(key) 图例行出现重复（双读风险）")
        }
    }

    func testCompassMissingLabels() throws {
        let app = XCUIApplication()
        app.launchArguments = ["-LixiangScreen", "compass", "-LixiangDebugDate", "2026-11-11",
                               "-LixiangDebugHideDeity", "cai,fu"]
        app.launch()
        XCTAssertTrue(app.wait(for: .runningForeground, timeout: 20))
        let lines = tree(app)
        print("A11Y_TREE_MISSING_BEGIN\n" + lines.joined(separator: "\n") + "\nA11Y_TREE_MISSING_END")
        XCTAssertTrue(lines.contains { $0.contains("财神，本日不在此位") }, "缺位财神 label 不对")
        XCTAssertTrue(lines.contains { $0.contains("福神，本日不在此位") }, "缺位福神 label 不对")
        XCTAssertTrue(lines.contains { $0.contains("喜神，") })
    }
}
