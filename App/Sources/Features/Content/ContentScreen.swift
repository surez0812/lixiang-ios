import SwiftUI
import LixiangCalendarCore

struct ContentScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    let contentID: String

    private var resolution: ContentResolution? { state.resolution(id: contentID) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let resolution {
                    header(resolution)
                    ForEach(resolution.regions) { region in
                        regionCard(resolution: resolution, region: region)
                    }
                    complianceFooter
                } else {
                    Text("内容加载失败").foregroundStyle(theme.ink2)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(ScreenBackground())
        .navigationTitle(resolution?.item.title ?? "民俗")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func header(_ resolution: ContentResolution) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(resolution.item.title).font(D1Theme.serif(30)).foregroundStyle(theme.ink)
            HStack(spacing: 6) {
                ForEach(resolution.item.category, id: \.self) { raw in
                    D1Chip(text: categoryLabel(raw), tone: .neutral)
                }
            }
            Text(resolution.item.teaser).font(.system(size: 12)).foregroundStyle(theme.ink2)
        }
    }

    private func regionCard(resolution: ContentResolution, region: RegionalDate) -> some View {
        let info = resolution.stateInfo(regionID: region.id, now: state.today)
        return D1Card {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(resolution.item.regionalDates == nil ? "内容" : region.label)
                        .font(.system(size: 12, weight: .semibold)).foregroundStyle(theme.ink)
                    Spacer()
                    if let info {
                        switch info.state {
                        case .unlocked: D1Chip(text: "今日已解锁", tone: .accent)
                        case .past: D1Chip(text: "已过 · 可回看", tone: .neutral)
                        case .locked: D1Chip(text: "未到 \(info.daysUntil ?? 0) 天", tone: .jade)
                        }
                    }
                }
                if let info {
                    switch info.state {
                    case .locked:
                        lockedView(info)
                    case .unlocked, .past:
                        unlockedView(resolution, info: info)
                    }
                } else {
                    Text("本年度无该日期").font(.system(size: 11)).foregroundStyle(theme.ink3)
                }
            }
        }
    }

    private func lockedView(_ info: ContentStateInfo) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("民俗内容将在 \(info.anchor.iso) 00:00 后解锁")
                .font(.system(size: 12, weight: .semibold)).foregroundStyle(theme.ink)
            Text("未到日期只显示名称、日期与一行主题；不展示准备清单、步骤或禁忌细节。")
                .font(.system(size: 10)).foregroundStyle(theme.ink3)
            Text("按北京时间判定 · 解锁前正文不下发、不随包、不可深链")
                .font(.system(size: 9)).foregroundStyle(theme.ink3)
        }
        .padding(10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.soft, in: RoundedRectangle(cornerRadius: 14))
    }

    private func unlockedView(_ resolution: ContentResolution, info: ContentStateInfo) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            if info.state == .past {
                Text("已过 · 下次解锁 \(info.nextUnlock?.iso ?? "—")")
                    .font(.system(size: 10)).foregroundStyle(theme.ink3)
            }
            ForEach(resolution.item.sections) { section in
                VStack(alignment: .leading, spacing: 4) {
                    Text(section.title).font(.system(size: 12, weight: .semibold)).foregroundStyle(theme.ink)
                    ForEach(section.paragraphs, id: \.self) { p in
                        Text(p).font(.system(size: 11)).foregroundStyle(theme.ink2)
                    }
                }
            }
            D1Divider()
            VStack(alignment: .leading, spacing: 3) {
                SectionLabel(text: "来源与许可")
                ForEach(resolution.item.sources, id: \.title) { source in
                    Text("\(source.kind) · \(source.title)\(source.note.map { " · \($0)" } ?? "")")
                        .font(.system(size: 9)).foregroundStyle(theme.ink3)
                }
            }
        }
    }

    private func categoryLabel(_ raw: String) -> String {
        switch raw {
        case "festival": return "节俗"
        case "ritual": return "民俗做法"
        case "ancestor": return "祭祖"
        case "solar_term": return "节气"
        case "custom": return "民俗"
        default: return raw
        }
    }

    private var complianceFooter: some View {
        Text("传统民俗文化内容；焚香烧纸请遵守当地消防与环保规定，不涉及宗教场所与教职人员。只讲民俗文化，不做吉凶判断。")
            .font(.system(size: 9)).foregroundStyle(theme.ink3)
            .padding(.top, 4)
    }
}
