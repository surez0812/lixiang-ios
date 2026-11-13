import Foundation

public enum LeapRule: String, Codable, Sendable, Hashable { case nonLeap, both, leapOnly }
public enum DayFallback: String, Codable, Sendable, Hashable { case lastDay, skip }

public enum DateRule: Codable, Sendable, Hashable {
    case lunar(month: Int, day: Int, leap: LeapRule, dayFallback: DayFallback)
    case solar(month: Int, day: Int)
    case solarTerm(term: String)
    case lastDayOfLunarMonth(month: Int)

    public static func lunar(_ month: Int, _ day: Int) -> DateRule {
        .lunar(month: month, day: day, leap: .nonLeap, dayFallback: .lastDay)
    }
}

public struct RegionalDate: Codable, Sendable, Hashable, Identifiable {
    public var id: String
    public var label: String
    public var dateRule: DateRule
    public init(id: String, label: String, dateRule: DateRule) {
        self.id = id; self.label = label; self.dateRule = dateRule
    }
}

public struct ContentSource: Codable, Sendable, Hashable {
    public var kind: String
    public var title: String
    public var note: String?
    public init(kind: String, title: String, note: String? = nil) {
        self.kind = kind; self.title = title; self.note = note
    }
}

public struct ContentSection: Codable, Sendable, Hashable, Identifiable {
    public var id: String { title + type }
    public var type: String
    public var title: String
    public var paragraphs: [String]
    public init(type: String, title: String, paragraphs: [String]) {
        self.type = type; self.title = title; self.paragraphs = paragraphs
    }
}

public struct ContentItem: Codable, Sendable, Hashable, Identifiable {
    public var id: String
    public var title: String
    public var category: [String]
    public var dateRule: DateRule
    public var regionalDates: [RegionalDate]?
    public var teaser: String
    public var sections: [ContentSection]
    public var sources: [ContentSource]
    public var license: String
    public var version: Int
    /// 内容门禁：PM 交付 JSON 可选字段（draft/in_review/approved）；缺失/非 approved 不进入可读正文。
    public var reviewStatus: String? = nil

    public init(id: String, title: String, category: [String], dateRule: DateRule, regionalDates: [RegionalDate]?,
                teaser: String, sections: [ContentSection], sources: [ContentSource], license: String,
                version: Int, reviewStatus: String? = nil) {
        self.id = id; self.title = title; self.category = category; self.dateRule = dateRule
        self.regionalDates = regionalDates; self.teaser = teaser; self.sections = sections
        self.sources = sources; self.license = license; self.version = version; self.reviewStatus = reviewStatus
    }
}

public enum ContentState: String, Sendable, Hashable { case locked, unlocked, past }

public struct ContentOccurrence: Sendable, Hashable {
    public var regionID: String?
    public var regionLabel: String?
    public var unlockDate: LocalDate
    public init(regionID: String?, regionLabel: String?, unlockDate: LocalDate) {
        self.regionID = regionID; self.regionLabel = regionLabel; self.unlockDate = unlockDate
    }
}

public struct ContentStateInfo: Sendable, Hashable {
    public var state: ContentState
    public var anchor: LocalDate
    public var nextUnlock: LocalDate?
    public var daysUntil: Int?
    public var isToday: Bool
}

public struct ContentResolution: Sendable, Hashable, Identifiable {
    public var id: String { item.id }
    public var item: ContentItem
    /// regionID -> 已解析的解锁日期（按时间升序；无 regionalDates 时 key = ""）
    public var unlocks: [String: [LocalDate]]
    public var regions: [RegionalDate]

    public func stateInfo(regionID: String?, now: LocalDate) -> ContentStateInfo? {
        let key = regionID ?? regions.first?.id ?? ""
        guard let dates = unlocks[key], !dates.isEmpty else { return nil }
        return ContentResolver.stateInfo(dates: dates, now: now)
    }
}

public enum ContentResolver {
    /// 单次扫描窗口内所有日期，解析全部内容项的解锁日期（UTC+8 日界；不依赖 Date/时区）
    public static func resolve(
        items: [ContentItem],
        now: LocalDate,
        engine: CalendarEngine,
        pastDays: Int = 60,
        futureDays: Int = 420
    ) -> [ContentResolution] {
        let start = now.adding(days: -pastDays)
        let end = now.adding(days: futureDays)
        var days: [(date: LocalDate, lunar: LunarDate, isLastDayOfLunarMonth: Bool)] = []
        var cursor = start
        var buffer: [(LocalDate, LunarDate)] = []
        while cursor <= end {
            let lunar = engine.lunarDate(cursor)
            buffer.append((cursor, lunar))
            cursor = cursor.adding(days: 1)
        }
        for i in buffer.indices {
            let (date, lunar) = buffer[i]
            let isLast: Bool
            if i + 1 < buffer.count {
                let next = buffer[i + 1].1
                isLast = next.month != lunar.month || next.isLeapMonth != lunar.isLeapMonth
            } else {
                isLast = false
            }
            days.append((date, lunar, isLast))
        }

        return items.map { item in
            let regions = item.regionalDates ?? [RegionalDate(id: "default", label: item.title, dateRule: item.dateRule)]
            var unlocks: [String: [LocalDate]] = [:]
            for region in regions {
                let dates = days.compactMap { day -> LocalDate? in
                    matches(rule: region.dateRule, day: day, fallback: item.dateRule) ? day.date : nil
                }
                unlocks[region.id] = dates
            }
            return ContentResolution(item: item, unlocks: unlocks, regions: regions)
        }
    }

    static func matches(
        rule: DateRule,
        day: (date: LocalDate, lunar: LunarDate, isLastDayOfLunarMonth: Bool),
        fallback: DateRule
    ) -> Bool {
        switch rule {
        case let .lunar(month, dayNumber, leap, dayFallback):
            guard day.lunar.month == month else { return false }
            switch leap {
            case .nonLeap: guard !day.lunar.isLeapMonth else { return false }
            case .leapOnly: guard day.lunar.isLeapMonth else { return false }
            case .both: break
            }
            if day.lunar.day == dayNumber { return true }
            if dayNumber == 30, dayFallback == .lastDay, day.isLastDayOfLunarMonth { return true }
            return false
        case let .solar(month, dayNumber):
            return day.date.month == month && day.date.day == dayNumber
        case let .solarTerm(term):
            return day.lunar.jieQi == term
        case let .lastDayOfLunarMonth(month):
            return day.lunar.month == month && day.isLastDayOfLunarMonth
        }
    }

    public static func stateInfo(dates: [LocalDate], now: LocalDate) -> ContentStateInfo? {
        guard !dates.isEmpty else { return nil }
        let sorted = dates.sorted()
        if sorted.contains(now) {
            return ContentStateInfo(state: .unlocked, anchor: now, nextUnlock: sorted.first(where: { $0 > now }), daysUntil: 0, isToday: true)
        }
        if let last = sorted.last(where: { $0 < now }), now.daysBetween(last) >= -30 {
            return ContentStateInfo(state: .past, anchor: last, nextUnlock: sorted.first(where: { $0 > now }), daysUntil: nil, isToday: false)
        }
        let next = sorted.first(where: { $0 > now })
        if let next {
            return ContentStateInfo(state: .locked, anchor: next, nextUnlock: next, daysUntil: now.daysBetween(next), isToday: false)
        }
        if let last = sorted.last {
            return ContentStateInfo(state: .past, anchor: last, nextUnlock: nil, daysUntil: nil, isToday: false)
        }
        return nil
    }
}
