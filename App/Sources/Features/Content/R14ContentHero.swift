import SwiftUI
import UIKit

/// 12 条内容的 hero 资产（webp 运行时解码，经 Contents/Content/Heroes 目录，不依赖 asset catalog webp 编译）。
@MainActor
enum R14ContentHero {
    struct Meta: Sendable {
        let assetName: String
        let altZH: String
        let altEN: String
    }

    static let fallbackAsset = "winter"
    private static let cache = NSCache<NSString, UIImage>()

    static let mapping: [String: Meta] = [
        "dongzhi": Meta(assetName: "dongzhi", altZH: "冬至，暖黄陶罐（温酒器）", altEN: "Winter solstice, warm yellow wine jar"),
        "qingming": Meta(assetName: "qingming", altZH: "清明，垂柳依依", altEN: "Qingming, weeping willow"),
        "chunjie": Meta(assetName: "chunjie", altZH: "春节，三盏红灯笼", altEN: "Spring Festival, three red lanterns"),
        "zhongqiu": Meta(assetName: "zhongqiu", altZH: "中秋，满月与月饼", altEN: "Mid-Autumn, full moon and mooncakes"),
        "xiayuan": Meta(assetName: "xiayuan", altZH: "下元节，秋日水岸与暖灯", altEN: "Xiayuan, autumn river and warm lanterns"),
        "zhongyuan": Meta(assetName: "zhongyuan", altZH: "中元节，水面河灯与暮色", altEN: "Zhongyuan, river lanterns at dusk"),
        "laba": Meta(assetName: "laba", altZH: "腊八，大碗腊八粥", altEN: "Laba, bowl of porridge"),
        "yulanpen": Meta(assetName: "yulanpen", altZH: "盂兰盆，荷塘白莲", altEN: "Yulanpen, white lotus in a pond"),
        "xiezao": Meta(assetName: "xiezao", altZH: "谢灶，灶台茶壶与橘子", altEN: "Xiezao, stove, teapot and oranges"),
        "jizu": Meta(assetName: "jizu", altZH: "祭祖，窗下白菊与秋阳", altEN: "Ancestral remembrance, chrysanthemums by a window"),
        "shangsi": Meta(assetName: "shangsi", altZH: "上巳，春水柳枝", altEN: "Shangsi, spring river and willow"),
        "chongyang": Meta(assetName: "chongyang", altZH: "重阳，菊花与秋山", altEN: "Chongyang, chrysanthemums and autumn hills"),
    ]

    static var ids: [String] { mapping.keys.sorted() }

    /// DEBUG：强制无 hero，用于 fallback winter 运行时截图（不影响生产）。
    static var forceMissing: Bool {
        #if DEBUG
        ProcessInfo.processInfo.arguments.contains("-LixiangForceMissingHero")
        #else
        false
        #endif
    }

    static func alt(for id: String, language: String = "zh") -> String? {
        guard let meta = mapping[id] else { return nil }
        return language.hasPrefix("en") ? meta.altEN : meta.altZH
    }

    static func assetName(for id: String) -> String? { mapping[id]?.assetName }

    static func uiImage(for id: String, bundle: Bundle = .main, forceMissing: Bool? = nil) -> UIImage? {
        if forceMissing ?? R14ContentHero.forceMissing { return nil }
        guard let meta = mapping[id] else { return nil }
        if let cached = cache.object(forKey: id as NSString) { return cached }
        let candidates: [URL?] = [
            bundle.url(forResource: meta.assetName, withExtension: "webp", subdirectory: "Content/Heroes"),
            bundle.url(forResource: meta.assetName, withExtension: "webp", subdirectory: "Heroes"),
            bundle.url(forResource: meta.assetName, withExtension: "webp"),
        ]
        guard let url = candidates.compactMap({ $0 }).first,
              let data = try? Data(contentsOf: url),
              let image = UIImage(data: data) else { return nil }
        cache.setObject(image, forKey: id as NSString)
        return image
    }

    /// fallback：缺失/解码失败时回退 Home 冬季插画，不出现空图。
    static func image(for id: String, bundle: Bundle = .main) -> Image {
        if let ui = uiImage(for: id, bundle: bundle) { return Image(uiImage: ui) }
        return Image(fallbackAsset)
    }

    static func accessibilityLabel(for id: String, language: String = "zh") -> String {
        alt(for: id, language: language) ?? "岁时插画"
    }
}
