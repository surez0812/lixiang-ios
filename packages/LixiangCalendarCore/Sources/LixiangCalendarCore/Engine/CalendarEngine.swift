import Foundation
import LunarSwift

public protocol CalendarEngine: Sendable {
    func lunarDate(_ date: LocalDate, hour: Int) -> LunarDate
    func almanac(_ date: LocalDate, hour: Int) -> AlmanacDay
    var festivalScope: FestivalScope { get }
}

public extension CalendarEngine {
    func lunarDate(_ date: LocalDate) -> LunarDate { lunarDate(date, hour: 12) }
}

public struct LunarSwiftEngine: CalendarEngine {
    public let festivalScope: FestivalScope
    public init(festivalScope: FestivalScope = .cn) { self.festivalScope = festivalScope }

    private func makeSolar(_ d: LocalDate, hour: Int) -> Solar {
        Solar.fromYmdHms(year: d.year, month: d.month, day: d.day, hour: hour, minute: 0, second: 0)
    }

    public func lunarDate(_ date: LocalDate, hour: Int = 12) -> LunarDate {
        let l = makeSolar(date, hour: hour).lunar
        return LunarDate(
            year: l.year,
            month: abs(l.month),
            day: l.day,
            isLeapMonth: l.month < 0,
            yearInChinese: l.yearInChinese,
            monthInChinese: l.monthInChinese,
            dayInChinese: l.dayInChinese,
            yearGanZhi: l.yearInGanZhi,
            monthGanZhi: l.monthInGanZhi,
            dayGanZhi: l.dayInGanZhi,
            shengXiao: l.yearShengXiao,
            jieQi: l.jieQi.isEmpty ? nil : l.jieQi
        )
    }

    public func almanac(_ date: LocalDate, hour: Int = 12) -> AlmanacDay {
        let solar = makeSolar(date, hour: hour)
        let l = solar.lunar
        let festivals = FestivalFilter.filtered(l.festivals + l.otherFestivals + solar.festivals, scope: festivalScope)
        let positions = DeityDirections(
            xi: CompassDirection(loose: l.dayPositionXiDesc) ?? .north,
            fu: CompassDirection(loose: l.dayPositionFuDesc) ?? .north,
            cai: CompassDirection(loose: l.dayPositionCaiDesc) ?? .north,
            yangGui: CompassDirection(loose: l.dayPositionYangGuiDesc) ?? .north,
            yinGui: CompassDirection(loose: l.dayPositionYinGuiDesc) ?? .north
        )
        let hours: [LunarHour] = l.times.enumerated().map { index, t in
            LunarHour(
                index: index,
                ganZhi: t.ganZhi,
                startMinute: t.minHm,
                endMinute: t.maxHm,
                yi: t.yi,
                ji: t.ji,
                tianShen: t.tianShen,
                luck: t.tianShenLuck,
                chongDesc: t.chongDesc,
                sha: CompassDirection(loose: t.sha)
            )
        }
        return AlmanacDay(
            date: date,
            lunar: LunarDate(
                year: l.year, month: abs(l.month), day: l.day, isLeapMonth: l.month < 0,
                yearInChinese: l.yearInChinese, monthInChinese: l.monthInChinese, dayInChinese: l.dayInChinese,
                yearGanZhi: l.yearInGanZhi, monthGanZhi: l.monthInGanZhi, dayGanZhi: l.dayInGanZhi,
                shengXiao: l.yearShengXiao, jieQi: l.jieQi.isEmpty ? nil : l.jieQi
            ),
            solarTerm: l.jieQi.isEmpty ? nil : l.jieQi,
            festivals: festivals,
            yi: l.dayYi,
            ji: l.dayJi,
            chongDesc: l.dayChongDesc,
            sha: CompassDirection(loose: l.daySha),
            jiShen: l.dayJiShen,
            xiongSha: l.dayXiongSha,
            positions: positions,
            taiShen: l.dayPositionTai,
            pengZuGan: l.pengZuGan,
            pengZuZhi: l.pengZuZhi,
            xiu: l.xiu,
            zhiXing: l.zhiXing,
            tianShen: l.dayTianShen,
            tianShenType: l.dayTianShenType,
            dayNaYin: l.dayNaYin,
            wuXing: l.eightChar.dayWuXing,
            hours: hours,
            currentHourIndex: Self.hourIndex(for: hour, hours: hours)
        )
    }

    /// 当前时刻落在哪个时辰（12 时段），23 点归晚子（index 12）
    public static func hourIndex(for hour: Int, hours: [LunarHour]) -> Int? {
        guard !hours.isEmpty else { return nil }
        if hour == 23 { return hours.count - 1 }
        return hours.firstIndex { h in
            Self.minutes(h.startMinute) <= hour * 60 && hour * 60 <= Self.minutes(h.endMinute)
        }
    }

    static func minutes(_ hm: String) -> Int {
        let parts = hm.split(separator: ":").compactMap { Int($0) }
        guard parts.count == 2 else { return 0 }
        return parts[0] * 60 + parts[1]
    }
}
