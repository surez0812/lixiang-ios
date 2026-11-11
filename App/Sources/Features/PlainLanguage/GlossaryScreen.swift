import SwiftUI
import LixiangCalendarCore

/// A23 解释页（8 页）：列表 + 详情
struct GlossaryScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Text("这页在说什么").d1SerifFont(26).foregroundStyle(theme.ink)
                Text("历法/黄历术语的白话解释，只讲文化背景，不做预测。").d1Font(11).foregroundStyle(theme.ink3)
                ForEach(state.plainLanguage.pages) { page in
                    NavigationLink { ExplainPageView(page: page) } label: {
                        D1Card(padding: 14) {
                            HStack {
                                Text(page.title).d1Font(14, weight: .semibold).foregroundStyle(theme.ink)
                                Spacer()
                                Image(systemName: "chevron.right").d1Font(10).foregroundStyle(theme.ink3)
                            }
                        }
                    }.buttonStyle(.plain)
                }
            }
            .padding(16)
        }
        .background(ScreenBackground())
        .navigationTitle("术语解释")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ExplainPageView: View {
    @Environment(\.d1) private var theme
    let page: ExplainPage
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(page.title).d1SerifFont(28).foregroundStyle(theme.ink)
                section("是什么", page.what)
                section("意味着什么", page.means)
                section("怎么用", page.how)
                Text(page.en).d1Font(11).foregroundStyle(theme.ink3)
            }
            .padding(16)
        }
        .background(ScreenBackground())
        .navigationTitle(page.title)
        .navigationBarTitleDisplayMode(.inline)
    }
    private func section(_ title: String, _ text: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title).d1Font(10, weight: .semibold).tracking(1).foregroundStyle(theme.ink3)
            Text(text).d1Font(13).foregroundStyle(theme.ink2).lineSpacing(4)
        }
    }
}
