import SwiftUI
import LixiangCalendarCore

/// A22 术语白话 sheet（点按宜/忌 chip）
struct PlainTermSheet: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    @Environment(\.dismiss) private var dismiss
    let term: String

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text(term).d1SerifFont(28).foregroundStyle(theme.ink)
                    if let t = state.plainLanguage.term(named: term) {
                        Text(t.zh).d1Font(14).foregroundStyle(theme.ink2).lineSpacing(4)
                        Text(t.en).d1Font(11).foregroundStyle(theme.ink3)
                        Text("分类：\(t.category)").d1Font(10).foregroundStyle(theme.ink3)
                    } else {
                        Text("暂无白话词条（内容补齐后显示）；先按传统历书字面理解即可。").d1Font(12).foregroundStyle(theme.ink2)
                    }
                    D1Divider()
                    Text("白话只解释含义，不做吉凶预测；不同历书流派表述可能有差异。").d1Font(9).foregroundStyle(theme.ink3)
                }
                .padding(20)
            }
            .background(ScreenBackground())
            .navigationTitle("这是什么意思")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("关闭") { dismiss() } } }
        }
    }
}
