import SwiftUI
import LixiangCalendarCore

/// R14 罗盘（T3）：日/时切换、12 时辰、五吉神/煞方；独立页返回同日；宽屏两列
struct R14CompassScreen: View {
    @Environment(\.d1) private var theme
    @EnvironmentObject private var days: SelectedDayStore
    let date: LocalDate
    let hour: Int?
    @State private var useHour = false

    private var almanac: AlmanacDay { days.almanac }
    private var layout: CompassLayout { CompassBuilder.layout(for: almanac) }
    private var selectedHour: LunarHour? {
        guard let hour else { return nil }
        return almanac.hours.first { h in
            minutes(h.startMinute) <= hour * 60 && hour * 60 <= minutes(h.endMinute)
        }
    }
    private var currentSha: CompassDirection? {
        if useHour, let h = selectedHour { return h.sha }
        return almanac.sha
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                if geo.size.width >= 744 {
                    HStack(alignment: .top, spacing: 16) { leftColumn; hoursCard }
                        .padding(16)
                } else {
                    VStack(alignment: .leading, spacing: 12) { leftColumn; hoursCard }
                        .padding(16)
                }
                Text("方位为传统历法参考，非风水/吉凶预测。")
                    .d1Font(9).foregroundStyle(theme.ink3).padding(.horizontal, 16)
            }
            .padding(.bottom, 96)
        }
        .background(ScreenBackground())
        .navigationTitle("值神罗盘")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .onAppear { if days.selectedDate != date { days.select(date) } }
    }

    private var leftColumn: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("", selection: $useHour) { Text("日方位").tag(false); Text("时方位").tag(true) }
                .pickerStyle(.segmented)
            D1Card(padding: 14) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(verbatim: "\(almanac.date.year)年\(almanac.date.month)月\(almanac.date.day)日 \(useHour ? "时" : "日")方位")
                        .d1Font(13, weight: .semibold).foregroundStyle(theme.ink)
                    Text("正北固定底盘；\(useHour ? "当前时辰" : "当日")煞方：\(currentSha?.rawValue ?? "—")")
                        .d1Font(11).foregroundStyle(theme.ink2)
                    ForEach(layout.present, id: \.deity) { entry in
                        HStack { Text(entry.deity.title).d1Font(12, weight: .semibold).foregroundStyle(theme.ink); Spacer(); Text(entry.direction.rawValue).d1Font(12).foregroundStyle(theme.ink2) }
                    }
                    ForEach(layout.missing, id: \.self) { deity in
                        HStack { Text(deity.title).d1Font(11).foregroundStyle(theme.ink3); Spacer(); Text("本日不在此位").d1Font(10).foregroundStyle(theme.ink3) }
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    private var hoursCard: some View {
        D1Card(padding: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("十二时辰").d1Font(13, weight: .semibold).foregroundStyle(theme.ink)
                ForEach(Array(almanac.hours.prefix(12).enumerated()), id: \.offset) { _, h in
                    HStack { Text("\(h.ganZhi)时").d1Font(10).foregroundStyle(theme.ink); Text("\(h.startMinute)–\(h.endMinute)").d1Font(9).foregroundStyle(theme.ink3); Spacer(); Text("煞\(h.sha?.rawValue ?? "—")").d1Font(9).foregroundStyle(theme.ink2); Text(h.tianShen).d1Font(9).foregroundStyle(theme.ink3) }
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    private func minutes(_ hm: String) -> Int {
        let p = hm.split(separator: ":").compactMap { Int($0) }
        return p.count == 2 ? p[0] * 60 + p[1] : 0
    }
}
