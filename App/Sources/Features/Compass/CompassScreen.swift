import SwiftUI
import LixiangCalendarCore

/// R14 罗盘（T3）：对照 compass-phone-light 重做——盘面+五神方位+煞方+图例+12 时辰
struct R14CompassScreen: View {
    @Environment(\.d1) private var theme
    @EnvironmentObject private var days: SelectedDayStore
    @EnvironmentObject private var chrome: R14ChromeState
    let date: LocalDate
    let hour: Int?
    @State private var useHour = false
    @State private var hourIndex: Int? = nil

    private var almanac: AlmanacDay { days.almanac }
    private var layout: CompassLayout { CompassBuilder.layout(for: almanac) }
    private var selectedHour: LunarHour? {
        if let hourIndex, let h = almanac.hours.first(where: { $0.index == hourIndex }) { return h }
        guard let hour else { return nil }
        return almanac.hours.first { h in minutes(h.startMinute) <= hour * 60 && hour * 60 <= minutes(h.endMinute) }
    }
    private var currentSha: CompassDirection? { useHour ? selectedHour?.sha : almanac.sha }
    private func shichenName(index: Int) -> String {
        let names = ["子", "丑", "寅", "卯", "辰", "巳", "午", "未", "申", "酉", "戌", "亥"]
        return names[((index % 12) + 12) % 12] + "时"
    }

    var body: some View {
        GeometryReader { geo in
            let wide = (geo.size.width >= 744 && geo.size.width > geo.size.height) || R14WideProbe.force
            if wide {
                // R14 iPad Landscape：左控件、右罗盘+图例（各自滚动）
                HStack(alignment: .top, spacing: 20) {
                    VStack(alignment: .leading, spacing: 12) {
                        header
                        modePicker
                        if useHour { hourSelector }
                        Text(verbatim: "\(useHour ? "所选时辰" : "所选日期")的\(useHour ? "时" : "日")方位").d1Font(11).foregroundStyle(theme.ink3)
                        Spacer(minLength: 0)
                    }
                    .frame(width: geo.size.width * 0.34, alignment: .leading)
                    .padding(.leading, 24).padding(.top, 16)
                    ScrollView {
                        VStack(spacing: 12) {
                            dial(size: min(geo.size.width * 0.38, 360))
                            legendCard
                            Text("固定北向图 · 上方为正北").d1Font(9).foregroundStyle(theme.ink3)
                        }.padding(16)
                    }
                    .background(theme.paper, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                    .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(theme.line.opacity(0.6)))
                    .padding(.trailing, 28).padding(.top, 16)
                }
                .padding(.bottom, 120)
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 14) {
                        header
                        modePicker
                        if useHour { hourSelector }
                        dial(size: min(geo.size.width - 40, 340))
                        legend
                        Text(verbatim: "\(useHour ? "时方位" : "日方位") · 五吉神方位与煞方；传统历法参考，非风水/吉凶预测。")
                            .d1Font(9).foregroundStyle(theme.ink3).padding(.horizontal, 4)
                        hoursCard
                    }
                    .padding(.horizontal, 20).padding(.vertical, 12).padding(.bottom, 150)
                }
            }
        }
        .background(ScreenBackground())
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            chrome.forceTabBarVisible = true
            if days.selectedDate != date { days.select(date) }
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("-LixiangCompassHour") {
                useHour = true
                if hourIndex == nil { hourIndex = selectedHour?.index }
            }
            #endif
        }
        .onDisappear { chrome.forceTabBarVisible = false }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("罗盘").d1SerifFont(26, weight: .semibold).foregroundStyle(theme.ink)
            Text(verbatim: "\(almanac.date.year)年\(almanac.date.month)月\(almanac.date.day)日 · 农历\(almanac.lunar.monthDayText)")
                .d1Font(11).foregroundStyle(theme.ink3)
        }
    }

    private var hourSelector: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 10) {
                Text("选择时辰").d1Font(12).foregroundStyle(theme.ink2)
                Menu {
                    ForEach(almanac.hours, id: \.index) { h in
                        Button("\(shichenName(index: h.index)) · \(h.ganZhi)") { hourIndex = h.index }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text(selectedHour.map { "\(shichenName(index: $0.index)) · \($0.ganZhi)" } ?? "选择时辰")
                            .d1Font(13, weight: .semibold).foregroundStyle(theme.ink)
                        Spacer(minLength: 4)
                        Image(systemName: "chevron.down").d1Font(9).foregroundStyle(theme.ink3)
                    }
                    .padding(.horizontal, 12).frame(minHeight: 40)
                    .background(theme.paper, in: RoundedRectangle(cornerRadius: 12))
                    .overlay(RoundedRectangle(cornerRadius: 12).strokeBorder(theme.line))
                }
            }
            if let h = selectedHour {
                Text(verbatim: "\(shichenName(index: h.index)) · \(h.startMinute)—\(h.endMinute)")
                    .d1Font(11).foregroundStyle(theme.ink3)
            }
        }
    }

    private var modePicker: some View {
        HStack(spacing: 8) {
            modeButton("日方位", active: !useHour) { useHour = false }
            modeButton("时方位", active: useHour) { useHour = true }
            Spacer()
        }
    }
    private func modeButton(_ title: String, active: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).d1Font(11, weight: .semibold)
                .foregroundStyle(active ? theme.cream : theme.ink2)
                .padding(.horizontal, 16).frame(minHeight: 36)
                .background(active ? Color.r14Red : theme.paper, in: Capsule())
                .overlay(Capsule().strokeBorder(theme.line.opacity(0.6)))
        }.buttonStyle(.plain)
    }

    // MARK: 盘面
    private func dial(size: CGFloat) -> some View {
        let r = size / 2
        return ZStack {
            Image("compass-dial").resizable().scaledToFit().frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(Color.r14Gold.opacity(0.5), lineWidth: 1))
            if let sha = currentSha {
                shaIndicator(direction: sha, radius: r * 0.62)
            }
            ForEach(layout.present, id: \.deity) { entry in
                deityBadge(entry, radius: r * 0.74)
            }
            VStack(spacing: 2) {
                Text("正北").d1Font(10, weight: .semibold).foregroundStyle(Color.r14Gold)
                Text("固定北向图").d1Font(8).foregroundStyle(theme.ink3)
            }
        }
        .frame(width: size, height: size)
        .frame(maxWidth: .infinity)
    }

    private func deityBadge(_ entry: CompassEntry, radius: CGFloat) -> some View {
        let pt = point(for: entry.direction.angleDegrees, radius: radius)
        return VStack(spacing: 0) {
            Text(entry.deity.title.replacingOccurrences(of: "神", with: "")).d1Font(9, weight: .semibold).foregroundStyle(theme.ink)
            Text(entry.direction.rawValue).d1Font(7).foregroundStyle(theme.ink3)
        }
        .padding(.horizontal, 5).padding(.vertical, 3)
        .background(theme.cream, in: Capsule())
        .overlay(Capsule().strokeBorder(Color.r14Gold.opacity(0.6)))
        .offset(x: pt.x, y: pt.y)
    }

    private func shaIndicator(direction: CompassDirection, radius: CGFloat) -> some View {
        let pt = point(for: direction.angleDegrees, radius: radius)
        return VStack(spacing: 0) {
            Image(systemName: "arrowtriangle.down.fill").d1Font(10).foregroundStyle(Color.r14Red)
            Text("煞 \(direction.rawValue)").d1Font(8, weight: .semibold).foregroundStyle(Color.r14Red)
        }.offset(x: pt.x, y: pt.y)
    }

    private func point(for degrees: Double, radius: CGFloat) -> CGPoint {
        let a = (degrees - 90) * .pi / 180
        return CGPoint(x: cos(a) * radius, y: sin(a) * radius)
    }

    // MARK: 图例（两列）
    private var legend: some View {
        let cols = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]
        return LazyVGrid(columns: cols, alignment: .leading, spacing: 6) {
            ForEach(layout.present, id: \.deity) { e in
                HStack(spacing: 5) { Circle().fill(Color.r14Gold).frame(width: 6, height: 6); Text(e.deity.title).d1Font(11, weight: .semibold).foregroundStyle(theme.ink); Text(e.direction.rawValue).d1Font(10).foregroundStyle(theme.ink2) }
            }
            if let sha = currentSha {
                HStack(spacing: 5) { Circle().fill(Color.r14Red).frame(width: 6, height: 6); Text("煞方").d1Font(11, weight: .semibold).foregroundStyle(theme.ink); Text(sha.rawValue).d1Font(10).foregroundStyle(theme.ink2) }
            }
        }
    }

    private var legendCard: some View {
        VStack(spacing: 0) {
            ForEach(layout.present, id: \.deity) { e in
                HStack { Text(e.deity.title).d1Font(13).foregroundStyle(theme.ink); Spacer(); Text(e.direction.rawValue).d1Font(13, weight: .semibold).foregroundStyle(theme.ink2) }
                    .frame(minHeight: 40)
                Divider().overlay(theme.line.opacity(0.6))
            }
            if let sha = currentSha {
                HStack { Text("煞方").d1Font(13).foregroundStyle(theme.ink); Spacer(); Text(sha.rawValue).d1Font(13, weight: .semibold).foregroundStyle(Color(hex: 0xB23A2A)) }
                    .frame(minHeight: 40)
            }
        }
    }

    private var hoursCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("十二时辰").d1SerifFont(18, weight: .semibold).foregroundStyle(theme.ink)
            ForEach(Array(almanac.hours.prefix(12).enumerated()), id: \.offset) { _, h in
                HStack {
                    Text("\(h.ganZhi)时").d1Font(11).foregroundStyle(theme.ink)
                    Text("\(h.startMinute)–\(h.endMinute)").d1Font(9).foregroundStyle(theme.ink3)
                    Spacer()
                    Text("煞\(h.sha?.rawValue ?? "—")").d1Font(10).foregroundStyle(theme.ink2)
                    Text(h.tianShen).d1Font(9).foregroundStyle(theme.ink3)
                }.padding(.vertical, 3)
                Divider().overlay(theme.line.opacity(0.5))
            }
        }
        .padding(14)
        .background(theme.paper, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 20).strokeBorder(theme.line.opacity(0.6)))
    }

    private func minutes(_ hm: String) -> Int {
        let p = hm.split(separator: ":").compactMap { Int($0) }
        return p.count == 2 ? p[0] * 60 + p[1] : 0
    }
}
