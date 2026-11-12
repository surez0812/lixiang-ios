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
    @State private var shareData: Data?
    @State private var showShare = false

    private var almanac: AlmanacDay { state.almanac(date) }
    private var quote: DaodejingQuote? { state.plainLanguage.dailyQuote(for: date) }
    private var imageHeight: CGFloat { 170 }
    private var minHeight: CGFloat { 0 }

    private var cardHeight: CGFloat { 640 }
    private var contentTop: CGFloat { cardHeight * 2 / 3 }   // 427

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: -44) {
                image
                    .frame(maxWidth: .infinity)
                    .frame(height: imageHeight)
                    .clipped()
                content
            }
            HStack(spacing: 4) {
                Button {
                    if shareData == nil {
                        shareData = ShareCardRenderer.jpegData(date: date, almanac: almanac, quote: quote, theme: theme)
                    }
                    showShare = shareData != nil
                } label: {
                    Image(systemName: "square.and.arrow.up").d1Font(12).foregroundStyle(theme.ink2)
                        .frame(width: 34, height: 34)
                        .background(theme.paper.opacity(0.8), in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("分享今日")
            }
            .padding(.trailing, 70)
            .padding(.top, 12)
            Image("seal-round-01")
                .resizable().scaledToFit()
                .frame(width: 50, height: 50)
                .rotationEffect(.degrees(6))
                .opacity(0.92)
                .padding(14)
                .accessibilityHidden(true)
        }
        .background(theme.paper)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 28).strokeBorder(theme.line.opacity(0.55), lineWidth: 0.8))
        .overlay(alignment: .top) {
            if let onDayTap {
                Button(action: onDayTap) {
                    Color.clear.frame(maxWidth: .infinity).frame(height: imageHeight).contentShape(Rectangle())
                }.buttonStyle(.plain).accessibilityLabel("查看当日详情")
            }
        }
        .accessibilityElement(children: .contain)
        .sheet(isPresented: $showShare) {
            ShareSheetView(data: shareData)
        }
    }

    private var image: some View {
        GeometryReader { geo in
            let w = geo.size.width
            SeasonalImage(date: date)
                .frame(width: w, height: cardHeight)
                .clipped()
                .overlay(alignment: .topLeading) {
                    if let badge = SolarTermPentad.badge(for: date, engine: state.engine) {
                        Text(badge).d1Font(10, weight: .semibold).foregroundStyle(theme.cream)
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
                VStack(alignment: .leading, spacing: 4) {
                    Text(titleText).d1SerifFont(22, weight: .semibold).foregroundStyle(theme.ink)
                        .lineLimit(1).minimumScaleFactor(0.7)
                    Text(verbatim: "\(date.year)年\(date.month)月\(date.day)日")
                        .d1Font(15, weight: .semibold).foregroundStyle(theme.ink2)
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
            if let quote {
                Divider().overlay(theme.line)
                Button(action: onQuoteTap) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("每日一句 · \(quote.source)").d1Font(9).foregroundStyle(theme.cream.opacity(0.85))
                        Text(quote.quote).d1Kaiti(20).foregroundStyle(theme.cream).lineLimit(2)
                        HStack(spacing: 14) {
                            Text("《道德经》第\(quote.chapter)章").d1Font(9).foregroundStyle(theme.cream.opacity(0.8))
                            Spacer()
                            Text("读解释").d1Font(10.5, weight: .semibold).foregroundStyle(theme.cream)
                            Text("分享").d1Font(10.5, weight: .semibold).foregroundStyle(theme.cream)
                        }
                    }
                }
                .buttonStyle(.plain)
                .padding(10)
                .background(LinearGradient(colors: [theme.quote1, theme.quote2], startPoint: .topLeading, endPoint: .bottomTrailing), in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                .accessibilityLabel("今日道德经，第\(quote.chapter)章")
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
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
