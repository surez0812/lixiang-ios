import XCTest
import UserNotifications
@testable import Lixiang

@MainActor
final class NotificationPermissionTests: XCTestCase {
    func testDeniedMockDoesNotRequestSystemAndKeepsAppUsable() async {
        let c = NotificationPermissionCenter(mock: .denied)
        await c.refresh()
        XCTAssertTrue(c.isDenied)
        let ok = await c.request()
        XCTAssertFalse(ok, "拒绝后不重试系统弹窗，返回 false 供 UI 保留 App 内提示")
        XCTAssertTrue(c.isDenied)
    }

    func testAuthorizedMockSchedules() async {
        let c = NotificationPermissionCenter(mock: .authorized)
        await c.refresh()
        XCTAssertFalse(c.isDenied)
        let ok = await c.request()
        XCTAssertTrue(ok)
        XCTAssertEqual(c.status, .authorized)
    }

    func testSettingsReturnReReadsAuthorization() async {
        let c = NotificationPermissionCenter(mock: .settingsReturn)
        await c.refresh()
        XCTAssertTrue(c.isDenied, "从设置返回前为 denied")
        await c.onSceneActive()
        XCTAssertFalse(c.isDenied, "scenePhase active 后重读为 authorized")
        XCTAssertEqual(c.status, .authorized)
    }

    func testPrepromptNotShownAutomatically() {
        let c = NotificationPermissionCenter(mock: .normal)
        XCTAssertFalse(c.showPreprompt, "未主动开启提醒前不得弹说明/权限")
    }
}
