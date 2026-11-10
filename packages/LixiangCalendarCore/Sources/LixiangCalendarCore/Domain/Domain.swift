import Foundation

/// 支持区间（FRD v1.1 / Lead 2026-11-11）：1900-01-01 … 2100-12-31
public enum SupportRange {
    public static let firstYear = 1900
    public static let lastYear = 2100
    public static func contains(_ d: LocalDate) -> Bool {
        (firstYear...lastYear).contains(d.year)
    }
}

/// UTC+8 统一时间（FRD v1.1：历法/节气/时辰/解锁判定一律按 UTC+8）
public enum BeijingTime {
    public static let timeZone = TimeZone(secondsFromGMT: 8 * 3600)!
    public static let calendar: Calendar = {
        var c = Calendar(identifier: .gregorian)
        c.timeZone = timeZone
        c.locale = Locale(identifier: "en_US_POSIX")
        return c
    }()
    public static func date(from d: LocalDate, hour: Int = 12) -> Date {
        var c = DateComponents(); c.year = d.year; c.month = d.month; c.day = d.day
        c.hour = hour; c.minute = 0; c.second = 0
        return calendar.date(from: c)!
    }
    public static func localDate(from date: Date) -> LocalDate {
        let c = calendar.dateComponents([.year, .month, .day], from: date)
        return LocalDate(c.year!, c.month!, c.day!)
    }
    public static func now() -> Date { Date() }
    public static func today() -> LocalDate { localDate(from: Date()) }
    public static func hour(of date: Date) -> Int { calendar.component(.hour, from: date) }
}

public struct LocalDate: Hashable, Comparable, Codable, Sendable, CustomStringConvertible {
    public var year: Int
    public var month: Int
    public var day: Int

    public init(_ year: Int, _ month: Int, _ day: Int) {
        self.year = year; self.month = month; self.day = day
    }

    public init?(_ iso: String) {
        let parts = iso.split(separator: "-").compactMap { Int($0) }
        guard parts.count == 3 else { return nil }
        self.init(parts[0], parts[1], parts[2])
    }

    public var iso: String { String(format: "%04d-%02d-%02d", year, month, day) }
    public var description: String { iso }
    public var isSupported: Bool { SupportRange.contains(self) }

    public static func < (lhs: LocalDate, rhs: LocalDate) -> Bool {
        (lhs.year, lhs.month, lhs.day) < (rhs.year, rhs.month, rhs.day)
    }

    public func adding(days: Int) -> LocalDate {
        let date = BeijingTime.date(from: self, hour: 12)
        let next = BeijingTime.calendar.date(byAdding: .day, value: days, to: date)!
        return BeijingTime.localDate(from: next)
    }

    /// 0 = 周日 … 6 = 周六（UTC+8）
    public var weekdayIndex: Int {
        let date = BeijingTime.date(from: self, hour: 12)
        return BeijingTime.calendar.component(.weekday, from: date) - 1
    }

    public var weekdayChinese: String {
        ["日", "一", "二", "三", "四", "五", "六"][weekdayIndex]
    }

    public func daysBetween(_ other: LocalDate) -> Int {
        let a = BeijingTime.date(from: self, hour: 12)
        let b = BeijingTime.date(from: other, hour: 12)
        return BeijingTime.calendar.dateComponents([.day], from: a, to: b).day ?? 0
    }
}

public enum WeekStart: Int, CaseIterable, Codable, Sendable {
    case sunday = 0
    case monday = 1
    public var displayName: String { self == .sunday ? "周日" : "周一" }
    public var identifiers: [String] { self == .monday ? ["一","二","三","四","五","六","日"] : ["日","一","二","三","四","五","六"] }
}

public struct LunarDate: Hashable, Codable, Sendable {
    public var year: Int
    public var month: Int
    public var day: Int
    public var isLeapMonth: Bool
    public var yearInChinese: String
    public var monthInChinese: String
    public var dayInChinese: String
    public var yearGanZhi: String
    public var monthGanZhi: String
    public var dayGanZhi: String
    public var shengXiao: String
    public var jieQi: String?

    public var monthDayText: String {
        isLeapMonth ? "闰\(monthInChinese)月\(dayInChinese)" : "\(monthInChinese)月\(dayInChinese)"
    }
    public var fullText: String { "\(yearInChinese)年\(monthDayText)" }
}

public enum CompassDirection: String, CaseIterable, Codable, Sendable {
    case north = "正北", northeast = "东北", east = "正东", southeast = "东南"
    case south = "正南", southwest = "西南", west = "正西", northwest = "西北"

    /// 顺时针角度：北 0°，东北 45° …
    public var angleDegrees: Double {
        switch self {
        case .north: return 0
        case .northeast: return 45
        case .east: return 90
        case .southeast: return 135
        case .south: return 180
        case .southwest: return 225
        case .west: return 270
        case .northwest: return 315
        }
    }

    /// 兼容库返回的「北/南/东/西」（煞方只返回四正短名）
    public init?(loose value: String) {
        if let d = CompassDirection(rawValue: value) { self = d; return }
        switch value {
        case "北": self = .north
        case "东北": self = .northeast
        case "东": self = .east
        case "东南": self = .southeast
        case "南": self = .south
        case "西南": self = .southwest
        case "西": self = .west
        case "西北": self = .northwest
        default: return nil
        }
    }
}

public struct DeityDirections: Hashable, Codable, Sendable {
    public var xi: CompassDirection
    public var fu: CompassDirection
    public var cai: CompassDirection
    public var yangGui: CompassDirection
    public var yinGui: CompassDirection
}

public struct LunarHour: Hashable, Codable, Sendable {
    public var index: Int
    public var ganZhi: String
    public var startMinute: String
    public var endMinute: String
    public var yi: [String]
    public var ji: [String]
    public var tianShen: String
    public var luck: String
    public var chongDesc: String
    public var sha: CompassDirection?
    public var isEarlyZi: Bool { index == 0 }
    public var isLateZi: Bool { index == 12 }
}

public struct AlmanacDay: Hashable, Codable, Sendable {
    public var date: LocalDate
    public var lunar: LunarDate
    public var solarTerm: String?
    public var festivals: [String]
    public var yi: [String]
    public var ji: [String]
    public var chongDesc: String
    public var sha: CompassDirection?
    public var jiShen: [String]
    public var xiongSha: [String]
    public var positions: DeityDirections
    public var taiShen: String
    public var pengZuGan: String
    public var pengZuZhi: String
    public var xiu: String
    public var zhiXing: String
    public var tianShen: String
    public var tianShenType: String
    public var dayNaYin: String
    public var wuXing: String
    public var hours: [LunarHour]
    public var currentHourIndex: Int?
}
