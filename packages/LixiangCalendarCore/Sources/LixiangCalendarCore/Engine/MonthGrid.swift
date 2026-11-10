import Foundation

public struct GridDay: Hashable, Sendable {
    public var date: LocalDate
    public var lunar: LunarDate
    public var isToday: Bool
    public var inCurrentMonth: Bool
    /// 月格第二行：初一显示月名（如「十月」），其余显示日（如「初三」）
    public var lunarLabel: String
    public var marker: DayMarker?
}

public struct DayMarker: Hashable, Sendable {
    public enum Kind: Hashable, Sendable { case solarTerm, festival, internationalFestival }
    public var kind: Kind
    public var name: String
}

public struct MonthGrid: Hashable, Sendable {
    public var year: Int
    public var month: Int
    public var days: [GridDay]     // 恒 42 格
    public var leadingBlanks: Int
}

public enum MonthGridBuilder {
    public static func build(
        year: Int,
        month: Int,
        weekStart: WeekStart,
        engine: CalendarEngine,
        today: LocalDate,
        festivalNames: (LocalDate) -> [String] = { _ in [] }
    ) -> MonthGrid {
        var first = DateComponents(); first.year = year; first.month = month; first.day = 1
        guard let firstDate = BeijingTime.calendar.date(from: first) else {
            return MonthGrid(year: year, month: month, days: [], leadingBlanks: 0)
        }
        let firstWeekday = BeijingTime.calendar.component(.weekday, from: firstDate) - 1
        let blanks = (firstWeekday - weekStart.rawValue + 7) % 7
        let startDate = BeijingTime.calendar.date(byAdding: .day, value: -blanks, to: firstDate)!
        let daysInMonth = BeijingTime.calendar.range(of: .day, in: .month, for: firstDate)?.count ?? 30

        var cells: [GridDay] = []
        cells.reserveCapacity(42)
        for i in 0..<42 {
            let date = BeijingTime.calendar.date(byAdding: .day, value: i, to: startDate)!
            let localDate = BeijingTime.localDate(from: date)
            let lunar = engine.lunarDate(localDate)
            let inMonth = localDate.month == month && localDate.year == year
            let label: String
            if lunar.day == 1 {
                label = lunar.isLeapMonth ? "闰\(lunar.monthInChinese)月" : "\(lunar.monthInChinese)月"
            } else {
                label = lunar.dayInChinese
            }
            var marker: DayMarker?
            if let term = lunar.jieQi {
                marker = DayMarker(kind: .solarTerm, name: term)
            } else {
                let festivals = festivalNames(localDate)
                if let f = festivals.first {
                    marker = DayMarker(kind: .festival, name: f)
                }
            }
            cells.append(GridDay(date: localDate, lunar: lunar, isToday: localDate == today,
                                 inCurrentMonth: inMonth, lunarLabel: label, marker: marker))
        }
        return MonthGrid(year: year, month: month, days: cells, leadingBlanks: blanks)
    }

    public static func daysInMonth(year: Int, month: Int) -> Int {
        var c = DateComponents(); c.year = year; c.month = month; c.day = 1
        guard let d = BeijingTime.calendar.date(from: c) else { return 30 }
        return BeijingTime.calendar.range(of: .day, in: .month, for: d)?.count ?? 30
    }
}
