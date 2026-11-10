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
