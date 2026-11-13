import SwiftUI
import LixiangCalendarCore

/// R14 每日一句：完整经文、出处、含义、日常应用；分享卡含二维码；四传统偏好。
struct DailyScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    @EnvironmentObject private var days: SelectedDayStore
    @State private var sharePayload: SharePayload?

    private var classic: DailyClassic { DailyClassic(rawValue: state.dailyClassic) ?? .dao }
    private var date: LocalDate { days.selectedDate }
    private var verse: R14DailyVerse? { R14DailyVerseStore.shared.verse(for: date, classic: classic) }
    private var almanac: AlmanacDay { days.almanac }
    private var hasMultipleTraditions: Bool { DailyClassic.allCases.filter { R14DailyVerseStore.shared.hasContent($0) }.count > 1 }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                header
                if hasMultipleTraditions { traditionPicker }
                if let verse {
                    verseBody(verse)
                } else {
                    Text("今日经典暂缺，试试切换经典来源。")
                        .d1Font(14).foregroundStyle(theme.ink2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .padding(.bottom, 100)
        }
        .background(ScreenBackground())
        .toolbar(.hidden, for: .tabBar)
        .navigationTitle("每日一句")
        .navigationBarTitleDisplayMode(.inline)
        .fullScreenCover(item: $sharePayload) { payload in
            DailySharePage(date: date, almanac: almanac, verse: payload.verse, theme: theme)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(date.month)月\(date.day)日 · \(almanac.lunar.monthDayText)").d1Font(12).foregroundStyle(theme.ink3)
            Text(classic.title).d1SerifFont(26).foregroundStyle(theme.ink)
        }
    }

    private var traditionPicker: some View {
        HStack(spacing: 8) {
            ForEach(DailyClassic.allCases) { c in
                if R14DailyVerseStore.shared.hasContent(c) {
                    Button {
                        state.dailyClassic = c.rawValue
                    } label: {
                        Text(c.title)
                            .d1Font(12, weight: classic == c ? .semibold : .regular)
                            .foregroundStyle(classic == c ? theme.onAccent : theme.ink2)
                            .padding(.horizontal, 12).frame(minHeight: 36)
                            .background(classic == c ? theme.accentStrong : theme.soft, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            Spacer(minLength: 0)
        }
    }

    private func verseBody(_ verse: R14DailyVerse) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text(verse.quote)
                    .d1Kaiti(26)
                    .foregroundStyle(theme.red)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
                Text(verse.source)
                    .d1Font(12)
                    .foregroundStyle(theme.ink3)
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.paper, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).strokeBorder(theme.line, lineWidth: 1))

            Text(verse.title).d1Font(17, weight: .semibold).foregroundStyle(theme.ink)
            Text(verse.meaning).d1Font(15).lineSpacing(7).foregroundStyle(theme.ink2).fixedSize(horizontal: false, vertical: true)

            Text(verse.actionTitle).d1Font(17, weight: .semibold).foregroundStyle(theme.ink)
            Text(verse.action).d1Font(15).lineSpacing(7).foregroundStyle(theme.ink2).fixedSize(horizontal: false, vertical: true)

            Button {
                share(verse)
            } label: {
                Label("分享今日一句", systemImage: "square.and.arrow.up")
                    .d1Font(15, weight: .semibold)
                    .frame(maxWidth: .infinity, minHeight: 46)
            }
            .buttonStyle(.borderedProminent)
            .tint(theme.accentStrong)
        }
    }

    private func share(_ verse: R14DailyVerse) {
        sharePayload = SharePayload(verse: verse)
    }
}

private struct SharePayload: Identifiable {
    let id = UUID()
    let verse: R14DailyVerse
}

private struct DailySharePage: View {
    let date: LocalDate
    let almanac: AlmanacDay
    let verse: R14DailyVerse
    let theme: D1Theme
    @Environment(\.dismiss) private var dismiss
    @State private var rendered: UIImage?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    Text("分享卡").d1Font(12, weight: .semibold).tracking(1.6).foregroundStyle(theme.ink3)
                    DailyShareCard(date: date, almanac: almanac, verse: verse, theme: theme)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .shadow(color: .black.opacity(0.08), radius: 12, y: 4)
                    if let rendered {
                        ShareLink(item: Image(uiImage: rendered), preview: SharePreview("历象 · 每日一句", image: Image(uiImage: rendered))) {
                            Label("系统分享", systemImage: "square.and.arrow.up")
                                .d1Font(15, weight: .semibold)
                                .frame(maxWidth: .infinity, minHeight: 46)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(theme.accentStrong)
                    }
                    Button("关闭") { dismiss() }.d1Font(14).foregroundStyle(theme.ink2).frame(minHeight: 44)
                }
                .padding(20)
            }
            .background(ScreenBackground())
            .navigationTitle("每日一句 · 分享")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) { Button("关闭") { dismiss() } }
            }
            .task {
                let view = DailyShareCard(date: date, almanac: almanac, verse: verse, theme: theme)
                let renderer = ImageRenderer(content: view)
                renderer.scale = 3
                renderer.proposedSize = ProposedViewSize(width: 360, height: 450)
                renderer.isOpaque = true
                rendered = renderer.uiImage
            }
        }
    }
}

/// 亮色分享卡：经文/出处/日期农历/二维码；无印章。
struct DailyShareCard: View {
    let date: LocalDate
    let almanac: AlmanacDay
    let verse: R14DailyVerse
    let theme: D1Theme
    private let size = CGSize(width: 360, height: 450)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("历象").d1SerifFont(20, weight: .semibold).foregroundStyle(theme.accentStrong)
                Spacer()
                Text("\(date.month)月\(date.day)日 · \(almanac.lunar.monthDayText)").d1Font(11).foregroundStyle(theme.ink3)
            }
            Text(verse.quote).d1Kaiti(24).foregroundStyle(theme.ink).lineLimit(3)
            Text(verse.title).d1Font(13, weight: .semibold).foregroundStyle(theme.ink2)
            Text(verse.meaning).d1Font(11).foregroundStyle(theme.ink2).lineLimit(3)
            Text(verse.source).d1Font(9).foregroundStyle(theme.ink3)
            Spacer()
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("历象 · 每日一句").d1Font(10, weight: .semibold).foregroundStyle(theme.ink2)
                    Text("App Store 搜索「历象」").d1Font(9).foregroundStyle(theme.ink3)
                }
                Spacer()
                if let qr = ShareCardRenderer.qrImage(text: "https://apps.apple.com/app/id6833252283", size: 110) {
                    Image(uiImage: qr).interpolation(.none).resizable().frame(width: 110, height: 110)
                }
            }
        }
        .padding(22)
        .frame(width: size.width, height: size.height, alignment: .topLeading)
        .background(LinearGradient(colors: [Color(hex: 0xFFF8EC), Color(hex: 0xF6E8D1)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .foregroundStyle(Color(hex: 0x35291F))
    }
}
