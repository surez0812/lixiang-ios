import UIKit
import SwiftUI

/// 字体解析：R14 设计期望宋体（Songti SC）。iOS 系统未必内置该字体，
/// 因此先按 PostScript 名探测，缺失时回退系统 serif，并在 DEBUG 输可用性。
enum D1Typography {
    static let songtiPostScriptNames = [
        "NotoSerifCJKsc-Bold", "NotoSerifCJKsc-Regular",
        "STSongti-SC-Bold", "STSongti-SC-Regular", "STSongti-SC-Light",
        "STSongtiSC-Bold", "STSongtiSC-Regular", "Songti SC"
    ]
    /// 内置开源宋体（Noto Serif SC，SIL OFL 1.1）；字重分 Regular/Bold 两个静态字面。
    static let notoSerifBold = "NotoSerifCJKsc-Bold"
    static let notoSerifRegular = "NotoSerifCJKsc-Regular"
    static let kaitiPostScriptNames = [
        "Kaiti SC", "KaitiSC-Regular", "STKaiti", "STKaitiSC", "KaiTi", "Kaiti"
    ]

    static func availableFontName(from candidates: [String]) -> String? {
        candidates.first { UIFont(name: $0, size: 17) != nil }
    }

    static func serifFont(size: CGFloat, weight: Font.Weight) -> Font {
        // 内置 Noto Serif SC：按 weight 选静态字面（Regular/Bold），避免 synthetic bold。
        let isBold = weight == .bold || weight == .semibold || weight == .heavy || weight == .black
        let noto = isBold ? [notoSerifBold, notoSerifRegular] : [notoSerifRegular, notoSerifBold]
        if let name = availableFontName(from: noto) {
            return .custom(name, size: size)
        }
        if let name = availableFontName(from: songtiPostScriptNames) {
            return .custom(name, size: size).weight(weight)
        }
        return .system(size: size, weight: weight, design: .serif)
    }

    static func kaitiFont(size: CGFloat, weight: Font.Weight) -> Font {
        if let name = availableFontName(from: kaitiPostScriptNames) {
            return .custom(name, size: size).weight(weight)
        }
        return .system(size: size, weight: weight, design: .serif)
    }

    static func availabilityReport() -> String {
        let families = UIFont.familyNames
            .filter { $0.localizedCaseInsensitiveContains("songti") || $0.localizedCaseInsensitiveContains("kaiti") || $0.localizedCaseInsensitiveContains("kai") }
            .sorted()
        let lines = families.map { fam in "\(fam): \(UIFont.fontNames(forFamilyName: fam).joined(separator: ","))" }
        let chosen = availableFontName(from: [notoSerifRegular]) ?? availableFontName(from: songtiPostScriptNames) ?? "fallback:system-serif"
        return "D1Typography fonts\n" + lines.joined(separator: "\n") + "\nnoto_serif=\(UIFont(name: notoSerifRegular, size: 17) != nil)\nsongti_chosen=\(chosen)"
    }
}

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
        let size = min(scaled, base * maxScale)
        if design == .serif {
            return content.font(D1Typography.serifFont(size: size, weight: weight))
        }
        return content.font(.system(size: size, weight: weight, design: design))
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
        font(D1Typography.serifFont(size: size, weight: weight))
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
        return content.font(D1Typography.kaitiFont(size: size, weight: weight))
    }
}
