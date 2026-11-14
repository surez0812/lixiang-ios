import XCTest
@testable import Lixiang

final class NotificationReminderIntentTests: XCTestCase {
    func testAuthorizedDoesNotEnableItemUserDisabled() {
        // 全局 authorized，但该条 item.reminderEnabled=false：effective 必须 false，且不得写回 true
        XCTAssertFalse(ReminderIntentPolicy.effective(desired: false, isDenied: false))
        XCTAssertFalse(ReminderIntentPolicy.persistOnAuthorized(desired: false))
    }

    func testDeniedShowsOffButPreservesDesiredIntent() {
        XCTAssertFalse(ReminderIntentPolicy.effective(desired: true, isDenied: true), "拒绝态显示关/disabled")
        XCTAssertTrue(ReminderIntentPolicy.persistOnAuthorized(desired: true), "用户原本 desired=true 可恢复")
    }

    func testManualEnablePersistsOnlyAfterUserAction() {
        XCTAssertTrue(ReminderIntentPolicy.effective(desired: true, isDenied: false))
        XCTAssertTrue(ReminderIntentPolicy.persistOnAuthorized(desired: true))
        XCTAssertFalse(ReminderIntentPolicy.persistOnAuthorized(desired: false))
    }
}
