import SwiftUI
import LixiangCalendarCore
import UIKit

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

final class R14ChromeState: ObservableObject {
    @Published var forceTabBarVisible = false
}

struct R14RootView: View {
    @EnvironmentObject private var state: AppState
    @StateObject private var chrome = R14ChromeState()
    @StateObject private var days: SelectedDayStore
    @State private var tab = 0
    @State private var paths = [NavigationPath](repeating: NavigationPath(), count: 5)
    @State private var pendingRoute: R14Route? = nil
    @State private var pendingTab = 0
    @State private var debugTypeScale: DynamicTypeSize? = nil

    init() {
        let engine = LunarSwiftEngine(festivalScope: .cn)
        let debug = DebugOptions.parse()
        let today = debug.date ?? LocalDate.beijingToday()
        _days = StateObject(wrappedValue: SelectedDayStore(engine: engine, today: today, hourProvider: {
            debug.hour ?? BeijingTime.hour(of: Date())
        }, deferCompute: true))
        #if DEBUG
        let args = ProcessInfo.processInfo.arguments
        if let i = args.firstIndex(of: "-LixiangTab"), i + 1 < args.count, let n = Int(args[i + 1]) { _tab = State(initialValue: n) }
        if let i = args.firstIndex(of: "-LixiangTypeScale"), i + 1 < args.count {
            switch args[i + 1] {
            case "xl": _debugTypeScale = State(initialValue: .xLarge)
            case "xxl": _debugTypeScale = State(initialValue: .xxLarge)
            case "xxxl": _debugTypeScale = State(initialValue: .xxxLarge)
            case "a1": _debugTypeScale = State(initialValue: .accessibility1)
            case "a2": _debugTypeScale = State(initialValue: .accessibility2)
            case "a3": _debugTypeScale = State(initialValue: .accessibility3)
            default: break
            }
        }
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
            case "folkloreDetail": r = .folkloreDetail(id: "xiezao", version: nil)
            case "countdownDetail": r = .countdownDetail(id: "first")
            default: r = .home
            }
            _pendingRoute = State(initialValue: r)
        }
        if let link = debug.deepLink, let url = URL(string: link) {
            let parts = url.pathComponents.filter { $0 != "/" }
            var target = 0
            var r: R14Route = .home
            switch url.host {
            case "ceremony", "folklore":
                target = 1; r = .folkloreDetail(id: parts.first ?? "xiezao", version: nil)
            case "almanac":
                target = 0; r = .almanac(Self.parseDate(parts.first) ?? today)
            case "compass":
                target = 0; r = .compass(Self.parseDate(parts.first) ?? today, hour: debug.hour)
            case "countdown":
                target = 3; r = .countdownDetail(id: parts.first)
            case "daily":
                target = 0; r = .daily
            case "selection":
                target = 2; r = .selection
            case "settings":
                target = 4; r = .settings
            default:
                target = 0; r = .home
            }
            _tab = State(initialValue: target)
            _pendingTab = State(initialValue: target)
            _pendingRoute = State(initialValue: r)
        }
        #endif
    }

    var body: some View {
        ZStack {
        ScreenBackground().ignoresSafeArea()
        GeometryReader { geo in
            let isDuo = R14DevicePolicy.isDuo(size: geo.size)
            let canvas = R14DevicePolicy.canvas(size: geo.size, idiom: UIDevice.current.userInterfaceIdiom, isDuo: isDuo)
            let duoSideBar = R14DevicePolicy.isDuoOpenLandscape(size: geo.size)
            Group {
                if !days.ready {
                    R14BootLoadingView()
                } else if duoSideBar {
                    HStack(spacing: 0) {
                        tabsContent
                        if !hideBar { R14SideTabBar(selected: $tab).padding(.trailing, 8) }
                    }
                } else {
                    VStack(spacing: 0) {
                        tabsContent.frame(maxWidth: .infinity, maxHeight: .infinity)
                        if !hideBar { R14FloatingTabBar(selected: $tab).padding(.bottom, 6) }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        }
        .tint(D1Theme.resolve(state.theme.colorScheme ?? .light).accent)
        .modifier(R14DebugTypeScale(size: debugTypeScale))
        .environmentObject(days)
        .environmentObject(chrome)
        .onOpenURL { _ in }
        .task { await days.prepare() }
        .onAppear {
            guard let r = pendingRoute else { return }
            pendingRoute = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                var p = paths; p[pendingTab].append(r); paths = p
            }
        }
    }

    #if DEBUG
    private static func parseDate(_ s: String?) -> LocalDate? {
        guard let s else { return nil }
        let p = s.split(separator: "-").compactMap { Int($0) }
        return p.count == 3 ? LocalDate(p[0], p[1], p[2]) : nil
    }
    #endif

    private var hideBar: Bool {
        // pushed 页隐藏 TabBar（各 Tab 栈 path 非空）
        guard paths.indices.contains(tab) else { return false }
        if chrome.forceTabBarVisible { return false }
        return paths[tab].count > 0
    }

    private var tabsContent: some View {
        ZStack {
            tabStack(0) { R14HomeScreen() }
            tabStack(1) { R14FolkloreScreen(onOpen: { id in
        var p = paths; p[1].append(R14Route.folkloreDetail(id: id, version: nil)); paths = p
    }) }
            tabStack(2) { SelectionScreen(initialDate: days.selectedDate) { date in
                days.select(date)
                var p = paths; p[2].append(R14Route.almanac(date)); paths = p
            } }
            tabStack(3) { R14CountdownScreen() }
            tabStack(4) { R14SettingsScreen() }
        }
    }

    private func tabStack<Content: View>(_ index: Int, @ViewBuilder root: () -> Content) -> some View {
        NavigationStack(path: $paths[index]) {
            root().navigationDestination(for: R14Route.self) { R14RouteDestination(route: $0) }
        }
        .opacity(tab == index ? 1 : 0)
        .allowsHitTesting(tab == index)
        .accessibilityHidden(tab != index)
    }
}

// MARK: - 自定义浮动 Tab（替代系统 TabView 形态）
struct R14FloatingTabBar: View {
    @Binding var selected: Int
    @Environment(\.d1) private var theme
    @EnvironmentObject private var state: AppState
    @EnvironmentObject private var days: SelectedDayStore
    @ObservedObject private var unread = FolkloreUnreadStore.shared

    private var folkloreUnread: Bool { unread.unreadCount(ContentFixtures.all) > 0 }

    private var countdownBadge: String? {
        let n = state.countdownStore.items.filter { item in
            AnniversaryResolver.occurrence(for: item, now: days.selectedDate, engine: days.engine)?.date == days.selectedDate
        }.count
        return n > 0 ? "\(n)" : "0"
    }
    private let items: [(String, String)] = [("日历","tab-calendar"),("岁时","tab-suishi"),("择日","TabSelection"),("倒计日","tab-countdown"),("设置","tab-settings")]
    var body: some View {
        HStack(spacing: 2) {
            ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                Button { selected = idx } label: {
                    VStack(spacing: 2) {
                        Image(item.1).renderingMode(.template).resizable().scaledToFit().frame(width: 22, height: 22)
                        Text(item.0).d1Font(9, weight: selected == idx ? .semibold : .regular)
                    }
                    .foregroundStyle(selected == idx ? theme.accent : theme.ink3)
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(selected == idx ? theme.accent.opacity(0.12) : .clear, in: Capsule())
                    .overlay(alignment: .topTrailing) {
                        if idx == 1 && folkloreUnread {
                            Circle().fill(Color.r14Red).frame(width: 6, height: 6).padding(.top, 4).padding(.trailing, 18)
                        }
                        if idx == 3, let badge = countdownBadge {
                            Text(badge).d1Font(8, weight: .bold).foregroundStyle(.white)
                                .frame(minWidth: 16, minHeight: 16)
                                .background(Color.r14Red, in: Capsule())
                                .padding(.top, 2).padding(.trailing, 12)
                        }
                    }
                }.buttonStyle(.plain)
                .accessibilityLabel(item.0)
                .accessibilityAddTraits(selected == idx ? .isSelected : [])
            }
        }
        .padding(.horizontal, 8).padding(.vertical, 6)
        .r14Glass(Capsule())
        .overlay(Capsule().strokeBorder(theme.line.opacity(0.35)))
        .padding(.horizontal, 18)
        .frame(maxWidth: 520)
    }
}

struct R14SideTabBar: View {
    @Binding var selected: Int
    @Environment(\.d1) private var theme
    private let items: [(String, String)] = [("日历","tab-calendar"),("岁时","tab-suishi"),("择日","TabSelection"),("倒计日","tab-countdown"),("设置","tab-settings")]
    var body: some View {
        VStack(spacing: 4) {
            ForEach(Array(items.enumerated()), id: \.offset) { idx, item in
                Button { selected = idx } label: {
                    Image(item.1).renderingMode(.template).resizable().scaledToFit().frame(width: 22, height: 22)
                        .foregroundStyle(selected == idx ? theme.accent : theme.ink3)
                        .frame(width: 44, height: 44)
                        .background(selected == idx ? theme.accent.opacity(0.12) : .clear, in: Capsule())
                }.buttonStyle(.plain).accessibilityLabel(item.0)
            }
        }
        .padding(6)
        .r14Glass(Capsule())
        .overlay(Capsule().strokeBorder(theme.line.opacity(0.35)))
    }
}


/// DEBUG/QA 动态字体覆盖；生产 nil 时完全跟随系统。
private struct R14DebugTypeScale: ViewModifier {
    let size: DynamicTypeSize?
    @ViewBuilder func body(content: Content) -> some View {
        if let size { content.dynamicTypeSize(size) } else { content }
    }
}


#if DEBUG
/// DEBUG 测试入口：`-LixiangForceWide` 在 iPad portrait 上强制宽屏布局（真机/QA 不需要）
enum R14WideProbe {
    static let force = ProcessInfo.processInfo.arguments.contains("-LixiangForceWide")
}
#else
enum R14WideProbe { static let force = false }
#endif
