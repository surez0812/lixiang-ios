import SwiftUI
import LixiangCalendarCore

/// A24 / 日期卡解释 sheet（design `layout-quote-light.png`）：插画+日期、朱橙 quote 卡、今日一句解释区
struct QuoteSheet: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    @Environment(\.dismiss) private var dismiss
    let quote: DaodejingQuote
    let date: LocalDate

    private var almanac: AlmanacDay { state.almanac(date) }

    /// 只展示公开信息：去掉括号内草稿/待核对说明（如「王弼本（qwen4 草稿，待双源核对）」→「王弼本」）
    private var publicSource: String {
        var text = quote.source
        for marker in ["qwen", "Qwen", "草稿", "待双源", "待核对", "待核", "TODO"] {
            text = text.replacingOccurrences(of: marker, with: "")
        }
        if let idx = text.firstIndex(where: { $0 == "（" || $0 == "(" }) {
            text = String(text[..<idx])
        }
        text = text.trimmingCharacters(in: CharacterSet(charactersIn: " ，,·（）()"))
        return text.isEmpty ? "王弼本" : text
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 12) {
                    ZStack(alignment: .bottomLeading) {
                        SolarTermArtView(date: date, maxHeight: 260, showLabel: false)
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(date.month)月\(date.day)日 · \(almanac.solarTerm ?? almanac.lunar.monthDayText) · \(almanac.lunar.monthDayText)")
                                .d1Font(11).foregroundStyle(theme.ink2)
                            Text("\(date.day)").d1SerifFont(40).foregroundStyle(theme.ink)
                        }
                        .padding(8)
                        .background(theme.paper.opacity(0.5), in: RoundedRectangle(cornerRadius: 16))
                        .padding(12)
                    }
                    quoteCard
                    explainCard
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 24)
            }
            .background(ScreenBackground())
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink(item: "「\(quote.quote)」——《道德经》第 \(quote.chapter) 章") {
                        Image(systemName: "square.and.arrow.up")
                    }
                }
                ToolbarItem(placement: .topBarLeading) { Button("关闭") { dismiss() } }
            }
        }
    }

    private var quoteCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("“").d1SerifFont(34).foregroundStyle(theme.cream.opacity(0.55)).frame(height: 18)
            Text(quote.quote).d1SerifFont(22).foregroundStyle(theme.cream)
            Text(quote.zh).d1Font(11).foregroundStyle(theme.cream.opacity(0.92))
            Text("《道德经》第\(quote.chapter)章 · 公版原文 · 每日轮换").d1Font(9).foregroundStyle(theme.cream.opacity(0.75))
            Divider().overlay(theme.cream.opacity(0.25))
            Button { } label: {
                HStack {
                    Text("点开读解释（原文 / 白话 / 怎么用）").d1Font(11, weight: .semibold).foregroundStyle(theme.cream)
                    Spacer()
                    Image(systemName: "chevron.right").d1Font(10).foregroundStyle(theme.cream.opacity(0.85))
                }
            }.buttonStyle(.plain)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(LinearGradient(colors: [theme.quote1, theme.quote2], startPoint: .topLeading, endPoint: .bottomTrailing),
                    in: RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var explainCard: some View {
        D1Card {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("今日一句").d1Font(10).foregroundStyle(theme.ink3)
                        Text(quote.quote).d1SerifFont(20).foregroundStyle(theme.ink)
                    }
                    Spacer()
                    Text("自知")
                        .d1SerifFont(12).foregroundStyle(theme.red)
                        .frame(width: 40, height: 44)
                        .overlay(RoundedRectangle(cornerRadius: 8).strokeBorder(theme.red, lineWidth: 1.2))
                        .rotationEffect(.degrees(8))
                        .accessibilityHidden(true)
                }
                Text("解释页：1–3 句白话 +「今天怎么用」；原文为公版，标注章节；不做吉凶预测。长按可复制原文。")
                    .d1Font(11).foregroundStyle(theme.ink2)
                HStack(spacing: 10) {
                    NavigationLink { GlossaryScreen() } label: {
                        Text("读解释").d1Font(12, weight: .semibold).foregroundStyle(theme.cream)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(theme.accent, in: Capsule())
                    }.buttonStyle(.plain)
                    ShareLink(item: "「\(quote.quote)」——《道德经》第 \(quote.chapter) 章") {
                        Text("分享今日一句").d1Font(12, weight: .semibold).foregroundStyle(theme.ink2)
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .overlay(Capsule().strokeBorder(theme.line, lineWidth: 1))
                    }.buttonStyle(.plain)
                }
                Text("原文：\(publicSource)").d1Font(9).foregroundStyle(theme.ink3)
            }
        }
    }
}
