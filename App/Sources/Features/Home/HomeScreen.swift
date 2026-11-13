import SwiftUI
import LixiangCalendarCore

/// R14 首页（T3）：Hero/三候/干支/岁时命中/每日一句/一签+天气双卡/黄历摘要/月历
struct R14HomeScreen: View {
    @Environment(\.d1) private var theme
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var days: SelectedDayStore
    private let calendar = R14CalendarGrid()

    var body: some View {
        GeometryReader { geo in
        ScrollView {
            if geo.size.width >= 744 {
                HStack(alignment: .top, spacing: 16) {
                    VStack(alignment: .leading, spacing: 14) {
                        hero
                        if !days.matchedFestivals.isEmpty { festivalsCard }
                        dailyCard
                        HStack(alignment: .top, spacing: 10) { fortuneCard; weatherCard }
                        almanacSummary
                    }
                    VStack(alignment: .leading, spacing: 14) {
                        monthGrid
                        Text("iPad 宽屏双列（左内容 / 右月历）").d1Font(9).foregroundStyle(theme.ink3)
                    }
                }
                .padding(.horizontal, 20).padding(.vertical, 14).padding(.bottom, 96)
            } else {
                VStack(alignment: .leading, spacing: 14) {
                    hero
                    if !days.matchedFestivals.isEmpty { festivalsCard }
                    dailyCard
                    HStack(alignment: .top, spacing: 10) { fortuneCard; weatherCard }
                    almanacSummary
                    monthGrid
                }
                .padding(.horizontal, 16).padding(.vertical, 12).padding(.bottom, 96)
            }
        }
        }
        .background(ScreenBackground())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var hero: some View {
        D1Card(padding: 16) {
            VStack(alignment: .leading, spacing: 6) {
                if let badge = SolarTermPentad.badge(for: days.selectedDate, engine: days.engine) {
                    Text(badge).d1Font(10, weight: .semibold).foregroundStyle(theme.cream)
                        .padding(.horizontal, 9).padding(.vertical, 4)
                        .background(theme.accent, in: Capsule())
                }
                Text(verbatim: "\(days.selectedDate.year)年\(days.selectedDate.month)月\(days.selectedDate.day)日")
                    .d1SerifFont(30, weight: .semibold).foregroundStyle(theme.ink)
                Text(verbatim: "农历\(days.lunar.monthDayText) · \(days.lunar.yearGanZhi)\(days.lunar.shengXiao)年 \(days.lunar.monthGanZhi)月 \(days.lunar.dayGanZhi)日")
                    .d1Font(12).foregroundStyle(theme.ink2)
                if let idx = days.hourIndex, days.shichen.indices.contains(idx) {
                    let h = days.shichen[idx]
                    Text(verbatim: "当前\(h.ganZhi)时 \(h.startMinute)–\(h.endMinute) · 天神\(h.tianShen)")
                        .d1Font(10).foregroundStyle(theme.ink3)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .accessibilityElement(children: .combine)
        }
    }

    private var festivalsCard: some View {
        NavigationLink(value: R14Route.almanac(days.selectedDate)) {
            D1Card(padding: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("今日岁时").d1Font(10).foregroundStyle(theme.ink3)
                        Text(days.matchedFestivals.joined(separator: " · ")).d1Font(13, weight: .semibold).foregroundStyle(theme.ink)
                    }
                    Spacer()
                    Image(systemName: "chevron.right").d1Font(10).foregroundStyle(theme.ink3)
                }
            }
        }.buttonStyle(.plain)
    }

    private var dailyCard: some View {
        NavigationLink(value: R14Route.daily) {
            D1Card(padding: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("每日一句").d1Font(10, weight: .semibold).foregroundStyle(theme.accentStrong)
                    if let q = state.dailyQuote(for: days.selectedDate) {
                        Text(q.quote).d1Kaiti(18).foregroundStyle(theme.ink).lineLimit(2)
                        Text(q.source).d1Font(9).foregroundStyle(theme.ink3).lineLimit(1)
                    } else {
                        Text("今日经典暂缺").d1Font(11).foregroundStyle(theme.ink3)
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }.buttonStyle(.plain)
    }

    private var fortuneCard: some View {
        NavigationLink(value: R14Route.fortune) {
            D1Card(padding: 12) {
                VStack(alignment: .leading, spacing: 6) { Image("fortune-cup").resizable().scaledToFit().frame(width: 28, height: 28)
                    Text("每日一签").d1Font(13, weight: .semibold).foregroundStyle(theme.ink)
                    Text("本地签库 · 不调 AI").d1Font(9).foregroundStyle(theme.ink3) }
                    .frame(maxWidth: .infinity, minHeight: 96, alignment: .topLeading)
            }
        }.buttonStyle(.plain)
    }

    private var weatherCard: some View {
        D1Card(padding: 12) {
            VStack(alignment: .leading, spacing: 6) { Image(systemName: "cloud.sun").d1Font(22).foregroundStyle(theme.accentStrong)
                Text("天气").d1Font(13, weight: .semibold).foregroundStyle(theme.ink)
                Text("权限后请求 · 离线可用").d1Font(9).foregroundStyle(theme.ink3) }
                .frame(maxWidth: .infinity, minHeight: 96, alignment: .topLeading)
        }
    }

    private var almanacSummary: some View {
        NavigationLink(value: R14Route.almanac(days.selectedDate)) {
            D1Card(padding: 12) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack { Text("黄历摘要").d1Font(13, weight: .semibold).foregroundStyle(theme.ink); Spacer(); Image(systemName: "chevron.right").d1Font(10).foregroundStyle(theme.ink3) }
                    row("宜", days.almanac.yi.prefix(4).joined(separator: " "), color: theme.yiText)
                    row("忌", days.almanac.ji.prefix(3).joined(separator: " "), color: theme.red)
                    Text("值神\(days.almanac.tianShen) · 冲\(days.almanac.chongDesc) · 煞\(days.sha?.rawValue ?? "—") · \(days.almanac.xiu)宿")
                        .d1Font(10).foregroundStyle(theme.ink2)
                }
            }
        }.buttonStyle(.plain)
    }

    private func row(_ label: String, _ text: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 6) { Text(label).d1Font(10, weight: .semibold).foregroundStyle(color); Text(text).d1Font(10).foregroundStyle(theme.ink2).lineLimit(2) }
    }

    private var monthGrid: some View {
        D1Card(padding: 12) {
            VStack(alignment: .leading, spacing: 6) {
                HStack { Text("月历").d1Font(13, weight: .semibold).foregroundStyle(theme.ink); Spacer(); Text(verbatim: "\(days.selectedDate.year)年\(days.selectedDate.month)月").d1Font(10).foregroundStyle(theme.ink3) }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 6) {
                    ForEach(["一","二","三","四","五","六","日"], id: \.self) { w in Text(w).d1Font(9).foregroundStyle(theme.ink3) }
                    ForEach(calendar.cells(for: days.selectedDate), id: \.self) { d in
                        let selected = d == days.selectedDate
                        NavigationLink(value: R14Route.almanac(d)) {
                            Text("\(d.day)").d1Font(11, weight: selected ? .semibold : .regular)
                                .foregroundStyle(selected ? theme.cream : (d.month == days.selectedDate.month ? theme.ink : theme.ink3))
                                .frame(maxWidth: .infinity, minHeight: 26)
                                .background(selected ? theme.accent : .clear, in: Circle())
                        }.buttonStyle(.plain)
                    }
                }
            }
        }
    }
}

/// 月历网格（周一开头；返回 6×7 日期，前后月补位）
struct R14CalendarGrid {
    func cells(for date: LocalDate) -> [LocalDate] {
        let first = LocalDate(date.year, date.month, 1)
        let weekday = isoWeekday(first)           // 1=Mon ... 7=Sun
        let start = first.adding(days: -(weekday - 1))
        return (0..<42).map { start.adding(days: $0) }
    }
    private func isoWeekday(_ d: LocalDate) -> Int {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "Asia/Shanghai") ?? .current
        let comps = DateComponents(year: d.year, month: d.month, day: d.day)
        let date = cal.date(from: comps) ?? Date()
        let w = cal.component(.weekday, from: date)   // 1=Sun
        return ((w + 5) % 7) + 1
    }
}
