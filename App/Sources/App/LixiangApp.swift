import SwiftUI
import LixiangCalendarCore

@main
struct LixiangApp: App {
    @StateObject private var state = AppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(state)
                .preferredColorScheme(state.theme.colorScheme)
                .environment(\.d1, D1Theme.resolve(state.theme.colorScheme ?? .light))
        }
    }
}
