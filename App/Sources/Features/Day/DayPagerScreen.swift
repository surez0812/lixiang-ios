import SwiftUI
import LixiangCalendarCore

/// 单日左右滑：#10 TabView(.page) + ±1 预取；页内 DayDetail 纵向滚动无手势竞争
struct DayPagerScreen: View {
    @EnvironmentObject private var state: AppState
    @State private var selection: LocalDate
    private let dates: [LocalDate]

    init(initial: LocalDate) {
        _selection = State(initialValue: initial)
        dates = (-3...3).map { initial.adding(days: $0) }
    }

    var body: some View {
        TabView(selection: $selection) {
            ForEach(dates, id: \.self) { d in
                DayDetailScreen(date: d)
                    .tag(d)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .onChange(of: selection) { _, newValue in
            let prev = newValue.adding(days: -1), next = newValue.adding(days: 1)
            _ = state.almanac(prev); _ = state.almanac(next)   // ±1 预取（内存缓存）
        }
        .accessibilityLabel("单日详情，左右滑动切换日期")
    }
}
