import SwiftUI
import LixiangCalendarCore

struct MonthScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    @State private var displayYear: Int = 0
    @State private var displayMonth: Int = 0
    @State private var showQuote = false
    @State private var selectedDate: LocalDate?
    @State private var countdownDetail: Anniversary?

    private var today: LocalDate { state.today }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                SolarTermArtView(date: today, maxHeight: 150)
                todayCardStack
                quoteCard
                monthCard
                toolsBar
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .background(ScreenBackground())
        .navigationTitle("")
        .navigationBarHidden(true)
        .onAppear {
            if displayYear == 0 { displayYear = today.year; displayMonth = today.month }
        }
        .navigationDestination(item: $countdownDetail) { item in
            CountdownDetailScreen(item: item)
        }
    }

    // R2-rich：三层卡叠压
    private var todayCardStack: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(theme.soft.opacity(0.7))
                .rotationEffect(.degrees(-1.6))
                .offset(x: -6, y: 8)
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(theme.paper.opacity(0.9))
                .rotationEffect(.degrees(1.2))
                .offset(x: 6, y: 4)
            todayCard
        }
    }

    // R2-rich：朱橙渐变 quote 卡
    private var quoteCard: some View {
        Group {
            if let q = state.plainLanguage.quote(for: today) {
                Button { showQuote = true } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("「\(q.quote)」")
                            .d1SerifFont(20)
                            .foregroundStyle(theme.cream)
                            .lineLimit(2)
                        HStack {
                            Text("《道德经》第 \(q.chapter) 章").d1Font(9).foregroundStyle(theme.cream.opacity(0.8))
                            Spacer()
                            Text("点按看解释").d1Font(9).foregroundStyle(theme.cream.opacity(0.8))
                        }
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(LinearGradient(colors: [theme.red, theme.accent],
                                               startPoint: .topLeading, endPoint: .bottomTrailing),
                                in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityLabel("今日道德经，第\(q.chapter)章，\(q.quote)")
            }
        }
    }

    // S1 块①：今日头卡
    private var todayCard: some View {
        let almanac = state.almanac(today)
        return D1Card {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 14) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(today.day)")
                            .d1NumberFont(108)
                            .tracking(-3)
                            .foregroundStyle(theme.ink)
                        Text(verbatim: "\(today.year)年\(today.month)月")
                            .d1Font(10, weight: .semibold)
                            .tracking(1.4)
                            .foregroundStyle(theme.ink3)
                        Text("\(almanac.lunar.dayGanZhi)日")
                            .d1Font(10).foregroundStyle(theme.ink3)
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        Text("星期\(today.weekdayChinese) · 农历\(almanac.lunar.monthDayText)")
                            .d1Font(13, weight: .medium)
                            .foregroundStyle(theme.ink2)
                        if let term = almanac.solarTerm {
                            D1Chip(text: term, tone: .jade)
                        }
                        if let days = nextSolarTermDays() {
                            Text("距\(days.name) \(days.days) 天")
                                .d1Font(10)
                                .foregroundStyle(theme.ink3)
                        }
                    }
                    Spacer()
                }
                D1Divider()
                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .top, spacing: 6) {
                        Text("宜").d1Font(11, weight: .bold).foregroundStyle(theme.accentStrong)
                        Text(almanac.yi.prefix(3).joined(separator: " · "))
                            .d1Font(11).foregroundStyle(theme.ink2).lineLimit(1)
                    }
                    HStack(alignment: .top, spacing: 6) {
                        Text("忌").d1Font(11, weight: .bold).foregroundStyle(theme.ink)
                        Text(almanac.ji.prefix(3).joined(separator: " · "))
                            .d1Font(11).foregroundStyle(theme.ink2).lineLimit(1)
                    }
                }
                HStack(spacing: 12) {
                    NavigationLink(value: Route.day(today)) {
                        HStack(spacing: 4) {
                            Text("详解").d1Font(11, weight: .semibold)
                            Image(systemName: "chevron.right").d1Font(9, weight: .semibold)
                        }
                        .foregroundStyle(theme.accentStrong)
                    }
                    Spacer()
                    if let q = state.plainLanguage.quote(for: today) {
                        Button {
                            showQuote = true
                        } label: {
                            Text("「\(q.quote)」").d1Font(10).foregroundStyle(theme.ink3).lineLimit(1)
                        }
                    }
                }
                NavigationLink(value: Route.compass(today)) {
                    HStack(spacing: 4) {
                        Image(systemName: "safari").d1Font(10)
                        Text("吉神罗盘").d1Font(10, weight: .semibold)
                        Image(systemName: "chevron.right").d1Font(9)
                    }
                    .foregroundStyle(theme.ink2)
                }
                .overlay(alignment: .topTrailing) {
                    Text("历象")
                        .d1SerifFont(11)
                        .foregroundStyle(theme.red)
                        .padding(5)
                        .overlay(RoundedRectangle(cornerRadius: 4).strokeBorder(theme.red, lineWidth: 1.2))
                        .rotationEffect(.degrees(8))
                        .padding(10)
                        .accessibilityHidden(true)
                }
            }
        }
    }

    // S1 块②：月网格卡
    private var monthCard: some View {
        let grid = MonthGridBuilder.build(
            year: displayYear, month: displayMonth, weekStart: state.weekStart,
            engine: state.engine, today: today,
            festivalNames: { date in
                let lunar = state.lunar(date)
                return (lunar.jieQi.map { [$0] } ?? []) + state.engine.almanac(date, hour: 12).festivals
            }
        )
        return D1Card(padding: 12) {
            VStack(spacing: 10) {
                HStack {
                    Text(verbatim: "\(displayYear)年\(displayMonth)月")
                        .d1SerifFont(23).foregroundStyle(theme.ink)
                    Spacer()
                    HStack(spacing: 14) {
                        Button { shiftMonth(-1) } label: { Image(systemName: "chevron.left") }
                        Button { shiftMonth(1) } label: { Image(systemName: "chevron.right") }
                        Button("回今天") { displayYear = today.year; displayMonth = today.month }
                            .d1Font(10, weight: .semibold)
                    }
                    .foregroundStyle(theme.ink2)
                }
                HStack(spacing: 0) {
                    ForEach(state.weekStart.identifiers, id: \.self) { w in
                        Text(w).d1Font(9, weight: .semibold).tracking(1.4)
                            .foregroundStyle(theme.ink3).frame(maxWidth: .infinity)
                    }
                }
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 2), count: 7), spacing: 4) {
                    ForEach(grid.days, id: \.date) { cell in
                        dayCell(cell)
                    }
                }
            }
        }
    }

    private func dayCell(_ cell: GridDay) -> some View {
        NavigationLink(value: Route.day(cell.date)) {
            VStack(spacing: 1) {
                Text("\(cell.date.day)")
                    .d1Font(17, weight: .semibold)
                    .foregroundStyle(cell.isToday ? theme.onAccent : (cell.inCurrentMonth ? theme.ink : theme.ink3))
                    .frame(width: 30, height: 30)
                    .background {
                        if cell.isToday {
                            Circle().fill(theme.accent)
                        } else if selectedDate == cell.date {
                            Circle().strokeBorder(theme.accentStrong, lineWidth: 1.5)
                        }
                    }
                Text(cell.label)
                    .font(.system(size: 7.5, weight: cell.labelKind == nil ? .regular : .semibold))
                    .foregroundStyle(labelColor(cell))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
            }
            .frame(maxWidth: .infinity, minHeight: 52)
            .contentShape(Rectangle())
            .overlay(alignment: .topTrailing) {
                if let marker = countdownMarker(cell.date) {
                    Button { countdownDetail = marker } label: {
                        Image(systemName: marker.icon ?? "star")
                            .d1Font(8)
                            .foregroundStyle(theme.accentStrong)
                            .frame(width: 16, height: 16)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("倒计日：\(marker.title)")
                }
            }
        }
        .buttonStyle(.plain)
    }

    // S1 块③：工具条
    private var toolsBar: some View {
        HStack(spacing: 10) {
            if let nearest = state.nearestFestivalDays() {
                D1Chip(text: "\(nearest.title) \(nearest.days) 天", tone: .neutral)
            }
            D1Chip(text: "倒计日", tone: .neutral)
            Spacer()
            Image(systemName: "magnifyingglass").foregroundStyle(theme.ink3)
        }
    }

    private func countdownMarker(_ date: LocalDate) -> Anniversary? {
        state.countdownStore.items.first { item in
            AnniversaryResolver.occurrence(for: item, now: date, engine: state.engine)?.date == date
        }
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

    private func shiftMonth(_ delta: Int) {
        var month = displayMonth + delta
        var year = displayYear
        if month < 1 { month = 12; year -= 1 }
        if month > 12 { month = 1; year += 1 }
        displayYear = year; displayMonth = month
    }

    private func nextSolarTermDays() -> (name: String, days: Int)? {
        var date = today
        for _ in 0..<40 {
            date = date.adding(days: 1)
            if let term = state.lunar(date).jieQi {
                return (term, today.daysBetween(date))
            }
        }
        return nil
    }
}
