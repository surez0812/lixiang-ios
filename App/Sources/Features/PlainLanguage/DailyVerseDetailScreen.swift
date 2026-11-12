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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if verses.isEmpty {
                    Text("今日经典暂缺").d1Font(12).foregroundStyle(theme.ink3)
                } else {
                    let v = verses[index]
                    Text(v.quote)
                        .d1SerifFont(30, weight: .semibold)
                        .foregroundStyle(Color(hex: 0xB23A2A))
                        .lineSpacing(6)
                    Text(v.source).d1Font(12).foregroundStyle(theme.ink3).lineLimit(1)
                    Divider().overlay(theme.line)
                    Text(v.title).d1Font(19, weight: .semibold).foregroundStyle(theme.ink).lineLimit(2)
                    Text(v.meaning).d1Font(15).foregroundStyle(theme.ink2).lineSpacing(8)
                    Text(v.action_title?.isEmpty == false ? v.action_title! : "把这句话放进今天")
                        .d1Font(17, weight: .semibold).foregroundStyle(theme.ink)
                        .padding(.top, 4)
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
                }
            }
            .padding(20)
        }
        .background(ScreenBackground())
        .navigationTitle("每日一句 · 样张")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            guard verses.isEmpty else { return }
            if let url = Bundle.main.url(forResource: "verse-sample", withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let arr = try? JSONDecoder().decode([DailyVerseDetail].self, from: data) {
                verses = arr
            }
        }
    }
}
