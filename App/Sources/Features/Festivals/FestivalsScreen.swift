import SwiftUI
import LixiangCalendarCore

struct FestivalsScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme

    private struct Row: Identifiable {
        let id: String
        let contentID: String
        let title: String
        let teaser: String
        let unlockDate: LocalDate
        let lunarText: String
        let state: ContentState
        let days: Int?
        let regionLabel: String?
    }

    private var rows: [Row] {
        var result: [Row] = []
        for resolution in state.resolutions() {
            for region in resolution.regions {
                guard let info = resolution.stateInfo(regionID: region.id, now: state.today) else { continue }
                let lunar = state.lunar(info.anchor)
                result.append(Row(
                    id: "\(resolution.item.id)-\(region.id)",
                    contentID: resolution.item.id,
                    title: resolution.item.title,
                    teaser: resolution.item.teaser,
                    unlockDate: info.anchor,
                    lunarText: lunar.monthDayText,
                    state: info.state,
                    days: info.daysUntil,
                    regionLabel: resolution.item.regionalDates == nil ? nil : region.label
                ))
            }
        }
        return result.sorted { $0.unlockDate < $1.unlockDate }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("按日子走").font(D1Theme.serif(30)).foregroundStyle(theme.ink)
                    Text("节俗内容按日期解锁 · 按北京时间").font(.system(size: 10)).foregroundStyle(theme.ink3)
                }
                .padding(.top, 8)
                ForEach(rows) { row in
                    NavigationLink(value: Route.content(row.contentID)) {
                        rowView(row)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(ScreenBackground())
        .navigationTitle("")
        .navigationBarHidden(true)
    }

    private func rowView(_ row: Row) -> some View {
        D1Card(padding: 14) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text("\(row.unlockDate.month)月\(row.unlockDate.day)日")
                        .font(D1Theme.serif(18)).foregroundStyle(theme.ink)
                    Text("农历\(row.lunarText)").font(.system(size: 10)).foregroundStyle(theme.ink3)
                    Spacer()
                    D1Chip(text: chipText(row), tone: chipTone(row))
                }
                Text(row.title).font(.system(size: 14, weight: .semibold)).foregroundStyle(theme.ink)
                if let region = row.regionLabel {
                    Text(region).font(.system(size: 9)).foregroundStyle(theme.ink3)
                }
                Text(row.teaser).font(.system(size: 11)).foregroundStyle(theme.ink2)
                if row.state == .locked {
                    Text("民俗内容将在 \(row.unlockDate.iso) 00:00 后解锁")
                        .font(.system(size: 9)).foregroundStyle(theme.ink3)
                }
            }
        }
    }

    private func chipText(_ row: Row) -> String {
        switch row.state {
        case .unlocked: return "今日已解锁"
        case .past: return "已过 \(state.today.daysBetween(row.unlockDate)) 天"
        case .locked: return "未到 \(row.days ?? 0) 天"
        }
    }

    private func chipTone(_ row: Row) -> D1Chip.Tone {
        switch row.state {
        case .unlocked: return .accent
        case .past: return .neutral
        case .locked: return .jade
        }
    }
}
