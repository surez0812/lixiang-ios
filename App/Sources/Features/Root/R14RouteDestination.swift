import SwiftUI
import LixiangCalendarCore

/// 路由目标：T3 已接 Home/Almanac/Compass；其余为 T4/T5 占位（接口不变）
struct R14RouteDestination: View {
    @EnvironmentObject private var days: SelectedDayStore
    let route: R14Route

    var body: some View {
        switch route {
        case .home:
            R14HomeScreen()
        case .almanac(let date):
            R14AlmanacScreen(date: date)
        case .compass(let date, let hour):
            R14CompassScreen(date: date, hour: hour)
        case .daily:
            DailyScreen()
        case .fortune:
            FortuneScreen()
        case .folklore:
            R14PlaceholderPage(title: "岁时", route: .folklore)
        case .folkloreDetail(let id, let version):
            R14PlaceholderPage(title: "岁时详情 \(id)@\(version ?? "-")", route: .folklore)
        case .selection:
            SelectionScreen(initialDate: days.selectedDate) { date in
                days.select(date)
            }
        case .countdown:
            R14PlaceholderPage(title: "倒计日", route: .countdown)
        case .countdownDetail(let id):
            R14PlaceholderPage(title: "倒计日详情 \(id ?? "-")", route: .countdown)
        case .settings:
            R14PlaceholderPage(title: "设置", route: .settings)
        }
    }
}
