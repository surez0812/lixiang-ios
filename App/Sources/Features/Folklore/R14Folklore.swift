import SwiftUI
import LixiangCalendarCore

enum FolkloreFilter: String, CaseIterable, Identifiable {
    case all = "全部", festival = "传统节日", tao = "道历节日", foto = "佛历节日", ritual = "民俗科仪"
    var id: String { rawValue }
    func matches(_ item: ContentItem) -> Bool {
        switch self {
        case .all: return true
        case .festival: return item.category.contains("festival") || item.category.contains("solar_term") || item.category.contains("traditional")
        case .tao: return item.category.contains("tao")
        case .foto: return item.category.contains("foto") || item.category.contains("buddhist")
        case .ritual: return item.category.contains("ritual") || item.category.contains("ancestor")
        }
    }
}

/// 岁时可读性/日期文案：过去节日（30 天内）应可读，不显示“还有0天解锁”。
enum FolkloreReadability {
    static func isReadable(_ info: ContentStateInfo) -> Bool {
        info.isToday || info.state == .past || (info.daysUntil ?? 99) <= 10
    }
    static func offsetText(_ info: ContentStateInfo) -> String {
        if info.isToday { return "今日" }
        if info.state == .past { return "已过去" }
        return "还有\(info.daysUntil ?? 0)天"
    }
    static func statusText(isReadable: Bool, info: ContentStateInfo) -> String {
        if info.isToday || info.state == .past { return "已解锁" }
        return isReadable ? "新解锁" : "未解锁"
    }
}

struct FolkloreRow: Identifiable {
    var id: String { resolution.item.id }
    let resolution: ContentResolution
    let state: ContentStateInfo
    let daysUntil: Int?      // nil = 已解锁/今天
    let isReadable: Bool
    var item: ContentItem { resolution.item }
}

/// R14 岁时列表：品牌卡 + 类别筛选 + 日期卡。
struct R14FolkloreScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    @State private var filter: FolkloreFilter = .all
    @StateObject private var load = R14FolkloreLoadController(mode: R14FolkloreLoadController.modeFromProcess())
    var onOpen: (String) -> Void = { _ in }

    private var rows: [FolkloreRow] {
        let resolved = ContentResolver.resolve(items: ContentCatalog.all, now: state.today, engine: state.engine)
        return resolved.compactMap { r -> FolkloreRow? in
            guard let info = r.stateInfo(regionID: nil, now: state.today) else { return nil }
            // 过去 30 天内的节日仍可读（不再被误判 locked）；未来按 T-10 解锁
            let days = info.isToday ? nil : info.daysUntil
            let readable = FolkloreReadability.isReadable(info)
            return FolkloreRow(resolution: r, state: info, daysUntil: days, isReadable: readable)
        }
        .sorted { ($0.state.anchor, $0.item.id) < ($1.state.anchor, $1.item.id) }
    }
    private var visible: [FolkloreRow] { rows.filter { filter.matches($0.item) } }
    private var nearest: FolkloreRow? { rows.first }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 14) {
                brandCard
                switch load.state {
                case .loading:
                    R14FolkloreStateBanner(state: .loading, retry: {})
                case .failed:
                    R14FolkloreStateBanner(state: .failed, retry: { load.retry() })
                case .offline:
                    R14FolkloreStateBanner(state: .offline, retry: { load.retry() })
                    chips
                    ForEach(visible) { row in Button { onOpen(row.item.id) } label: { rowCard(row) }.buttonStyle(.plain) }
                case .loaded:
                    chips
                    ForEach(visible) { row in
                        Button { onOpen(row.item.id) } label: { rowCard(row) }
                            .buttonStyle(.plain)
                    }
                    if visible.isEmpty {
                        Text("这个分类下暂时没有岁时内容。").d1Font(13).foregroundStyle(theme.ink2).padding(.vertical, 8)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 10)
            .padding(.bottom, 150)
        }
        .background(ScreenBackground())
    }

    private var brandCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("历象 · 把日子过成风景").d1Font(10, weight: .semibold).tracking(1.6).foregroundStyle(.white.opacity(0.8))
            Text("岁时有约").d1SerifFont(30).foregroundStyle(.white)
            Text("未到来的日子，也值得期待。").d1Font(13).foregroundStyle(.white.opacity(0.85))
            if let n = nearest {
                Text("\(n.item.title) · \(n.isReadable ? "新内容已解锁" : "还有\(n.daysUntil ?? 0)天")")
                    .d1SerifFont(20).foregroundStyle(.white).padding(.top, 4)
                Text(n.isReadable ? "先读一段冬日故事。" : "到日子再来读。").d1Font(12).foregroundStyle(.white.opacity(0.8))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [Color(hex: 0x8E2D1C), Color(hex: 0xA63D26)], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var chips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(FolkloreFilter.allCases) { f in
                    Button { filter = f } label: {
                        Text(f.rawValue)
                            .d1Font(13, weight: filter == f ? .semibold : .regular)
                            .foregroundStyle(filter == f ? .white : theme.ink2)
                            .padding(.horizontal, 14).frame(minHeight: 38)
                            .background(filter == f ? theme.accentStrong : theme.paper, in: Capsule())
                            .overlay(Capsule().strokeBorder(filter == f ? .clear : theme.line, lineWidth: 1))
                    }.buttonStyle(.plain)
                }
            }
            .padding(.vertical, 2)
        }
    }

    private func rowCard(_ row: FolkloreRow) -> some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(spacing: 2) {
                Text("\(row.state.anchor.month)月").d1Font(10).foregroundStyle(theme.ink3)
                Text("\(row.state.anchor.day)").d1SerifFont(30).foregroundStyle(theme.ink)
                Text(FolkloreReadability.offsetText(row.state)).d1Font(10).foregroundStyle(theme.ink3)
            }
            .frame(width: 54)
            VStack(alignment: .leading, spacing: 5) {
                HStack {
                    Text(row.item.title).d1SerifFont(20).foregroundStyle(theme.ink)
                    Spacer()
                    HStack(spacing: 4) {
                        if !FolkloreUnreadStore.shared.isRead(row.item), row.isReadable {
                            Circle().fill(theme.accentStrong).frame(width: 5, height: 5)
                        }
                        Text(statusText(row)).d1Font(11, weight: .semibold)
                            .foregroundStyle(row.isReadable ? theme.accentStrong : theme.ink3)
                    }
                }
                Text(row.item.teaser).d1Font(12).foregroundStyle(theme.ink2).lineLimit(2)
                Text(categoryLabel(row.item.category.first)).d1Font(10)
                    .foregroundStyle(theme.ink3)
                    .padding(.horizontal, 8).padding(.vertical, 3)
                    .background(theme.soft, in: Capsule())
            }
            Image(systemName: "chevron.right").font(.system(size: 11, weight: .semibold)).foregroundStyle(theme.ink3).padding(.top, 6)
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.paper, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).strokeBorder(theme.line, lineWidth: 1))
    }

    private func statusText(_ row: FolkloreRow) -> String {
        FolkloreReadability.statusText(isReadable: row.isReadable, info: row.state)
    }
}

/// R14 岁时详情：紧凑头 + 插画 + 正文（原生渲染；后续可切 WKWebView 内容服务）。
struct R14FolkloreDetailScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    let id: String
    @Environment(\.dismiss) private var dismiss
    @State private var showShare = false
    @StateObject private var load = R14FolkloreLoadController(mode: R14FolkloreLoadController.modeFromProcess())

    private var isPlaceholder: Bool {
        guard let row else { return true }
        let item = row.item
        if item.version == 0 { return true }
        if !ContentCatalog.isApproved(item) { return true }   // 草稿/未审核：内容准备中，不标读
        if item.sources.contains(where: { $0.title.contains("示例") || $0.note?.contains("非最终") == true }) { return true }
        return item.sections.contains { $0.paragraphs.contains { $0.contains("P1 示例") } }
    }

    private var row: FolkloreRow? {
        let resolved = ContentResolver.resolve(items: ContentCatalog.all, now: state.today, engine: state.engine)
        guard let r = resolved.first(where: { $0.item.id == id }), let info = r.stateInfo(regionID: nil, now: state.today) else { return nil }
        let days = info.isToday ? nil : info.daysUntil
        return FolkloreRow(resolution: r, state: info, daysUntil: days, isReadable: FolkloreReadability.isReadable(info))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                if load.state != .loaded {
                    R14FolkloreStateBanner(state: load.state, retry: { load.retry() })
                        .padding(.horizontal, 16).padding(.top, 8)
                }
                if load.state == .failed || load.state == .loading {
                    EmptyView()
                } else if let row {
                VStack(alignment: .leading, spacing: 0) {
                    header(row)
                    if row.isReadable {
                        // 宽度派生 16:9 容器（不固定 220 裁切）；fill 只裁边不拉伸
                        Color.clear
                            .aspectRatio(16.0 / 9.0, contentMode: .fit)
                            .overlay {
                                R14ContentHero.image(for: row.item.id)
                                    .resizable()
                                    .scaledToFill()
                            }
                            .clipped()
                            .overlay(LinearGradient(colors: [.clear, .black.opacity(0.12)], startPoint: .top, endPoint: .bottom))
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(Text(R14ContentHero.accessibilityLabel(for: row.item.id)))
                        if isPlaceholder {
                            contentPendingCard
                        } else {
                            article(row.item)
                        }
                    } else {
                        lockedCard(row)
                    }
                }
                .padding(.bottom, 150)
                } else {
                    Text("没找到这个岁时内容。").d1Font(14).foregroundStyle(theme.ink2).padding(24)
                }
            }
        }
        .background(ScreenBackground())
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            if load.state == .loaded, let row, row.isReadable, !isPlaceholder {
                FolkloreUnreadStore.shared.markRead(row.item)
            }
        }
        .overlay(alignment: .topLeading) {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left").font(.system(size: 17, weight: .semibold))
                    .frame(width: 44, height: 44)
                    .background(.ultraThinMaterial, in: Circle())
            }
            .foregroundStyle(theme.ink)
            .padding(.leading, 14).padding(.top, 6)
        }
    }

    private func header(_ row: FolkloreRow) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(categoryLabel(row.item.category.first)).d1Font(10).foregroundStyle(theme.ink3)
                .padding(.horizontal, 8).padding(.vertical, 3).background(theme.soft, in: Capsule())
            Text(row.item.title).d1SerifFont(34).foregroundStyle(theme.ink)
            Text(row.item.teaser).d1Font(13).foregroundStyle(theme.ink2).lineSpacing(4)
            HStack {
                Text(verbatim: String(format: "%d年%d月%d日", row.state.anchor.year, row.state.anchor.month, row.state.anchor.day))
                    .d1Font(12).foregroundStyle(theme.ink3)
                Text(row.state.isToday ? "· 今天" : (row.state.state == .past ? "· 已过去 · 已解锁" : "· 还有\(row.daysUntil ?? 0)天"))
                    .d1Font(12).foregroundStyle(theme.accentStrong)
                Spacer()
                Button { showShare = true } label: {
                    Label("分享", systemImage: "square.and.arrow.up").d1Font(13, weight: .semibold)
                }.foregroundStyle(theme.accentStrong).frame(minHeight: 44)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.paper)
    }

    private func article(_ item: ContentItem) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("一段来由 · 一点日常").d1Font(10, weight: .semibold).tracking(1.6).foregroundStyle(theme.ink3)
            Text(item.sections.first?.paragraphs.first ?? item.teaser)
                .d1SerifFont(28).foregroundStyle(theme.ink).fixedSize(horizontal: false, vertical: true)
            ForEach(item.sections, id: \.id) { section in
                VStack(alignment: .leading, spacing: 8) {
                    Text(section.title).d1SerifFont(20).foregroundStyle(theme.ink)
                    ForEach(section.paragraphs, id: \.self) { p in
                        Text(p).d1Font(15).lineSpacing(8).foregroundStyle(theme.ink2).fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("来源").d1Font(10, weight: .semibold).foregroundStyle(theme.ink3)
                ForEach(Array(item.sources.enumerated()), id: \.offset) { _, src in
                    Text(verbatim: "· \(src.title)\(src.note.map { " — \($0)" } ?? "")")
                        .d1Font(10).foregroundStyle(theme.ink3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Text(verbatim: "更新于 v\(item.version)").d1Font(9).foregroundStyle(theme.ink3)
            }
        }
        .padding(18)
    }

    private var contentPendingCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("内容准备中").d1SerifFont(22).foregroundStyle(theme.ink)
            Text("这篇岁时正文仍是示例稿，正式版本上线后会在此展示。")
                .d1Font(14).foregroundStyle(theme.ink2).lineSpacing(5)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func lockedCard(_ row: FolkloreRow) -> some View {
        VStack(spacing: 8) {
            Image(systemName: "lock").font(.system(size: 26)).foregroundStyle(theme.accentStrong)
            Text("还有\(row.daysUntil ?? 0)天解锁").d1Font(16, weight: .semibold).foregroundStyle(theme.ink)
            Text("到日子再来读这段岁时故事。").d1Font(12).foregroundStyle(theme.ink3)
        }
        .frame(maxWidth: .infinity).padding(.vertical, 60)
    }
}


private func categoryLabel(_ raw: String?) -> String {
    switch raw {
    case "festival": return "传统节日"
    case "solar_term": return "节气"
    case "tao": return "道历节日"
    case "foto", "buddhist": return "佛历节日"
    case "ritual": return "民俗科仪"
    case "ancestor": return "祭祖纪念"
    case "traditional": return "传统节日"
    default: return raw ?? "民俗"
    }
}
