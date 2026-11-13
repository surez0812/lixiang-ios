import SwiftUI
import Foundation

/// 岁时内容加载状态（v1 本地 fixtures；保留离线/失败/重试状态机，未来接内容服务时复用）。
enum R14FolkloreLoadState: Equatable {
    case loading
    case loaded
    case offline      // 有缓存：展示缓存 + banner
    case failed       // 无缓存：错误 + 重试，不显示假内容
}

enum R14FolkloreInjectMode: String {
    case normal, offline, failed, loading, retry
}

@MainActor
final class R14FolkloreLoadController: ObservableObject {
    @Published private(set) var state: R14FolkloreLoadState
    private let mode: R14FolkloreInjectMode
    private var retried = false

    init(mode: R14FolkloreInjectMode = .normal, autoRetry: Bool = false) {
        self.mode = mode
        switch mode {
        case .loading: state = .loading
        case .failed: state = .failed
        case .offline, .retry: state = .offline
        case .normal: state = .loaded
        }
        if mode == .retry || autoRetry {
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 1_200_000_000)
                self.retry()
            }
        }
    }

    /// 重试迁移：offline/failed/loading → loading → loaded（v1 本地数据视为成功）。
    func retry() {
        guard !retried else { return }
        retried = true
        state = .loading
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 250_000_000)
            self.state = .loaded
        }
    }

    static func modeFromProcess() -> R14FolkloreInjectMode {
        let args = ProcessInfo.processInfo.arguments
        if args.contains("-LixiangForceLoading") { return .loading }
        if args.contains("-LixiangForceLoadFail") { return .failed }
        if args.contains("-LixiangForceOffline") { return .offline }
        if args.contains("-LixiangOfflineRetry") { return .retry }
        return .normal
    }
}

/// 共用状态卡（列表/详情）
struct R14FolkloreStateBanner: View {
    @Environment(\.d1) private var theme
    let state: R14FolkloreLoadState
    var retry: () -> Void

    var body: some View {
        switch state {
        case .loading:
            HStack(spacing: 10) {
                ProgressView().tint(theme.accent)
                Text("正在加载岁时内容…").d1Font(12).foregroundStyle(theme.ink2)
                Spacer()
            }
            .padding(14)
            .background(theme.paper, in: RoundedRectangle(cornerRadius: 14))
        case .offline:
            HStack(spacing: 8) {
                Image(systemName: "wifi.slash").foregroundStyle(theme.accentStrong)
                VStack(alignment: .leading, spacing: 2) {
                    Text("内容服务不可用 · 当前为离线内容").d1Font(11, weight: .semibold).foregroundStyle(theme.ink)
                    Text("联网后可获取更新；已缓存内容仍可阅读。").d1Font(9).foregroundStyle(theme.ink3)
                }
                Spacer(minLength: 0)
                Button("重试", action: retry).d1Font(11, weight: .semibold).foregroundStyle(theme.accentStrong).frame(minHeight: 44)
                    .accessibilityLabel("重试加载岁时内容").accessibilityIdentifier("folklore.retry")
            }
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(theme.soft, in: RoundedRectangle(cornerRadius: 14))
            .accessibilityElement(children: .contain)
            .accessibilityLabel("内容服务不可用，当前为离线内容")
            .accessibilityIdentifier("folklore.offlineBanner")
        case .failed:
            VStack(alignment: .leading, spacing: 8) {
                Label("岁时内容加载失败", systemImage: "exclamationmark.triangle").d1Font(13, weight: .semibold).foregroundStyle(theme.ink)
                Text("请检查网络后重试；未加载成功前不会展示示例内容。").d1Font(10).foregroundStyle(theme.ink3)
                Button("重试", action: retry).d1Font(12, weight: .semibold)
                    .padding(.horizontal, 16).frame(minHeight: 44)
                    .background(theme.accent, in: Capsule()).foregroundStyle(theme.cream)
                    .accessibilityLabel("重试加载岁时内容").accessibilityIdentifier("folklore.retry")
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16)
            .background(theme.paper, in: RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(theme.line))
            .accessibilityElement(children: .contain)
            .accessibilityLabel("岁时内容加载失败")
            .accessibilityIdentifier("folklore.failedCard")
        case .loaded:
            EmptyView()
        }
    }
}
