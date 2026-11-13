import XCTest
@testable import Lixiang
import UIKit

final class R14DuoRailTests: XCTestCase {
    func testDuoOpenLandscapeUsesSafeAreaContentSize() {
        // Codex 运行时证据：AppDelegate 951×669，Root 安全区后 867×635
        let size = CGSize(width: 867, height: 635)
        let canvas = R14DevicePolicy.canvas(size: size, idiom: .phone, isDuo: true)
        XCTAssertEqual(canvas, .duoOpenLandscape, "Duo 横屏安全区尺寸应映射到 openLandscape")
        XCTAssertTrue(size.width > size.height)
        // Root rail 条件（isDuo && width>height）
        XCTAssertTrue(size.width > size.height)
    }

    func testDuoClosedLandscapeKeepsBottomTabs() {
        // 外屏 678×466，安全区内容约 606×432：短边 <600 → Closed Landscape，底部 Tab
        for size in [CGSize(width: 678, height: 466), CGSize(width: 606, height: 432)] {
            let canvas = R14DevicePolicy.canvas(size: size, idiom: .phone, isDuo: true)
            XCTAssertEqual(canvas, .duoClosedLandscape)
            let landscape = size.width > size.height
            let innerLike = min(size.width, size.height) >= 600
            XCTAssertTrue(landscape)
            XCTAssertFalse(innerLike)
            XCTAssertFalse(landscape && innerLike, "Closed Landscape 不得启用 rail")
        }
    }

    func testDuoPortraitStaysBottomTabs() {
        // 内屏竖屏 669×951 → openPortrait；安全区后短边 590 → closedPortrait，两者都用底部 Tab
        XCTAssertEqual(R14DevicePolicy.canvas(size: CGSize(width: 669, height: 951), idiom: .phone, isDuo: true), .duoOpenPortrait)
        XCTAssertEqual(R14DevicePolicy.canvas(size: CGSize(width: 590, height: 812), idiom: .phone, isDuo: true), .duoClosedPortrait)
        let size = CGSize(width: 590, height: 812)
        let canvas = R14DevicePolicy.canvas(size: size, idiom: .phone, isDuo: true)
        XCTAssertEqual(canvas, .duoClosedPortrait)
        XCTAssertFalse(size.width > size.height)
        XCTAssertFalse(size.width > size.height && min(size.width, size.height) >= 600)
    }

    func testNormaliPhoneStaysPhonePortrait() {
        let canvas = R14DevicePolicy.canvas(size: CGSize(width: 375, height: 812), idiom: .phone, isDuo: false)
        XCTAssertEqual(canvas, .phonePortrait)
    }

    func testIPadLandscapeUnaffected() {
        let canvas = R14DevicePolicy.canvas(size: CGSize(width: 1194, height: 834), idiom: .pad, isDuo: false)
        XCTAssertEqual(canvas, .iPadLandscape)
    }
}
