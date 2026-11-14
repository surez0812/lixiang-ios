import SwiftUI
import LixiangCalendarCore

struct CountdownDetailScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var notify = NotificationPermissionCenter()
    @State private var desiredReminder: Bool
    let item: Anniversary

    init(item: Anniversary) {
        self.item = item
        _desiredReminder = State(initialValue: item.reminderEnabled)
    }

    private func persistReminder(_ on: Bool) {
        var updated = current
        updated.reminderEnabled = on
        state.countdownStore.update(updated)
        Task { await NotificationScheduler.reschedule(items: state.countdownStore.items, engine: state.engine, now: state.today) }
    }

    private var effectiveReminder: Bool { ReminderIntentPolicy.effective(desired: desiredReminder, isDenied: notify.isDenied) }

    private var current: Anniversary { state.countdownStore.items.first { $0.id == item.id } ?? item }
    private var occurrence: AnniversaryOccurrence? {
        AnniversaryResolver.occurrence(for: current, now: state.today, engine: state.engine)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                D1Card {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 8) {
                            Image(systemName: current.icon ?? "star").d1Font(16).foregroundStyle(theme.accentStrong)
                            Text(current.title).d1SerifFont(26).foregroundStyle(theme.ink)
                        }
                        if let occ = occurrence {
                            Text(verbatim: "\(occ.date.year)年\(occ.date.month)月\(occ.date.day)日")
                                .d1Font(11).foregroundStyle(theme.ink3)
                            Text(occ.isToday ? "就是今天" : (occ.daysFromNow > 0 ? "还有 \(occ.daysFromNow) 天" : "已过 \(abs(occ.daysFromNow)) 天"))
                                .d1Font(28, weight: .semibold).foregroundStyle(theme.accentStrong)
                        }
                        Text("\(current.calendar == .lunar ? "农历" : "公历") · \(current.repeatRule == .yearly ? "每年" : "一次性")\(current.calendar == .lunar && current.isLeapMonth ? " · 闰月" : "")")
                            .d1Font(10).foregroundStyle(theme.ink3)
                    }
                }
                D1Card {
                    Toggle("本地通知提醒", isOn: Binding(
                        get: { effectiveReminder },
                        set: { newValue in
                            if notify.isDenied { return }
                            if newValue {
                                notify.showPreprompt = true
                            } else {
                                desiredReminder = false
                                persistReminder(false)   // 仅用户手动关闭才改写持久化
                            }
                        }))
                        .d1Font(12)
                        .disabled(notify.isDenied)
                        .accessibilityIdentifier("notify.toggle")
                    Text(notify.isDenied ? "系统通知已拒绝；开关不可开启，请去设置允许通知。" : (effectiveReminder ? "提醒时间 \(String(format: "%02d:%02d", current.reminderHour, current.reminderMinute))" : "未开启提醒"))
                        .d1Font(10).foregroundStyle(theme.ink3)
                    if notify.isDenied {
                        HStack(spacing: 8) {
                            Image(systemName: "bell.slash").foregroundStyle(theme.accentStrong)
                            Text("通知未开启；App 内提醒仍可见。").d1Font(10).foregroundStyle(theme.ink2)
                            Spacer(minLength: 0)
                            Button("去设置") { notify.openSettings() }
                                .d1Font(10, weight: .semibold).foregroundStyle(theme.accentStrong).frame(minHeight: 44)
                                .accessibilityIdentifier("notify.openSettings")
                        }
                        .accessibilityElement(children: .contain)
                        .accessibilityLabel("通知未开启，App 内提醒仍可见")
                        .accessibilityIdentifier("notify.deniedBanner")
                    }
                }
                if ProcessInfo.processInfo.arguments.contains(where: { $0.hasPrefix("-LixiangNotify") }) {
                    Text("notify.status=\(notify.debugStatusText) toggle=\(effectiveReminder ? 1 : 0) item=\(current.reminderEnabled ? 1 : 0)")
                        .d1Font(10, weight: .semibold)
                        .foregroundStyle(notify.isDenied ? theme.red : theme.yiText)
                        .accessibilityIdentifier("notify.statusMarker")
                }
                Text("倒计日只在本机保存；通知为本地通知，不上传。").d1Font(9).foregroundStyle(theme.ink3)
            }
            .padding(16)
        }
        .background(ScreenBackground())
        .navigationTitle("倒计日")
        .navigationBarTitleDisplayMode(.inline)
        .alert("开启本地通知提醒？", isPresented: $notify.showPreprompt) {
            Button("暂不开启", role: .cancel) {
                desiredReminder = false
                persistReminder(false)
            }
            Button("去开启") {
                Task {
                    let granted = await notify.request()
                    desiredReminder = granted
                    persistReminder(granted)
                    state.countdownStore.markNotificationDenied(!granted)
                }
            }
        } message: {
            Text("允许通知后，历象会在设定的时间提醒你；暂不允许，App 内仍会显示临近的日子。")
        }
        .task {
            await notify.refresh()
            notify.scheduleSettingsReturnSimulation()   // 详情创建完成后 3s 才迁移（QA 时序）
            if notify.isDenied {
                // 拒绝态只影响 effective（开关显示关/disabled），保留用户 desired 意图与持久化
            } else if ReminderIntentPolicy.persistOnAuthorized(desired: desiredReminder) {
                persistReminder(true)                   // 只有用户原本 desired=true 才恢复排程
            }
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("-LixiangNotifyPrepromptDetail") { notify.showPreprompt = true }
            #endif
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { Task { await notify.onSceneActive() } }
        }
        .onChange(of: notify.status) { _, newStatus in
            // 全局授权变化不覆写逐条 desired；仅 desired=true 时恢复排程
            if newStatus == .authorized, ReminderIntentPolicy.persistOnAuthorized(desired: desiredReminder) {
                persistReminder(true)
                #if DEBUG
                print("LXNOTIFY restoreReminder desired=true after authorized")
                #endif
            }
        }
    }
}
