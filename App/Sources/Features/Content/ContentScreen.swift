import SwiftUI
import LixiangCalendarCore

/// F7 · WebView + B′ 内容页（6 态：已解锁 / 离线已缓存 / 离线未缓存 / 加载 / 错误 / 锁定；来源与许可独立页）
struct ContentScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    let contentID: String

    @State private var result = ContentLoadResult(phase: .loading)
    @State private var loadedOnce = false
    @State private var reloadToken = UUID()

    private var item: ContentItem? { state.contentItem(id: contentID) }
    private var siteURL: URL { URL(string: "https://lixiang.zhaoyao.xin/ceremony/\(contentID)")! }
    private var scale: Double { min(max(state.debug.typeScale ?? 1.0, 1.0), 2.0) }
    private var mode: ContentNetworkMode { ContentNetworkMode(rawValue: state.debug.network ?? "normal") ?? .normal }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let banner = offlineBanner {
                    bannerView(banner)
                }
                header
                bodyContent
                sourceLink
                footer
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
        }
        .background(ScreenBackground())
        .navigationTitle(item?.title ?? "民俗")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                ShareLink(item: siteURL, subject: Text("历象 · \(item?.title ?? "")"), message: Text(lockShareMessage)) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
        .task(id: reloadToken) { await load() }
    }

    // MARK: - 数据
    private func load() async {
        let sandbox = SandboxContentSource(engine: state.engine, now: state.today, mode: mode,
                                           versionOverride: state.debug.contentVersion)
        let primeSource: SandboxContentSource? = (state.debug.cacheState == "primed")
            ? SandboxContentSource(engine: state.engine, now: state.today, mode: .normal,
                                   versionOverride: state.debug.contentVersion)
            : nil
        let repository = ContentRepository(source: sandbox, now: state.today, mode: mode, typeScale: scale)
        if let primeSource {
            let primer = ContentRepository(source: primeSource, now: state.today, mode: .normal, typeScale: scale)
            _ = await primer.load(slug: contentID)
        }
        result = await repository.load(slug: contentID)
        loadedOnce = true
    }

    private var lockShareMessage: String {
        if result.phase == .locked, let entry = result.entry {
            return "历象 · \(item?.title ?? "") · \(entry.unlockDate.iso) 解锁后可读（不含正文）"
        }
        return "历象 · \(item?.title ?? "")"
    }

    // MARK: - 头卡（本地先渲染，不等 WebView）
    private var header: some View {
        let entry = result.entry
        return D1Card {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item?.title ?? contentID).font(D1Theme.serif(22 * min(scale, 1.4))).foregroundStyle(theme.ink)
                        let regionLabel = item?.regionalDates?.first?.label
                        if let regionLabel {
                            Text(regionLabel).d1Font(10).foregroundStyle(theme.ink3)
                        }
                        Text("按北京时间（UTC+8）判定解锁").d1Font(9).foregroundStyle(theme.ink3)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(entry?.contentVersion ?? "—").d1Font(9, weight: .semibold).foregroundStyle(theme.ink3)
                        if let updated = entry?.updatedAt {
                            Text("更新于 \(updated.prefix(10))").d1Font(8).foregroundStyle(theme.ink3)
                        }
                    }
                }
                HStack(spacing: 6) {
                    switch result.phase {
                    case .locked:
                        D1Chip(text: "未解锁", tone: .ji)
                    case .offlineCached, .offlineUncached:
                        D1Chip(text: "已解锁", tone: .yi)
                    default:
                        D1Chip(text: "已解锁", tone: .yi)
                    }
                    D1Chip(text: "网页内容", tone: .neutral)
                    if result.cached { D1Chip(text: "已缓存", tone: .neutral) }
                    else if result.phase == .ready { D1Chip(text: "未缓存", tone: .neutral) }
                }
            }
        }
    }

    @ViewBuilder
    private var bodyContent: some View {
        switch result.phase {
        case .loading:
            loadingSkeleton
        case .locked:
            lockedBody
        case .ready, .offlineCached:
            if let html = result.html {
                D1Card(padding: 8) {
                    WebViewReader(html: html)
                        .frame(minHeight: 520)
                }
            } else {
                errorCard(message: "内容暂时无法加载")
            }
        case .offlineUncached:
            offlineUncachedCard
        case .error:
            errorCard(message: "内容暂时无法加载", detail: "检查网络后重试；已缓存部分不会显示成旧正文。")
        }
    }

    private var loadingSkeleton: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("加载中").d1Font(10).foregroundStyle(theme.ink3)
            ForEach(0..<3, id: \.self) { i in
                D1Card(padding: 14) {
                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4).fill(theme.soft).frame(width: 96, height: 12)
                        RoundedRectangle(cornerRadius: 4).fill(theme.soft).frame(height: 10)
                        RoundedRectangle(cornerRadius: 4).fill(theme.soft).frame(width: 220, height: 10)
                        if i == 0 { RoundedRectangle(cornerRadius: 4).fill(theme.soft).frame(height: 10) }
                    }
                }
            }
            Text("正文加载前先显示本地头卡；骨架 ≥300ms 才出现，无白屏。")
                .d1Font(9).foregroundStyle(theme.ink3)
        }
    }

    private var lockedBody: some View {
        VStack(spacing: 10) {
            if let resolution = state.resolution(id: contentID) {
                ForEach(resolution.regions) { region in
                    let info = resolution.stateInfo(regionID: region.id, now: state.today)
                    D1Card {
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(region.label).d1Font(12, weight: .semibold).foregroundStyle(theme.ink)
                                Spacer()
                                if let info {
                                    switch info.state {
                                    case .locked: D1Chip(text: "未到 \(info.daysUntil ?? 0) 天", tone: .jade)
                                    case .unlocked: D1Chip(text: "今日已解锁", tone: .accent)
                                    case .past: D1Chip(text: "已过 · 可回看", tone: .neutral)
                                    }
                                }
                            }
                            if let info, info.state == .locked {
                                Text("民俗内容将在 \(info.anchor.iso) 00:00 后解锁").d1Font(11).foregroundStyle(theme.ink2)
                                Text("未解锁只显示名称、日期与一行主题；不展示准备清单、步骤或禁忌细节；不返回正文。")
                                    .d1Font(10).foregroundStyle(theme.ink3)
                            }
                        }
                    }
                }
            }
            Text("传统民俗文化内容；焚香烧纸请遵守当地消防与环保规定，不涉及宗教场所与教职人员。")
                .d1Font(9).foregroundStyle(theme.ink3)
        }
    }

    private var offlineUncachedCard: some View {
        D1Card {
            VStack(alignment: .leading, spacing: 6) {
                Text("离线且未缓存").d1Font(13, weight: .semibold).foregroundStyle(theme.ink)
                Text("联网后可读；已解锁状态不受影响。").d1Font(11).foregroundStyle(theme.ink2)
                HStack(spacing: 10) {
                    Button("重试") { reloadToken = UUID() }
                        .d1Font(11, weight: .semibold)
                        .padding(.horizontal, 14).padding(.vertical, 8)
                        .background(theme.accent, in: Capsule())
                        .foregroundStyle(theme.onAccent)
                    Text("去设置网络").d1Font(10).foregroundStyle(theme.ink3)
                }
            }
        }
    }

    private func errorCard(message: String, detail: String? = nil) -> some View {
        D1Card {
            VStack(alignment: .leading, spacing: 6) {
                Text(message).d1Font(13, weight: .semibold).foregroundStyle(theme.ink)
                if let detail { Text(detail).d1Font(11).foregroundStyle(theme.ink2) }
                Button("重试") { reloadToken = UUID() }
                    .d1Font(11, weight: .semibold)
                    .padding(.horizontal, 14).padding(.vertical, 8)
                    .background(theme.accent, in: Capsule())
                    .foregroundStyle(theme.onAccent)
            }
        }
    }

    private var offlineBanner: String? {
        switch result.phase {
        case .offlineCached: return "离线 · 显示已缓存内容（\(result.entry?.contentVersion ?? "—")）"
        case .offlineUncached: return "离线 · 无缓存"
        default: return nil
        }
    }

    private func bannerView(_ text: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "wifi.slash").d1Font(10)
            Text(text).d1Font(10, weight: .semibold)
        }
        .foregroundStyle(theme.jiText)
        .padding(.horizontal, 12).padding(.vertical, 7)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.jiBg, in: RoundedRectangle(cornerRadius: 12))
    }

    private var sourceLink: some View {
        NavigationLink {
            SourceLicenseScreen(slug: contentID, entry: result.entry, item: item)
        } label: {
            D1Card(padding: 14) {
                HStack {
                    Text("来源与许可").d1Font(12, weight: .semibold).foregroundStyle(theme.ink)
                    Spacer()
                    Image(systemName: "chevron.right").d1Font(10).foregroundStyle(theme.ink3)
                }
            }
        }
        .buttonStyle(.plain)
    }

    private var footer: some View {
        Text("北京时间（UTC+8）解锁 · 网页静态发布（B′）· 未解锁正文不在服务器 · 版本新旧静默替换 · 配图 16:9 + alt")
            .d1Font(9).foregroundStyle(theme.ink3)
    }
}
