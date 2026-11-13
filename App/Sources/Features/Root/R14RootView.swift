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

struct R14RootView: View {
    @EnvironmentObject private var state: AppState
    @StateObject private var days: SelectedDayStore
    @State private var tab = 0
    @State private var paths = [NavigationPath](repeating: NavigationPath(), count: 5)
    @State private var pendingRoute: R14Route? = nil

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
            _pendingRoute = State(initialValue: r)
        }
        #endif
    }

    var body: some View {
        GeometryReader { geo in
            let canvas = R14DevicePolicy.canvas(size: geo.size, idiom: UIDevice.current.userInterfaceIdiom)
            let duoSideBar = canvas == .duoOpenLandscape || (geo.size.width > geo.size.height && abs(geo.size.width - 951) < 24 && abs(geo.size.height - 669) < 24)
            ZStack(alignment: duoSideBar ? .trailing : .bottom) {
                tabsContent
                    .safeAreaInset(edge: .bottom) {
                        if !duoSideBar && !hideBar { Color.clear.frame(height: 84) }
                    }
                    .safeAreaInset(edge: .trailing) {
                        if duoSideBar && !hideBar { Color.clear.frame(width: 76) }
                    }
                if !hideBar {
                    if duoSideBar {
                        R14SideTabBar(selected: $tab).padding(.trailing, 8).padding(.vertical, 24)
                    } else {
                        R14FloatingTabBar(selected: $tab).padding(.bottom, 6)
                    }
                }
            }
        }
        .tint(D1Theme.resolve(state.theme.colorScheme ?? .light).accent)
        .environmentObject(days)
        .onOpenURL { _ in }
        .onAppear {
            guard let r = pendingRoute else { return }
            pendingRoute = nil
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                var p = paths; p[0].append(r); paths = p
            }
        }
    }

    private var hideBar: Bool {
        // pushed 页隐藏 TabBar（各 Tab 栈 path 非空）
        guard paths.indices.contains(tab) else { return false }
        return paths[tab].count > 0
    }

    private var tabsContent: some View {
        ZStack {
            tabStack(0) { R14HomeScreen() }
            tabStack(1) { R14PlaceholderPage(title: "岁时", route: .folklore) }
            tabStack(2) { R14PlaceholderPage(title: "择日", route: .selection) }
            tabStack(3) { R14PlaceholderPage(title: "倒计日", route: .countdown) }
            tabStack(4) { R14PlaceholderPage(title: "设置", route: .settings) }
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
                        if idx == 1 {
                            Circle().fill(Color(hex: 0xB23A2A)).frame(width: 6, height: 6).padding(.top, 4).padding(.trailing, 18)
                        }
                        if idx == 3, let badge = countdownBadge {
                            Text(badge).d1Font(8, weight: .bold).foregroundStyle(.white)
                                .frame(minWidth: 16, minHeight: 16)
                                .background(Color(hex: 0xB23A2A), in: Capsule())
                                .padding(.top, 2).padding(.trailing, 12)
                        }
                    }
                }.buttonStyle(.plain)
                .accessibilityLabel(item.0)
                .accessibilityAddTraits(selected == idx ? .isSelected : [])
            }
        }
        .padding(.horizontal, 8).padding(.vertical, 6)
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(Capsule().strokeBorder(theme.line.opacity(0.6)))
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
        .background(.ultraThinMaterial, in: Capsule())
        .overlay(Capsule().strokeBorder(theme.line.opacity(0.6)))
    }
}
