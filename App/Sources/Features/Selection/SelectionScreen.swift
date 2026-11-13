import SwiftUI
import LixiangCalendarCore

/// 择日：事项 + 起止 + 周末/避纪念；真实按黄历宜忌逐日筛选（原型固定候选池作废）。
struct SelectionScreen: View {
    @Environment(\.d1) private var theme
    @EnvironmentObject private var state: AppState
    var onOpenDay: (LocalDate) -> Void = { _ in }

    @State private var matter: SelectionMatter = .travel
    @State private var startDate: Date
    @State private var endDate: Date
    @State private var weekendOnly = false
    @State private var avoidAnniversaries = false
    @State private var results: [SelectionResult] = []
    @State private var searched = false
    @State private var spanTooLong = false

    private let engine = SelectionEngine()

    init(initialDate: LocalDate = .beijingToday(), onOpenDay: @escaping (LocalDate) -> Void = { _ in }) {
        self.onOpenDay = onOpenDay
        _startDate = State(initialValue: BeijingTime.date(from: initialDate, hour: 12))
        _endDate = State(initialValue: BeijingTime.date(from: initialDate.adding(days: 30), hour: 12))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                header
                card(title: "想安排的事") { matterRow }
                card(title: "从哪天开始") { dateRow($startDate, label: "开始") }
                card(title: "看到哪一天") { dateRow($endDate, label: "结束") }
                card(title: "偏好") { preferences }
                Button(action: search) {
                    Text("看看可参考的日期")
                        .d1Font(16, weight: .semibold)
                        .frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(.borderedProminent)
                .tint(theme.accentStrong)
                if spanTooLong {
                    Text("范围最长 366 天，请缩小后再试。").d1Font(12).foregroundStyle(theme.ink2)
                }
                if searched {
                    resultsSection
                }
                Text("按事项与日期范围整理，最终也请结合天气、时间和参与者安排。")
                    .d1Font(11).foregroundStyle(theme.ink3).lineSpacing(4)
                    .padding(.top, 4)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .background(ScreenBackground())
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("历象 · 把日子过成风景").d1Font(10, weight: .semibold).tracking(1.8).foregroundStyle(theme.ink3)
            Text("择一日，做一事").d1SerifFont(30).foregroundStyle(theme.ink)
            Text("让民俗参考，配合自己的安排。").d1Font(13).foregroundStyle(theme.ink2)
        }
        .padding(.top, 6)
    }

    private func card<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title).d1Font(12, weight: .semibold).foregroundStyle(theme.ink3)
            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.paper, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 20, style: .continuous).strokeBorder(theme.line, lineWidth: 1))
    }

    private var matterRow: some View {
        HStack(spacing: 8) {
            ForEach(SelectionMatter.allCases) { m in
                Button {
                    matter = m
                } label: {
                    Text(m.rawValue)
                        .d1Font(14, weight: matter == m ? .semibold : .regular)
                        .foregroundStyle(matter == m ? theme.onAccent : theme.ink2)
                        .padding(.horizontal, 14)
                        .frame(minHeight: 40)
                        .background(matter == m ? theme.accentStrong : theme.soft, in: Capsule())
                }
                .buttonStyle(.plain)
            }
            Spacer(minLength: 0)
        }
    }

    private func dateRow(_ binding: Binding<Date>, label: String) -> some View {
        HStack {
            Text(label).d1Font(14).foregroundStyle(theme.ink)
            Spacer()
            DatePicker("", selection: binding, displayedComponents: .date)
                .labelsHidden()
                .environment(\.locale, Locale(identifier: "zh_CN"))
        }
    }

    private var preferences: some View {
        VStack(spacing: 8) {
            Toggle("仅周末", isOn: $weekendOnly)
            Toggle("不与纪念日冲突", isOn: $avoidAnniversaries)
        }
        .d1Font(14)
    }

    private var resultsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("可参考的日期").d1SerifFont(19).foregroundStyle(theme.ink)
                Spacer()
                Text("\(matter.rawValue) · \(results.count)天").d1Font(12).foregroundStyle(theme.ink2)
            }
            if results.isEmpty {
                Text("这个范围里没有匹配的日期，试试放宽条件。")
                    .d1Font(13).foregroundStyle(theme.ink2)
                    .padding(.vertical, 12)
            } else {
                ForEach(results) { result in
                    resultRow(result)
                }
            }
        }
    }

    private func resultRow(_ result: SelectionResult) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 2) {
                Text("\(result.date.day)").d1SerifFont(28).foregroundStyle(theme.ink)
                Text("周\(result.date.weekdayChinese)").d1Font(10).foregroundStyle(theme.ink3)
            }
            .frame(width: 44)
            VStack(alignment: .leading, spacing: 6) {
                Text(verbatim: String(format: "%d年%d月", result.date.year, result.date.month)).d1Font(11).foregroundStyle(theme.ink3)
                HStack(spacing: 6) {
                    Text("宜").d1Font(10, weight: .semibold).foregroundStyle(theme.yiText)
                    Text(result.yi.prefix(4).joined(separator: " · ")).d1Font(12).foregroundStyle(theme.ink2).lineLimit(1)
                }
                HStack(spacing: 6) {
                    Text("忌").d1Font(10, weight: .semibold).foregroundStyle(theme.jiText)
                    Text(result.ji.prefix(3).joined(separator: " · ")).d1Font(12).foregroundStyle(theme.ink3).lineLimit(1)
                }
            }
            Spacer(minLength: 0)
            Button("看当日 ›") { onOpenDay(result.date) }
                .d1Font(12, weight: .semibold)
                .foregroundStyle(theme.accentStrong)
                .frame(minWidth: 44, minHeight: 44)
        }
        .padding(14)
        .background(theme.paper, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 18, style: .continuous).strokeBorder(theme.line, lineWidth: 1))
    }

    private func search() {
        let start = BeijingTime.localDate(from: startDate)
        let end = BeijingTime.localDate(from: endDate)
        guard start <= end else { results = []; searched = true; spanTooLong = false; return }
        let span = start.daysBetween(end)
        guard span <= SelectionPreferences.maxSpanDays else { results = []; searched = true; spanTooLong = true; return }
        spanTooLong = false
        let prefs = SelectionPreferences(matter: matter, start: start, end: end,
                                        weekendOnly: weekendOnly, avoidAnniversaries: avoidAnniversaries)
        results = SelectionEngine(calendar: LunarSwiftEngine(), anniversaries: state.countdownStore.items).candidates(prefs)
        searched = true
    }
}
