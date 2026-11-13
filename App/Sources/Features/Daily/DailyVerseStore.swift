import Foundation
import LixiangCalendarCore

/// R14 每日一句内容（新 schema：quote/title/meaning/action/source）。
struct R14DailyVerse: Decodable, Equatable {
    var date: String
    var tradition: String?
    var classic: String
    var chapter: String?
    var source: String
    var quote: String
    var title: String
    var meaning: String
    var actionTitle: String
    var action: String
    var en: String?

    enum CodingKeys: String, CodingKey {
        case date, tradition, classic, chapter, source, quote, title, meaning, en
        case actionTitle = "action_title"
        case action
    }
}

@MainActor
final class R14DailyVerseStore: ObservableObject {
    static let shared = R14DailyVerseStore()
    private var cache: [String: [String: R14DailyVerse]] = [:]
    private let fileNames: [DailyClassic: String] = [
        .dao: "dao-365", .buddhist: "buddhist-365", .confucian: "confucian-365", .quanshan: "quanshan-365"
    ]

    func verse(for date: LocalDate, classic: DailyClassic) -> R14DailyVerse? {
        let key = date.iso
        if let v = load(classic)[key] { return v }
        if classic != .dao, let v = load(.dao)[key] { return v }
        return nil
    }

    func hasContent(_ classic: DailyClassic) -> Bool { !load(classic).isEmpty }

    private func load(_ classic: DailyClassic) -> [String: R14DailyVerse] {
        let key = classic.rawValue
        if let cached = cache[key] { return cached }
        var out: [String: R14DailyVerse] = [:]
        guard let name = fileNames[classic] else { cache[key] = out; return out }
        let candidates: [(String?, String?)] = [
            ("daily-classics", name), (nil, name), ("PlainLanguage/daily-classics", name)
        ]
        for (dir, file) in candidates {
            let url = dir.flatMap { Bundle.main.url(forResource: file, withExtension: "json", subdirectory: $0) }
                ?? Bundle.main.url(forResource: file, withExtension: "json")
            if let url, let data = try? Data(contentsOf: url),
               let arr = try? JSONDecoder().decode([R14DailyVerse].self, from: data) {
                for v in arr { out[v.date] = v }
                break
            }
        }
        cache[key] = out
        return out
    }
}
