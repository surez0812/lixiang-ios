import SwiftUI

// Integration reference only. Not compiled or installed in this design delivery.
@available(iOS 26.0, *)
struct R9NavigationReference: View {
    enum Section: Hashable { case calendar, folklore, selection, countdown, settings }
    @State private var section: Section = .calendar
    var nearestCountdownDays: Int?
    private var countdownLabel: String? {
        guard let days = nearestCountdownDays, (0...10).contains(days) else { return nil }
        return String(days)
    }
    var body: some View {
        TabView(selection: $section) {
            Tab("日历", image: "tab-calendar", value: .calendar) { Text("Calendar home") }
            Tab("岁时", image: "tab-suishi", value: .folklore) { Text("Upcoming traditions") }
            Tab("择日", image: "TabSelection", value: .selection) { Text("Date selection") }
            Tab("倒计日", image: "tab-countdown", value: .countdown) { Text("Anniversaries") }
                .badge(countdownLabel)
            Tab("设置", image: "tab-settings", value: .settings) { Text("Settings") }
        }
    }
}

@available(iOS 26.0, *)
struct R9FloatingBack<Content: View>: View {
    let dismiss: () -> Void
    @ViewBuilder var content: Content
    var body: some View {
        content
            .toolbar(.hidden, for: .navigationBar)
            .overlay(alignment: .topLeading) {
                Button(action: dismiss) {
                    Image(systemName: "chevron.left")
                        .frame(width: 44, height: 44)
                }
                .buttonStyle(.glass)
                .accessibilityLabel("返回")
                .padding(8)
            }
    }
}
