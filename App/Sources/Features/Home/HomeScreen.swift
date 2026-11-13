import SwiftUI
import LixiangCalendarCore

/// R14 首页（T3）：对照 home-phone-light / home-ipad-landscape 实现
struct R14HomeScreen: View {
    @Environment(\.d1) private var theme
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var days: SelectedDayStore
    private let calendar = R14CalendarGrid()

    private var anniversary: String? {
        state.countdownStore.items.lazy.compactMap { item in
            AnniversaryResolver.occurrence(for: item, now: days.selectedDate, engine: days.engine)?.date == days.selectedDate ? item.title : nil
        }.first
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                if geo.size.width >= 744 {
                    HStack(alignment: .top, spacing: 16) {
                        VStack(alignment: .leading, spacing: 14) { hero; HStack(alignment: .top, spacing: 10) { fortuneCard; weatherCard } }
                        VStack(alignment: .leading, spacing: 14) { almanacCard; monthCard }
                    }.padding(.horizontal, 24).padding(.top, 20).padding(.bottom, 120)
                } else {
                    VStack(alignment: .leading, spacing: 14) { hero; HStack(alignment: .top, spacing: 10) { fortuneCard; weatherCard }; almanacCard; monthCard }
                        .padding(.horizontal, 16).padding(.vertical, 12).padding(.bottom, 150)
                }
            }
        }
        .background(ScreenBackground())
        .onAppear { R14StartupProbe.log("home.appear") }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Hero（插画背景 + 日期 + 岁时/纪念 + 红色经文块）
    private var hero: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                Image("winter").resizable().scaledToFill().frame(height: 210).clipped()
                    .overlay(LinearGradient(colors: [.clear, theme.paper.opacity(0.9), theme.paper], startPoint: .center, endPoint: .bottom))
                if let badge = SolarTermPentad.badge(for: days.selectedDate, engine: days.engine) {
                    Text(badge).d1Font(10, weight: .semibold).foregroundStyle(theme.cream)
                        .padding(.horizontal, 10).padding(.vertical, 5)
                        .background(Color.r14Red, in: Capsule()).padding(12)
                }
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(verbatim: "\(days.selectedDate.year)年\(days.selectedDate.month)月\(days.selectedDate.day)日 · 星期\(days.selectedDate.weekdayChinese)")
                    .d1SerifFont(24, weight: .semibold).foregroundStyle(theme.ink)
                Text(verbatim: "农历\(days.lunar.monthDayText)").d1SerifFont(14).foregroundStyle(theme.ink2)
                Text(verbatim: "\(days.lunar.yearGanZhi)年  \(days.lunar.monthGanZhi)月  \(days.lunar.dayGanZhi)日").d1SerifFont(14).foregroundStyle(theme.ink2)
                if let idx = days.hourIndex, days.shichen.indices.contains(idx) {
                    let h = days.shichen[idx]
                    Text(verbatim: "\(h.ganZhi)时 · \(h.startMinute)–\(h.endMinute)").d1SerifFont(12).foregroundStyle(theme.ink3)
                }
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                    heroChip("今日岁时", days.matchedFestivals.isEmpty ? "暂无岁时" : days.matchedFestivals.prefix(2).joined(separator: " "), muted: days.matchedFestivals.isEmpty)
                    heroChip("今日纪念", anniversary ?? "暂无纪念", muted: anniversary == nil)
                }.padding(.top, 2)
                quoteBlock.padding(.top, 4)
            }
            .padding(.horizontal, 16).padding(.bottom, 16)
        }
        .background(theme.paper)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(theme.line.opacity(0.6)))
    }

    private func heroChip(_ title: String, _ value: String, muted: Bool = false) -> some View {
        NavigationLink(value: R14Route.almanac(days.selectedDate)) {
            HStack(spacing: 4) {
                Text(title).d1Font(9).foregroundStyle(theme.ink3)
                Text(value).d1SerifFont(11, weight: .semibold).foregroundStyle(muted ? theme.ink3 : theme.ink).lineLimit(1)
                Spacer(minLength: 0)
                Image(systemName: "chevron.right").d1Font(7).foregroundStyle(theme.ink3)
            }
            .padding(.horizontal, 8).frame(minHeight: 32)
            .background(theme.soft, in: RoundedRectangle(cornerRadius: 10))
        }.buttonStyle(.plain)
    }

    private var quoteBlock: some View {
        NavigationLink(value: R14Route.daily) {
            VStack(alignment: .leading, spacing: 6) {
                if let q = state.dailyQuote(for: days.selectedDate) {
                    Text(q.quote).d1Kaiti(20).foregroundStyle(theme.cream).lineLimit(3)
                    HStack(spacing: 8) {
                        Text("\(q.source)").d1Font(9).foregroundStyle(theme.cream.opacity(0.8)).lineLimit(1)
                        Spacer(minLength: 0)
                        Text("读解释与分享").d1Font(9, weight: .semibold).foregroundStyle(theme.cream)
                    }
                } else {
                    Text("今日经典暂缺").d1Font(12).foregroundStyle(theme.cream)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(LinearGradient(colors: [Color.r14Red, Color.r14RedDeep], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
        }.buttonStyle(.plain)
    }

    // MARK: 双卡
    private var fortuneCard: some View {
        NavigationLink(value: R14Route.fortune) {
            D1Card(padding: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 8) { Image("fortune-cup").resizable().scaledToFit().frame(width: 26, height: 26)
                        Text("每日一签").d1SerifFont(16, weight: .semibold).foregroundStyle(theme.ink) }
                    HStack { Text("静心，问今日").d1Font(11).foregroundStyle(theme.ink2); Spacer(); Image(systemName: "chevron.right").d1Font(9).foregroundStyle(theme.ink3) }
                        .frame(minHeight: 44)
                }.frame(maxWidth: .infinity, minHeight: 98, alignment: .topLeading)
            }
        }.buttonStyle(.plain)
    }
    private var weatherCard: some View { HomeWeatherCard() }

    // MARK: 今日黄历卡
    private var almanacCard: some View {
        NavigationLink(value: R14Route.almanac(days.selectedDate)) {
            VStack(alignment: .leading, spacing: 8) {
                Text(verbatim: "\(days.lunar.dayGanZhi)日 · \(days.almanac.tianShenType) · \(days.almanac.dayNaYin)")
                    .d1Font(10).foregroundStyle(theme.ink3)
                Text("今日黄历").d1SerifFont(26, weight: .semibold).foregroundStyle(theme.ink)
                largeYiJi("宜", days.almanac.yi, color: theme.yiText)
                largeYiJi("忌", days.almanac.ji, color: theme.red)
                Divider().overlay(theme.line)
                HStack {
                    Text("全项宜忌 · 十二时辰 · 罗盘").d1Font(10).foregroundStyle(theme.ink2)
                    Spacer()
                    Text("展开今日 ›").d1Font(10, weight: .semibold).foregroundStyle(Color.r14Red)
                }.frame(minHeight: 44)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.paper, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(alignment: .topTrailing) {
                Image("compass-dial").resizable().scaledToFit().frame(width: 150, height: 150).opacity(0.12).padding(8).allowsHitTesting(false)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(theme.line.opacity(0.6)))
            .padding(.bottom, 8)
        }.buttonStyle(.plain)
    }

    private func largeYiJi(_ label: String, _ items: [String], color: Color) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Text(label).d1SerifFont(20, weight: .semibold).foregroundStyle(color).frame(width: 26, alignment: .leading)
            Text(items.prefix(4).joined(separator: "    ")).d1SerifFont(17).foregroundStyle(theme.ink).lineLimit(2)
        }
    }

    // MARK: 月历（农历日号 + 节气/岁时/纪念圆点；选中朱底）
    private var monthCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack { Text("月历").d1SerifFont(20, weight: .semibold).foregroundStyle(theme.ink); Spacer()
                Text(verbatim: "\(days.selectedDate.year)年\(days.selectedDate.month)月").d1Font(10).foregroundStyle(theme.ink3) }
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 5) {
                ForEach(["一","二","三","四","五","六","日"], id: \.self) { w in Text(w).d1Font(9).foregroundStyle(theme.ink3) }
                ForEach(calendar.cells(for: days.selectedDate), id: \.self) { d in
                    dayCell(d)
                }
            }
        }
        .padding(14)
        .background(theme.paper, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(theme.line.opacity(0.6)))
    }

    private func dayCell(_ d: LocalDate) -> some View {
        let isSel = d == days.selectedDate
        let inMonth = d.month == days.selectedDate.month
        return NavigationLink(value: R14Route.almanac(d)) {
            VStack(spacing: 1) {
                Text("\(d.day)").d1SerifFont(13, weight: isSel ? .semibold : .regular)
                    .foregroundStyle(isSel ? theme.cream : (inMonth ? theme.ink : theme.ink3))
                    .frame(width: 28, height: 24)
                    .background(isSel ? Color.r14Red : .clear, in: Circle())
                Text(lunarLabel(d)).d1Font(7.5).foregroundStyle(isSel ? theme.cream : theme.ink3).lineLimit(1)
                HStack(spacing: 2) {
                    if hasSolarTerm(d) { Circle().fill(theme.solarTermText).frame(width: 3, height: 3) }
                    if !festivals(d).isEmpty { Circle().fill(Color.r14Red).frame(width: 3, height: 3) }
                    if hasAnniversary(d) { Circle().fill(theme.accent).frame(width: 3, height: 3) }
                }.frame(height: 4)
            }
            .frame(maxWidth: .infinity, minHeight: 42)
        }.buttonStyle(.plain)
    }

    private func lunarLabel(_ d: LocalDate) -> String {
        days.meta(for: d).lunarMonthDay
    }
    private func hasSolarTerm(_ d: LocalDate) -> Bool { days.meta(for: d).solarTerm != nil }
    private func festivals(_ d: LocalDate) -> [String] { days.meta(for: d).festivals }
    private func hasAnniversary(_ d: LocalDate) -> Bool {
        state.countdownStore.items.contains { AnniversaryResolver.occurrence(for: $0, now: d, engine: days.engine)?.date == d }
    }
}

/// 月历网格（周一开头；42 格；前后月补位）
struct R14CalendarGrid {
    func cells(for date: LocalDate) -> [LocalDate] {
        let first = LocalDate(date.year, date.month, 1)
        let weekday = isoWeekday(first)
        let start = first.adding(days: -(weekday - 1))
        return (0..<42).map { start.adding(days: $0) }
    }
    private func isoWeekday(_ d: LocalDate) -> Int {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "Asia/Shanghai") ?? .current
        let date = cal.date(from: DateComponents(year: d.year, month: d.month, day: d.day)) ?? Date()
        let w = cal.component(.weekday, from: date)
        return ((w + 5) % 7) + 1
    }
}
