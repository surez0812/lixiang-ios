import SwiftUI
import UserNotifications

/// 通知授权状态机：只在用户主动开启提醒时请求；拒绝不阻断；scenePhase 回前台重读设置。
/// DEBUG 注入用于模拟器无法稳定弹系统权限窗时的 QA（注入 ≠ 原生通过）。
@MainActor
final class NotificationPermissionCenter: ObservableObject {
    enum MockMode { case normal, denied, authorized, settingsReturn }

    @Published private(set) var status: UNAuthorizationStatus = .notDetermined
    @Published var showPreprompt = false
    @Published private(set) var systemPromptAttempts = 0
    private let mock: MockMode
    private var returnedFromSettings = false

    init(mock: MockMode? = nil) {
        let resolved = mock ?? Self.modeFromProcess()
        self.mock = resolved
        switch resolved {
        case .denied, .settingsReturn: status = .denied
        case .authorized: status = .authorized
        case .normal: status = .notDetermined
        }
        #if DEBUG
        print("LXNOTIFY mock=\(resolved)")
        #endif
    }

    /// DEBUG 注入：模拟 scenePhase inactive→active 后重读设置。
    var isSettingsReturnMock: Bool { mock == .settingsReturn }

    /// 由详情 `onAppear/task` 在**视图创建完成后**调用，3s 后模拟 inactive→active 重读。
    func scheduleSettingsReturnSimulation(after seconds: Double = 3.0) {
        guard mock == .settingsReturn, !returnedFromSettings else { return }
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
            self.simulateSettingsReturn()
        }
    }

    var debugStatusText: String { status == .authorized ? "authorized" : (status == .denied ? "denied" : "notDetermined") }

    func simulateSettingsReturn() {
        returnedFromSettings = true
        status = .authorized
        #if DEBUG
        print("LXNOTIFY simulateSettingsReturn -> authorized")
        #endif
    }

    static func modeFromProcess() -> MockMode {
        let a = ProcessInfo.processInfo.arguments
        if a.contains("-LixiangNotifyDenied") { return .denied }
        if a.contains("-LixiangNotifyAuthorized") { return .authorized }
        if a.contains("-LixiangNotifySettingsReturn") { return .settingsReturn }
        return .normal
    }

    func refresh() async {
        #if DEBUG
        print("LXNOTIFY refresh mock=\(mock) returned=\(returnedFromSettings) status=\(status.rawValue)")
        #endif
        switch mock {
        case .denied: status = .denied
        case .authorized: status = .authorized
        case .settingsReturn: status = returnedFromSettings ? .authorized : .denied
        case .normal: status = await UNUserNotificationCenter.current().notificationSettings().authorizationStatus
        }
    }

    /// 仅由用户动作触发（preprompt 确认/开关打开）。
    func request() async -> Bool {
        switch mock {
        case .denied: status = .denied; return false
        case .authorized: status = .authorized; return true
        case .settingsReturn: status = returnedFromSettings ? .authorized : .denied; return status == .authorized
        case .normal:
            let center = UNUserNotificationCenter.current()
            let settings = await center.notificationSettings()
            if settings.authorizationStatus == .authorized { status = .authorized; return true }
            if settings.authorizationStatus == .denied { status = .denied; return false }
            systemPromptAttempts += 1
            let ok = (try? await center.requestAuthorization(options: [.alert, .sound, .badge])) ?? false
            status = ok ? .authorized : .denied
            return ok
        }
    }

    /// scenePhase == .active 时调用：从系统设置返回后重读。
    func onSceneActive() async {
        if mock == .settingsReturn { returnedFromSettings = true }
        await refresh()
    }

    func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }

    var isDenied: Bool { status == .denied }
    /// denined 时开关不可开启；UI 显示「系统已拒绝」并引导去设置。
    var canToggleReminder: Bool { status != .denied }
}
