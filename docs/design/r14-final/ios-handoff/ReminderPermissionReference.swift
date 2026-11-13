import Foundation
import UserNotifications

// Design integration reference. Save the anniversary before invoking this flow.
// The calendar engine must compute a valid future occurrence, including lunar rules.
enum ReminderOutcome { case scheduled, inAppOnly }
struct ReminderPermissionReference {
    let center: UNUserNotificationCenter

    func saveReminder(_ request: UNNotificationRequest, userChoseEnable: Bool) async throws -> ReminderOutcome {
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            try await center.add(request)
            return .scheduled
        case .notDetermined:
            guard userChoseEnable else { return .inAppOnly }
            let allowed = try await center.requestAuthorization(options: [.alert, .sound])
            guard allowed else { return .inAppOnly }
            try await center.add(request)
            return .scheduled
        case .denied:
            // Do not ask repeatedly. Offer a user-initiated link to app settings.
            return .inAppOnly
        @unknown default:
            return .inAppOnly
        }
    }
}
