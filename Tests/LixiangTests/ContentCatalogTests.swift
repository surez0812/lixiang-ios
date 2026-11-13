import XCTest
@testable import Lixiang
import LixiangCalendarCore

final class ContentCatalogTests: XCTestCase {
    private func item(id: String, version: Int, review: String?) -> ContentItem {
        ContentItem(id: id, title: id, category: ["festival"], dateRule: .solar(month: 1, day: 1), regionalDates: nil,
                    teaser: "t", sections: [ContentSection(type: "intro", title: "s", paragraphs: ["p"])],
                    sources: [ContentSource(kind: "reference", title: "s")], license: "original",
                    version: version, reviewStatus: review)
    }

    func testEnvelopeParsesAndFiltersApproved() throws {
        let items = [item(id: "a", version: 1, review: "approved"),
                     item(id: "b", version: 1, review: "draft"),
                     item(id: "c", version: 1, review: nil)]
        struct Env: Encodable { let version = 1; let items: [ContentItem] }
        let data = try JSONEncoder().encode(Env(items: items))
        let r = try XCTUnwrap(ContentCatalog.parse(data))
        XCTAssertEqual(r.items.count, 3)
        XCTAssertEqual(r.approvedIDs, ["a"], "仅 approved 进入可读正文；缺失 reviewStatus 排除")
    }

    func testBareArrayParses() throws {
        let items = [item(id: "x", version: 1, review: "approved")]
        let data = try JSONEncoder().encode(items)
        let r = try XCTUnwrap(ContentCatalog.parse(data))
        XCTAssertEqual(r.items.count, 1)
        XCTAssertEqual(r.approvedIDs, ["x"])
    }

    func testParseFailureFallsBackToFixtures() {
        XCTAssertNil(ContentCatalog.parse(Data("not json".utf8)))
        let fallback = ContentCatalog.load(bundle: Bundle(for: ContentCatalogTests.self))
        XCTAssertEqual(fallback.items.count, ContentFixtures.all.count)
        XCTAssertTrue(fallback.approvedIDs.isEmpty)
        XCTAssertEqual(fallback.source, "fixtures-fallback")
    }

    func testReviewStatusAndVersionGate() {
        XCTAssertFalse(ContentCatalog.isApproved(item(id: "draft", version: 1, review: "draft")))
        XCTAssertFalse(ContentCatalog.isApproved(item(id: "missing", version: 1, review: nil)))
        XCTAssertFalse(ContentCatalog.isApproved(item(id: "v0", version: 0, review: "approved")), "version0 必须保持内容准备中")
        XCTAssertTrue(ContentCatalog.isApproved(item(id: "ok", version: 1, review: "approved")))
    }

    func testBundledResourceIsEnvelopeAndDraftGated() {
        let r = ContentCatalog.load()
        XCTAssertEqual(r.source, "events.json")
        XCTAssertEqual(r.items.count, 4, "当前资源为 4 条示例；PM 12 条 JSON 可直接替换 envelope")
        XCTAssertTrue(r.approvedIDs.isEmpty, "示例/未标 approved 不得作为正式正文")
    }
}
