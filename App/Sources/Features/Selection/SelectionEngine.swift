import Foundation
import LixiangCalendarCore

enum SelectionMatter: String, CaseIterable, Identifiable, Sendable {
    case travel = "出行", marriage = "嫁娶", moving = "入宅", opening = "开市"
    var id: String { rawValue }
    /// 宜忌条目里可能出现的同义/组合词
    var aliases: [String] {
        switch self {
        case .travel: return ["出行", "会友", "赴任"]
        case .marriage: return ["嫁娶", "订盟", "纳采"]
        case .moving: return ["入宅", "移徙", "安床"]
        case .opening: return ["开市", "交易", "立券"]
        }
    }
}

struct SelectionPreferences: Equatable {
    var matter: SelectionMatter = .travel
    var start: LocalDate
    var end: LocalDate
    var weekendOnly = false
    var avoidAnniversaries = false
    /// 原型固定 3 日候选池不是真算法；正式实现按日期范围逐日筛选，最多 366 天。
    static let maxSpanDays = 366
}

struct SelectionResult: Identifiable, Equatable {
    var id: String { date.iso }
    let date: LocalDate
    let almanac: AlmanacDay

    var yi: [String] { almanac.yi }
    var ji: [String] { almanac.ji }
}

struct SelectionEngine {
    let calendar: CalendarEngine
    let anniversaries: [Anniversary]

    init(calendar: CalendarEngine = LunarSwiftEngine(), anniversaries: [Anniversary] = []) {
        self.calendar = calendar
        self.anniversaries = anniversaries
    }

    func candidates(_ prefs: SelectionPreferences) -> [SelectionResult] {
        guard prefs.start <= prefs.end else { return [] }
        var day = prefs.start
        var out: [SelectionResult] = []
        var steps = 0
        while day <= prefs.end && steps < SelectionPreferences.maxSpanDays {
            steps += 1
            defer { day = day.adding(days: 1) }
            if prefs.weekendOnly, !(day.weekdayIndex == 0 || day.weekdayIndex == 6) { continue }
            if prefs.avoidAnniversaries, anniversaryHits(day) { continue }
            let a = calendar.almanac(day, hour: 12)
            if isAuspicious(a, for: prefs.matter) { out.append(SelectionResult(date: day, almanac: a)) }
        }
        return out
    }

    func isAuspicious(_ day: AlmanacDay, for matter: SelectionMatter) -> Bool {
        func hit(_ list: [String]) -> Bool {
            list.contains { item in matter.aliases.contains { item.contains($0) } }
        }
        if hit(day.ji) { return false }
        return hit(day.yi)
    }

    func anniversaryHits(_ day: LocalDate) -> Bool {
        anniversaries.contains { item in
            switch item.calendar {
            case .gregorian:
                return item.month == day.month && item.day == day.day
            case .lunar:
                let lunar = calendar.lunarDate(day)
                return item.month == lunar.month && item.day == lunar.day && !lunar.isLeapMonth
            }
        }
    }
}
