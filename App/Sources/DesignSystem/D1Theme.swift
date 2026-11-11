import SwiftUI
import UIKit

/// 历象 D1「奶油暖橘」token（设计基线：design/final/D1-apricot/spec/UI-SPEC.md §0.1）
struct D1Theme {
    var bg: Color
    var bg1: Color
    var bg2: Color
    var bg3: Color
    var paper: Color
    var red: Color
    var cream: Color
    var card: Color
    var soft: Color
    var ink: Color
    var ink2: Color
    var ink3: Color
    var line: Color
    var accent: Color
    var accentStrong: Color
    var jade: Color
    var onAccent: Color
    /// 忌：暖灰/低饱和陶土（保留兼容；宜忌主用下方配对色）
    var jiChip: Color
    var onJiChip: Color
    /// 宜/忌 文本+底 配对（D1 细节修 §3）
    var yiText: Color
    var yiBg: Color
    var jiText: Color
    var jiBg: Color
    var solarTermText: Color
    var festivalText: Color
    // P2 罗盘五神色（design P2-F4-COMPASS §3）
    var deityXi: Color
    var deityCai: Color
    var deityFu: Color
    var deityYang: Color
    var deityYin: Color

    static let light = D1Theme(
        bg: Color(hex: 0xF7EBDC), bg1: Color(hex: 0xF7EBDC), bg2: Color(hex: 0xF1C795), bg3: Color(hex: 0xEBB878),
        paper: Color(hex: 0xFFF8EC), red: Color(hex: 0xC0452C), cream: Color(hex: 0xFFF1D8),
        card: Color(hex: 0xFFF8EC), soft: Color(hex: 0xF6E0C2),
        ink: Color(hex: 0x3A2417), ink2: Color(hex: 0x7A4F35), ink3: Color(hex: 0xA67B58),
        line: Color(hex: 0xE7C9A4), accent: Color(hex: 0xE07A3C), accentStrong: Color(hex: 0xC0452C),
        jade: Color(hex: 0x93A98E), onAccent: .white,
        jiChip: Color(hex: 0x7E6A58), onJiChip: .white,
        yiText: Color(hex: 0x3F5A43), yiBg: Color(hex: 0xE7EFE3),
        jiText: Color(hex: 0x8A3E26), jiBg: Color(hex: 0xF6E2D8),
        solarTermText: Color(hex: 0x5E7358), festivalText: Color(hex: 0xA85E3E),
        deityXi: Color(hex: 0xDE9B78), deityCai: Color(hex: 0xC79A5B), deityFu: Color(hex: 0x93A98E),
        deityYang: Color(hex: 0x8FA3B8), deityYin: Color(hex: 0xB08CA8)
    )
    static let dark = D1Theme(
        bg: Color(hex: 0x241710), bg1: Color(hex: 0x241710), bg2: Color(hex: 0x1D110C), bg3: Color(hex: 0x160D09),
        paper: Color(hex: 0x2F2016), red: Color(hex: 0xF08A5C), cream: Color(hex: 0xFFEED4),
        card: Color(hex: 0x2F2016), soft: Color(hex: 0x3A281B),
        ink: Color(hex: 0xF7E6CE), ink2: Color(hex: 0xD9B794), ink3: Color(hex: 0xB08A68),
        line: Color(hex: 0x4A3322), accent: Color(hex: 0xFF9A5C), accentStrong: Color(hex: 0xF08A5C),
        jade: Color(hex: 0xA9BCA3), onAccent: Color(hex: 0x241C16),
        jiChip: Color(hex: 0xC7B5A2), onJiChip: Color(hex: 0x241C16),
        yiText: Color(hex: 0xC9DCC3), yiBg: Color(hex: 0x33402F),
        jiText: Color(hex: 0xF0B49A), jiBg: Color(hex: 0x3F2A22),
        solarTermText: Color(hex: 0xA9BCA3), festivalText: Color(hex: 0xE8A886),
        deityXi: Color(hex: 0xE8A886), deityCai: Color(hex: 0xD6AE72), deityFu: Color(hex: 0xA9BCA3),
        deityYang: Color(hex: 0xA8BCD0), deityYin: Color(hex: 0xC9A8C2)
    )

    static func resolve(_ scheme: ColorScheme) -> D1Theme { scheme == .dark ? .dark : .light }

    // 字体（Songti SC 不存在时回退系统 serif）
    static func serif(_ size: CGFloat, _ weight: Font.Weight = .semibold) -> Font {
        if UIFont(name: "STSongti-SC-Bold", size: size) != nil {
            return .custom("STSongti-SC-Bold", size: size)
        }
        return .system(size: size, weight: weight, design: .serif)
    }
}

private struct D1ThemeKey: EnvironmentKey {
    static let defaultValue: D1Theme = .light
}
extension EnvironmentValues {
    var d1: D1Theme {
        get { self[D1ThemeKey.self] }
        set { self[D1ThemeKey.self] = newValue }
    }
}

extension Color {
    init(hex: UInt32) {
        self.init(.sRGB,
                  red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255,
                  opacity: 1)
    }
}
