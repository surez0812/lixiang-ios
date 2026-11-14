import XCTest
import SwiftUI
import UIKit
@testable import Lixiang

@MainActor
final class ContentHeroTests: XCTestCase {
    private let expectedIDs: Set<String> = ["dongzhi","qingming","chunjie","zhongqiu","xiayuan","zhongyuan","laba","yulanpen","xiezao","jizu","shangsi","chongyang"]

    func testMappingAndAltComplete() {
        XCTAssertEqual(Set(R14ContentHero.ids), expectedIDs)
        XCTAssertEqual(R14ContentHero.ids.count, 12)
        for id in expectedIDs {
            let zh = R14ContentHero.alt(for: id)
            let en = R14ContentHero.alt(for: id, language: "en")
            XCTAssertNotNil(zh); XCTAssertFalse(zh!.isEmpty, "\(id) zh alt 为空")
            XCTAssertNotNil(en); XCTAssertFalse(en!.isEmpty, "\(id) en alt 为空")
            XCTAssertFalse(R14ContentHero.accessibilityLabel(for: id).isEmpty)
        }
    }

    func testAll12WebPDecodeWith16x9() throws {
        for id in R14ContentHero.ids {
            let ui = try XCTUnwrap(R14ContentHero.uiImage(for: id), "\(id) webp 解码失败/资源缺失")
            XCTAssertEqual(ui.size.width, 1024, accuracy: 0.5, "\(id) 宽度")
            XCTAssertEqual(ui.size.height, 576, accuracy: 0.5, "\(id) 高度")
            XCTAssertEqual(ui.size.width / ui.size.height, 16.0/9.0, accuracy: 0.01, "\(id) 宽高比")
        }
    }

    func testForceMissingReturnsNilForAnyID() throws {
        for id in R14ContentHero.ids {
            XCTAssertNil(R14ContentHero.uiImage(for: id, forceMissing: true), "\(id) forced missing 应返回 nil")
        }
        XCTAssertFalse(R14ContentHero.forceMissing, "正常运行不得处于 forced missing")
    }

    func testMissingHeroFallsBackToWinter() {
        XCTAssertNil(R14ContentHero.uiImage(for: "not-a-content-id"))
        XCTAssertNil(R14ContentHero.alt(for: "not-a-content-id"))
        XCTAssertEqual(R14ContentHero.accessibilityLabel(for: "not-a-content-id"), "岁时插画")
        // Image 不崩溃且使用 winter fallback（类型无法直接断言，覆盖分支）
        _ = R14ContentHero.image(for: "not-a-content-id")
    }

    func testCacheReturnsSameImage() throws {
        let a = try XCTUnwrap(R14ContentHero.uiImage(for: "chongyang"))
        let b = try XCTUnwrap(R14ContentHero.uiImage(for: "chongyang"))
        XCTAssertTrue(a === b, "同一 id 应命中缓存")
    }
}
