import SwiftUI
import LixiangCalendarCore

/// P2 批次1 · F4 吉神罗盘（按 design P2-F4-COMPASS.md 落地）
/// 只把「神煞方位」可视化；无中宫、无命理、不读磁力计/定位、不做实时罗盘。
struct CompassScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    let date: LocalDate

    @State private var highlighted: Deity?

    private var almanac: AlmanacDay { state.almanac(date, hour: state.debugHour ?? BeijingTime.hour(of: Date())) }
    private var layout: CompassLayout { CompassBuilder.layout(for: almanac, hidden: state.hiddenDeities) }
    private var textOnly: Bool {
        #if DEBUG
        state.debug.screen == "compass-a11y"
        #else
        false
        #endif
    }

    var body: some View {
        GeometryReader { geo in
            ScrollView {
                if geo.size.width >= 880 {
                    // iPad 11/13、Duo 内屏横：盘左 + 图例右（图例两列）
                    HStack(alignment: .top, spacing: 16) {
                        if textOnly { textAlternative } else {
                            compass(diameter: dialDiameter(for: geo.size.width, wide: true))
                        }
                        legend(columns: 2).frame(maxWidth: .infinity)
                    }
                    .padding(16)
                } else {
                    VStack(spacing: 12) {
                        if textOnly { textAlternative } else {
                            compass(diameter: dialDiameter(for: geo.size.width, wide: false))
                        }
                        legend(columns: 1)
                        footnote
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
            }
        }
        .background(ScreenBackground())
        .navigationTitle("吉神罗盘 · \(date.month)月\(date.day)日")
        .navigationBarTitleDisplayMode(.inline)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("吉神罗盘，\(date.month)月\(date.day)日，今日方位")
    }

    /// 盘径按容器（spec P2-F4 §2 新口径）：<320 → 280；320–700 → 300；>700 → 320
    private func dialDiameter(for width: CGFloat, wide: Bool) -> CGFloat {
        if width < 320 { return 280 }
        if width <= 700 { return 300 }
        return 320
    }

    private var textAlternative: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("吉神罗盘 · 文本替身").font(D1Theme.serif(24)).foregroundStyle(theme.ink)
            Text("VoiceOver 朗读顺序：喜神 → 财神 → 福神 → 阳贵 → 阴贵 → 煞方；盘面为装饰（accessibilityHidden）。")
                .font(.system(size: 10)).foregroundStyle(theme.ink3)
        }
    }

    private var footnote: some View {
        Text("5 针：喜神/财神/福神/阳贵/阴贵；同方位按径向错开。缺位 = 本日不在此位（不画针）。传统方位示意，非风水/招财/吉凶预测。")
            .font(.system(size: 9)).foregroundStyle(theme.ink3)
            .padding(.horizontal, 4)
    }

    // MARK: - 盘
    private func compass(diameter: CGFloat) -> some View {
        GeometryReader { geo in
            let R = diameter / 2
            let center = CGPoint(x: geo.size.width / 2, y: diameter / 2 + 6)
            ZStack {
                Circle()
                    .strokeBorder(theme.line, style: StrokeStyle(lineWidth: 1, dash: [1, 6]))
                    .frame(width: (R + 10) * 2, height: (R + 10) * 2)
                    .position(center)
                ForEach(Array(CompassDirection.allCases.enumerated()), id: \.offset) { _, direction in
                    SectorShape(center: center, radius: R,
                                startAngle: direction.angleDegrees - 22.5,
                                endAngle: direction.angleDegrees + 22.5)
                        .fill(direction.isCardinal ? theme.jade.opacity(0.05) : theme.accent.opacity(0.05))
                }
                // 22.5° 短刻
                ForEach(Array(stride(from: 0.0, to: 360.0, by: 22.5)), id: \.self) { angle in
                    tick(center: center, radius: R, angle: angle)
                }
                // 方位标签（R+15）
                ForEach(Array(CompassDirection.allCases.enumerated()), id: \.offset) { _, direction in
                    Text(direction.rawValue)
                        .font(.system(size: 8.5))
                        .foregroundStyle(theme.ink3)
                        .position(point(center: center, radius: R + 15, angle: direction.angleDegrees))
                }
                // 煞方（仅四正，±12° 虚线扇区 + 文字）
                if let sha = layout.sha {
                    SectorShape(center: center, radius: R * 0.97,
                                startAngle: sha.angleDegrees - 12, endAngle: sha.angleDegrees + 12)
                        .fill(theme.jiText.opacity(0.10))
                    SectorShape(center: center, radius: R - 8,
                                startAngle: sha.angleDegrees - 12, endAngle: sha.angleDegrees + 12)
                        .stroke(theme.jiText, style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                    Text("煞 \(sha.rawValue.replacingOccurrences(of: "正", with: ""))")
                        .font(.system(size: 8.5, weight: .semibold))
                        .foregroundStyle(theme.jiText)
                        .position(point(center: center, radius: R * 0.62, angle: sha.angleDegrees))
                }
                // 五神针（同方位径向错开，不做角度偏移）
                ForEach(needleGroups, id: \.direction) { group in
                    ForEach(Array(group.entries.enumerated()), id: \.offset) { index, entry in
                        needle(entry,
                               center: center,
                               badgeRadius: R - CGFloat(22 + index * 20),
                               groupIndex: index,
                               emphasized: highlighted == entry.deity)
                    }
                }
                // 中心圆（无中宫）
                Circle()
                    .fill(theme.card)
                    .frame(width: R * 0.68, height: R * 0.68)
                    .overlay(
                        Circle().strokeBorder(theme.line, lineWidth: 1)
                    )
                    .overlay(
                        VStack(spacing: 1) {
                            Text("今日方位").font(.system(size: 11, weight: .semibold)).foregroundStyle(theme.ink2)
                            Text("只讲方位").font(.system(size: 9)).foregroundStyle(theme.ink3)
                        }
                    )
                    .position(center)
            }
            .frame(width: geo.size.width, height: diameter + 24)
            .accessibilityHidden(true)   // 盘为装饰，图例为文本替身
        }
        .frame(width: diameter + 24, height: diameter + 24)
    }

    private func tick(center: CGPoint, radius: CGFloat, angle: Double) -> some View {
        Path { path in
            path.move(to: point(center: center, radius: radius - 4, angle: angle))
            path.addLine(to: point(center: center, radius: radius + 4, angle: angle))
        }
        .stroke(theme.line, lineWidth: 0.8)
    }

    private struct NeedleGroup {
        var direction: CompassDirection
        var entries: [CompassEntry]
    }

    private var needleGroups: [NeedleGroup] {
        var order: [CompassDirection] = []
        var map: [CompassDirection: [CompassEntry]] = [:]
        for entry in layout.present {
            if map[entry.direction] == nil { order.append(entry.direction) }
            map[entry.direction, default: []].append(entry)
        }
        return order.map { NeedleGroup(direction: $0, entries: map[$0] ?? []) }
    }

    private func needle(_ entry: CompassEntry, center: CGPoint, badgeRadius: CGFloat,
                        groupIndex: Int, emphasized: Bool) -> some View {
        let angle = entry.direction.angleDegrees
        let position = point(center: center, radius: badgeRadius, angle: angle)
        let color = color(for: entry.deity)
        return ZStack {
            Path { path in
                path.move(to: center)
                path.addLine(to: position)
            }
            .stroke(theme.line, lineWidth: 0.8)
            Circle()
                .fill(theme.card)
                .frame(width: 22, height: 22)
                .overlay(Circle().strokeBorder(color, lineWidth: emphasized ? 2.2 : 1.4))
                .overlay(
                    Text(entry.deity.badgeCharacter)
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundStyle(theme.ink)
                )
                .position(position)
                .contentShape(Circle().inset(by: -11))
                .onTapGesture { highlighted = entry.deity }
        }
    }

    // MARK: - 图例（文本替身；顺序 喜→财→福→阳贵→阴贵→煞）
    private func legend(columns: Int) -> some View {
        D1Card(padding: 0) {
            LazyVGrid(columns: columns == 2
                      ? [GridItem(.flexible(), spacing: 0, alignment: .leading),
                         GridItem(.flexible(), spacing: 0, alignment: .leading)]
                      : [GridItem(.flexible(), spacing: 0, alignment: .leading)],
                      alignment: .leading, spacing: 0) {
                ForEach(legendOrder) { deity in
                    let entry = layout.present.first { $0.deity == deity }
                    HStack(spacing: 10) {
                        Text(deity.badgeCharacter)
                            .font(.system(size: 10, weight: .semibold)).foregroundStyle(theme.ink)
                            .frame(width: 22, height: 22)
                            .background(Circle().fill(theme.card))
                            .overlay(Circle().strokeBorder(color(for: deity), lineWidth: 1.4))
                        Text(deity.title).font(.system(size: 12)).foregroundStyle(entry == nil ? theme.ink3 : theme.ink)
                        Spacer()
                        Text(entry?.direction.rawValue ?? "本日不在此位")
                            .font(.system(size: 11)).foregroundStyle(entry == nil ? theme.ink3 : theme.ink2)
                    }
                    .padding(.horizontal, 16).padding(.vertical, 9)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(entry == nil ? "\(deity.title)，本日不在此位" : "\(deity.title)，\(entry!.direction.rawValue)")
                    D1Divider().padding(.leading, 48)
                }
                HStack(spacing: 10) {
                    Text("煞").font(.system(size: 10, weight: .semibold)).foregroundStyle(theme.jiText)
                        .frame(width: 22)
                    Text("煞方").font(.system(size: 12, weight: .semibold)).foregroundStyle(theme.ink)
                    Spacer()
                    Text(layout.sha.map { "\($0.rawValue) · 仅四正" } ?? "—")
                        .font(.system(size: 11)).foregroundStyle(theme.ink2)
                }
                .padding(.horizontal, 16).padding(.vertical, 9)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("煞方，\(layout.sha?.rawValue ?? "无")，仅四正")
            }
        }
    }

    private var legendOrder: [Deity] { [.xi, .cai, .fu, .yangGui, .yinGui] }
    private var sortedForVoiceOver: [Deity] { legendOrder }

    private func point(center: CGPoint, radius: CGFloat, angle: Double) -> CGPoint {
        let radians = (angle - 90) * .pi / 180
        return CGPoint(x: center.x + radius * cos(radians), y: center.y + radius * sin(radians))
    }

    private func color(for deity: Deity) -> Color {
        switch deity {
        case .xi: return theme.deityXi
        case .cai: return theme.deityCai
        case .fu: return theme.deityFu
        case .yangGui: return theme.deityYang
        case .yinGui: return theme.deityYin
        }
    }
}

private extension CompassDirection {
    var isCardinal: Bool { [.north, .south, .east, .west].contains(self) }
}

private extension Deity {
    var badgeCharacter: String {
        switch self {
        case .xi: return "喜"
        case .cai: return "财"
        case .fu: return "福"
        case .yangGui: return "阳"
        case .yinGui: return "阴"
        }
    }
}

private struct SectorShape: Shape {
    var center: CGPoint
    var radius: CGFloat
    var startAngle: Double
    var endAngle: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: center)
        path.addArc(center: center,
                    radius: radius,
                    startAngle: .degrees(startAngle - 90),
                    endAngle: .degrees(endAngle - 90),
                    clockwise: false)
        path.closeSubpath()
        return path
    }
}
