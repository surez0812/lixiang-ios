import SwiftUI

/// 首帧占位：引擎/黄历在后台准备时给明确加载态，避免 Duo 冷启动白屏。
struct R14BootLoadingView: View {
    @Environment(\.d1) private var theme
    var body: some View {
        VStack(spacing: 14) {
            ProgressView().tint(theme.accent)
            Text("历象 · 正在准备今日").d1SerifFont(16, weight: .semibold).foregroundStyle(theme.ink)
            Text("首次启动需载入历法与节日数据，请稍候。").d1Font(11).foregroundStyle(theme.ink3)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.bg)
    }
}
