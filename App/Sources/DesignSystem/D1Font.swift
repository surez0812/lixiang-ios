import UIKit
import SwiftUI

/// M-1 字号体系：语义字阶 + Dynamic Type（@ScaledMetric），标题类上限 1.4×。
struct D1FontModifier: ViewModifier {
    @ScaledMetric private var scaled: CGFloat
    private let base: CGFloat
    private let weight: Font.Weight
    private let design: Font.Design
    private let maxScale: CGFloat

    init(size: CGFloat, weight: Font.Weight = .regular, design: Font.Design = .default, maxScale: CGFloat = 2.0) {
        self.base = size
        self.weight = weight
        self.design = design
        self.maxScale = maxScale
        _scaled = ScaledMetric(wrappedValue: size, relativeTo: .body)
    }

    func body(content: Content) -> some View {
        content.font(.system(size: min(scaled, base * maxScale), weight: weight, design: design))
    }
}

extension View {
    /// 正文/UI 字号：随 Dynamic Type 缩放（上限 2.0×）
    func d1Font(_ size: CGFloat, weight: Font.Weight = .regular) -> some View {
        modifier(D1FontModifier(size: size, weight: weight))
    }
    /// R2-rich 楷体（大日期/quote）：DT 上限 1.2×
    func d1Kaiti(_ size: CGFloat, weight: Font.Weight = .regular) -> some View {
        modifier(D1KaitiModifier(size: size, weight: weight))
    }
    /// 大数字（108pt 基线）：DT 上限 1.2×（R2-rich §2）
    func d1NumberFont(_ size: CGFloat, weight: Font.Weight = .semibold) -> some View {
        modifier(D1FontModifier(size: size, weight: weight, design: .default, maxScale: 1.2))
    }
    /// 标题/大数字（宋体）：随 DT 缩放但上限 1.4×（A16 验收）
    func d1SerifFont(_ size: CGFloat, weight: Font.Weight = .regular) -> some View {
        modifier(D1FontModifier(size: size, weight: weight, design: .serif, maxScale: 1.4))
    }
}

// 兼容 Text/Image 直接链式调用（这些位置由外层 View 的 Dynamic Type 语义字阶覆盖不完整，
// 后续 M-1 收尾时统一改为容器级语义字阶；此处保证可编译并保留原字号）。
extension Text {
    func d1Font(_ size: CGFloat, weight: Font.Weight = .regular) -> Text {
        font(.system(size: size, weight: weight))
    }
    func d1SerifFont(_ size: CGFloat, weight: Font.Weight = .regular) -> Text {
        font(.system(size: size, weight: weight, design: .serif))
    }
}


/// 楷体（Kaiti SC）：R2-rich 大日期/quote 专用；上限 1.2×
struct D1KaitiModifier: ViewModifier {
    @ScaledMetric private var scaled: CGFloat
    private let base: CGFloat
    private let weight: Font.Weight
    init(size: CGFloat, weight: Font.Weight = .regular) {
        self.base = size; self.weight = weight
        _scaled = ScaledMetric(wrappedValue: size, relativeTo: .largeTitle)
    }
    func body(content: Content) -> some View {
        let size = min(scaled, base * 1.2)
        let candidates = ["Kaiti SC", "KaitiSC", "STKaiti", "STKaitiSC", "KaiTi", "Kaiti"]
        var resolved: String? = candidates.first(where: { UIFont(name: $0, size: size) != nil })
        if resolved == nil,
           let family = UIFont.familyNames.first(where: { $0.localizedCaseInsensitiveContains("Kaiti") || $0.localizedCaseInsensitiveContains("Kai") }),
           let name = UIFont.fontNames(forFamilyName: family).first {
            resolved = name
        }
        let kaiti: Font? = resolved.map { Font.custom($0, size: size) }
        return content.font(kaiti.map { $0.weight(weight) } ?? .system(size: size, weight: weight, design: .serif))
    }
}
