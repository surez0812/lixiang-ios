import SwiftUI
import LixiangCalendarCore

/// R14 倒计日列表（按 countdown-phone-light）：红品牌卡 + 记下一个日子 + 卡片列表 + 提醒说明。
struct R14CountdownScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    @State private var showNew = false

    private var items: [(Anniversary, AnniversaryOccurrence)] {
        state.countdownStore.items.compactMap { item in
            guard let occ = AnniversaryResolver.occurrence(for: item, now: state.today, engine: state.engine) else { return nil }
            return (item, occ)
        }
        .sorted { $0.1.daysFromNow < $1.1.daysFromNow }
    }

    private var nearest: (Anniversary, AnniversaryOccurrence)? { items.first }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                brandCard
                Button { showNew = true } label: {
                    Text("记下一个日子").d1Font(16, weight: .semibold).frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(.borderedProminent).tint(theme.accentStrong)
                ForEach(items, id: \.0.id) { item, occ in
                    NavigationLink {
                        CountdownDetailScreen(item: item)
                    } label: {
                        card(item, occ)
                    }
                    .buttonStyle(.plain)
                }
                infoCard
            }
            .padding(.horizontal, 18)
            .padding(.top, 10)
            .padding(.bottom, 150)
        }
        .background(ScreenBackground())
        .sheet(isPresented: $showNew) {
            CountdownForm(item: nil) { item in
                state.countdownStore.add(item)
                Task {
                    let granted = await NotificationScheduler.requestAuthorization()
                    state.countdownStore.markNotificationDenied(!granted)
                    await NotificationScheduler.reschedule(items: state.countdownStore.items, engine: state.engine, now: state.today)
                }
            }
        }
    }

    private var brandCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("历象 · 把日子过成风景").d1Font(10, weight: .semibold).tracking(1.6).foregroundStyle(.white.opacity(0.8))
            Text("把重要的日子，放在心上").d1SerifFont(28).foregroundStyle(.white).fixedSize(horizontal: false, vertical: true)
            Text("今天，也值得好好纪念。").d1Font(13).foregroundStyle(.white.opacity(0.85))
            if let nearest {
                Text("\(nearest.0.title) · \(relative(nearest.1))").d1SerifFont(20).foregroundStyle(.white).padding(.top, 4)
            } else {
                Text("还没有纪念日，记下第一个吧。").d1SerifFont(18).foregroundStyle(.white.opacity(0.9)).padding(.top, 4)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [Color.r14RedDeep, Color.r14Red], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func card(_ item: Anniversary, _ occ: AnniversaryOccurrence) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .firstTextBaseline) {
                Text(item.title).d1SerifFont(20).foregroundStyle(theme.ink)
                Spacer()
                Text(relative(occ)).d1Font(13, weight: .semibold).foregroundStyle(theme.accentStrong)
            }
            Text("\(item.calendar == .lunar ? "农历" : "公历") · \(repeatText(item)) · \(occ.date.iso)")
                .d1Font(12).foregroundStyle(theme.ink3)
            HStack(spacing: 6) {
                Text(item.reminderEnabled ? "提醒 \(String(format: "%02d:%02d", item.reminderHour, item.reminderMinute))" : "提醒未开启")
                    .d1Font(11).foregroundStyle(theme.ink2)
                Text("·").foregroundStyle(theme.ink3)
                Text("App 内提醒\(item.reminderEnabled ? "已开启" : "未开启")").d1Font(11).foregroundStyle(theme.ink3)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.paper, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).strokeBorder(theme.line, lineWidth: 1))
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("提醒按你的选择到来").d1Font(14, weight: .semibold).foregroundStyle(theme.ink)
            Text("允许通知后，历象会在设定的时间提醒你。暂不允许，也会在 App 内展示临近的日子。")
                .d1Font(12).foregroundStyle(theme.ink3).lineSpacing(4)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.soft, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private func relative(_ occ: AnniversaryOccurrence) -> String {
        if occ.daysFromNow == 0 { return "今天" }
        if occ.daysFromNow > 0 { return "\(occ.daysFromNow)天后" }
        return "已过 \(-occ.daysFromNow) 天"
    }
    private func repeatText(_ item: Anniversary) -> String { item.repeatRule == .yearly ? "每年" : "一次" }
}
