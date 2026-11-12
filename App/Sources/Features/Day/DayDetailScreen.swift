import SwiftUI
import LixiangCalendarCore

private struct TermBox: Identifiable { let term: String; var id: String { term } }

struct DayDetailScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    let date: LocalDate
    @State private var showAllHours = false
    @State private var expandYiJi = false
    @State private var selectedTerm: String?
    @State private var expandMore = false
    @State private var showQuoteSheet = false

    private var almanac: AlmanacDay {
        state.almanac(date, hour: state.debugHour ?? BeijingTime.hour(of: Date()))
    }

    var body: some View {
        ScrollViewReader { proxy in
        ScrollView {
            VStack(spacing: 12) {
                MergedDayCard(date: date, variant: .day) { showQuoteSheet = true }
                    .frame(maxWidth: 520)
                    .frame(maxWidth: .infinity)
                religionYearRows
                weatherPanel
                festivalWindowPanel
                shichenBandCard.id("shichen-band")
                if showAllHours { expandedHourRows }
                HStack(spacing: 10) {
                    NavigationLink(value: Route.compass(date)) { miniCard(icon: "safari", title: "吉神罗盘", sub: compassSub) }
                        .buttonStyle(.plain)
                    NavigationLink(value: Route.content("dongzhi")) { miniCard(icon: "book.closed", title: "民俗 · 冬至", sub: "查看内容") }
                        .buttonStyle(.plain)
                }
                yiJiCard
                foldedRows
                entries
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            .padding(.bottom, 120)
        }
        .onAppear {
            #if DEBUG
            if state.debug.expandShichen { showAllHours = true }
            if state.debug.scrollShichen {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    withAnimation(nil) { proxy.scrollTo("shichen-band", anchor: .center) }
                }
            }
            #endif
        }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("\(date.month)月\(date.day)日 · \(navTitleSuffix)").d1Font(13, weight: .semibold).foregroundStyle(theme.ink2)
            }
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: ShareText.day(date)) { Image(systemName: "square.and.arrow.up") }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(ScreenBackground())
        .sheet(item: Binding(get: { selectedTerm.map { TermBox(term: $0) } }, set: { selectedTerm = $0?.term })) { box in
            PlainTermSheet(term: box.term)
        }
        .sheet(isPresented: $showQuoteSheet) {
            DailyVerseScreen(date: date)
        }
        .onAppear {
            #if DEBUG
            if let t = state.debug.debugTerm { selectedTerm = t }
            if state.debug.quoteSheet { showQuoteSheet = true }
            #endif
        }

    }

    private var navTitleSuffix: String {
        if let term = almanac.solarTerm { return term }
        if let f = almanac.festivals.first { return f }
        return almanac.lunar.monthDayText
    }

    private var datePhrase: String {
        if almanac.solarTerm == "冬至" { return "一年里夜最长的一天" }
        if let term = almanac.solarTerm { return "二十四节气 · \(term)" }
        if let f = almanac.festivals.first { return f }
        return "农历\(almanac.lunar.monthDayText)"
    }

    private var kickerText: String {
        let head = almanac.solarTerm ?? almanac.festivals.first ?? ""
        return head.isEmpty ? almanac.lunar.monthDayText : "\(head) · \(almanac.lunar.monthDayText)"
    }

    private var sealText: String { almanac.solarTerm ?? (almanac.festivals.first ?? "历象") }

    private var compassSub: String {
        "喜 \(almanac.positions.xi.rawValue) · 煞 \(almanac.sha?.rawValue ?? "—")"
    }

    private var dateCard: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 4) {
                Text(kickerText)
                    .d1Font(10).foregroundStyle(theme.ink3)
                    .frame(maxWidth: 240, alignment: .leading)
                    .lineLimit(1)
                Text("\(date.day)")
                    .d1SerifFont(108)
                    .foregroundStyle(theme.ink)
                    .fixedSize()
                Text(datePhrase)
                    .d1SerifFont(22, weight: .semibold)
                    .foregroundStyle(theme.ink)
                    .lineLimit(1)
                    .minimumScaleFactor(0.65)
                    .frame(maxWidth: 300, alignment: .leading)
                    .padding(.trailing, 64)   // 右侧 ≥64pt 安全区（印章独立位）
                Text("星期\(date.weekdayChinese) · \(almanac.lunar.yearGanZhi)年 · \(almanac.lunar.monthGanZhi)月 · \(almanac.lunar.dayGanZhi)日")
                    .d1Font(11).foregroundStyle(theme.ink3)
                    .lineLimit(2).fixedSize(horizontal: false, vertical: true)
                HStack(spacing: 6) {
                    D1Chip(text: "宜 \(almanac.yi.prefix(2).joined(separator: " "))", tone: .yi)
                    D1Chip(text: "忌 \(almanac.ji.prefix(2).joined(separator: " "))", tone: .ji)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            // 印章：独立右上角位（不压标题行）
            Text(sealText)
                .d1SerifFont(12)
                .foregroundStyle(theme.red)
                .multilineTextAlignment(.center)
                .frame(width: 40, height: 44)
                .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(theme.red, lineWidth: 1.2))
                .rotationEffect(.degrees(8))
                .padding(12)
                .accessibilityHidden(true)
        }
        .frame(minHeight: 196)
        .background(theme.paper, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(theme.line.opacity(0.6), lineWidth: 0.8))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(date.month)月\(date.day)日，\(datePhrase)，星期\(date.weekdayChinese)")
    }

    private var quoteCard: some View {
        Group {
            if let q = state.plainLanguage.quote(for: date) {
                Button { showQuoteSheet = true } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("“").d1SerifFont(34).foregroundStyle(theme.cream.opacity(0.55)).frame(height: 18)
                        Text(q.quote).d1SerifFont(22).foregroundStyle(theme.cream).lineLimit(2)
                        Text(q.zh).d1Font(11).foregroundStyle(theme.cream.opacity(0.92)).lineLimit(2)
                        Text("《道德经》第\(q.chapter)章 · 公版 · 点开读解释").d1Font(9).foregroundStyle(theme.cream.opacity(0.75))
                        Divider().overlay(theme.cream.opacity(0.25))
                        HStack {
                            Text("今天怎么用").d1Font(11, weight: .semibold).foregroundStyle(theme.cream)
                            Spacer()
                            Image(systemName: "chevron.right").d1Font(10).foregroundStyle(theme.cream.opacity(0.85))
                        }
                    }
                    .padding(16)
                    .frame(maxWidth: .infinity, minHeight: 190, alignment: .leading)
                    .background(LinearGradient(colors: [theme.quote1, theme.quote2], startPoint: .topLeading, endPoint: .bottomTrailing),
                                in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                }.buttonStyle(.plain)
                .accessibilityLabel("今日道德经，第\(q.chapter)章，\(q.quote)")
            }
        }
    }

    private var shichenBandCard: some View {
        let hours = mergedHours
        return D1Card(padding: 14) {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("时辰宜忌").d1SerifFont(20, weight: .semibold).foregroundStyle(theme.ink)
                    Spacer()
                    Text("12 时段 · 当前\(currentShichenName) · \(currentLuckText)").d1Font(10).foregroundStyle(theme.ink3)
                }
                HStack(spacing: 2) {
                    ForEach(Array(hours.enumerated()), id: \.offset) { idx, h in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(h.color(theme))
                            .frame(maxWidth: .infinity, minHeight: 14)
                            .overlay(alignment: .top) {
                                if idx == currentMergedIndex {
                                    VStack(spacing: 0) {
                                        Image(systemName: "arrowtriangle.down.fill").d1Font(7).foregroundStyle(theme.ink)
                                        Spacer(minLength: 0)
                                    }
                                    .offset(y: -9)
                                }
                            }
                            .overlay {
                                if idx == currentMergedIndex {
                                    RoundedRectangle(cornerRadius: 3).strokeBorder(theme.ink, lineWidth: 1.6)
                                }
                            }
                            .accessibilityElement()
                            .accessibilityLabel("\(shichenName(idx))，\(h.colorKind)，宜\(h.yiCount)忌\(h.jiCount)")
                    }
                }
                HStack(spacing: 12) {
                    legendDot(theme.jade, "宜"); legendDot(theme.amber, "平"); legendDot(theme.red, "忌")
                    Spacer()
                    Text("当前 \(currentShichenName) \(currentShichenRange)").d1Font(9).foregroundStyle(theme.ink3)
                }
                Text("平 = 宜忌并见/相近；传统参考，非吉凶预测。").d1Font(9).foregroundStyle(theme.ink3)
                Button(showAllHours ? "收起时辰详情" : "展开 12 时段详情") { D1Motion.withAnimation { showAllHours.toggle() } }
                    .d1Font(10, weight: .semibold).foregroundStyle(theme.accentStrong)
            }
        }
    }

    private var mergedHours: [BandHour] {
        let src = almanac.hours
        func counts(_ h: LunarHour) -> (Int, Int) {
            (h.yi.filter { $0 != "无" }.count, h.ji.filter { $0 != "无" }.count)
        }
        guard src.count >= 13 else { return src.map { let c = counts($0); return BandHour(yiCount: c.0, jiCount: c.1) } }
        let early = counts(src[0]); let late = counts(src[12])
        var out: [BandHour] = [BandHour(yiCount: early.0 + late.0, jiCount: early.1 + late.1)]
        out += src[1...11].map { let c = counts($0); return BandHour(yiCount: c.0, jiCount: c.1) }
        return out
    }

    private var currentMergedIndex: Int {
        guard let idx = almanac.currentHourIndex else { return -1 }
        if idx == 0 || idx == 12 { return 0 }
        return max(0, min(11, idx))
    }

    /// 展开 12 时段：文字（宜/平/忌）与色带同一 presence 判定
    private var expandedHourRows: some View {
        D1Card(padding: 14) {
            VStack(alignment: .leading, spacing: 6) {
                Text("12 时段详情（文字与色带同源）").d1Font(10, weight: .semibold).foregroundStyle(theme.ink3)
                ForEach(Array(mergedHours.enumerated()), id: \.offset) { idx, h in
                    HStack(spacing: 8) {
                        Text(slotLabel(idx)).d1Font(10).foregroundStyle(theme.ink3).frame(width: 56, alignment: .leading)
                        Text(h.colorKind)
                            .d1Font(11, weight: .semibold)
                            .foregroundStyle(h.color(theme))
                            .frame(width: 22, alignment: .leading)
                        Text("宜\(h.yiCount) · 忌\(h.jiCount)").d1Font(9).foregroundStyle(theme.ink3)
                        Text(luckText(idx)).d1Font(9, weight: .medium).foregroundStyle(luckText(idx) == "吉" ? theme.jade : theme.red)
                        Text("煞\(shaText(idx))").d1Font(9).foregroundStyle(theme.ink3)
                        Spacer()
                        if idx == currentMergedIndex { Text("当前").d1Font(9, weight: .semibold).foregroundStyle(theme.accentStrong) }
                    }
                    .padding(.vertical, 2)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("\(slotLabel(idx))，\(h.colorKind)，宜\(h.yiCount)忌\(h.jiCount)")
                    D1Divider()
                }
            }
        }
    }

    private func luckText(_ idx: Int) -> String {
        let real = idx == 0 ? 0 : idx
        guard almanac.hours.indices.contains(real) else { return "—" }
        return almanac.hours[real].luck
    }

    private func shaText(_ idx: Int) -> String {
        let real = idx == 0 ? 0 : idx
        guard almanac.hours.indices.contains(real) else { return "—" }
        return almanac.hours[real].sha?.rawValue ?? "—"
    }

    private var currentLuckText: String {
        guard let idx = almanac.currentHourIndex, almanac.hours.indices.contains(idx) else { return "日级参考" }
        return "黄黑道：\(almanac.hours[idx].luck)"
    }

    private func slotLabel(_ idx: Int) -> String {
        if idx == 0 { return "子时 23–01" }
        guard idx < almanac.hours.count else { return "—" }
        let h = almanac.hours[idx]
        return "\(h.ganZhi)时 \(h.startMinute)–\(h.endMinute)"
    }

    @State private var weather = WeatherService()

    private var upcomingFestivals: [(LocalDate, String)] {
        var out: [(LocalDate, String)] = []
        for off in 0...10 {
            let d = date.adding(days: off)
            for f in state.almanac(d).festivals { out.append((d, f)) }
        }
        return Array(out.prefix(5))
    }

    @ViewBuilder
    private var festivalWindowPanel: some View {
        D1Card(padding: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("民俗 · 未来 10 天").d1Font(11, weight: .semibold).foregroundStyle(theme.ink)
                if upcomingFestivals.isEmpty {
                    Text("未来 10 天暂无民俗内容").d1Font(10).foregroundStyle(theme.ink3)
                } else {
                    ForEach(Array(upcomingFestivals.enumerated()), id: \.offset) { _, item in
                        HStack(spacing: 8) {
                            Text("\(item.0.month)/\(item.0.day)").d1Font(10).foregroundStyle(theme.ink3).frame(width: 44, alignment: .leading)
                            Text(item.1).d1Font(11).foregroundStyle(theme.ink)
                            Spacer()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private var weatherPanel: some View {
        D1Card(padding: 12) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("天气 · 上海").d1Font(11, weight: .semibold).foregroundStyle(theme.ink)
                    Spacer()
                    switch weather.state {
                    case .loading: ProgressView().controlSize(.mini)
                    default:
                        Button("刷新") { Task { await weather.refresh(force: true) } }
                            .d1Font(9, weight: .semibold).foregroundStyle(theme.accentStrong)
                    }
                }
                switch weather.state {
                case .idle, .loading:
                    Text("加载中…").d1Font(10).foregroundStyle(theme.ink3)
                case .loaded(let snap, let cached):
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("\(Int(snap.temperature.rounded()))°").d1SerifFont(24, weight: .semibold).foregroundStyle(theme.ink)
                        Text(WeatherCode.text(snap.code)).d1Font(11).foregroundStyle(theme.ink2)
                        Spacer()
                        Text(cached ? "缓存" : "刚刚").d1Font(8).foregroundStyle(theme.ink3)
                    }
                    Text("天气数据：Open-Meteo（CC BY 4.0）· 仅供参考")
                        .d1Font(8).foregroundStyle(theme.ink3)
                case .failed(let msg):
                    Text(msg).d1Font(10).foregroundStyle(theme.ink3)
                    Text("天气数据：Open-Meteo（CC BY 4.0）").d1Font(8).foregroundStyle(theme.ink3)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .task {
            let watchdog = Task {
                try? await Task.sleep(nanoseconds: 10_000_000_000)
                weather.timeoutIfLoading()
            }
            await weather.refresh()
            watchdog.cancel()
        }
    }

    @ViewBuilder
    private var religionYearRows: some View {
        if let engine = state.engine as? LunarSwiftEngine {
            let tao = state.showTaoCalendar ? engine.taoInfo(for: date) : nil
            let foto = state.showFotoCalendar ? engine.fotoInfo(for: date) : nil
            if tao != nil || foto != nil {
                D1Card(padding: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        if let tao {
                            Text("道历 \(tao.year) 年 · \(tao.yearInChinese)")
                                .d1Font(11, weight: .semibold).foregroundStyle(theme.ink)
                            if !tao.festivals.isEmpty {
                                Text("道历节日：\(tao.festivals.joined(separator: "、"))")
                                    .d1Font(10).foregroundStyle(theme.ink3)
                                    .accessibilityLabel("道历节日：\(tao.festivals.joined(separator: "、"))")
                            }
                        }
                        if let foto {
                            Text("佛历 \(foto.year) 年 · \(foto.yearInChinese)")
                                .d1Font(11, weight: .semibold).foregroundStyle(theme.ink)
                            if !foto.festivals.isEmpty {
                                Text("佛历节日：\(foto.festivals.joined(separator: "、"))")
                                    .d1Font(10).foregroundStyle(theme.ink3)
                                    .accessibilityLabel("佛历节日：\(foto.festivals.joined(separator: "、"))")
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }

    private func shichenName(_ idx: Int) -> String {
        if idx == 0 { return "子时" }
        let srcIdx = idx
        guard srcIdx < almanac.hours.count else { return "—" }
        return "\(almanac.hours[srcIdx].ganZhi)时"
    }

    private var currentShichenName: String {
        guard let idx = almanac.currentHourIndex, idx < almanac.hours.count else { return "—" }
        return "\(almanac.hours[idx].ganZhi)时"
    }

    private var currentShichenRange: String {
        guard let idx = almanac.currentHourIndex, idx < almanac.hours.count else { return "" }
        return "\(almanac.hours[idx].startMinute)–\(almanac.hours[idx].endMinute)"
    }

    private func legendDot(_ color: Color, _ text: String) -> some View {
        HStack(spacing: 3) {
            RoundedRectangle(cornerRadius: 1.5).fill(color).frame(width: 8, height: 8)
            Text(text).d1Font(9).foregroundStyle(theme.ink3)
        }
    }

    private func miniCard(icon: String, title: String, sub: String) -> some View {
        D1Card(padding: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Image(systemName: icon).d1Font(15).foregroundStyle(theme.accentStrong)
                Text(title).d1Font(12, weight: .semibold).foregroundStyle(theme.ink).lineLimit(1)
                Text(sub).d1Font(9).foregroundStyle(theme.ink3).lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private var yiJiCard: some View {
        let deduped = YiJiItems.dedupe(yi: almanac.yi, ji: almanac.ji)
        return D1Card {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    SectionLabel(text: "宜忌")
                    Spacer()
                    Toggle("白话", isOn: $state.showVernacular)
                        .labelsHidden()
                        .scaleEffect(0.75)
                    Text("白话").d1Font(10).foregroundStyle(theme.ink3)
                }
                yiJiRow(kind: .yi, items: deduped.yi)
                D1Divider()
                yiJiRow(kind: .ji, items: deduped.ji)
                HStack {
                    Button(expandYiJi ? "收起" : "展开全部") { D1Motion.withAnimation { expandYiJi.toggle() } }
                        .d1Font(11, weight: .semibold)
                        .foregroundStyle(theme.accentStrong)
                    Spacer()
                    Text("共 \(deduped.yi.count) / \(deduped.ji.count) 项")
                        .d1Font(9).foregroundStyle(theme.ink3)
                }
                if state.showVernacular {
                    Text("白话：宜=传统历书认为适合做的事；忌=认为不太适合做的事，不是绝对禁令，传统历书流派间可能不同。")
                        .d1Font(10).foregroundStyle(theme.ink3)
                }
            }
        }
    }

    private func yiJiRow(kind: YiJiKind, items: [String]) -> some View {
        let maxChips = 6
        let shown = expandYiJi ? items : Array(items.prefix(maxChips))
        let more = max(0, items.count - maxChips)
        return VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Text(kind == .yi ? "宜" : "忌")
                    .d1Font(12, weight: .bold)
                    .foregroundStyle(kind == .yi ? theme.yiText : theme.jiText)
                    .frame(width: 18, alignment: .leading)
                FlowChips(items: shown, tone: kind == .yi ? .yi : .ji) { selectedTerm = $0 }
                if !expandYiJi && more > 0 {
                    D1Chip(text: "+\(more)", tone: .neutral)
                }
                if state.showVernacular {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(shown, id: \.self) { term in
                            if let t = state.plainLanguage.term(named: term) {
                                Text("· \(term) — \(t.zh)").d1Font(9).foregroundStyle(theme.ink3)
                            }
                        }
                    }
                    .padding(.top, 2)
                }
            }
        }
    }

    private var shichenCard: some View {
        ShichenCard(hours: almanac.hours, currentIndex: almanac.currentHourIndex,
                    expanded: $showAllHours)
    }

    private var foldedRows: some View {
        VStack(spacing: 0) {
            foldRow("冲煞", "\(almanac.chongDesc) · 煞方 \(almanac.sha?.rawValue ?? "—")")
            foldRow("吉神宜趋", almanac.jiShen.joined(separator: " · "))
            if expandMore {
                foldRow("凶煞宜忌", almanac.xiongSha.joined(separator: " · "))
                foldRow("彭祖百忌", "\(almanac.pengZuGan)；\(almanac.pengZuZhi)")
                foldRow("胎神", almanac.taiShen)
                foldRow("星宿 · 建除", "\(almanac.xiu) · \(almanac.zhiXing) · \(almanac.tianShenType)")
                foldRow("纳音 · 五行", "\(almanac.dayNaYin) · \(almanac.wuXing)")
            }
            Button(expandMore ? "收起更多黄历" : "展开更多黄历") { D1Motion.withAnimation { expandMore.toggle() } }
                .d1Font(11, weight: .semibold).foregroundStyle(theme.accentStrong)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14).padding(.vertical, 10)
        }
        .background(theme.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(theme.line, lineWidth: 1))
    }

    private func foldRow(_ title: String, _ value: String) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                Text(title).d1Font(11, weight: .semibold).foregroundStyle(theme.ink2)
                    .frame(width: 72, alignment: .leading)
                Text(value).d1Font(11).foregroundStyle(theme.ink2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 14).padding(.vertical, 10)
            D1Divider().padding(.leading, 14)
        }
    }

    private var entries: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                if let id = state.contentID(for: date) {
                    NavigationLink(value: Route.content(id)) { entryRow("民俗内容", "查看 ›") }
                }
            }
        }
    }

    private func entryRow(_ title: String, _ detail: String) -> some View {
        D1Card(padding: 12) {
            HStack {
                Text(title).d1Font(12, weight: .semibold).foregroundStyle(theme.ink)
                Spacer()
                Text(detail).d1Font(10).foregroundStyle(theme.ink3)
            }
        }
    }
}

private struct ShichenCard: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    let hours: [LunarHour]
    let currentIndex: Int?
    @Binding var expanded: Bool

    var body: some View {
        D1Card {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    SectionLabel(text: "时辰宜忌")
                    Spacer()
                    Text("按北京时间 · 时家口径")
                        .d1Font(9).foregroundStyle(theme.ink3)
                }
                if let currentIndex, let current = displayRows.first(where: { $0.indexes.contains(currentIndex) }) {
                    row(current, highlighted: true)
                }
                if expanded {
                    ForEach(displayRows.filter { !$0.indexes.contains(currentIndex ?? -1) }) { row($0, highlighted: false) }
                }
                Button(expanded ? "收起" : "展开全部 12 时辰") { D1Motion.withAnimation { expanded.toggle() } }
                    .d1Font(11, weight: .semibold).foregroundStyle(theme.accentStrong)
            }
        }
    }

    private func row(_ item: DisplayHour, highlighted: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Text(item.name).d1Font(12, weight: .semibold).foregroundStyle(theme.ink)
                Text(item.range).d1Font(10).foregroundStyle(theme.ink3)
                if highlighted { D1Chip(text: "当前时辰", tone: .accent) }
                Spacer()
            }
            ForEach(item.segments) { seg in
                HStack(alignment: .top, spacing: 6) {
                    Text(seg.label).d1Font(9, weight: .semibold).foregroundStyle(theme.ink3)
                        .frame(width: 84, alignment: .leading)
                    Text("\(seg.ganZhi) \(seg.luck)").d1Font(9).foregroundStyle(theme.ink3)
                    Spacer()
                }
                Text("宜 \(seg.yi.prefix(3).joined(separator: " · "))")
                    .d1Font(9).foregroundStyle(theme.ink2).lineLimit(1)
                Text("忌 \(seg.ji.prefix(3).joined(separator: " · "))")
                    .d1Font(9).foregroundStyle(theme.ink2).lineLimit(1)
            }
        }
        .padding(8)
        .background(highlighted ? theme.soft : Color.clear, in: RoundedRectangle(cornerRadius: 12))
        .overlay {
            if highlighted {
                RoundedRectangle(cornerRadius: 12).strokeBorder(theme.accentStrong, lineWidth: 1)
            }
        }
    }

    /// 12 个展示时段：子时合并早/晚两段
    private var displayRows: [DisplayHour] {
        var rows: [DisplayHour] = []
        let names = ["子","丑","寅","卯","辰","巳","午","未","申","酉","戌","亥"]
        func segment(_ hour: LunarHour, label: String) -> DisplaySegment {
            DisplaySegment(id: "\(hour.index)", label: label, ganZhi: hour.ganZhi, luck: hour.luck, yi: hour.yi, ji: hour.ji)
        }
        if let early = hours.first, let late = hours.last, hours.count == 13 {
            rows.append(DisplayHour(id: "zi", name: "子时", range: "23:00–00:59",
                                    indexes: [0, 12],
                                    segments: [segment(early, label: "早子 00:00–00:59"),
                                               segment(late, label: "晚子 23:00–23:59")]))
            for i in 1..<12 {
                let h = hours[i]
                rows.append(DisplayHour(id: "h\(i)", name: "\(names[i % 12])时", range: "\(h.startMinute)–\(h.endMinute)",
                                        indexes: [i],
                                        segments: [segment(h, label: "时家宜忌")]))
            }
        }
        return rows
    }
}

private struct DisplaySegment: Identifiable {
    let id: String
    let label: String
    let ganZhi: String
    let luck: String
    let yi: [String]
    let ji: [String]
}

private struct DisplayHour: Identifiable {
    let id: String
    let name: String
    let range: String
    let indexes: [Int]
    let segments: [DisplaySegment]
}

/// 时辰色带（designer spec 8bfd6750 / 验收 3-7-2、4-7-1、2-8-2）：
/// 单边覆盖：仅宜→绿、仅忌→朱；宜忌并见或双无→平（琥珀）
/// 注：PM 文字中的 score(宜数−忌数) 版本与验收数字不一致，已按验收数字实现并在证据中给出两套分布
struct BandHour {
    var yiCount: Int
    var jiCount: Int
    var score: Int { yiCount - jiCount }
    var colorKind: String {
        if yiCount > 0 && jiCount == 0 { return "宜" }
        if jiCount > 0 && yiCount == 0 { return "忌" }
        return "平"
    }
    func color(_ theme: D1Theme) -> Color {
        switch colorKind {
        case "宜": return theme.jade
        case "忌": return theme.red
        default: return theme.amber
        }
    }
    /// B′ 计数版（仅供证据对照）
    var b2ColorKind: String {
        if score >= 2 { return "宜" }
        if score <= -2 { return "忌" }
        return "平"
    }
}

enum ShareText {
    static func day(_ date: LocalDate) -> String {
        "历象 · \(date.month)月\(date.day)日（农历）· 传统历法民俗参考"
    }
}
