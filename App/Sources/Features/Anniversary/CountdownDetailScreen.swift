import SwiftUI
import LixiangCalendarCore

struct CountdownDetailScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    let item: Anniversary

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
                            Text("\(occ.date.year)年\(occ.date.month)月\(occ.date.day)日")
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
                        get: { current.reminderEnabled },
                        set: { newValue in
                            var updated = current; updated.reminderEnabled = newValue
                            state.countdownStore.update(updated)
                        }))
                        .d1Font(12)
                    Text(current.reminderEnabled ? "提醒时间 \(String(format: "%02d:%02d", current.reminderHour, current.reminderMinute))" : "未开启提醒")
                        .d1Font(10).foregroundStyle(theme.ink3)
                }
                Text("倒计日只在本机保存；通知为本地通知，不上传。").d1Font(9).foregroundStyle(theme.ink3)
            }
            .padding(16)
        }
        .background(ScreenBackground())
        .navigationTitle("倒计日")
        .navigationBarTitleDisplayMode(.inline)
    }
}
