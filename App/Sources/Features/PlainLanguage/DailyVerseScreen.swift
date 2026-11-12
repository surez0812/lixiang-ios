import SwiftUI
import LixiangCalendarCore

/// 「每日一句」：一张大卡（节气图/日期/农历/干支/每日一句+解释+出处），读解释本页展开，不跳值神
struct DailyVerseScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    let date: LocalDate
    @State private var showExplain = false
    @State private var shareData: Data?

    private var almanac: AlmanacDay { state.almanac(date) }
    private var quote: DaodejingQuote? { state.plainLanguage.dailyQuote(for: date) }

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                MergedDayCard(date: date, variant: .day) { }
                if let quote {
                    D1Card(padding: 14) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("每日一句 · 第\(quote.chapter)章").d1Font(11, weight: .semibold).foregroundStyle(theme.ink3)
                                Spacer()
                                Button(showExplain ? "收起解释" : "读解释") {
                                    withAnimation { showExplain.toggle() }
                                }
                                .d1Font(11, weight: .semibold).foregroundStyle(theme.accentStrong)
                            }
                            Text(quote.quote).d1Kaiti(20).foregroundStyle(theme.ink).lineLimit(3)
                            if showExplain {
                                Text(quote.zh).d1Font(12).foregroundStyle(theme.ink2).lineSpacing(3)
                                Text("《道德经》第\(quote.chapter)章 · \(quote.source)")
                                    .d1Font(10).foregroundStyle(theme.ink3)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16).padding(.vertical, 8).padding(.bottom, 120)
        }
        .background(ScreenBackground())
        .navigationTitle("每日一句")
        .navigationBarTitleDisplayMode(.inline)
    }
}
