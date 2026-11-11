import Foundation

public enum AnniversaryCalendar: String, Codable, Sendable, CaseIterable { case gregorian, lunar }
public enum AnniversaryRepeat: String, Codable, Sendable, CaseIterable { case once, yearly }
/// 2/29 平年提醒策略（仅提醒日不同；闰年仍 2/29）
public enum Feb29Policy: String, Codable, Sendable, CaseIterable { case feb28, mar01, skip }

public struct Anniversary: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var title: String
    public var calendar: AnniversaryCalendar
    public var month: Int
    public var day: Int
    public var isLeapMonth: Bool          // 仅农历
    public var repeatRule: AnniversaryRepeat
    public var feb29Policy: Feb29Policy
    public var reminderEnabled: Bool
    public var reminderHour: Int
    public var reminderMinute: Int
    public var note: String
    public var createdAt: Date

    public init(id: UUID = UUID(), title: String, calendar: AnniversaryCalendar = .gregorian,
                month: Int, day: Int, isLeapMonth: Bool = false,
                repeatRule: AnniversaryRepeat = .yearly, feb29Policy: Feb29Policy = .feb28,
                reminderEnabled: Bool = false, reminderHour: Int = 9, reminderMinute: Int = 0,
                note: String = "", createdAt: Date = Date()) {
        self.id = id; self.title = title; self.calendar = calendar
        self.month = month; self.day = day; self.isLeapMonth = isLeapMonth
        self.repeatRule = repeatRule; self.feb29Policy = feb29Policy
        self.reminderEnabled = reminderEnabled
        self.reminderHour = reminderHour; self.reminderMinute = reminderMinute
        self.note = note; self.createdAt = createdAt
    }
}

public struct AnniversaryOccurrence: Hashable, Sendable {
    public var date: LocalDate
    public var daysFromNow: Int          // 正=还有 N 天；负=已过 N 天；0=今天
    public var isToday: Bool { daysFromNow == 0 }
}

public enum AnniversaryResolver {
    /// 下次发生（UTC+8 日期）：一次性=固定日期；每年重复=未来最近一次（今天也算）；2/29 按策略处理
    public static func occurrence(for item: Anniversary, now: LocalDate, engine: CalendarEngine) -> AnniversaryOccurrence? {
        if item.repeatRule == .once {
            guard let date = resolveOnce(item, engine: engine) else { return nil }
            return AnniversaryOccurrence(date: date, daysFromNow: now.daysBetween(date))
        }
        guard let date = nextYearly(item, now: now, engine: engine) else { return nil }
        return AnniversaryOccurrence(date: date, daysFromNow: now.daysBetween(date))
    }

    static func resolveOnce(_ item: Anniversary, engine: CalendarEngine) -> LocalDate? {
        if item.calendar == .gregorian {
            if item.month == 2, item.day == 29, !isLeapYear(item.month >= 1 ? item.createdAtYear : item.createdAtYear) {
                return nil
            }
            return LocalDate(item.createdAtYear, item.month, item.day)
        }
        // 农历一次性：从创建年附近解析
        return nextLunar(item, from: LocalDate(item.createdAtYear - 1, 1, 1), engine: engine)
    }

    static func nextYearly(_ item: Anniversary, now: LocalDate, engine: CalendarEngine) -> LocalDate? {
        if item.calendar == .gregorian {
            var year = now.year
            for _ in 0..<3 {
                if let date = gregorianDate(item, year: year), date >= now { return date }
                year += 1
            }
            return gregorianDate(item, year: now.year + 1)
        }
        // 农历：从今天起向后扫描 400 天（含今天）
        var cursor = now
        for _ in 0..<400 {
            let lunar = engine.lunarDate(cursor, hour: 12)
            if lunar.month == item.month, lunar.day == item.day, lunar.isLeapMonth == item.isLeapMonth {
                return cursor
            }
            cursor = cursor.adding(days: 1)
        }
        return nil
    }

    static func gregorianDate(_ item: Anniversary, year: Int) -> LocalDate? {
        if item.month == 2, item.day == 29, !isLeapYear(year) {
            switch item.feb29Policy {
            case .feb28: return LocalDate(year, 2, 28)
            case .mar01: return LocalDate(year, 3, 1)
            case .skip: return nil
            }
        }
        return LocalDate(year, item.month, item.day)
    }

    static func nextLunar(_ item: Anniversary, from start: LocalDate, engine: CalendarEngine) -> LocalDate? {
        var cursor = start
        for _ in 0..<800 {
            let lunar = engine.lunarDate(cursor, hour: 12)
            if lunar.month == item.month, lunar.day == item.day, lunar.isLeapMonth == item.isLeapMonth {
                return cursor
            }
            cursor = cursor.adding(days: 1)
        }
        return nil
    }

    static func isLeapYear(_ year: Int) -> Bool {
        (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
    }
}

extension Anniversary {
    var createdAtYear: Int { BeijingTime.calendar.component(.year, from: createdAt) }
}
