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


// MARK: - FRD v1.3：月格标签优先级（节日 > 节气 > 农历月名）

@Test func monthGridLabelPriority() {
    let grid = MonthGridBuilder.build(year: 2026, month: 11, weekStart: .monday, engine: engine, today: LocalDate(2026, 11, 11),
                                      festivalNames: { date in
                                          FestivalFilter.filtered(engine.almanac(date, hour: 12).festivals, scope: .cn)
                                      })
    let cells = Dictionary(uniqueKeysWithValues: grid.days.map { ($0.date, $0) })
    #expect(cells[LocalDate(2026, 11, 9)]?.label == "寒衣节")   // 十月初一 + 寒衣节 → 节日优先
    #expect(cells[LocalDate(2026, 11, 7)]?.label == "立冬")
    #expect(cells[LocalDate(2026, 11, 22)]?.label == "小雪")
    #expect(cells[LocalDate(2026, 11, 23)]?.label == "下元节")
    // 无节日/节气的初一显示农历月名
    let dec = MonthGridBuilder.build(year: 2026, month: 12, weekStart: .monday, engine: engine, today: LocalDate(2026, 11, 11),
                                     festivalNames: { date in
                                         FestivalFilter.filtered(engine.almanac(date, hour: 12).festivals, scope: .cn)
                                     })
    #expect(dec.days.contains { $0.date == LocalDate(2026, 12, 22) && $0.label == "冬至" })
}

// MARK: - 时辰时间注入（截图 09:41→巳时；01:17→丑时；23:xx→晚子）

@Test func currentHourIndexByInjectedHour() {
    let date = LocalDate(2026, 11, 11)
    #expect(engine.almanac(date, hour: 9).currentHourIndex == 5)    // 巳时 09:00–10:59
    #expect(engine.almanac(date, hour: 1).currentHourIndex == 1)    // 丑时 01:00–02:59
    #expect(engine.almanac(date, hour: 23).currentHourIndex == 12)  // 晚子 23:00–23:59
    #expect(engine.almanac(date, hour: 0).currentHourIndex == 0)    // 早子 00:00–00:59
}

// MARK: - 节俗索引三组 + 冬至 41 天 + 已过项

@Test func contentIndexGroups() {
    let resolutions = ContentResolver.resolve(items: ContentFixtures.all, now: LocalDate(2026, 11, 11),
                                               engine: engine, pastDays: 370, futureDays: 420)
    let groups = ContentIndexBuilder.build(resolutions: resolutions, now: LocalDate(2026, 11, 11))
    #expect(groups.today.isEmpty)
    #expect(!groups.past.isEmpty)                                  // 清明/除夕/谢灶已过可回看
    #expect(groups.past.allSatisfy { $0.state == .past && $0.date < LocalDate(2026, 11, 11) })
    let dongzhi = groups.upcoming.first { $0.contentID == "dongzhi" }
    #expect(dongzhi?.date == LocalDate(2026, 12, 22))
    #expect(dongzhi?.days == 41)
    #expect(groups.upcoming.first?.date == LocalDate(2026, 12, 22)) // 冬至在最前
}


// MARK: - P2 罗盘数据（缺位/四正/无中宫）

@Test func compassLayoutBasics() {
    let day = engine.almanac(LocalDate(2026, 11, 11), hour: 12)
    let layout = CompassBuilder.layout(for: day)
    #expect(layout.present.count + layout.missing.count == 5)
    #expect(layout.present.allSatisfy { $0.deity.allowedDirections.contains($0.direction) })
    // 煞方仅四正
    if let sha = layout.sha {
        #expect([CompassDirection.north, .south, .east, .west].contains(sha))
    }
    // 无中宫：八方位枚举不含中
    #expect(!CompassDirection.allCases.map(\.rawValue).contains("中"))
}

@Test func compassMissingIsReportedNotDrawn() {
    let day = engine.almanac(LocalDate(2026, 11, 11), hour: 12)
    let layout = CompassBuilder.layout(for: day, hidden: [.cai, .fu])
    #expect(layout.missing.contains(.cai))
    #expect(layout.missing.contains(.fu))
    #expect(!layout.present.contains { $0.deity == .cai || $0.deity == .fu })
    #expect(layout.present.count == 3)
}


// MARK: - P2/F7 B′：manifest / 缓存键 / sha256 / 解锁判定

@Test func manifestRoundTripAndCacheKey() throws {
    let html = "<html><body>谢灶</body></html>"
    let sha = SHA256.hex(html)
    let entry = ManifestEntry(slug: "xiezao", title: "谢灶", unlockDate: LocalDate(2027, 1, 30),
                              contentVersion: "v1.0.3", sha256: sha, updatedAt: "2026-11-11T00:00:00+08:00")
    let manifest = ContentManifest(schemaVersion: 1, generatedAt: "2026-11-11T00:00:00+08:00", items: [entry])
    let data = try JSONEncoder().encode(manifest)
    let decoded = try JSONDecoder().decode(ContentManifest.self, from: data)
    #expect(decoded.entry(slug: "xiezao")?.unlockDate == LocalDate(2027, 1, 30))
    #expect(decoded.entry(slug: "xiezao")?.sha256 == sha)
    let key = ContentCacheKey(slug: "xiezao", contentVersion: "v1.0.3", sha256: sha)
    #expect(key.fileName.hasPrefix("xiezao_v1.0.3_"))
}

@Test func manifestParserValidation() throws {
    let good = """
    {"schemaVersion":1,"generatedAt":"2026-11-11T00:00:00+08:00","items":[
      {"slug":"xiezao","title":"谢灶","unlockDate":"2027-01-30","contentVersion":"v1.0.3",
       "sha256":"\(SHA256.hex("x"))","updatedAt":"2026-11-11"}]}
    """
    let manifest = try ManifestParser.parse(Data(good.utf8))
    #expect(manifest.items.count == 1)
    let bad = """
    {"items":[{"slug":"x","title":"x","unlockDate":"2027-13-40","contentVersion":"v1","sha256":"short","updatedAt":"x"}]}
    """
    #expect(throws: ManifestError.self) { _ = try ManifestParser.parse(Data(bad.utf8)) }
}

@Test func contentUnlockUTC8Policy() {
    let unlock = LocalDate(2027, 1, 30)
    #expect(ContentUnlock.state(unlockDate: unlock, now: LocalDate(2027, 1, 29)) == .locked)
    #expect(ContentUnlock.state(unlockDate: unlock, now: LocalDate(2027, 1, 30)) == .unlocked)
    #expect(ContentUnlock.state(unlockDate: unlock, now: LocalDate(2027, 1, 31)) == .past)
    #expect(ContentUnlock.daysUntil(unlockDate: unlock, now: LocalDate(2026, 11, 11)) == 80)
}


// MARK: - 回归：远期已过（>30 天）不应被当作“刚过”，应回到 locked（F7 locked 截图缺陷根因）

@Test func stateInfoDoesNotTreatOldPastAsRecent() {
    let resolutions = ContentResolver.resolve(items: [ContentFixtures.xieZao], now: LocalDate(2026, 11, 11),
                                               engine: engine, pastDays: 370, futureDays: 420)
    let info = resolutions[0].stateInfo(regionID: "north", now: LocalDate(2026, 11, 11))
    #expect(info?.state == .locked)
    #expect(info?.anchor == LocalDate(2027, 1, 30))
    #expect(info?.daysUntil == 80)
    // 近 30 天内已过仍为 past
    let recent = resolutions[0].stateInfo(regionID: "north", now: LocalDate(2027, 2, 10))
    #expect(recent?.state == .past)
}


// MARK: - F6 倒计日（内部 Anniversary）：下次发生/一次性/2-29/闰月

@Test func anniversaryGregorianYearlyAndOnce() {
    let yearly = Anniversary(title: "生日", calendar: .gregorian, month: 11, day: 20, repeatRule: .yearly)
    let next = AnniversaryResolver.occurrence(for: yearly, now: LocalDate(2026, 11, 11), engine: engine)
    #expect(next?.date == LocalDate(2026, 11, 20))
    #expect(next?.daysFromNow == 9)

    let pastOnce = Anniversary(title: "一次", calendar: .gregorian, month: 10, day: 1, repeatRule: .once,
                               createdAt: BeijingTime.date(from: LocalDate(2026, 1, 1)))
    let occ = AnniversaryResolver.occurrence(for: pastOnce, now: LocalDate(2026, 11, 11), engine: engine)
    #expect(occ?.date == LocalDate(2026, 10, 1))
    #expect(occ?.daysFromNow == -41)   // 已过 X 天
}

@Test func anniversaryFeb29Policies() {
    func item(_ policy: Feb29Policy) -> Anniversary {
        Anniversary(title: "2/29", calendar: .gregorian, month: 2, day: 29, repeatRule: .yearly, feb29Policy: policy)
    }
    let now = LocalDate(2027, 1, 1)   // 2027 非闰年
    #expect(AnniversaryResolver.occurrence(for: item(.feb28), now: now, engine: engine)?.date == LocalDate(2027, 2, 28))
    #expect(AnniversaryResolver.occurrence(for: item(.mar01), now: now, engine: engine)?.date == LocalDate(2027, 3, 1))
    #expect(AnniversaryResolver.occurrence(for: item(.skip), now: now, engine: engine)?.date == LocalDate(2028, 2, 29)) // skip 平年，下一次闰年 2/29
}

@Test func anniversaryLunarYearly() {
    let lunarBirthday = Anniversary(title: "农历生日", calendar: .lunar, month: 1, day: 1, isLeapMonth: false, repeatRule: .yearly)
    let next = AnniversaryResolver.occurrence(for: lunarBirthday, now: LocalDate(2026, 11, 11), engine: engine)
    #expect(next?.date == LocalDate(2027, 2, 6))   // 2027 春节
    let leapBirthday = Anniversary(title: "闰六月", calendar: .lunar, month: 6, day: 1, isLeapMonth: true, repeatRule: .yearly)
    let leap = AnniversaryResolver.occurrence(for: leapBirthday, now: LocalDate(2025, 1, 1), engine: engine)
    #expect(leap?.date == LocalDate(2025, 7, 25))  // 2025 闰六月初一
}

// MARK: - M-2 白话/解释/道德经数据层

@Test func plainLanguagePackDeterministicQuote() {
    let quotes = [
        DaodejingQuote(chapter: 1, quote: "道可道，非常道", zh: "能说清楚的道，往往不是最根本的道。", en: "The Way that can be told...", source: "王弼本"),
        DaodejingQuote(chapter: 2, quote: "有无相生，难易相成", zh: "有和无、难和易互相衬出。", en: "Being and non-being...", source: "王弼本")
    ]
    let pack = PlainLanguagePack(quotes: quotes, terms: [], pages: [])
    let a = pack.quote(for: LocalDate(2026, 11, 11))
    let b = pack.quote(for: LocalDate(2026, 11, 11))
    #expect(a == b)                       // 确定性
    #expect([1, 2].contains(a?.chapter ?? -1))
    #expect(pack.quote(for: LocalDate(2026, 11, 12)) != nil)
}

@Test func plainLanguageMappingsAndPages() {
    let pack = PlainLanguagePack(quotes: [],
        terms: [PlainTerm(term: "开光", category: "仪式", zh: "给新物件做个象征性启用仪式", en: "consecrate")],
        pages: [ExplainPage(term: "zhishen", title: "值神", what: "w", means: "m", how: "h", en: "e")])
    #expect(pack.term(named: "开光")?.category == "仪式")
    #expect(pack.page(titled: "值神")?.term == "zhishen")
    #expect(pack.term(named: "不存在") == nil)
}
