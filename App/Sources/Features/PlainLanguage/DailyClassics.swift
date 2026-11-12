import Foundation
import LixiangCalendarCore

/// 每日一句 · 多经典（道经/佛经/儒家/劝善书）；内容包 daily-classics/<key>-365.json
enum DailyClassic: String, CaseIterable, Identifiable {
    case dao, buddhist, confucian, quanshan
    var id: String { rawValue }
    var title: String {
        switch self {
        case .dao: return "道经"
        case .buddhist: return "佛经"
        case .confucian: return "儒家经典"
        case .quanshan: return "劝善书"
        }
    }
    var fileName: String { "\(rawValue)-365" }
}

struct ClassicVerse: Decodable {
    var date: String
    var chapter: Int?
    var quote: String
    var zh: String?
    var en: String?
    var source: String?
}

@MainActor
final class DailyClassicsStore {
    static let shared = DailyClassicsStore()
    private var cache: [String: [String: ClassicVerse]] = [:]

    func verse(for date: LocalDate, classic: DailyClassic) -> DaodejingQuote? {
        let key = String(format: "%04d-%02d-%02d", date.year, date.month, date.day)
        if let v = load(classic)[key] {
            #if DEBUG
            print("LXVERSE classic=\(classic.rawValue) file=\(classic.fileName).json hit=1 fallback=0 date=\(key)")
            #endif
            return map(v)
        }
        if classic != .dao, let v = load(.dao)[key] {
            #if DEBUG
            print("LXVERSE classic=\(classic.rawValue) file=\(classic.fileName).json hit=0 fallback=dao date=\(key)")
            #endif
            return map(v)
        }
        #if DEBUG
        print("LXVERSE classic=\(classic.rawValue) file=\(classic.fileName).json hit=0 fallback=none date=\(key) (内容未交付/缺日)")
        #endif
        return nil
    }

    private func map(_ v: ClassicVerse) -> DaodejingQuote {
        DaodejingQuote(chapter: v.chapter ?? 1, quote: v.quote, zh: v.zh ?? "", en: v.en ?? "", source: v.source ?? "公版")
    }

    private func load(_ classic: DailyClassic) -> [String: ClassicVerse] {
        let key = classic.rawValue
        if let c = cache[key] { return c }
        var out: [String: ClassicVerse] = [:]
        for dir in ["PlainLanguage/daily-classics", "daily-classics", "PlainLanguage", nil] {
            let url = dir.map { Bundle.main.url(forResource: classic.fileName, withExtension: "json", subdirectory: $0) }
                ?? Bundle.main.url(forResource: classic.fileName, withExtension: "json")
            if let url, let data = try? Data(contentsOf: url),
               let arr = try? JSONDecoder().decode([ClassicVerse].self, from: data) {
                for v in arr { out[v.date] = v }
                break
            }
        }
        cache[key] = out
        return out
    }
}

extension AppState {
    var dailyVerse: DaodejingQuote? { dailyQuote(for: today) }
    func dailyQuote(for date: LocalDate) -> DaodejingQuote? {
        let classic = DailyClassic(rawValue: dailyClassic) ?? .dao
        return DailyClassicsStore.shared.verse(for: date, classic: classic)
    }
}
