import Testing
import Foundation
@testable import LixiangCalendarCore

private let engine = LunarSwiftEngine()

@Test func supportRange() {
    #expect(LocalDate(1900, 1, 1).isSupported)
    #expect(LocalDate(2100, 12, 31).isSupported)
    #expect(!LocalDate(1899, 12, 31).isSupported)
    #expect(!LocalDate(2101, 1, 1).isSupported)
}

@Test func springFestival2026() {
    let lunar = engine.lunarDate(LocalDate(2026, 2, 17))
    #expect(lunar.month == 1)
    #expect(lunar.day == 1)
    #expect(!lunar.isLeapMonth)
    #expect(lunar.yearGanZhi == "丙午")
    #expect(lunar.yearInChinese == "二〇二六")
}

@Test func qingming2026() {
    let lunar = engine.lunarDate(LocalDate(2026, 4, 5))
    #expect(lunar.jieQi == "清明")
}

@Test func leapMonth2025() {
    let lunar = engine.lunarDate(LocalDate(2025, 7, 25))
    #expect(lunar.month == 6)
    #expect(lunar.isLeapMonth)
    #expect(lunar.day == 1)
}

@Test func chuXi2027Is29thOf12thMonth() {
    let lunar = engine.lunarDate(LocalDate(2027, 2, 5))
    #expect(lunar.month == 12)
    #expect(lunar.day == 29)
}

@Test func hoursAre13WithEarlyAndLateZi() {
    let day = engine.almanac(LocalDate(2026, 11, 11), hour: 12)
    #expect(day.hours.count == 13)
    #expect(day.hours[0].startMinute == "00:00")
    #expect(day.hours[0].endMinute == "00:59")
    #expect(day.hours[12].startMinute == "23:00")
    #expect(day.hours[12].endMinute == "23:59")
    #expect(day.currentHourIndex == 6)   // 午时 11:00–12:59
    #expect(day.hours[6].ganZhi == "庚午")
}

@Test func almanacFieldsPresent() {
    let day = engine.almanac(LocalDate(2026, 11, 11), hour: 12)
    #expect(!day.yi.isEmpty)
    #expect(!day.ji.isEmpty)
    #expect(!day.chongDesc.isEmpty)
    #expect(day.jiShen.count > 0)
    #expect(!day.taiShen.isEmpty)
    #expect(!day.pengZuGan.isEmpty)
    #expect(!day.xiu.isEmpty)
    #expect(!day.zhiXing.isEmpty)
    #expect(["黄道", "黑道"].contains(day.tianShenType))
    #expect(!day.wuXing.isEmpty)
}

@Test func directionEnums() {
    #expect(CompassDirection(loose: "北") == .north)
    #expect(CompassDirection(loose: "正北") == .north)
    #expect(CompassDirection(loose: "东南") == .southeast)
    #expect(CompassDirection(loose: "西北")?.angleDegrees == 315)
}

@Test func monthGrid42Days() {
    let grid = MonthGridBuilder.build(year: 2026, month: 11, weekStart: .monday, engine: engine, today: LocalDate(2026, 11, 11))
    #expect(grid.days.count == 42)
    #expect(grid.days.contains { $0.date == LocalDate(2026, 11, 11) && $0.isToday })
    #expect(grid.days.filter { $0.inCurrentMonth }.count == 30)
    #expect(grid.days[grid.leadingBlanks].date == LocalDate(2026, 11, 1))
}

@Test func yiJiGroupingCoversAllItems() {
    let day = engine.almanac(LocalDate(2026, 11, 11), hour: 12)
    let groups = YiJiGrouping.groups(for: day.yi, kind: .yi)
    #expect(!groups.isEmpty)
    let grouped = groups.flatMap(\.items)
    #expect(Set(grouped) == Set(day.yi))
}

@Test func regionalUnlockStatesForXieZao() {
    let resolutions = ContentResolver.resolve(items: [ContentFixtures.xieZao], now: LocalDate(2026, 11, 11), engine: engine)
    let north = resolutions[0].stateInfo(regionID: "north", now: LocalDate(2027, 1, 30))
    let southSameDay = resolutions[0].stateInfo(regionID: "south", now: LocalDate(2027, 1, 30))
    let southNextDay = resolutions[0].stateInfo(regionID: "south", now: LocalDate(2027, 1, 31))
    #expect(north?.state == .unlocked)
    #expect(southSameDay?.state == .locked)
    #expect(southNextDay?.state == .unlocked)
}

@Test func contentStatesQingMing() {
    let resolutions = ContentResolver.resolve(items: [ContentFixtures.qingMing], now: LocalDate(2027, 4, 1), engine: engine)
    let before = resolutions[0].stateInfo(regionID: nil, now: LocalDate(2027, 4, 4))
    let today = resolutions[0].stateInfo(regionID: nil, now: LocalDate(2027, 4, 5))
    let past = resolutions[0].stateInfo(regionID: nil, now: LocalDate(2027, 4, 20))
    #expect(before?.state == .locked)
    #expect(today?.state == .unlocked)
    #expect(past?.state == .past)
}

@Test func chuXiUsesLastDayOfLunarMonth() {
    let resolutions = ContentResolver.resolve(items: [ContentFixtures.chuXi], now: LocalDate(2027, 1, 1), engine: engine)
    let locked = resolutions[0].stateInfo(regionID: nil, now: LocalDate(2027, 2, 4))
    let unlocked = resolutions[0].stateInfo(regionID: nil, now: LocalDate(2027, 2, 5))
    #expect(locked?.state == .locked)
    #expect(unlocked?.state == .unlocked)
}


// MARK: - FRD F1-02 / F2-03：非中国节日全过滤

@Test func nonChineseFestivalsFiltered() {
    let samples = ["2026-10-31", "2026-11-01", "2026-11-26", "2026-12-24", "2026-12-25"]
    for iso in samples {
        let date = LocalDate(iso)!
        let day = engine.almanac(date, hour: 12)
        for name in day.festivals {
            #expect(!["万圣节", "万圣节前夜", "感恩节", "平安夜", "圣诞节", "情人节"].contains(name))
        }
    }
    // 传统节日仍在：2026-11-24（下元节）标记存在
    let day = engine.almanac(LocalDate(2026, 11, 23), hour: 12)
    #expect(day.festivals.contains("下元节"))
}

@Test func festivalScopeFilterKeepsExpected() {
    let raw = ["春节", "元宵节", "清明节", "中秋节", "除夕", "万圣节", "感恩节", "圣诞节", "情人节", "元旦", "国庆节"]
    let filtered = FestivalFilter.filtered(raw, scope: .cn)
    #expect(filtered.contains("春节"))
    #expect(filtered.contains("元旦"))
    #expect(!filtered.contains("万圣节"))
    #expect(!filtered.contains("圣诞节"))
    #expect(!filtered.contains("情人节"))
}

// MARK: - 权威源 fixture：2026 年 24 节气（香港天文学会《香港天文年曆 2026》）
// 来源：handover/calendar-20261111/tech/evidence/06-solar-terms-2026-vs-HKAS.md
// 口径：日期必须一致；时刻 ≤ ±2s（库四舍五入到秒）

private let authority2026: [(String, String, Int)] = [
    ("小寒", "2026-01-05", 9), ("大寒", "2026-01-20", 56), ("立春", "2026-02-04", 8),
    ("雨水", "2026-02-18", 56), ("惊蛰", "2026-03-05", 0), ("春分", "2026-03-20", 59),
    ("清明", "2026-04-05", 0), ("谷雨", "2026-04-20", 8), ("立夏", "2026-05-05", 44),
    ("小满", "2026-05-21", 45), ("芒种", "2026-06-05", 21), ("夏至", "2026-06-21", 30),
    ("小暑", "2026-07-07", 57), ("大暑", "2026-07-23", 5), ("立秋", "2026-08-07", 43),
    ("处暑", "2026-08-23", 49), ("白露", "2026-09-07", 16), ("秋分", "2026-09-23", 14),
    ("寒露", "2026-10-08", 17), ("霜降", "2026-10-23", 57), ("立冬", "2026-11-07", 5),
    ("小雪", "2026-11-22", 21), ("大雪", "2026-12-07", 32), ("冬至", "2026-12-22", 14)
]

@Test func solarTerms2026DatesMatchAuthority() {
    var found: [String: LocalDate] = [:]
    var date = LocalDate(2026, 1, 1)
    while date.year == 2026 {
        if let term = engine.lunarDate(date).jieQi { found[term] = date }
        date = date.adding(days: 1)
    }
    for (name, iso, _) in authority2026 {
        #expect(found[name] == LocalDate(iso), "节气 \(name) 日期不一致")
    }
    #expect(found.count >= 24)
}

@Test func chineseNewYearAndEveAcrossYears() {
    let expected: [(String, String, String)] = [
        ("2026-02-17", "2026-02-16", "丙午"),  // 春节 / 除夕（腊月廿九）
        ("2027-02-06", "2027-02-05", "丁未"),
        ("2028-01-26", "2028-01-25", "戊申")
    ]
    for (cny, eve, ganzhi) in expected {
        let cnyLunar = engine.lunarDate(LocalDate(cny)!)
        let eveLunar = engine.lunarDate(LocalDate(eve)!)
        #expect(cnyLunar.month == 1 && cnyLunar.day == 1)
        #expect(cnyLunar.yearGanZhi == ganzhi)
        #expect(eveLunar.month == 12 && eveLunar.day == 29)
    }
}


@Test func yiJiDedupeRules() {
    let r = YiJiItems.dedupe(yi: ["祭祀", " 祭祀 ", "开光", "嫁娶"], ji: ["祭祀", "开光", "动土", "动土"])
    #expect(r.yi == ["祭祀", "开光", "嫁娶"])
    #expect(r.ji == ["动土"])
    #expect(r.duplicates.contains("祭祀"))
    #expect(r.duplicates.contains("开光"))
}
