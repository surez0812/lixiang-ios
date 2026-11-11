import SwiftUI
import LixiangCalendarCore

/// A24 道德经短句 sheet（原文+白话+解释入口；分享仅原文+章次）
struct QuoteSheet: View {
    @Environment(\.d1) private var theme
    @Environment(\.dismiss) private var dismiss
    let quote: DaodejingQuote
    let date: LocalDate

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    Text("第 \(quote.chapter) 章").d1Font(10, weight: .semibold).tracking(1.2).foregroundStyle(theme.ink3)
                    Text(quote.quote).d1SerifFont(26).foregroundStyle(theme.ink)
                    Text(quote.zh).d1Font(13).foregroundStyle(theme.ink2).lineSpacing(4)
                    Text(quote.en).d1Font(11).foregroundStyle(theme.ink3)
                    Text("出处：\(quote.source) · 公版").d1Font(9).foregroundStyle(theme.ink3)
                    D1Divider()
                    NavigationLink { GlossaryScreen() } label: {
                        HStack {
                            Text("历法术语解释").d1Font(12, weight: .semibold).foregroundStyle(theme.ink)
                            Spacer()
                            Image(systemName: "chevron.right").d1Font(10).foregroundStyle(theme.ink3)
                        }
                    }
                    Text("传统经典只作文化阅读；不构成任何预测或建议。").d1Font(9).foregroundStyle(theme.ink3)
                }
                .padding(20)
            }
            .background(ScreenBackground())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: "「\(quote.quote)」——《道德经》第 \(quote.chapter) 章") { Image(systemName: "square.and.arrow.up") }
                }
                ToolbarItem(placement: .topBarLeading) { Button("关闭") { dismiss() } }
            }
        }
    }
}
