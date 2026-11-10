import SwiftUI
import LixiangCalendarCore

struct DayDetailScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    let date: LocalDate
    @State private var showAllHours = false
    @State private var expandYiJi = false
    @State private var expandMore = false

    private var almanac: AlmanacDay { state.almanac(date, hour: BeijingTime.hour(of: Date())) }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                header
                yiJiCard
                shichenCard
                foldedRows
                entries
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(ScreenBackground())
        .navigationTitle("\(date.month)月\(date.day)日")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var header: some View {
        D1Card {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 14) {
                    Text("\(date.day)")
                        .font(.system(size: 78, weight: .semibold)).tracking(-2)
                        .foregroundStyle(theme.ink)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("星期\(date.weekdayChinese) · 农历\(almanac.lunar.monthDayText)")
                            .font(.system(size: 13, weight: .medium)).foregroundStyle(theme.ink2)
                        Text("\(almanac.lunar.yearGanZhi)年 \(almanac.lunar.monthGanZhi)月 \(almanac.lunar.dayGanZhi)日")
                            .font(.system(size: 10)).foregroundStyle(theme.ink3)
                        HStack(spacing: 6) {
                            if let term = almanac.solarTerm { D1Chip(text: term, tone: .jade) }
                            D1Chip(text: "值神 \(almanac.tianShen)", tone: .neutral)
                        }
                    }
                    Spacer()
                }
                if !almanac.festivals.isEmpty {
                    HStack(spacing: 6) {
                        ForEach(almanac.festivals.prefix(3), id: \.self) { D1Chip(text: $0, tone: .accent) }
                    }
                }
            }
        }
    }

    private var yiJiCard: some View {
        D1Card {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    SectionLabel(text: "宜忌")
                    Spacer()
                    Toggle("白话", isOn: $state.showVernacular)
                        .labelsHidden()
                        .scaleEffect(0.75)
                    Text("白话").font(.system(size: 10)).foregroundStyle(theme.ink3)
                }
                yiJiColumn(kind: .yi, items: almanac.yi)
                D1Divider()
                yiJiColumn(kind: .ji, items: almanac.ji)
                Button(expandYiJi ? "收起" : "展开全部") { withAnimation { expandYiJi.toggle() } }
                    .font(.system(size: 11, weight: .semibold)).foregroundStyle(theme.accentStrong)
            }
        }
    }

    private func yiJiColumn(kind: YiJiKind, items: [String]) -> some View {
        let groups = YiJiGrouping.groups(for: items, kind: kind)
        return VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Text(kind == .yi ? "宜" : "忌")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(kind == .yi ? theme.accentStrong : theme.ink)
                ForEach(groups) { group in
                    D1Chip(text: group.category.title, tone: kind == .yi ? .accent : .strong)
                }
            }
            if expandYiJi {
                ForEach(groups) { group in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(group.category.title).font(.system(size: 9, weight: .semibold)).foregroundStyle(theme.ink3)
                        Text(group.items.joined(separator: " · "))
                            .font(.system(size: 11)).foregroundStyle(theme.ink2)
                    }
                }
            } else {
                Text(items.prefix(6).joined(separator: " · "))
                    .font(.system(size: 11)).foregroundStyle(theme.ink2)
                    .lineLimit(2)
            }
            if state.showVernacular {
                Text(kind == .yi ? "白话：传统历书里认为适合做的事。" : "白话：传统历书里认为不太适合做的事，不是绝对禁令。")
                    .font(.system(size: 10)).foregroundStyle(theme.ink3)
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
            Button(expandMore ? "收起更多黄历" : "展开更多黄历") { withAnimation { expandMore.toggle() } }
                .font(.system(size: 11, weight: .semibold)).foregroundStyle(theme.accentStrong)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 14).padding(.vertical, 10)
        }
        .background(theme.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(theme.line, lineWidth: 1))
    }

    private func foldRow(_ title: String, _ value: String) -> some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                Text(title).font(.system(size: 11, weight: .semibold)).foregroundStyle(theme.ink2)
                    .frame(width: 72, alignment: .leading)
                Text(value).font(.system(size: 11)).foregroundStyle(theme.ink2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 14).padding(.vertical, 10)
            D1Divider().padding(.leading, 14)
        }
    }

    private var entries: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                entryRow("吉神罗盘", "数据已就绪 · 界面 P2")
                if let id = state.contentID(for: date) {
                    NavigationLink(value: Route.content(id)) { entryRow("民俗内容", "查看 ›") }
                }
            }
        }
    }

    private func entryRow(_ title: String, _ detail: String) -> some View {
        D1Card(padding: 12) {
            HStack {
                Text(title).font(.system(size: 12, weight: .semibold)).foregroundStyle(theme.ink)
                Spacer()
                Text(detail).font(.system(size: 10)).foregroundStyle(theme.ink3)
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
                        .font(.system(size: 9)).foregroundStyle(theme.ink3)
                }
                if let currentIndex, let current = displayRows.first(where: { $0.indexes.contains(currentIndex) }) {
                    row(current, highlighted: true)
                }
                if expanded {
                    ForEach(displayRows.filter { !$0.indexes.contains(currentIndex ?? -1) }) { row($0, highlighted: false) }
                }
                Button(expanded ? "收起" : "展开全部 12 时辰") { withAnimation { expanded.toggle() } }
                    .font(.system(size: 11, weight: .semibold)).foregroundStyle(theme.accentStrong)
            }
        }
    }

    private func row(_ item: DisplayHour, highlighted: Bool) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 6) {
                Text(item.name).font(.system(size: 12, weight: .semibold)).foregroundStyle(theme.ink)
                Text(item.range).font(.system(size: 10)).foregroundStyle(theme.ink3)
                if highlighted { D1Chip(text: "当前时辰", tone: .accent) }
                Spacer()
            }
            ForEach(item.segments) { seg in
                HStack(alignment: .top, spacing: 6) {
                    Text(seg.label).font(.system(size: 9, weight: .semibold)).foregroundStyle(theme.ink3)
                        .frame(width: 84, alignment: .leading)
                    Text("\(seg.ganZhi) \(seg.luck)").font(.system(size: 9)).foregroundStyle(theme.ink3)
                    Spacer()
                }
                Text("宜 \(seg.yi.prefix(3).joined(separator: " · "))")
                    .font(.system(size: 9)).foregroundStyle(theme.ink2).lineLimit(1)
                Text("忌 \(seg.ji.prefix(3).joined(separator: " · "))")
                    .font(.system(size: 9)).foregroundStyle(theme.ink2).lineLimit(1)
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
