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

    func testBundledResourceIsApproved12() {
        let r = ContentCatalog.load()
        XCTAssertEqual(r.source, "events.json")
        XCTAssertEqual(r.version, 1, "envelope version 必须为 1")
        XCTAssertEqual(r.items.count, 12, "已批准接入 12 条岁时内容")
        XCTAssertEqual(r.approvedIDs.count, 12, "12/12 approved")
        XCTAssertEqual(Set(r.items.map(\.id)), r.approvedIDs, "approvedIDs 应覆盖全部条目")
    }

    func testDraftAndMissingReviewStatusStayPending() throws {
        // 保留门禁：draft/缺失 reviewStatus 不进入 approved，详情仍 pending
        let items = [item(id: "draft", version: 1, review: "draft"),
                     item(id: "missing", version: 1, review: nil),
                     item(id: "ok", version: 1, review: "approved")]
        struct Env: Encodable { let version = 1; let items: [ContentItem] }
        let data = try JSONEncoder().encode(Env(items: items))
        let r = try XCTUnwrap(ContentCatalog.parse(data))
        XCTAssertEqual(r.approvedIDs, ["ok"], "draft/缺失不得进入可读正文")
        XCTAssertFalse(ContentCatalog.isApproved(item(id: "draft", version: 1, review: "draft")))
        XCTAssertFalse(ContentCatalog.isApproved(item(id: "missing", version: 1, review: nil)))
        XCTAssertTrue(ContentCatalog.isApproved(item(id: "ok", version: 1, review: "approved")))
        XCTAssertEqual(r.version, 1)
    }
}
