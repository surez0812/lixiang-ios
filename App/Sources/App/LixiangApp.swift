import SwiftUI
import UIKit
import LixiangCalendarCore

@main
struct LixiangApp: App {
    @StateObject private var state = AppState()

    init() {
        TabBarStyle.apply(theme: D1Theme.light)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(state)
                .preferredColorScheme(state.theme.colorScheme)
                .environment(\.d1, D1Theme.resolve(state.theme.colorScheme ?? .light))
        }
    }
}


/// tab 图标：线宽 1.5 / 尺寸 19，激活暖橘、未激活 ink3（D1 细节修 §4）
enum TabBarStyle {
    static func apply(theme: D1Theme) {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        let normal = UIColor(theme.ink3)
        let selected = UIColor(theme.accent)
        appearance.stackedLayoutAppearance.normal.iconColor = normal
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normal]
        appearance.stackedLayoutAppearance.selected.iconColor = selected
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selected]
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
