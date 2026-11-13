import SwiftUI
import LixiangCalendarCore

/// R14 黄历（T3）：所选日整组重算、前后一天、白话开关、字段全、岁时匹配、罗盘入口
struct R14AlmanacScreen: View {
    @Environment(\.d1) private var theme
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var days: SelectedDayStore
    let date: LocalDate
    @State private var showAllHours = false

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                let wide = AlmanacLayout.columns(width: geo.size.width) == 2
                if wide {
                    HStack(alignment: .top, spacing: 16) { left; right }.padding(16)
                } else {
                    VStack(alignment: .leading, spacing: 12) { left; right }.padding(16)
                }
            }
        }
        .background(ScreenBackground())
        .navigationTitle(Text(verbatim: "\(date.year)年\(date.month)月\(date.day)日"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(value: R14Route.compass(days.selectedDate, hour: days.hourIndex ?? 12)) {
                    Text("值神罗盘").d1Font(11, weight: .semibold)
                        .padding(.horizontal, 10).frame(minHeight: 44)
                }
            }
        }
        .onAppear { if days.selectedDate != date { days.select(date) } }
    }

    private var left: some View {
        VStack(alignment: .leading, spacing: 12) {
            D1Card(padding: 14) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(verbatim: "\(days.selectedDate.year)年\(days.selectedDate.month)月\(days.selectedDate.day)日 · 星期\(days.selectedDate.weekdayChinese)")
                        .d1Font(12, weight: .semibold).foregroundStyle(theme.ink)
                    Text(verbatim: "农历\(days.lunar.monthDayText) · \(days.lunar.yearGanZhi)年 \(days.lunar.monthGanZhi)月 \(days.lunar.dayGanZhi)日")
                        .d1Font(11).foregroundStyle(theme.ink2)
                    if let term = days.almanac.solarTerm { Text("节气 \(term)").d1Font(10).foregroundStyle(theme.solarTermText) }
                    HStack(spacing: 10) {
                        Button("前一天") { days.previousDay() }.d1Font(11, weight: .semibold)
                        Button("今天") { days.selectToday() }.d1Font(11, weight: .semibold)
                        Button("后一天") { days.nextDay() }.d1Font(11, weight: .semibold)
                    }.frame(minHeight: 44)
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            D1Card(padding: 14) {
                VStack(alignment: .leading, spacing: 5) {
                    Toggle(isOn: $state.showVernacular) { Text("白话").d1Font(11).foregroundStyle(theme.ink) }.tint(theme.accent)
                    HStack(alignment: .top, spacing: 6) { Text("宜").d1Font(11, weight: .semibold).foregroundStyle(theme.yiText); Text(days.almanac.yi.joined(separator: " ")).d1Font(11).foregroundStyle(theme.ink2) }
                    HStack(alignment: .top, spacing: 6) { Text("忌").d1Font(11, weight: .semibold).foregroundStyle(theme.red); Text(days.almanac.ji.joined(separator: " ")).d1Font(11).foregroundStyle(theme.ink2) }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            if !days.matchedFestivals.isEmpty {
                D1Card(padding: 12) { Text("岁时：\(days.matchedFestivals.joined(separator: "、"))").d1Font(11).foregroundStyle(theme.ink2) }
            }
        }
    }

    private var right: some View {
        VStack(alignment: .leading, spacing: 12) {
            D1Card(padding: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("黄历").d1Font(13, weight: .semibold).foregroundStyle(theme.ink)
                    field("纪元", "黄帝\(days.selectedDate.year + 2697)年")
                    field("值神", "\(days.almanac.tianShen)（\(days.almanac.tianShenType)）")
                    field("冲煞", "\(days.almanac.chongDesc) · 煞\(days.sha?.rawValue ?? "—")")
                    field("纳音", days.almanac.dayNaYin)
                    field("建除", days.almanac.zhiXing)
                    field("彭祖", "\(days.almanac.pengZuGan)；\(days.almanac.pengZuZhi)")
                    field("胎神", days.almanac.taiShen)
                    field("星宿", days.almanac.xiu)
                    field("吉神", days.almanac.jiShen.joined(separator: " · "))
                    field("凶煞", days.almanac.xiongSha.joined(separator: " · "))
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            D1Card(padding: 12) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack { Text("十二时辰").d1Font(13, weight: .semibold).foregroundStyle(theme.ink); Spacer()
                        Button(showAllHours ? "收起" : "展开") { withAnimation { showAllHours.toggle() } }.d1Font(10, weight: .semibold).foregroundStyle(theme.accentStrong) }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 4) {
                            ForEach(Array(days.shichen.prefix(12).enumerated()), id: \.offset) { idx, h in
                                VStack(spacing: 2) {
                                    Text(h.ganZhi).d1Font(9).foregroundStyle(theme.ink)
                                    Text(h.luck).d1Font(8).foregroundStyle(h.luck == "吉" ? theme.yiText : theme.red)
                                }
                                .padding(.horizontal, 6).padding(.vertical, 5)
                                .background(idx == days.hourIndex ? theme.accent.opacity(0.18) : theme.card, in: RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    if showAllHours {
                        ForEach(Array(days.shichen.enumerated()), id: \.offset) { _, h in
                            HStack { Text("\(h.ganZhi)时"); Text("\(h.startMinute)–\(h.endMinute)"); Spacer(); Text("煞\(h.sha?.rawValue ?? "—")"); Text(h.luck) }
                                .d1Font(10).foregroundStyle(theme.ink2)
                        }
                    }
                }
            }
        }
    }

    private func field(_ label: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text(label).d1Font(10).foregroundStyle(theme.ink3).frame(width: 40, alignment: .leading)
            Text(value).d1Font(11).foregroundStyle(theme.ink2).frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

enum AlmanacLayout {
    static func columns(width: CGFloat) -> Int { width >= 744 ? 2 : 1 }
}
