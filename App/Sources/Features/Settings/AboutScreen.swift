import SwiftUI

struct AboutScreen: View {
    @Environment(\.d1) private var theme
    @Environment(\.openURL) private var openURL

    private var version: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(v) (\(b))"
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                D1Card {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("历象").d1SerifFont(28).foregroundStyle(theme.ink)
                        Text("传统历法 · 民俗文化").d1Font(10).foregroundStyle(theme.ink3)
                        Text("版本 \(version)").d1Font(10).foregroundStyle(theme.ink3)
                    }
                }
                D1Card(padding: 0) {
                    VStack(spacing: 0) {
                        linkRow("隐私政策") { PrivacyScreen(title: "隐私政策", resource: "privacy") }
                        D1Divider().padding(.leading, 16)
                        linkRow("用户条款") { PrivacyScreen(title: "用户条款", resource: "user-terms") }
                        D1Divider().padding(.leading, 16)
                        linkRow("售后与支持") { PrivacyScreen(title: "支持", resource: "support") }
                        D1Divider().padding(.leading, 16)
                        Button { openURL(URL(string: "mailto:support@zhaoyao.xin")!) } label: {
                            HStack {
                                Text("联系我们").d1Font(12).foregroundStyle(theme.ink)
                                Spacer()
                                Text("support@zhaoyao.xin").d1Font(10).foregroundStyle(theme.ink3).lineLimit(1)
                                Image(systemName: "envelope").d1Font(10).foregroundStyle(theme.ink3)
                            }
                            .padding(16)
                        }.buttonStyle(.plain)
                    }
                }
                Text("传统历法民俗参考，不构成宗教劝诱或预测。")
                    .d1Font(10).foregroundStyle(theme.ink3)
                Text("© 2026 昭杳 · 历象内容为原创整理与传统公版文本，不宣称 AI 生成，不做吉凶预测。")
                    .d1Font(9).foregroundStyle(theme.ink3)
            }
            .padding(16)
        }
        .background(ScreenBackground())
        .navigationTitle("关于历象")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func linkRow<Destination: View>(_ title: String, @ViewBuilder destination: () -> Destination) -> some View {
        NavigationLink { destination() } label: {
            HStack {
                Text(title).d1Font(12).foregroundStyle(theme.ink)
                Spacer()
                Image(systemName: "chevron.right").d1Font(10).foregroundStyle(theme.ink3)
            }
            .padding(16)
        }.buttonStyle(.plain)
    }
}

/// 本地 Markdown 渲染（法务/支持文案；终稿替换资源文件即可）
struct PrivacyScreen: View {
    @Environment(\.d1) private var theme
    let title: String
    let resource: String
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                ForEach(markdownLines, id: \.self) { line in
                    Text(line).d1Font(12).foregroundStyle(theme.ink2).lineSpacing(3)
                }
            }
            .frame(maxWidth: 600, alignment: .leading)
            .padding(16)
        }
        .background(ScreenBackground())
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var markdownLines: [String] {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "md")
                ?? Bundle.main.url(forResource: resource, withExtension: "md", subdirectory: "Legal"),
              let text = try? String(contentsOf: url, encoding: .utf8) else { return ["内容准备中。"] }
        return text.split(separator: "\n").map(String.init).filter { !$0.isEmpty }
    }
}
