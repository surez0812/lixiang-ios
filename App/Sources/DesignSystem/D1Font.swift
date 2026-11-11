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
