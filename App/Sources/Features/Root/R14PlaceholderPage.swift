import SwiftUI
import UIKit
import LixiangCalendarCore

/// T1/T5 空壳页：显示画布/日期链路，供未实现页与导航矩阵使用
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
                            Text(verbatim: "黄历链路：\(days.almanac.lunar.dayGanZhi)日 · 值神\(days.almanac.tianShen) · 煞\(days.sha?.rawValue ?? "—")")
                                .d1Font(11).foregroundStyle(theme.ink2)
                            Text("岁时命中：\(days.matchedFestivals.isEmpty ? "无（隐藏）" : days.matchedFestivals.joined(separator: "、"))")
                                .d1Font(11).foregroundStyle(theme.ink3)
                        }
                    }
                    HStack(spacing: 10) {
                        Button("前一天") { days.previousDay() }
                        Button("今天") { days.selectToday() }
                        Button("后一天") { days.nextDay() }
                    }.buttonStyle(.bordered).frame(minHeight: 44)
                    Text("页面待实现（T3–T5）；此页仅用于导航/画布/日期链路验证。")
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
