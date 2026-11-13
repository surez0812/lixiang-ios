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
    var amber: Color
    var cream: Color
    var quote1: Color
    var quote2: Color
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
        bg: Color(hex: 0xFFF8EC), bg1: Color(hex: 0xFFF8EC), bg2: Color(hex: 0xF6E8D1), bg3: Color(hex: 0xEAD6B8),
        paper: Color(hex: 0xFFFCF5), red: Color(hex: 0xA63D26), amber: Color(hex: 0xB3863D), cream: Color(hex: 0xFFFCF5),
        quote1: Color(hex: 0xA63D26), quote2: Color(hex: 0xB3863D),
        card: Color(hex: 0xFFFCF5), soft: Color(hex: 0xF6E8D1),
        ink: Color(hex: 0x35291F), ink2: Color(hex: 0x79634D), ink3: Color(hex: 0x9A8570),
        line: Color(hex: 0xE8D6BA), accent: Color(hex: 0xA63D26), accentStrong: Color(hex: 0xA63D26),
        jade: Color(hex: 0x8FA58A), onAccent: .white,
        jiChip: Color(hex: 0x8A7663), onJiChip: .white,
        yiText: Color(hex: 0x3F5A43), yiBg: Color(hex: 0xE7EFE3),
        jiText: Color(hex: 0x8A3E26), jiBg: Color(hex: 0xF6E2D8),
        solarTermText: Color(hex: 0x5E7358), festivalText: Color(hex: 0xA85E3E),
        deityXi: Color(hex: 0xDE9B78), deityCai: Color(hex: 0xC79A5B), deityFu: Color(hex: 0x93A98E),
        deityYang: Color(hex: 0x8FA3B8), deityYin: Color(hex: 0xB08CA8)
    )
    static let dark = D1Theme(
        bg: Color(hex: 0x211D19), bg1: Color(hex: 0x211D19), bg2: Color(hex: 0x403326), bg3: Color(hex: 0x2A231C),
        paper: Color(hex: 0x30281F), red: Color(hex: 0xFFAC88), amber: Color(hex: 0xD9B675), cream: Color(hex: 0xF8ECD8),
        quote1: Color(hex: 0xFFAC88), quote2: Color(hex: 0xD9B675),
        card: Color(hex: 0x30281F), soft: Color(hex: 0x403326),
        ink: Color(hex: 0xF8ECD8), ink2: Color(hex: 0xC9B69C), ink3: Color(hex: 0xA58F76),
        line: Color(hex: 0x69523B), accent: Color(hex: 0xFFAC88), accentStrong: Color(hex: 0xFFAC88),
        jade: Color(hex: 0xA9BCA3), onAccent: Color(hex: 0x211D19),
        jiChip: Color(hex: 0xC7B5A2), onJiChip: Color(hex: 0x211D19),
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

// R14 精确色板（tokens.json）；按系统浅/深动态解析，避免视图里散落旧色值。
extension Color {
    static let r14Red = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor.r14(0xFFAC88) : UIColor.r14(0xA63D26)
    })
    static let r14RedDeep = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor.r14(0x7A2A1A) : UIColor.r14(0x8E2D1C)
    })
    static let r14Gold = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor.r14(0xD9B675) : UIColor.r14(0xB3863D)
    })
    static let r14Ink = Color(uiColor: UIColor { trait in
        trait.userInterfaceStyle == .dark ? UIColor.r14(0xF8ECD8) : UIColor.r14(0x35291F)
    })
}

private extension UIColor {
    static func r14(_ hex: UInt32) -> UIColor {
        UIColor(red: CGFloat((hex >> 16) & 0xFF) / 255,
                green: CGFloat((hex >> 8) & 0xFF) / 255,
                blue: CGFloat(hex & 0xFF) / 255, alpha: 1)
    }
}
