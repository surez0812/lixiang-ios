import SwiftUI
import LixiangCalendarCore

enum AppTheme: String, CaseIterable, Identifiable {
    case system, light, dark
    var id: String { rawValue }
    var title: String {
        switch self {
        case .system: return "跟随系统"
        case .light: return "浅色"
        case .dark: return "深色"
        }
    }
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

@MainActor
final class AppState: ObservableObject {
    @Published var theme: AppTheme {
        didSet { UserDefaults.standard.set(theme.rawValue, forKey: Keys.theme) }
    }
    @Published var weekStart: WeekStart {
        didSet { UserDefaults.standard.set(weekStart.rawValue, forKey: Keys.weekStart) }
    }
    @Published var dailyClassic: String {
        didSet { UserDefaults.standard.set(dailyClassic, forKey: "lx.daily.classic") }
    }
    @Published var showVernacular: Bool {
        didSet { UserDefaults.standard.set(showVernacular, forKey: Keys.vernacular) }
    }
    @Published var showTaoCalendar: Bool {
        didSet { UserDefaults.standard.set(showTaoCalendar, forKey: Keys.taoCalendar) }
    }
    @Published var showFotoCalendar: Bool {
        didSet { UserDefaults.standard.set(showFotoCalendar, forKey: Keys.fotoCalendar) }
    }

    let debug: DebugOptions
    let engine: any CalendarEngine
    let plainLanguage: PlainLanguagePack = PlainLanguageLoader.load()
    let countdownStore: AnniversaryStore = AnniversaryStore(seed: DebugOptions.parse().seedCountdown)
    let today: LocalDate
    /// 截图/测试注入“当前小时”（DEBUG）；nil = 系统时间
    let debugHour: Int?
    /// DEBUG 罗盘缺位演示（防御路径）
    let hiddenDeities: Set<Deity>

    private enum Keys {
        static let theme = "appearance"
        static let weekStart = "weekStart"
        static let vernacular = "showVernacular"
        static let taoCalendar = "showTaoCalendar"
        static let fotoCalendar = "showFotoCalendar"
    }

    init(debug: DebugOptions = .parse()) {
        self.debug = debug
        #if DEBUG
        print("LXLAUNCH args=\(ProcessInfo.processInfo.arguments)")
        print("LXLAUNCH screen=\(debug.screen ?? "nil") expandTerms=\(debug.expandTerms) debugTerms=\(debug.debugTerms ?? "nil") valueGod=\(debug.valueGod)")
        #endif
        if let forced = debug.theme, let t = AppTheme(rawValue: forced) {
            self.theme = t
        } else {
            self.theme = AppTheme(rawValue: UserDefaults.standard.string(forKey: Keys.theme) ?? "") ?? .system
        }
        #if DEBUG
        if let forced = debug.classic { self.dailyClassic = forced } else { self.dailyClassic = UserDefaults.standard.string(forKey: "lx.daily.classic") ?? "dao" }
        #else
        self.dailyClassic = UserDefaults.standard.string(forKey: "lx.daily.classic") ?? "dao"
        #endif
        self.showTaoCalendar = UserDefaults.standard.bool(forKey: Keys.taoCalendar)
        self.showFotoCalendar = UserDefaults.standard.bool(forKey: Keys.fotoCalendar)
        if let stored = UserDefaults.standard.object(forKey: Keys.weekStart) as? Int, let w = WeekStart(rawValue: stored) {
            self.weekStart = w
        } else {
            self.weekStart = .monday
        }
        self.showVernacular = UserDefaults.standard.bool(forKey: Keys.vernacular)
        self.engine = LunarSwiftEngine()
        self.today = debug.date ?? BeijingTime.today()
        self.debugHour = debug.hour
        self.hiddenDeities = debug.hiddenDeities
        self.cachedResolutions = nil
    }

    func setTheme(_ theme: AppTheme) { self.theme = theme }

    func almanac(_ date: LocalDate, hour: Int = 12) -> AlmanacDay { engine.almanac(date, hour: hour) }
    func lunar(_ date: LocalDate) -> LunarDate { engine.lunarDate(date, hour: 12) }

    private var cachedResolutions: [ContentResolution]?

    func resolutions() -> [ContentResolution] {
        if let cached = cachedResolutions { return cached }
        let resolved = ContentResolver.resolve(items: ContentFixtures.all, now: today, engine: engine,
                                               pastDays: 370, futureDays: 420)
        cachedResolutions = resolved
        return resolved
    }

    func indexGroups() -> (past: [ContentIndexRow], today: [ContentIndexRow], upcoming: [ContentIndexRow]) {
        ContentIndexBuilder.build(resolutions: resolutions(), now: today)
    }

    func contentItem(id: String) -> ContentItem? { ContentFixtures.all.first { $0.id == id } }
    func resolution(id: String) -> ContentResolution? { resolutions().first { $0.item.id == id } }

    func nearestFestivalDays() -> (title: String, days: Int)? {
        var best: (String, Int)?
        for resolution in resolutions() {
            for region in resolution.regions {
                if let info = resolution.stateInfo(regionID: region.id, now: today),
                   info.state == .locked, let days = info.daysUntil {
                    if best == nil || days < best!.1 { best = (resolution.item.title, days) }
                }
            }
        }
        return best
    }

    func contentID(for date: LocalDate) -> String? {
        let lunar = engine.lunarDate(date, hour: 12)
        if lunar.month == 12, (23...29).contains(lunar.day) { return "xiezao" }
        if lunar.jieQi == "清明" { return "qingming" }
        if lunar.month == 12, lunar.day >= 29 { return "chuxi" }
        return nil
    }
}
