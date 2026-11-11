import SwiftUI
import LixiangCalendarCore

/// R2-rich 月历首页（design `rich/final/screens/layout-month-{light,dark}.png`）
/// 结构：品牌导航(28) → 节气插画(128/2.70:1) → 紧凑日期叠卡 → 完整 quote 卡 → 月历卡 → 浮起 pill tab
struct MonthScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    @State private var displayYear: Int = 0
    @State private var displayMonth: Int = 0
    @State private var showQuote = false
    @State private var selectedDate: LocalDate?
    @State private var countdownDetail: Anniversary?

    private var today: LocalDate { state.today }
    private var almanac: AlmanacDay { state.almanac(today) }

    var body: some View {
        ScrollViewReader { proxy in
        ScrollView {
            VStack(spacing: 12) {
                topNav
                MergedDayCard(date: today, variant: .month) { showQuote = true }
                    .frame(maxWidth: 520)
                    .frame(maxWidth: .infinity)
                monthCard
                Color.clear.frame(height: 120).id("bottom")
            }
            .padding(.horizontal, 18)
            .padding(.top, 4)
            .padding(.bottom, 24)
        }
        .onAppear {
            #if DEBUG
            if state.debug.scrollBottom {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(nil) { proxy.scrollTo("bottom", anchor: .bottom) }
                }
            }
            #endif
        }
        }
        .background(ScreenBackground())
        .navigationBarHidden(true)
        .onAppear {
            if displayYear == 0 { displayYear = today.year; displayMonth = today.month }
            #if DEBUG
            if let raw = state.debug.countdownDetailDate,
               let parts = Optional(raw.split(separator: "-").compactMap { Int($0) }), parts.count == 3 {
                let target = LocalDate(parts[0], parts[1], parts[2])
                countdownDetail = state.countdownStore.items.first { item in
                    AnniversaryResolver.occurrence(for: item, now: target, engine: state.engine)?.date == target
                } ?? state.countdownStore.items.first
            } else if state.debug.countdownDetail {
                countdownDetail = state.countdownStore.items.first
            }
            #endif
        }
        .sheet(isPresented: $showQuote) {
            if let q = state.plainLanguage.quote(for: today) { QuoteSheet(quote: q, date: today) }
        }
        .navigationDestination(item: $countdownDetail) { item in
            CountdownDetailScreen(item: item)
        }
    }

    // ① 品牌导航：返回 / 昭杳 · 历象 / 搜索（28pt）
    private var topNav: some View {
        HStack {
            Button { displayYear = today.year; displayMonth = today.month } label: {
                Image(systemName: "chevron.left").d1Font(14, weight: .semibold)
            }
            .accessibilityLabel("回到今天")
            Spacer()
            Text("昭杳 · 历象").d1SerifFont(16, weight: .semibold).foregroundStyle(theme.ink2)
            Spacer()
            Button {} label: {
                Image(systemName: "magnifyingglass").d1Font(15, weight: .medium)
            }
            .accessibilityLabel("搜索（即将上线）")
        }
        .foregroundStyle(theme.ink2)
        .frame(height: 28)
    }

    // ③ 紧凑日期叠卡（≈110pt，仅月历信息；日详情内容不在此）
    private var dateCardStack: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(theme.soft.opacity(0.55))
                .rotationEffect(.degrees(-1.4))
                .offset(x: -5, y: 7)
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(theme.paper.opacity(0.85))
                .rotationEffect(.degrees(1.1))
                .offset(x: 5, y: 4)
            dateCard
        }
    }

    private var dateCard: some View {
        HStack(alignment: .center, spacing: 12) {
            Text("\(today.day)")
                .d1SerifFont(108)
                .monospacedDigit()
                .foregroundStyle(theme.ink)
                .frame(width: 118, alignment: .leading)
                .offset(y: -2)
            VStack(alignment: .leading, spacing: 5) {
                Text(dateCardTitle)
                    .d1SerifFont(22, weight: .semibold)
                    .foregroundStyle(theme.ink)
                    .lineLimit(1).minimumScaleFactor(0.8)
                Text(dateCardSubtitle)
                    .d1Font(11)
                    .foregroundStyle(theme.ink2)
                    .lineLimit(1).minimumScaleFactor(0.8)
                Text(ganZhiLine)
                    .d1Font(12, weight: .medium)
                    .foregroundStyle(theme.ink3)
                    .lineSpacing(4)
                    .lineLimit(1).minimumScaleFactor(0.8)
                    .accessibilityLabel("干支 \(ganZhiLine)")
                HStack(spacing: 6) {
                    if let f = nearestHoliday() {
                        D1Chip(text: "距\(f.title) \(f.days) 天", tone: .accent)
                    }
                    if let first = almanac.yi.first {
                        D1Chip(text: "宜 \(almanac.yi.prefix(2).joined(separator: " "))", tone: .neutral)
                    }
                }
            }
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .frame(height: 96)
        .background(theme.paper, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(theme.line.opacity(0.6), lineWidth: 0.8))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(today.month)月\(today.day)日，\(dateCardTitle)，\(dateCardSubtitle)")
    }

    /// 首页完整干支：年/月/日（闰月/月建按库表，不自算；缺项回退日干支）
    private var ganZhiLine: String {
        let y = almanac.lunar.yearGanZhi
        let m = almanac.lunar.monthGanZhi
        let d = almanac.lunar.dayGanZhi
        guard !y.isEmpty, !m.isEmpty, !d.isEmpty else { return "\(d)日" }
        return "\(y)年 · \(m)月 · \(d)日"
    }

    private var dateCardTitle: String {
        if let term = almanac.solarTerm { return "\(term) · \(almanac.lunar.monthDayText)" }
        return almanac.lunar.monthDayText
    }

    private var dateCardSubtitle: String {
        if let next = nextSolarTermDays() {
            return "星期\(today.weekdayChinese) · 距\(next.name) \(next.days) 天"
        }
        return "星期\(today.weekdayChinese)"
    }

    // ④ 完整 quote 卡（≈190pt；朱橙渐变/暗色深红；对比 ≥4.5）
    private var quoteCard: some View {
        Group {
            if let q = state.plainLanguage.quote(for: today) {
                Button { showQuote = true } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("“").d1Kaiti(34).foregroundStyle(theme.cream.opacity(0.55)).frame(height: 20)
                        Text(q.quote).d1Kaiti(22).foregroundStyle(theme.cream).lineLimit(2)
                        Text(q.zh).d1Font(11).foregroundStyle(theme.cream.opacity(0.92)).lineLimit(2)
                        Text("《道德经》第\(q.chapter)章 · 公版 · 点开读解释")
                            .d1Font(9).foregroundStyle(theme.cream.opacity(0.75))
                        Divider().overlay(theme.cream.opacity(0.25))
                        HStack {
                            Text("今天怎么用").d1Font(11, weight: .semibold).foregroundStyle(theme.cream)
                            Spacer()
                            Image(systemName: "chevron.right").d1Font(10).foregroundStyle(theme.cream.opacity(0.85))
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, minHeight: 190, alignment: .leading)
                    .background(LinearGradient(colors: [theme.quote1, theme.quote2],
                                               startPoint: .topLeading, endPoint: .bottomTrailing),
                                in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("今日道德经，第\(q.chapter)章，\(q.quote)。\(q.zh)")
            }
        }
    }

    // ⑤ 月历卡（标题「月历 · 十二月」+ 右侧下一节日）
    private var monthCard: some View {
        let grid = MonthGridBuilder.build(
            year: displayYear, month: displayMonth, weekStart: state.weekStart,
            engine: state.engine, today: today,
            festivalNames: { date in
                let lunar = state.lunar(date)
                return (lunar.jieQi.map { [$0] } ?? []) + state.engine.almanac(date, hour: 12).festivals
            }
        )
        return D1Card(padding: 14) {
            VStack(spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    Text("月历 · \(solarMonthChinese(displayMonth))月")
                        .d1SerifFont(22, weight: .semibold).foregroundStyle(theme.ink)
                    Spacer()
                    if let term = almanac.solarTerm {
                        Text("\(term) \(today.month)/\(today.day)").d1Font(10).foregroundStyle(theme.ink3)
                    } else if let next = nextSolarTermDays() {
                        let d = today.adding(days: next.days)
                        Text("\(next.name) \(d.month)/\(d.day)").d1Font(10).foregroundStyle(theme.ink3)
                    }
                }
                HStack(spacing: 0) {
                    ForEach(state.weekStart.identifiers, id: \.self) { w in
                        Text(w).d1Font(10, weight: .medium)
                            .foregroundStyle(theme.ink3).frame(maxWidth: .infinity)
                    }
                }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 7), spacing: 2) {
                    ForEach(grid.days, id: \.date) { cell in
                        dayCell(cell)
                    }
                }
            }
        }
        .contentShape(Rectangle())
        .gesture(DragGesture(minimumDistance: 30).onEnded { value in
            if value.translation.width < 0 { shiftMonth(1) }
            else if value.translation.width > 0 { shiftMonth(-1) }
        })
    }

    private func dayCell(_ cell: GridDay) -> some View {
        ZStack(alignment: .topTrailing) {
            NavigationLink(value: Route.day(cell.date)) {
                VStack(spacing: 1) {
                    Text("\(cell.date.day)")
                        .d1Font(17, weight: .semibold)
                        .foregroundStyle(cell.isToday ? theme.cream : (cell.inCurrentMonth ? theme.ink : theme.ink3))
                        .frame(width: 24, height: 24)
                        .background {
                            if cell.isToday {
                                Circle().fill(theme.accent)
                            } else if selectedDate == cell.date {
                                Circle().strokeBorder(theme.accent, lineWidth: 1.5)
                            }
                        }
                    Text(cell.label)
                        .d1Font(9.5)
                        .foregroundStyle(labelColor(cell))
                        .lineLimit(1).minimumScaleFactor(0.75)
                }
                .frame(maxWidth: .infinity, minHeight: 34)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            if let marker = countdownMarker(cell.date) {
                Button { countdownDetail = marker } label: {
                    Image(systemName: marker.icon ?? "star")
                        .d1Font(9, weight: .semibold)
                        .foregroundStyle(theme.accentStrong)
                        .frame(width: 18, height: 18)
                        .background(theme.paper.opacity(0.9), in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("倒计日：\(marker.title)")
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(cell.date.month)月\(cell.date.day)日，\(cell.label)\(cell.isToday ? "，今天" : "")")
    }

    /// 最近固定公历节日（元旦/劳动/国庆），用于日期卡「距X天」chip（与设计稿一致）
    private func nearestHoliday() -> (title: String, days: Int)? {
        let fixed: [(String, Int, Int)] = [("元旦", 1, 1), ("劳动节", 5, 1), ("国庆", 10, 1)]
        var best: (String, Int)?
        for (name, m, d) in fixed {
            var year = today.year
            var date = LocalDate(year, m, d)
            if date < today { year += 1; date = LocalDate(year, m, d) }
            let days = today.daysBetween(date)
            if best == nil || days < best!.1 { best = (name, days) }
        }
        return best.map { (title: $0.0, days: $0.1) }
    }

    private func shiftMonth(_ delta: Int) {
        var m = displayMonth + delta
        var y = displayYear
        if m < 1 { m = 12; y -= 1 }
        if m > 12 { m = 1; y += 1 }
        displayYear = y; displayMonth = m
    }

    private func nextSolarTermDays() -> (name: String, days: Int)? {
        var date = today
        for _ in 0..<40 {
            date = date.adding(days: 1)
            if let term = state.lunar(date).jieQi { return (term, today.daysBetween(date)) }
        }
        return nil
    }

    private func labelColor(_ cell: GridDay) -> Color {
        guard cell.inCurrentMonth else { return theme.line }
        switch cell.labelKind {
        case .festival: return theme.festivalText
        case .solarTerm: return theme.solarTermText
        case .internationalFestival: return theme.ink3
        case nil: return theme.ink3
        }
    }

    private func countdownMarker(_ date: LocalDate) -> Anniversary? {
        state.countdownStore.items.first { item in
            AnniversaryResolver.occurrence(for: item, now: date, engine: state.engine)?.date == date
        }
    }

    private func solarMonthChinese(_ month: Int) -> String {
        ["一", "二", "三", "四", "五", "六", "七", "八", "九", "十", "十一", "十二"][max(0, min(11, month - 1))]
    }

    private func festivalMonthDay(_ title: String) -> String {
        for resolution in state.resolutions() where resolution.item.title == title {
            for region in resolution.regions {
                if let info = resolution.stateInfo(regionID: region.id, now: today) {
                    return "\(info.anchor.month)/\(info.anchor.day)"
                }
            }
        }
        return ""
    }
}
