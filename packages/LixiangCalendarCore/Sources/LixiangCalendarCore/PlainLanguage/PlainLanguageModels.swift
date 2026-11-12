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
    enum CodingKeys: String, CodingKey { case term, category, zh, en }
    /// v1.0 映射精简为 term/zh/en（无 category）→ 缺省归类「其他」，避免整包解码失败
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        term = try c.decode(String.self, forKey: .term)
        zh = try c.decode(String.self, forKey: .zh)
        en = try c.decode(String.self, forKey: .en)
        category = (try? c.decodeIfPresent(String.self, forKey: .category)) ?? "其他"
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
    enum CodingKeys: String, CodingKey { case term, title, what, means, how, en }
    public init(term: String, title: String, what: String, means: String, how: String, en: String) {
        self.term = term; self.title = title; self.what = what; self.means = means; self.how = how; self.en = en
    }

    private static let titleAliases: [String: String] = [
        "zhishen": "值神",
        "pengzu": "彭祖百忌",
        "shichen": "时辰宜忌"
    ]

    /// v1.0 内容改为 term/what/means/how/en（无 title）：自定义解码，title 用中文别名回退
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        term = try c.decode(String.self, forKey: .term)
        what = try c.decode(String.self, forKey: .what)
        means = try c.decode(String.self, forKey: .means)
        how = try c.decode(String.self, forKey: .how)
        en = try c.decode(String.self, forKey: .en)
        if let t = try c.decodeIfPresent(String.self, forKey: .title), !t.isEmpty {
            title = t
        } else {
            title = Self.titleAliases[term] ?? term
        }
    }
}

public struct PlainLanguagePack: Sendable {
    public var quotes: [DaodejingQuote]
    public var terms: [PlainTerm]
    public var pages: [ExplainPage]
    public var panelTerms: [PanelTerm]
    public var dailyVerses: [DailyVerse]

    public init(quotes: [DaodejingQuote] = [], terms: [PlainTerm] = [], pages: [ExplainPage] = [], panelTerms: [PanelTerm] = [], dailyVerses: [DailyVerse] = []) {
        self.quotes = quotes.sorted { $0.chapter < $1.chapter }
        self.terms = terms
        self.pages = pages
        self.panelTerms = panelTerms
        self.dailyVerses = dailyVerses
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
    public func panelTerm(named term: String) -> PanelTerm? { panelTerms.first { $0.term == term } }

    /// 模糊：精确优先，其次前缀/包含（冲猴 煞北 → 冲/煞/煞北）
    public func panelTermMatching(_ name: String) -> PanelTerm? {
        if let exact = panelTerm(named: name) { return exact }
        return panelTerms.first { p in
            p.term.count >= 1 && (name.contains(p.term) || p.term.contains(name))
        }
    }

    /// 优先按日期（yyyy-MM-dd）；缺日回退 81 章轮换
    public func dailyQuote(for date: LocalDate) -> DaodejingQuote? {
        let key = String(format: "%04d-%02d-%02d", date.year, date.month, date.day)
        if let v = dailyVerses.first(where: { $0.date == key }) {
            return DaodejingQuote(chapter: v.chapter, quote: v.quote, zh: v.zh, en: v.en, source: v.source)
        }
        return quote(for: date)
    }
    public func term(named name: String) -> PlainTerm? { termIndex[name] }
}

/// #11 panel 白话（值神/吉神/凶煞/建除/彭祖/星宿/纳音/胎神；显示层无草稿标注）
public struct PanelTerm: Codable, Hashable, Sendable, Identifiable {
    public var id: String { term }
    public var term: String
    public var domain: String
    public var zh: String
    public var en: String
    public var meaning: String?
    public var impact: String?
    public var usage: String?
    public init(term: String, domain: String, zh: String, en: String,
                meaning: String? = nil, impact: String? = nil, usage: String? = nil) {
        self.term = term; self.domain = domain; self.zh = zh; self.en = en
        self.meaning = meaning; self.impact = impact; self.usage = usage
    }
    enum CodingKeys: String, CodingKey { case term, domain, zh, en, meaning, impact, usage }
    /// v1（zh/en）与 v2（meaning/impact/usage/en）兼容
    public init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        term = try c.decode(String.self, forKey: .term)
        domain = (try? c.decode(String.self, forKey: .domain)) ?? "其他"
        meaning = try? c.decodeIfPresent(String.self, forKey: .meaning)
        impact = try? c.decodeIfPresent(String.self, forKey: .impact)
        usage = try? c.decodeIfPresent(String.self, forKey: .usage)
        let oldZh = (try? c.decodeIfPresent(String.self, forKey: .zh)) ?? nil
        zh = oldZh ?? meaning ?? ""
        en = (try? c.decodeIfPresent(String.self, forKey: .en)) ?? ""
    }
    /// UI：三段（含义/影响/怎么用），缺项回退旧 zh
    public var detailText: String {
        if let meaning, !meaning.isEmpty {
            var parts = ["含义：\(meaning)"]
            if let impact, !impact.isEmpty { parts.append("影响：\(impact)") }
            if let usage, !usage.isEmpty { parts.append("怎么用：\(usage)") }
            return parts.joined(separator: "\n")
        }
        return zh
    }
}


/// 365 每日一句（build12）：按日期取；缺日回退 81 章轮换
public struct DailyVerse: Codable, Hashable, Sendable {
    public var date: String
    public var chapter: Int
    public var quote: String
    public var zh: String
    public var en: String
    public var source: String
    public init(date: String, chapter: Int, quote: String, zh: String, en: String, source: String) {
        self.date = date; self.chapter = chapter; self.quote = quote; self.zh = zh; self.en = en; self.source = source
    }
}
