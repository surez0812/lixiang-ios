import SwiftUI
import LixiangCalendarCore

/// R2-rich 合并大卡：节气图(卡高 50%，center42% 裁切) + 日期内容 + 卡内 quote
/// 规格：proposals/lixiang-1.0-20261111/merged-card/MERGED-CARD-SPEC.md
struct MergedDayCard: View {
    enum Variant { case month, day }
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    @Environment(\.colorScheme) private var colorScheme
    let date: LocalDate
    var variant: Variant = .month
    var onQuoteTap: () -> Void = {}

    private var almanac: AlmanacDay { state.almanac(date) }
    private var quote: DaodejingQuote? { state.plainLanguage.quote(for: date) }
    private var cardHeight: CGFloat { variant == .month ? 470 : 530 }
    private var imageHeight: CGFloat { cardHeight / 2 }

    var body: some View {
        VStack(spacing: -34) {
            image
            content
        }
        .frame(height: cardHeight, alignment: .top)
        .background(theme.paper)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 28).strokeBorder(theme.line.opacity(0.55), lineWidth: 0.8))
        .accessibilityElement(children: .contain)
    }

    private var image: some View {
        GeometryReader { geo in
            let w = geo.size.width
            SeasonalImage(date: date)
                .frame(width: w, height: imageHeight)
                .clipped()
                .overlay(alignment: .topLeading) {
                    if let term = almanac.solarTerm {
                        Text(term).d1Font(10, weight: .semibold).foregroundStyle(theme.cream)
                            .padding(.horizontal, 10).padding(.vertical, 5)
                            .background(theme.accent, in: Capsule()).padding(12)
                            .accessibilityHidden(true)
                    }
                }
                .overlay(alignment: .bottom) {
                    LinearGradient(colors: [theme.paper.opacity(0), theme.paper],
                                   startPoint: .top, endPoint: .bottom)
                        .frame(height: imageHeight * 0.5)
                }
        }
        .frame(height: imageHeight)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 10) {
                Text("\(date.day)").d1SerifFont(108).foregroundStyle(theme.ink)
                VStack(alignment: .leading, spacing: 4) {
                    Text(titleText).d1SerifFont(22, weight: .semibold).foregroundStyle(theme.ink)
                        .lineLimit(1).minimumScaleFactor(0.7)
                    Text("星期\(date.weekdayChinese) · \(almanac.lunar.yearGanZhi)年 · \(almanac.lunar.monthGanZhi)月 · \(almanac.lunar.dayGanZhi)日")
                        .d1Font(11).foregroundStyle(theme.ink3).lineLimit(2)
                }
                Spacer(minLength: 0)
            }
            HStack(spacing: 6) {
                D1Chip(text: "宜 \(almanac.yi.prefix(3).joined(separator: " "))", tone: .yi)
                D1Chip(text: "忌 \(almanac.ji.prefix(3).joined(separator: " "))", tone: .ji)
            }
            if let quote {
                Divider().overlay(theme.line)
                Button(action: onQuoteTap) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(quote.quote).d1Kaiti(20).foregroundStyle(theme.ink).lineLimit(2)
                        HStack {
                            Text("《道德经》第\(quote.chapter)章").d1Font(10.5).foregroundStyle(theme.ink3)
                            Spacer()
                            Text("今天怎么用").d1Font(10.5, weight: .semibold).foregroundStyle(theme.accentStrong)
                            Image(systemName: "chevron.right").d1Font(9).foregroundStyle(theme.accentStrong)
                        }
                    }
                }.buttonStyle(.plain)
                .accessibilityLabel("今日道德经，第\(quote.chapter)章")
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var titleText: String {
        if let term = almanac.solarTerm { return "\(term) · \(almanac.lunar.monthDayText)" }
        return almanac.lunar.monthDayText
    }
}

/// 节气插画（不叠字），明暗自适应
struct SeasonalImage: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.colorScheme) private var colorScheme
    let date: LocalDate
    var body: some View {
        let term = SeasonalArtStore.shared.currentTerm(for: date, engine: state.engine)
        let slug = term.flatMap { SeasonalArtStore.shared.slug(forChineseTerm: $0) }
        if let slug, let ui = SeasonalArtStore.shared.image(slug: slug, dark: colorScheme == .dark) {
            Image(uiImage: ui).resizable().scaledToFill()
        } else {
            LinearGradient(colors: [Color(hex: 0xE7C9A4), Color(hex: 0xF7EBDC)], startPoint: .top, endPoint: .bottom)
        }
    }
}
