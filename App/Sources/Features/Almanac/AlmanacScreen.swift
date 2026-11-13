import SwiftUI
import LixiangCalendarCore

/// R14 黄历（T3）：对照 almanac-phone-light 重做——红 Hero + 纪元 + 当日岁时 + 宜忌逐项白话
struct R14AlmanacScreen: View {
    @Environment(\.d1) private var theme
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var days: SelectedDayStore
    @EnvironmentObject private var chrome: R14ChromeState
    let date: LocalDate
    @State private var showAllHours = false

    private var engine: LunarSwiftEngine? { days.engine as? LunarSwiftEngine }
    private var taoYear: Int? { engine?.taoInfo(for: days.selectedDate)?.year }
    private var fotoYear: Int? { engine?.fotoInfo(for: days.selectedDate)?.year }
    private var festival: String? { days.matchedFestivals.first }
    private var festivalCategory: String {
        guard let id = state.contentID(for: days.selectedDate) else { return "岁时" }
        _ = id
        return "民俗"
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                if geo.size.width >= 744 || R14WideProbe.force {
                    HStack(alignment: .top, spacing: 20) {
                        ScrollView { VStack(alignment: .leading, spacing: 14) { leftColumn; yiJiCard } }
                            .frame(width: geo.size.width * 0.40)
                        ScrollView { wideHoursColumn }
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 24).padding(.top, 16).padding(.bottom, 120)
                } else {
                    VStack(alignment: .leading, spacing: 14) { leftColumn; rightColumn }
                        .padding(.horizontal, 16).padding(.top, 8).padding(.bottom, 120)
                }
            }
        }
        .background(theme.bg)
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            chrome.forceTabBarVisible = true
            if days.selectedDate != date { days.select(date) }
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("-LixiangVernacular") { state.showVernacular = true }
            #endif
        }
        .onDisappear { chrome.forceTabBarVisible = false }
    }

    // MARK: 左列：红 Hero + 纪元 + 当日岁时 + 前后一天
    private var leftColumn: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.left").d1Font(14, weight: .semibold).foregroundStyle(theme.cream)
                        .frame(width: 40, height: 40)
                        .r14Glass(Circle())
                }.buttonStyle(.plain).accessibilityLabel("返回")
                Text("黄历").d1SerifFont(22, weight: .semibold).foregroundStyle(theme.cream)
                Spacer()
                NavigationLink(value: R14Route.compass(days.selectedDate, hour: days.hourIndex)) {
                    Text("值神罗盘").d1Font(11, weight: .semibold).foregroundStyle(Color.r14Red)
                        .padding(.horizontal, 12).frame(minHeight: 40)
                        .background(theme.cream, in: Capsule())
                }.buttonStyle(.plain)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(verbatim: "\(days.selectedDate.year)年\(days.selectedDate.month)月\(days.selectedDate.day)日 · 星期\(days.selectedDate.weekdayChinese)")
                    .d1SerifFont(24, weight: .semibold).foregroundStyle(theme.cream)
                Text(verbatim: "农历\(days.lunar.monthDayText) · \(days.lunar.yearGanZhi)年 \(days.lunar.monthGanZhi)月 \(days.lunar.dayGanZhi)日")
                    .d1Font(11).foregroundStyle(theme.cream.opacity(0.9))
                if let idx = days.hourIndex, days.shichen.indices.contains(idx) {
                    let h = days.shichen[idx]
                    Text(verbatim: "\(h.ganZhi)时 \(h.startMinute)–\(h.endMinute)").d1SerifFont(12).foregroundStyle(theme.cream.opacity(0.8))
                }
                HStack(spacing: 6) {
                    Image(systemName: "sun.max").d1Font(10)
                    Text(verbatim: "黄帝纪元 · 道历 \(taoYear ?? days.selectedDate.year + 2697) 年").d1Font(10)
                }.foregroundStyle(theme.cream.opacity(0.92))
                HStack(spacing: 6) {
                    Image(systemName: "leaf").d1Font(10)
                    Text(verbatim: "佛历纪元 \(fotoYear ?? 2570) 年").d1Font(10)
                }.foregroundStyle(theme.cream.opacity(0.92))
                if let festival = festival ?? days.almanac.solarTerm {
                    NavigationLink(value: R14Route.folkloreDetail(id: state.contentID(for: days.selectedDate) ?? "xiezao", version: nil)) {
                        HStack(spacing: 6) {
                            Text("当日岁时").d1Font(9).foregroundStyle(theme.cream.opacity(0.8))
                            Text(festival).d1SerifFont(14, weight: .semibold).foregroundStyle(theme.cream)
                            Text(festivalCategory).d1Font(8).foregroundStyle(theme.cream.opacity(0.75))
                                .padding(.horizontal, 6).padding(.vertical, 2)
                                .background(theme.cream.opacity(0.15), in: Capsule())
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right").d1Font(9).foregroundStyle(theme.cream.opacity(0.8))
                        }
                        .padding(.horizontal, 10).padding(.vertical, 8)
                        .background(theme.cream.opacity(0.12), in: RoundedRectangle(cornerRadius: 12))
                    }.buttonStyle(.plain).padding(.top, 2)
                }
                HStack(spacing: 10) {
                    Button { days.previousDay() } label: {
                        Text("前一天").d1Font(11, weight: .semibold).foregroundStyle(theme.cream)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(theme.cream.opacity(0.6)))
                    }.buttonStyle(.plain)
                    Button { days.nextDay() } label: {
                        Text("后一天").d1Font(11, weight: .semibold).foregroundStyle(theme.cream)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(theme.cream.opacity(0.6)))
                    }.buttonStyle(.plain)
                }.padding(.top, 4)
            }
        }
        .padding(16)
        .background(LinearGradient(colors: [Color.r14Red, Color.r14RedDeep], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    // MARK: 右列：宜忌卡 + 时辰
    private var wideHoursColumn: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("一日十二辰 · 各有次序").d1Font(10, weight: .semibold).tracking(1.4).foregroundStyle(theme.ink3)
            Text("把一天，慢慢展开").d1SerifFont(26, weight: .semibold).foregroundStyle(theme.ink)
            Text("十二时辰在同一列表中，上下滑动查看。时段按北京时间。").d1Font(10).foregroundStyle(theme.ink3)
            Divider().overlay(theme.line)
            ForEach(Array(days.shichen.prefix(12).enumerated()), id: \.offset) { _, h in
                VStack(alignment: .leading, spacing: 5) {
                    HStack { Text("\(h.ganZhi)时").d1SerifFont(18, weight: .semibold).foregroundStyle(theme.ink)
                        Text("\(h.startMinute)—\(h.endMinute)").d1Font(10).foregroundStyle(theme.ink3)
                        Spacer()
                        Text(h.luck).d1Font(9, weight: .semibold).foregroundStyle(h.luck == "吉" ? theme.yiText : theme.red)
                            .padding(.horizontal, 8).padding(.vertical, 3)
                            .background((h.luck == "吉" ? theme.yiText : theme.red).opacity(0.10), in: Capsule())
                    }
                    Text(verbatim: "\(h.tianShen) · \(h.chongDesc) · 煞\(h.sha?.rawValue ?? "—")").d1Font(10).foregroundStyle(theme.ink2)
                    HStack(alignment: .top, spacing: 8) {
                        Text("宜").d1Font(11, weight: .semibold).foregroundStyle(theme.yiText).frame(width: 18)
                        Text(h.yi.prefix(6).joined(separator: "  ")).d1Font(10).foregroundStyle(theme.ink2)
                    }
                    HStack(alignment: .top, spacing: 8) {
                        Text("忌").d1Font(11, weight: .semibold).foregroundStyle(theme.red).frame(width: 18)
                        Text(h.ji.prefix(6).joined(separator: "  ")).d1Font(10).foregroundStyle(theme.ink2)
                    }
                }
                .padding(.vertical, 6)
                Divider().overlay(theme.line.opacity(0.5))
            }
        }
        .padding(16)
        .background(theme.paper, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(theme.line.opacity(0.6)))
    }

    private var rightColumn: some View {
        VStack(alignment: .leading, spacing: 14) {
            yiJiCard
            hoursCard
        }
    }

    private var yiJiCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("宜忌").d1SerifFont(20, weight: .semibold).foregroundStyle(theme.ink)
                Spacer()
                Text("逐项可读").d1Font(9, weight: .semibold).foregroundStyle(Color.r14Red)
                    .padding(.horizontal, 8).padding(.vertical, 4)
                    .overlay(Capsule().strokeBorder(Color.r14Red.opacity(0.5)))
            }
            Toggle(isOn: $state.showVernacular) {
                VStack(alignment: .leading, spacing: 1) {
                    Text("白话全解").d1Font(11, weight: .semibold).foregroundStyle(theme.ink)
                    Text("开启后逐项显示白话解释").d1Font(9).foregroundStyle(theme.ink3)
                }
            }.tint(theme.accent)
            Divider().overlay(theme.line)
            termSection("宜", days.almanac.yi, color: theme.yiText)
            Divider().overlay(theme.line)
            termSection("忌", days.almanac.ji, color: theme.red)
        }
        .padding(16)
        .background(theme.paper, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(theme.line.opacity(0.6)))
    }

    private func termSection(_ label: String, _ items: [String], color: Color) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Text(label).d1SerifFont(20, weight: .semibold).foregroundStyle(color)
                Text("· \(items.count) 项").d1Font(9).foregroundStyle(theme.ink3)
            }
            ForEach(Array(items.enumerated()), id: \.offset) { idx, term in
                VStack(alignment: .leading, spacing: 3) {
                    Text(term).d1Font(12, weight: .semibold).foregroundStyle(theme.ink)
                    if state.showVernacular {
                        let matched = state.plainLanguage.panelTermMatching(term)
                        let expl = matched?.detailText ?? matched?.zh
                            ?? "「\(term)」为传统黄历用语，是否适合仍需结合现实安排与参与者情况判断。"
                        Text(expl).d1Font(10).foregroundStyle(theme.ink2).lineSpacing(2)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if idx < items.count - 1 { Divider().overlay(theme.line.opacity(0.5)) }
            }
        }
    }

    private var hoursCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("十二时辰").d1SerifFont(18, weight: .semibold).foregroundStyle(theme.ink)
            ForEach(Array(days.shichen.prefix(12).enumerated()), id: \.offset) { idx, h in
                HStack {
                    Text("\(h.ganZhi)时").d1Font(10, weight: idx == days.hourIndex ? .semibold : .regular).foregroundStyle(theme.ink)
                    Text("\(h.startMinute)–\(h.endMinute)").d1Font(9).foregroundStyle(theme.ink3)
                    Spacer()
                    Text("煞\(h.sha?.rawValue ?? "—")").d1Font(9).foregroundStyle(theme.ink2)
                    Text(h.luck).d1Font(9).foregroundStyle(h.luck == "吉" ? theme.yiText : theme.red)
                }.frame(minHeight: 24)
            }
        }
        .padding(14)
        .background(theme.paper, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(theme.line.opacity(0.6)))
    }
}

enum AlmanacLayout {
    static func columns(width: CGFloat) -> Int { width >= 744 ? 2 : 1 }
}
