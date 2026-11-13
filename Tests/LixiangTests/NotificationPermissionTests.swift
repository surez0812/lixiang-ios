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

    func testDeniedToggleCloseAndNoRepeatedSystemPrompt() async {
        let c = NotificationPermissionCenter(mock: .denied)
        await c.refresh()
        XCTAssertFalse(c.canToggleReminder, "denied 时开关不可开启")
        XCTAssertTrue(c.isDenied)
        _ = await c.request()
        _ = await c.request()
        XCTAssertEqual(c.systemPromptAttempts, 0, "denied 注入下不重复触发系统弹窗")
    }

    func testSettingsReturnMigratesDeniedToAuthorized() async {
        let c = NotificationPermissionCenter(mock: .settingsReturn)
        await c.refresh()
        XCTAssertTrue(c.isDenied, "初始为 denied")
        XCTAssertFalse(c.canToggleReminder)
        c.simulateSettingsReturn()          // 对应 scenePhase inactive→active 重读
        XCTAssertFalse(c.isDenied)
        XCTAssertEqual(c.status, .authorized)
        XCTAssertTrue(c.canToggleReminder)
    }

    func testPrepromptNotShownAutomatically() {
        let c = NotificationPermissionCenter(mock: .normal)
        XCTAssertFalse(c.showPreprompt, "未主动开启提醒前不得弹说明/权限")
    }
}
