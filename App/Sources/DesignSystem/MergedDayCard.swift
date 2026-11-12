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
    var onDayTap: (() -> Void)? = nil

    private var almanac: AlmanacDay { state.almanac(date) }
    private var quote: DaodejingQuote? { state.plainLanguage.quote(for: date) }
    private var imageHeight: CGFloat { 333 }
    private var minHeight: CGFloat { 500 }

    private var cardHeight: CGFloat { 640 }
    private var contentTop: CGFloat { cardHeight * 2 / 3 }   // 427

    var body: some View {
        ZStack(alignment: .top) {
            image
                .frame(maxWidth: .infinity)
                .frame(height: cardHeight)
                .clipped()
            LinearGradient(colors: [.clear, theme.paper.opacity(0.97), theme.paper],
                           startPoint: .top, endPoint: .bottom)
                .frame(height: cardHeight - contentTop)
                .offset(y: contentTop)
                .allowsHitTesting(false)
            ScrollView(.vertical, showsIndicators: false) {
                content
            }
            .frame(height: cardHeight - contentTop)
            .offset(y: contentTop)
        }
        .frame(height: cardHeight)
        .background(theme.paper)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 28).strokeBorder(theme.line.opacity(0.55), lineWidth: 0.8))
        .overlay(alignment: .top) {
            if let onDayTap {
                Button(action: onDayTap) {
                    Color.clear.frame(maxWidth: .infinity).frame(height: contentTop).contentShape(Rectangle())
                }.buttonStyle(.plain).accessibilityLabel("查看当日详情")
            }
        }
        .accessibilityElement(children: .contain)
    }

    private var image: some View {
        GeometryReader { geo in
            let w = geo.size.width
            SeasonalImage(date: date)
                .frame(width: w, height: cardHeight)
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
        .frame(height: cardHeight)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 10) {
                Text("\(date.day)").d1SerifFont(60).foregroundStyle(theme.ink)
                VStack(alignment: .leading, spacing: 4) {
                    Text(titleText).d1SerifFont(22, weight: .semibold).foregroundStyle(theme.ink)
                        .lineLimit(1).minimumScaleFactor(0.7)
                    Text(verbatim: "\(date.year)年\(date.month)月\(date.day)日")
                        .d1Font(13, weight: .semibold).foregroundStyle(theme.ink2)
                    Text("星期\(date.weekdayChinese) · 农历\(almanac.lunar.monthDayText) · \(almanac.lunar.yearGanZhi)年 \(almanac.lunar.monthGanZhi)月 \(almanac.lunar.dayGanZhi)日")
                        .d1Font(10, weight: .medium).foregroundStyle(theme.ink).lineLimit(2)
                }
                Spacer(minLength: 0)
            }
            if !almanac.festivals.isEmpty {
                HStack(spacing: 6) {
                    ForEach(Array(almanac.festivals.prefix(1)), id: \.self) { f in
                        Text("节日 · \(f)").d1Font(9, weight: .medium)
                            .foregroundStyle(theme.solarTermText)
                            .padding(.horizontal, 8).padding(.vertical, 3)
                            .background(theme.solarTermText.opacity(0.12), in: Capsule())
                    }
                    if almanac.festivals.count > 1 {
                        Text("+\(almanac.festivals.count - 1)").d1Font(9, weight: .medium)
                            .foregroundStyle(theme.ink3)
                            .padding(.horizontal, 6).padding(.vertical, 3)
                            .background(theme.line.opacity(0.2), in: Capsule())
                    }
                }
                .accessibilityLabel("节日：\(almanac.festivals.joined(separator: "、"))")
            }
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 5) { Circle().fill(theme.yiText).frame(width: 5, height: 5); Text("宜：\(almanac.yi.prefix(8).joined(separator: " "))").d1Font(10.5).foregroundStyle(theme.ink).lineLimit(2) }
                HStack(spacing: 5) { Circle().fill(theme.red).frame(width: 5, height: 5); Text("忌：\(almanac.ji.prefix(8).joined(separator: " "))").d1Font(10.5).foregroundStyle(theme.red).lineLimit(2) }
            }
            .accessibilityLabel("宜：\(almanac.yi.prefix(8).joined(separator: "、"))；忌：\(almanac.ji.prefix(8).joined(separator: "、"))")
            if let quote {
                Divider().overlay(theme.line)
                Button(action: onQuoteTap) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(quote.quote).d1Kaiti(15).foregroundStyle(theme.ink).lineLimit(2)
                        HStack {
                            Text("《道德经》第\(quote.chapter)章").d1Font(9).foregroundStyle(theme.ink3)
                            Spacer()
                            Text("每日一句").d1Font(10.5, weight: .semibold).foregroundStyle(theme.accentStrong)
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
