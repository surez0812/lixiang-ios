import XCTest
import SwiftUI
@testable import Lixiang
import LixiangCalendarCore

@MainActor
final class DailyShareExportTests: XCTestCase {
    func testShareCardRendererIs1080x1350() throws {
        let engine = LunarSwiftEngine(festivalScope: .cn)
        let date = LocalDate(2026, 11, 14)
        let almanac = engine.almanac(date, hour: 12)
        let verse = R14DailyVerseStore.shared.verse(for: date, classic: .dao)
        let v = try XCTUnwrap(verse, "需要 dao 内容")
        let card = DailyShareCard(date: date, almanac: almanac, verse: v, theme: D1Theme.light)
            .frame(width: 360, height: 450)
        let renderer = ImageRenderer(content: card)
        renderer.scale = 3
        renderer.proposedSize = ProposedViewSize(width: 360, height: 450)
        renderer.isOpaque = true
        let image = try XCTUnwrap(renderer.uiImage)
        XCTAssertEqual(image.size.width, 360, accuracy: 0.01)
        XCTAssertEqual(image.size.height, 450, accuracy: 0.01)
        XCTAssertEqual(image.scale, 3, accuracy: 0.001)
        let cg = try XCTUnwrap(image.cgImage)
        XCTAssertEqual(cg.width, 1080)
        XCTAssertEqual(cg.height, 1350)
        let png = try XCTUnwrap(image.pngData())
        let url = URL(fileURLWithPath: "/tmp/r14-share-export-test.png")
        try png.write(to: url)
        print("LIXDAILY_EXPORT_TEST points=\(image.size) scale=\(image.scale) px=\(cg.width)x\(cg.height) path=\(url.path) bytes=\(png.count)")
    }
}
