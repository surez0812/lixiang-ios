import Foundation
import LixiangCalendarCore

enum PlainLanguageLoader {
    static func load() -> PlainLanguagePack {
        func decode<T: Decodable>(_ type: T.Type, _ name: String) -> [T] {
            let url = Bundle.main.url(forResource: name, withExtension: "json", subdirectory: "PlainLanguage")
                ?? Bundle.main.url(forResource: name, withExtension: "json")
            guard let url, let data = try? Data(contentsOf: url),
                  let decoded = try? JSONDecoder().decode([T].self, from: data) else { return [] }
            return decoded
        }
        return PlainLanguagePack(quotes: decode(DaodejingQuote.self, "daodejing"),
                                 terms: decode(PlainTerm.self, "yi-ji-mapping"),
                                 pages: decode(ExplainPage.self, "explain-pages"),
                                 panelTerms: decode(PanelTerm.self, "panel-terms"))
    }
}
