import XCTest
@testable import Lixiang

@MainActor
final class FolkloreLoadStateTests: XCTestCase {
    func testNormalLoaded() {
        XCTAssertEqual(R14FolkloreLoadController(mode: .normal).state, .loaded)
    }

    func testOfflineKeepsCachedContentAndRetry() async {
        let c = R14FolkloreLoadController(mode: .offline)
        XCTAssertEqual(c.state, .offline, "离线有缓存：保持 offline 状态供 UI 展示缓存 + banner")
        c.retry()
        XCTAssertEqual(c.state, .loading, "重试应先进入 loading")
        try? await Task.sleep(nanoseconds: 500_000_000)
        XCTAssertEqual(c.state, .loaded, "重试成功后迁移到 loaded")
    }

    func testFailedNoFakeContentAndRetry() async {
        let c = R14FolkloreLoadController(mode: .failed)
        XCTAssertEqual(c.state, .failed)
        c.retry()
        try? await Task.sleep(nanoseconds: 500_000_000)
        XCTAssertEqual(c.state, .loaded)
    }

    func testLoadingEventuallyLoadsOnRetry() async {
        let c = R14FolkloreLoadController(mode: .loading)
        XCTAssertEqual(c.state, .loading)
        try? await Task.sleep(nanoseconds: 300_000_000)
        XCTAssertEqual(c.state, .loading, "未重试前保持 loading")
        c.retry()
        try? await Task.sleep(nanoseconds: 500_000_000)
        XCTAssertEqual(c.state, .loaded)
    }

    func testAutoRetryModeReachesLoaded() async {
        let c = R14FolkloreLoadController(mode: .retry)
        XCTAssertEqual(c.state, .offline)
        for _ in 0..<60 {                      // 轮询最多 6s，避免 CI 调度抖动
            if c.state == .loaded { break }
            try? await Task.sleep(nanoseconds: 100_000_000)
        }
        XCTAssertEqual(c.state, .loaded, "auto retry 模式用于 QA 截图 retry-success")
    }
}
