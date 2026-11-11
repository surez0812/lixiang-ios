import Foundation

/// A24 道德经短句（81 章目标；中间版 51 章）
public struct DaodejingQuote: Codable, Hashable, Sendable, Identifiable {
    public var chapter: Int
    public var quote: String
    public var zh: String
    public var en: String
    public var source: String
    public var id: Int { chapter }
    public init(chapter: Int, quote: String, zh: String, en: String, source: String) {
        self.chapter = chapter; self.quote = quote; self.zh = zh; self.en = en; self.source = source
    }
}

/// A22 宜忌术语白话映射
public struct PlainTerm: Codable, Hashable, Sendable, Identifiable {
    public var term: String
    public var category: String
    public var zh: String
    public var en: String
    public var id: String { term }
    public init(term: String, category: String, zh: String, en: String) {
        self.term = term; self.category = category; self.zh = zh; self.en = en
    }
}

/// A23 解释页（8 页）
public struct ExplainPage: Codable, Hashable, Sendable, Identifiable {
    public var term: String
    public var title: String
    public var what: String
    public var means: String
    public var how: String
    public var en: String
    public var id: String { term }
    public init(term: String, title: String, what: String, means: String, how: String, en: String) {
        self.term = term; self.title = title; self.what = what; self.means = means; self.how = how; self.en = en
    }
}

public struct PlainLanguagePack: Sendable {
    public var quotes: [DaodejingQuote]
    public var terms: [PlainTerm]
    public var pages: [ExplainPage]

    public init(quotes: [DaodejingQuote] = [], terms: [PlainTerm] = [], pages: [ExplainPage] = []) {
        self.quotes = quotes.sorted { $0.chapter < $1.chapter }
        self.terms = terms
        self.pages = pages
    }

    private var termIndex: [String: PlainTerm] {
        Dictionary(uniqueKeysWithValues: terms.map { ($0.term, $0) })
    }
    private var pageIndex: [String: ExplainPage] {
        Dictionary(uniqueKeysWithValues: pages.map { ($0.title, $0) })
    }

    /// 确定性轮换：按北京日期的 epoch day 在现有章节中取模（内容补齐后自动覆盖 81 章）
    public func quote(for date: LocalDate) -> DaodejingQuote? {
        guard !quotes.isEmpty else { return nil }
        let epoch = LocalDate(1970, 1, 1).daysBetween(date)
        let idx = ((epoch % quotes.count) + quotes.count) % quotes.count
        return quotes[idx]
    }

    public func page(titled title: String) -> ExplainPage? { pageIndex[title] }
    public func term(named name: String) -> PlainTerm? { termIndex[name] }
}
