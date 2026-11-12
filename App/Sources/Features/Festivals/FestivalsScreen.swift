import SwiftUI
import LixiangCalendarCore

/// F5 节俗索引（P2）：吸顶「下一篇解锁」横幅 + 月份分组 + 已过默认折叠 + manifest 状态机
struct FestivalsScreen: View {
    var onOpenMonth: () -> Void = {}
    var onOpenAnniversary: () -> Void = {}
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme

    @State private var expandPast = false
    @State private var refreshing = false
    @State private var loadPhase: LoadPhase = .loading
    @State private var retryToken = UUID()

    enum LoadPhase: Equatable { case loading, ready, errorWithCache, errorNoCache }

    private var mode: ContentNetworkMode { ContentNetworkMode(rawValue: state.debug.network ?? "normal") ?? .normal }
    private var groups: (past: [ContentIndexRow], today: [ContentIndexRow], upcoming: [ContentIndexRow]) {
        state.debug.emptyIndex ? ([], [], []) : state.indexGroups()
    }
    /// 下一篇解锁（横幅）
    private var bannerRow: ContentIndexRow? { groups.upcoming.first }

    private var allRows: [ContentIndexRow] {
        groups.today + groups.upcoming + groups.past
    }

    var body: some View {
        VStack(spacing: 0) {
            if let bannerRow, loadPhase != .errorNoCache, !groups.upcoming.isEmpty {
                banner(bannerRow)
            }
            if let note = phaseNote {
                HStack(spacing: 6) {
                    Image(systemName: "wifi.exclamationmark").font(.system(size: 10))
                    Text(note).d1Font(10, weight: .semibold)
                }
                .foregroundStyle(theme.jiText)
                .padding(.horizontal, 12).padding(.vertical, 7)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(theme.jiBg)
            }
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 8, pinnedViews: [.sectionHeaders]) {
                    content
                }
                .frame(maxWidth: 600, alignment: .leading)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
            .refreshable { await refresh() }
        }
        .background(ScreenBackground())
        .navigationTitle("")
        .navigationBarHidden(true)
        .task(id: retryToken) { await simulatePhase() }
        .onAppear {
            if state.debug.expandPast { expandPast = true }
        }
    }

    // MARK: - 吸顶横幅
    private func banner(_ row: ContentIndexRow) -> some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 2) {
                Text("下一篇解锁 · \(row.title)").d1Font(12, weight: .semibold).foregroundStyle(theme.ink)
                Text("\(row.date.month)月\(row.date.day)日 · 00:00 后可见 · \(row.days ?? 0) 天")
                    .d1Font(10).foregroundStyle(theme.ink3)
            }
            Spacer()
            if let region = row.regionLabel {
                Text(region).d1Font(9).foregroundStyle(theme.ink3)
            }
            D1Chip(text: "未到 \(row.days ?? 0) 天", tone: .jade)
        }
        .padding(.horizontal, 16).padding(.vertical, 10)
        .background(theme.soft)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("下一篇解锁，\(row.title)，\(row.date.month)月\(row.date.day)日，还有\(row.days ?? 0)天")
    }

    // MARK: - 内容
    @ViewBuilder
    private var content: some View {
        switch loadPhase {
        case .loading:
            skeleton
        case .errorNoCache:
            errorCard
        default:
            if allRows.isEmpty {
                emptyState
            } else {
                if !groups.today.isEmpty {
                    monthSections(rows: groups.today, allowBannerSkip: false)
                }
                let upcoming = groups.upcoming.filter { $0.id != bannerRow?.id }
                if !upcoming.isEmpty {
                    monthSections(rows: upcoming, bannerMonth: bannerRow?.date)
                }

            }
        }
    }

    private func monthSections(rows: [ContentIndexRow], bannerMonth: LocalDate? = nil, allowBannerSkip: Bool = true) -> some View {
        let grouped = Dictionary(grouping: rows) { "\($0.date.year)年\($0.date.month)月" }
        let keys = grouped.keys.sorted { lhs, rhs in
            (grouped[lhs]?.first?.date ?? LocalDate(1900, 1, 1)) < (grouped[rhs]?.first?.date ?? LocalDate(1900, 1, 1))
        }
        return ForEach(keys, id: \.self) { key in
            Section {
                ForEach(grouped[key] ?? []) { row in
                    NavigationLink(value: Route.content(row.contentID)) {
                        rowView(row)
                    }
                    .buttonStyle(.plain)
                }
                if let bannerMonth, "\(bannerMonth.year)年\(bannerMonth.month)月" == key, let bannerRow {
                    HStack {
                        Text("见顶部").d1Font(10).foregroundStyle(theme.ink3)
                        Text(bannerRow.title).d1Font(10).foregroundStyle(theme.ink2)
                        Spacer()
                    }
                    .padding(.vertical, 4)
                }
            } header: {
                Text(key)
                    .d1Font(10, weight: .semibold).tracking(1.2)
                    .foregroundStyle(theme.ink3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 6)
                    .background(theme.bg)
                    .accessibilityAddTraits(.isHeader)
            }
        }
    }



    private func rowView(_ row: ContentIndexRow) -> some View {
        D1Card(padding: 14) {
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text("\(row.date.month)月\(row.date.day)日").d1SerifFont(18).foregroundStyle(theme.ink)
                    Text("农历\(state.lunar(row.date).monthDayText)").d1Font(10).foregroundStyle(theme.ink3)
                    Spacer()
                    D1Chip(text: chipText(row), tone: chipTone(row))
                }
                HStack(spacing: 6) {
                    Text(row.title).d1Font(14, weight: .semibold).foregroundStyle(theme.ink)
                    if let region = row.regionLabel { Text(region).d1Font(9).foregroundStyle(theme.ink3) }
                }
                Text(row.teaser).d1Font(11).foregroundStyle(theme.ink2)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(row.title)，\(row.date.month)月\(row.date.day)日，农历\(state.lunar(row.date).monthDayText)，\(chipText(row))")
    }

    // MARK: - 状态
    private var phaseNote: String? {
        switch loadPhase {
        case .errorWithCache: return "内容更新失败，正在使用已缓存内容"
        case .errorNoCache: return nil
        case .loading: return refreshing ? "更新中" : nil
        case .ready: return refreshing ? "更新中" : nil
        }
    }

    private var skeleton: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(0..<4, id: \.self) { _ in
                D1Card(padding: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        RoundedRectangle(cornerRadius: 4).fill(theme.soft).frame(width: 90, height: 12)
                        RoundedRectangle(cornerRadius: 4).fill(theme.soft).frame(height: 10)
                    }
                }
            }
        }
        .padding(.top, 8)
    }

    private var errorCard: some View {
        D1Card {
            VStack(alignment: .leading, spacing: 6) {
                Text("内容暂时不可用").d1Font(13, weight: .semibold).foregroundStyle(theme.ink)
                Text("检查网络后重试；已解锁状态不受影响。").d1Font(11).foregroundStyle(theme.ink2)
                HStack(spacing: 10) {
                    Button("重试") { retryToken = UUID() }
                        .d1Font(12, weight: .semibold)
                        .frame(minWidth: 44, minHeight: 44)
                        .padding(.horizontal, 10)
                        .background(theme.accent, in: Capsule())
                        .foregroundStyle(theme.onAccent)
                    Button("去月历") { onOpenMonth() }
                        .d1Font(12, weight: .semibold)
                        .frame(minWidth: 44, minHeight: 44)
                        .padding(.horizontal, 10)
                        .background(theme.soft, in: Capsule())
                        .foregroundStyle(theme.ink2)
                }
            }
        }
        .padding(.top, 8)
    }

    private var emptyState: some View {
        D1Card {
            VStack(alignment: .leading, spacing: 10) {
                Text("未来 90 天暂无节俗内容").d1Font(13, weight: .semibold).foregroundStyle(theme.ink)
                Text("内容按季度滚动补充；锁定/解锁规则不受影响。").d1Font(11).foregroundStyle(theme.ink2)
                HStack(spacing: 10) {
                    Button("查看全部月份") { onOpenMonth() }
                        .d1Font(11, weight: .semibold)
                        .frame(minHeight: 44)
                        .padding(.horizontal, 14)
                        .background(theme.accent, in: Capsule())
                        .foregroundStyle(theme.onAccent)
                    Button("去倒计日") { onOpenAnniversary() }
                        .d1Font(11, weight: .semibold)
                        .frame(minHeight: 44)
                        .padding(.horizontal, 14)
                        .background(theme.soft, in: Capsule())
                        .foregroundStyle(theme.ink2)
                }
            }
        }
        .padding(.top, 8)
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

    private func simulatePhase() async {
        switch mode {
        case .slow, .hang:
            loadPhase = .loading
            try? await Task.sleep(nanoseconds: 800_000_000)
            loadPhase = .ready
        case .error:
            loadPhase = (state.debug.cacheState == "primed") ? .errorWithCache : .errorNoCache
        case .offline:
            loadPhase = (state.debug.cacheState == "primed") ? .errorWithCache : .errorNoCache
        case .normal:
            loadPhase = .ready
        }
    }

    private func refresh() async {
        refreshing = true
        try? await Task.sleep(nanoseconds: 700_000_000)
        loadPhase = .ready
        refreshing = false
    }
}
