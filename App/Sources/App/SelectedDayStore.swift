import Foundation
import Combine
import LixiangCalendarCore

/// 冷启动打点（DEBUG 输出 LXSTARTUP 单行），用于 iPad/Duo 首启 profile。
enum R14StartupProbe {
    private static let t0 = ProcessInfo.processInfo.systemUptime
    static func ms(_ v: Double) -> Double { (v - t0) * 1000 }
    static func log(_ stage: String, _ detail: String = "") {
        #if DEBUG
        print(String(format: "LXSTARTUP %.0fms %@ %@", ms(ProcessInfo.processInfo.systemUptime), stage, detail))
        #endif
    }
    static var elapsedMs: Double { ms(ProcessInfo.processInfo.systemUptime) }
}

/// R14 数据层：所选日唯一来源；改日整组重算（黄历/时辰/岁时/罗盘方向），不缓存旧值。
@MainActor
final class SelectedDayStore: ObservableObject {
    @Published private(set) var selectedDate: LocalDate
    @Published private(set) var festivals: [String]
    @Published private(set) var hourIndex: Int?
    @Published private(set) var ready: Bool
    private var cachedAlmanac: AlmanacDay?
    /// 代际 token：select 时自增；prepare 的 detached 结果只在代际/日期未变时写回。
    private var generation = 0
    private var prepareInFlight = false

    /// 惰性黄历：deferCompute 启动时不在 init 主线程重算；首次访问才计算。
    var almanac: AlmanacDay {
        if let cachedAlmanac { return cachedAlmanac }
        let a = engine.almanac(selectedDate, hour: hourProvider())
        cachedAlmanac = a
        return a
    }

    let engine: any CalendarEngine
    let today: LocalDate
    private let hourProvider: () -> Int

    init(engine: any CalendarEngine = LunarSwiftEngine(festivalScope: .cn),
         today: LocalDate = .beijingToday(),
         hourProvider: @escaping () -> Int = { BeijingTime.hour(of: Date()) },
         deferCompute: Bool = false) {
        self.engine = engine
        self.today = today
        self.hourProvider = hourProvider
        self.selectedDate = today
        if deferCompute {
            self.ready = false
            self.festivals = []
            self.hourIndex = nil
        } else {
            let a = engine.almanac(today, hour: hourProvider())
            self.cachedAlmanac = a
            self.ready = true
            self.festivals = a.festivals
            self.hourIndex = a.currentHourIndex
        }
    }

    /// 冷启动：后台准备黄历/时辰/岁时，避免 Duo 首帧白屏；完成后 ready=true。
    func prepare() async {
        guard !ready, !prepareInFlight else { return }
        prepareInFlight = true
        defer { prepareInFlight = false }
        let date = selectedDate
        let gen = generation
        let hour = hourProvider()
        let engine = self.engine
        R14StartupProbe.log("prepare.start")
        let started = ProcessInfo.processInfo.systemUptime
        let a = await Task.detached(priority: .userInitiated) {
            let t = ProcessInfo.processInfo.systemUptime
            let almanac = engine.almanac(date, hour: hour)
            R14StartupProbe.log("prepare.engineAlmanac", String(format: "%.0fms", (ProcessInfo.processInfo.systemUptime - t) * 1000))
            return almanac
        }.value
        guard selectedDate == date, generation == gen else {
            R14StartupProbe.log("prepare.discardedStale", "date=\(date.month)-\(date.day) gen=\(gen)")
            return
        }
        // 预热月历 42 格的黄历元数据（后台），避免首帧主线程 42×engine.almanac 卡顿
        let prewarmStart = ProcessInfo.processInfo.systemUptime
        let dates = Self.monthGridDates(for: date)
        let engineForPrewarm = self.engine
        let metas = await Task.detached(priority: .userInitiated) { () -> [(LocalDate, AlmanacDay)] in
            dates.map { d in (d, engineForPrewarm.almanac(d, hour: 12)) }
        }.value
        guard selectedDate == date, generation == gen else {
            R14StartupProbe.log("prepare.discardedStale", "phase=prewarm")
            return
        }
        for (d, a) in metas {
            metaCache[d] = DayMeta(lunarMonthDay: a.lunar.monthDayText, solarTerm: a.solarTerm, festivals: a.festivals)
        }
        cachedAlmanac = a
        festivals = a.festivals
        hourIndex = a.currentHourIndex
        R14StartupProbe.log("prepare.done", String(format: "%.0fms prewarm=%.0fms", (ProcessInfo.processInfo.systemUptime - started) * 1000, (ProcessInfo.processInfo.systemUptime - prewarmStart) * 1000))
        ready = true
    }

    /// 整组重算：一次 set 会更新 almanac/festivals/hourIndex；页面不得只改标题。
    func select(_ date: LocalDate) {
        generation += 1                 // 使在途 prepare 结果失效
        let hour = hourProvider()
        let a = engine.almanac(date, hour: hour)
        selectedDate = date
        cachedAlmanac = a
        festivals = a.festivals
        hourIndex = a.currentHourIndex
        ready = true                    // select 已同步算出所选日，无需等旧 prepare
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

    /// 月历 42 格用：每日期只算一次 almanac，缓存避免每次渲染重复重算。
    struct DayMeta { var lunarMonthDay: String; var solarTerm: String?; var festivals: [String] }
    private var metaCache: [LocalDate: DayMeta] = [:]
    func meta(for date: LocalDate) -> DayMeta {
        if let cached = metaCache[date] { return cached }
        let a = (date == selectedDate && cachedAlmanac != nil) ? almanac : engine.almanac(date, hour: 12)
        let m = DayMeta(lunarMonthDay: a.lunar.monthDayText, solarTerm: a.solarTerm, festivals: a.festivals)
        metaCache[date] = m
        return m
    }

    func compassHours() -> [LunarHour] { almanac.hours }
    func compassPositions(hour: Int?) -> DeityDirections? {
        guard let hour, let idx = almanac.hours.firstIndex(where: { h in
            Self.minutes(h.startMinute) <= hour * 60 && hour * 60 <= Self.minutes(h.endMinute)
        }) else { return almanac.positions }
        _ = idx
        return almanac.positions // 方位数据为日级；逐时煞/冲在 almanac.sha 上另行展示
    }
    /// 与 Home 月历一致：周一开头 42 格
    static func monthGridDates(for date: LocalDate) -> [LocalDate] {
        let first = LocalDate(date.year, date.month, 1)
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "Asia/Shanghai") ?? .current
        let d0 = cal.date(from: DateComponents(year: first.year, month: first.month, day: 1)) ?? Date()
        let w = cal.component(.weekday, from: d0)          // 1=Sun
        let weekday = ((w + 5) % 7) + 1
        let start = first.adding(days: -(weekday - 1))
        return (0..<42).map { start.adding(days: $0) }
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
