import Foundation
import Combine
import LixiangCalendarCore

/// R14 数据层：所选日唯一来源；改日整组重算（黄历/时辰/岁时/罗盘方向），不缓存旧值。
@MainActor
final class SelectedDayStore: ObservableObject {
    @Published private(set) var selectedDate: LocalDate
    @Published private(set) var almanac: AlmanacDay
    @Published private(set) var festivals: [String]
    @Published private(set) var hourIndex: Int?

    let engine: any CalendarEngine
    let today: LocalDate
    private let hourProvider: () -> Int

    init(engine: any CalendarEngine = LunarSwiftEngine(festivalScope: .cn),
         today: LocalDate = .beijingToday(),
         hourProvider: @escaping () -> Int = { BeijingTime.hour(of: Date()) }) {
        self.engine = engine
        self.today = today
        self.hourProvider = hourProvider
        self.selectedDate = today
        let a = engine.almanac(today, hour: hourProvider())
        self.almanac = a
        self.festivals = a.festivals
        self.hourIndex = a.currentHourIndex
    }

    /// 整组重算：一次 set 会更新 almanac/festivals/hourIndex；页面不得只改标题。
    func select(_ date: LocalDate) {
        let hour = hourProvider()
        let a = engine.almanac(date, hour: hour)
        selectedDate = date
        almanac = a
        festivals = a.festivals
        hourIndex = a.currentHourIndex
    }

    func selectToday() { select(today) }
    func nextDay() { select(selectedDate.adding(days: 1)) }
    func previousDay() { select(selectedDate.adding(days: -1)) }

    var lunar: LunarDate { almanac.lunar }
    var shichen: [LunarHour] { almanac.hours }
    var positions: DeityDirections? { almanac.positions }
    var sha: CompassDirection? { almanac.sha }
    /// 岁时按所选日严格匹配；无命中返回空（UI 隐藏，不留占位）
    var matchedFestivals: [String] { festivals }

    func compassHours() -> [LunarHour] { almanac.hours }
    func compassPositions(hour: Int?) -> DeityDirections? {
        guard let hour, let idx = almanac.hours.firstIndex(where: { h in
            Self.minutes(h.startMinute) <= hour * 60 && hour * 60 <= Self.minutes(h.endMinute)
        }) else { return almanac.positions }
        _ = idx
        return almanac.positions // 方位数据为日级；逐时煞/冲在 almanac.sha 上另行展示
    }
    private static func minutes(_ hm: String) -> Int {
        let p = hm.split(separator: ":").compactMap { Int($0) }
        return p.count == 2 ? p[0] * 60 + p[1] : 0
    }
}

extension LocalDate {
    /// 北京日期（UTC+8）的今天；不依赖设备时区，避免跨时区偏差测试
    static func beijingToday(now: Date = Date()) -> LocalDate {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "Asia/Shanghai") ?? .current
        let c = cal.dateComponents([.year, .month, .day], from: now)
        return LocalDate(c.year ?? 1970, c.month ?? 1, c.day ?? 1)
    }
}
