import SwiftUI
import LixiangCalendarCore

/// R14 五 Tab 路由（替代旧 day/pager 路由；旧 Route 仅供未迁移页编译）
enum R14Route: Hashable {
    case home
    case almanac(LocalDate)
    case compass(LocalDate, hour: Int?)
    case daily
    case fortune
    case folklore
    case folkloreDetail(id: String, version: String?)
    case selection
    case countdown
    case countdownDetail(id: String?)
    case settings
}

struct R14RootView: View {
    @EnvironmentObject private var state: AppState
    @StateObject private var days: SelectedDayStore
    @State private var tab = 0
    @State private var paths = [NavigationPath](repeating: NavigationPath(), count: 5)

    init() {
        let engine = LunarSwiftEngine(festivalScope: .cn)
        let debug = DebugOptions.parse()
        let today = debug.date ?? LocalDate.beijingToday()
        _days = StateObject(wrappedValue: SelectedDayStore(engine: engine, today: today, hourProvider: {
            debug.hour ?? BeijingTime.hour(of: Date())
        }))
        #if DEBUG
        let args = ProcessInfo.processInfo.arguments
        if let i = args.firstIndex(of: "-LixiangTab"), i + 1 < args.count, let n = Int(args[i + 1]) { _tab = State(initialValue: n) }
        let routeName: String? = {
            guard let i = args.firstIndex(of: "-LixiangR14Route"), i + 1 < args.count else { return nil }
            return args[i + 1]
        }()
        if let routeName {
            let r: R14Route
            switch routeName {
            case "almanac": r = .almanac(today)
            case "compass": r = .compass(today, hour: debug.hour ?? 12)
            case "daily": r = .daily
            case "fortune": r = .fortune
            case "selection": r = .selection
            case "folklore": r = .folklore
            case "countdown": r = .countdown
            case "settings": r = .settings
            default: r = .home
            }
            var initial = [NavigationPath](repeating: NavigationPath(), count: 5)
            initial[0] = NavigationPath([r])
            _paths = State(initialValue: initial)
        }
        #endif
    }

    var body: some View {
        TabView(selection: $tab) {
            NavigationStack(path: $paths[0]) { R14HomeScreen() }
                .navigationDestination(for: R14Route.self) { R14RouteDestination(route: $0) }
                .tabItem { Label("日历", image: "tab-calendar") }.tag(0)
            NavigationStack(path: $paths[1]) { R14PlaceholderPage(title: "岁时", route: .folklore) }
                .navigationDestination(for: R14Route.self) { R14RouteDestination(route: $0) }
                .tabItem { Label("岁时", image: "tab-suishi") }.tag(1)
            NavigationStack(path: $paths[2]) { R14PlaceholderPage(title: "择日", route: .selection) }
                .navigationDestination(for: R14Route.self) { R14RouteDestination(route: $0) }
                .tabItem { Label("择日", image: "TabSelection") }.tag(2)
            NavigationStack(path: $paths[3]) { R14PlaceholderPage(title: "倒计日", route: .countdown) }
                .navigationDestination(for: R14Route.self) { R14RouteDestination(route: $0) }
                .tabItem { Label("倒计日", image: "tab-countdown") }.tag(3)
            NavigationStack(path: $paths[4]) { R14PlaceholderPage(title: "设置", route: .settings) }
                .navigationDestination(for: R14Route.self) { R14RouteDestination(route: $0) }
                .tabItem { Label("设置", image: "tab-settings") }.tag(4)
        }
        .tint(D1Theme.resolve(state.theme.colorScheme ?? .light).accent)
        .environmentObject(days)
        .onOpenURL { _ in }
    }
}

/// T1 空壳：显示画布/所选日/链路入口；页面实现由 T3–T5 替换
struct R14PlaceholderPage: View {
    @Environment(\.d1) private var theme
    @EnvironmentObject private var days: SelectedDayStore
    let title: String
    let route: R14Route

    var body: some View {
        GeometryReader { geo in
            let canvas = R14DevicePolicy.canvas(size: geo.size, idiom: UIDevice.current.userInterfaceIdiom)
            ScrollView {
                VStack(alignment: .leading, spacing: 14) {
                    Text(title).d1SerifFont(28, weight: .semibold).foregroundStyle(theme.ink)
                    Text(verbatim: "画布 \(canvas.rawValue)（共享 \(canvas.sharedLayout.rawValue)）· \(Int(geo.size.width))×\(Int(geo.size.height))")
                        .d1Font(11).foregroundStyle(theme.ink3)
                    D1Card(padding: 14) {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(verbatim: "\(days.selectedDate.year)年\(days.selectedDate.month)月\(days.selectedDate.day)日 · 农历\(days.lunar.monthDayText)")
                                .d1Font(13, weight: .semibold).foregroundStyle(theme.ink)
                            Text("黄历链路：\(days.almanac.lunar.dayGanZhi)日 · 值神\(days.almanac.tianShen) · 煞\(days.sha?.rawValue ?? "—")")
                                .d1Font(11).foregroundStyle(theme.ink2)
                            Text("岁时命中：\(days.matchedFestivals.isEmpty ? "无（隐藏）" : days.matchedFestivals.joined(separator: "、"))")
                                .d1Font(11).foregroundStyle(theme.ink3)
                        }
                    }
                    HStack(spacing: 10) {
                        Button("前一天") { days.previousDay() }.buttonStyle(.bordered)
                        Button("今天") { days.selectToday() }.buttonStyle(.bordered)
                        Button("后一天") { days.nextDay() }.buttonStyle(.bordered)
                    }
                    .frame(minHeight: 44)
                    Text("T1 空壳：Home/Almanac/Compass 页面将由 T3 替换；此页仅验证 5Tab/画布/日期整组重算链路。")
                        .d1Font(10).foregroundStyle(theme.ink3)
                }
                .padding(16)
            }
        }
        .background(ScreenBackground())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
    }
}
