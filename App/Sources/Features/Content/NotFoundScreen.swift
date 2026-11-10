import SwiftUI

/// 深链/未知 slug：原生内联卡（无全屏 modal）
struct NotFoundScreen: View {
    @Environment(\.d1) private var theme
    let slug: String
    var body: some View {
        ScrollView {
            D1Card {
                VStack(alignment: .leading, spacing: 6) {
                    Text("内容不存在").font(.system(size: 14, weight: .semibold)).foregroundStyle(theme.ink)
                    Text("链接指向的内容不存在或已下线（\(slug)）。").font(.system(size: 11)).foregroundStyle(theme.ink2)
                    Text("返回后可从「民俗」按日期浏览已解锁内容。").font(.system(size: 10)).foregroundStyle(theme.ink3)
                }
            }
            .padding(16)
        }
        .background(ScreenBackground())
        .navigationTitle("民俗")
        .navigationBarTitleDisplayMode(.inline)
    }
}
