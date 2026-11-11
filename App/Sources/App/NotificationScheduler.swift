import Foundation
import UserNotifications
import LixiangCalendarCore

/// 本地通知：首次保存才请求权限；拒绝后条目保留、列表标「提醒未开启」。
enum NotificationScheduler {
    static func requestAuthorization() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        if settings.authorizationStatus == .authorized { return true }
        if settings.authorizationStatus == .denied { return false }
        return (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
    }

    static func reschedule(items: [Anniversary], engine: any CalendarEngine, now: LocalDate) async {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        for item in items where item.reminderEnabled {
            guard let occ = AnniversaryResolver.occurrence(for: item, now: now, engine: engine) else { continue }
            var components = DateComponents()
            components.year = occ.date.year; components.month = occ.date.month; components.day = occ.date.day
            components.hour = item.reminderHour; components.minute = item.reminderMinute
            let content = UNMutableNotificationContent()
            content.title = item.title
            content.body = "倒计日 · 就是今天（还有 0 天）"
            content.sound = .default
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let request = UNNotificationRequest(identifier: "countdown-\(item.id)-\(occ.date.iso)", content: content, trigger: trigger)
            try? await center.add(request)
        }
    }
}
