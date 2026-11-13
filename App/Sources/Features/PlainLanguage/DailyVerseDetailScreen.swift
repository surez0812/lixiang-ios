import SwiftUI
import LixiangCalendarCore

/// DAILY-VERSE-SCHEMA 样张：quote→source→divider→title→meaning→action_title→action（纯文本，空段隐藏）
struct DailyVerseDetail: Decodable, Identifiable {
    var date: String
    var tradition: String
    var classic: String
    var chapter: String
    var source: String
    var quote: String
    var title: String
    var meaning: String
    var action_title: String?
    var action: String
    var en: String?
    var id: String { date }
}

struct DailyVerseSampleScreen: View {
    @Environment(\.d1) private var theme
    @State private var verses: [DailyVerseDetail] = []
    @State private var index = 0
    @State private var shareData: Data?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if verses.isEmpty {
                    Text("今日经典暂缺").d1Font(12).foregroundStyle(theme.ink3)
                } else {
                    let v = verses[index]
                    Text(quoteAttributed(v.quote))
                        .d1SerifFont(30, weight: .semibold)
                        .foregroundStyle(Color.r14Red)
                    Text(v.source).d1Font(12).foregroundStyle(theme.ink3).lineLimit(1)
                    Divider().overlay(theme.line)
                    Text(v.title).d1Font(19, weight: .semibold).foregroundStyle(theme.ink).lineLimit(2)
                    Text(v.meaning).d1Font(15).foregroundStyle(theme.ink2).lineSpacing(8)
                    Text(v.action_title?.isEmpty == false ? v.action_title! : "把这句话放进今天")
                        .d1Font(17, weight: .semibold).foregroundStyle(theme.ink)
                    Text(v.action).d1Font(15).foregroundStyle(theme.ink2).lineSpacing(8)
                    HStack {
                        Button("上一条") { index = max(0, index - 1) }.disabled(index == 0)
                        Spacer()
                        Text("\(index + 1)/\(verses.count)").d1Font(10).foregroundStyle(theme.ink3)
                        Spacer()
                        Button("下一条") { index = min(verses.count - 1, index + 1) }.disabled(index == verses.count - 1)
                    }
                    .d1Font(11, weight: .semibold)
                    .padding(.top, 8)
                    Divider().overlay(theme.line)
                    HStack(spacing: 12) {
                        if let shareData {
                            ShareLink(item: ShareableJPEG(data: shareData),
                                      preview: SharePreview("历象 · 每日一句", image: Image(uiImage: UIImage(data: shareData) ?? UIImage()))) {
                                Label("分享这一句", systemImage: "square.and.arrow.up")
                                    .d1Font(12, weight: .semibold)
                            }
                        }
                        Spacer()
                    }
                    if let shareData, let img = UIImage(data: shareData) {
                        Text("分享卡样张（1080×1350 + QR220）").d1Font(9).foregroundStyle(theme.ink3)
                        Image(uiImage: img).resizable().scaledToFit().frame(width: 180, height: 225)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .accessibilityLabel("分享卡样张")
                    }
                }
            }
            .padding(20)
        }
        .background(ScreenBackground())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: index) { _, _ in
            if verses.indices.contains(index) { shareData = renderShare(verses[index]) }
        }
        .onAppear {
            guard verses.isEmpty else { return }
            if let url = Bundle.main.url(forResource: "verse-sample", withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let arr = try? JSONDecoder().decode([DailyVerseDetail].self, from: data) {
                verses = arr
                if arr.indices.contains(index) { shareData = renderShare(arr[index]) }
            }
        }
    }

    private func quoteAttributed(_ text: String) -> AttributedString {
        var a = AttributedString(text)
        let style = NSMutableParagraphStyle()
        style.lineBreakStrategy = .pushOut
        style.lineSpacing = 6
        a.paragraphStyle = style
        return a
    }

    @MainActor
    private func renderShare(_ v: DailyVerseDetail) -> Data? {
        let renderer = ImageRenderer(content: VerseShareCard(v: v))
        renderer.scale = 3
        return renderer.uiImage?.jpegData(compressionQuality: 0.9)
    }
}

private struct VerseShareCard: View {
    let v: DailyVerseDetail
    private let theme = D1Theme.light
    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Text("历象").d1SerifFont(18, weight: .semibold).foregroundStyle(theme.accentStrong)
            Text(v.quote).d1SerifFont(24, weight: .semibold)
                .foregroundStyle(Color.r14Red).lineSpacing(5)
            Text(v.source).d1Font(10).foregroundStyle(theme.ink3)
            Divider().overlay(theme.line)
            Text(v.title).d1Font(15, weight: .semibold).foregroundStyle(theme.ink).lineLimit(2)
            Text(v.meaning).d1Font(11).foregroundStyle(theme.ink2).lineSpacing(4).lineLimit(5)
            Text(v.action_title?.isEmpty == false ? v.action_title! : "把这句话放进今天")
                .d1Font(13, weight: .semibold).foregroundStyle(theme.ink)
            Text(v.action).d1Font(11).foregroundStyle(theme.ink2).lineSpacing(4).lineLimit(3)
            Spacer()
            HStack {
                Text("App Store 搜索「历象」").d1Font(8).foregroundStyle(theme.ink3)
                Spacer()
                if let qr = ShareCardRenderer.qrImage(text: "https://apps.apple.com/app/id6833252283", size: 90) {
                    Image(uiImage: qr).interpolation(.none).resizable().frame(width: 90, height: 90)
                }
            }
        }
        .padding(20)
        .frame(width: 360, height: 450, alignment: .topLeading)
        .background(theme.paper)
    }
}
