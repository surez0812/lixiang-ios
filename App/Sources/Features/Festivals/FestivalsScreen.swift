import SwiftUI
import LixiangCalendarCore

struct FestivalsScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme

    private var groups: (past: [ContentIndexRow], today: [ContentIndexRow], upcoming: [ContentIndexRow]) {
        state.indexGroups()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("按日子走").font(D1Theme.serif(30)).foregroundStyle(theme.ink)
                    Text("节俗内容按日期解锁 · 按北京时间").font(.system(size: 10)).foregroundStyle(theme.ink3)
                }
                .padding(.top, 8)

                section("即将到来", rows: groups.upcoming, tone: .jade)
                section("今日解锁", rows: groups.today, tone: .accent)
                section("已过 · 可回看", rows: groups.past, tone: .neutral)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(ScreenBackground())
        .navigationTitle("")
        .navigationBarHidden(true)
    }

    @ViewBuilder
    private func section(_ title: String, rows: [ContentIndexRow], tone: D1Chip.Tone) -> some View {
        if !rows.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    SectionLabel(text: title)
                    Text("\(rows.count)").font(.system(size: 9)).foregroundStyle(theme.ink3)
                }
                ForEach(rows) { row in
                    NavigationLink(value: Route.content(row.contentID)) {
                        rowView(row, tone: tone)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private func rowView(_ row: ContentIndexRow, tone: D1Chip.Tone) -> some View {
        D1Card(padding: 14) {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("\(row.date.month)月\(row.date.day)日")
                        .font(D1Theme.serif(18)).foregroundStyle(theme.ink)
                    Text("农历\(state.lunar(row.date).monthDayText)")
                        .font(.system(size: 10)).foregroundStyle(theme.ink3)
                    Spacer()
                    D1Chip(text: chipText(row), tone: chipTone(row))
                }
                HStack(spacing: 6) {
                    Text(row.title).font(.system(size: 14, weight: .semibold)).foregroundStyle(theme.ink)
                    if let region = row.regionLabel {
                        Text(region).font(.system(size: 9)).foregroundStyle(theme.ink3)
                    }
                }
                Text(row.teaser).font(.system(size: 11)).foregroundStyle(theme.ink2)
            }
        }
    }

    private func chipText(_ row: ContentIndexRow) -> String {
        switch row.state {
        case .unlocked: return "今日已解锁"
        case .past: return "已过 \(row.days ?? 0) 天 · 可回看"
        case .locked: return "未到 \(row.days ?? 0) 天"
        }
    }

    private func chipTone(_ row: ContentIndexRow) -> D1Chip.Tone {
        switch row.state {
        case .unlocked: return .accent
        case .past: return .neutral
        case .locked: return .jade
        }
    }
}
