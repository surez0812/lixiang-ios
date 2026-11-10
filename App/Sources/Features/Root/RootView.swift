import SwiftUI
import LixiangCalendarCore

enum Route: Hashable {
    case day(LocalDate)
    case content(String)
}

struct RootView: View {
    @EnvironmentObject private var state: AppState
    @State private var selectedTab = 0
    @State private var monthPath = NavigationPath()
    @State private var festivalsPath = NavigationPath()

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $monthPath) {
                MonthScreen()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .day(let date): DayDetailScreen(date: date)
                        case .content(let id): ContentScreen(contentID: id)
                        }
                    }
            }
            .tabItem { Label("月历", systemImage: "calendar").symbolVariant(.none) }
            .tag(0)

            NavigationStack(path: $festivalsPath) {
                FestivalsScreen()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .content(let id): ContentScreen(contentID: id)
                        default: EmptyView()
                        }
                    }
            }
            .tabItem { Label("民俗", systemImage: "scroll").symbolVariant(.none) }
            .tag(1)

            NavigationStack {
                AnniversaryScreen()
            }
            .tabItem { Label("纪念日", systemImage: "heart").symbolVariant(.none) }
            .tag(2)

            NavigationStack {
                SettingsScreen()
            }
            .tabItem { Label("设置", systemImage: "slider.horizontal.3").symbolVariant(.none) }
            .tag(3)
        }
        .tint(D1Theme.resolve(state.theme.colorScheme ?? .light).accent)
        .onChange(of: state.theme) { _, _ in
            TabBarStyle.apply(theme: D1Theme.resolve(state.theme.colorScheme ?? .light))
        }
        .onAppear(perform: applyDebugScreen)
    }

    private func applyDebugScreen() {
        #if DEBUG
        let screen = state.debug.screen
        if screen == "festivals" { selectedTab = 1 }
        if screen == "anniversary" { selectedTab = 2 }
        if screen == "settings" { selectedTab = 3 }
        if screen == "day" {
            selectedTab = 0
            monthPath = NavigationPath([Route.day(state.today)])
        }
        if screen == "locked" || screen == "content" {
            selectedTab = 1
            festivalsPath = NavigationPath([Route.content(state.debug.contentID ?? "xiezao")])
        }
        #endif
    }
}
