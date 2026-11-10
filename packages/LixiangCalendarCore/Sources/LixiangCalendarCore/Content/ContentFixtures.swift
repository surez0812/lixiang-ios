import Foundation

/// P1 本地内置示例内容（PM 口径 2026-11-11）：
/// - 仅用于演示 F5/F6/F7 三态与分段/来源；**不是最终正文**（正式 3 篇由内容团队 compliance-passed 后 P2 接入 B′/WebView）
/// - 不含来源不明图片；正文为示例文案，不得当作最终内容发布
public enum ContentFixtures {
    public static let all: [ContentItem] = [xieZao, qingMing, chuXi, dongZhi]

    public static let xieZao = ContentItem(
        id: "xiezao",
        title: "谢灶",
        category: ["festival", "ritual"],
        dateRule: .lunar(12, 23),
        regionalDates: [
            RegionalDate(id: "north", label: "北方做法 · 腊月廿三", dateRule: .lunar(12, 23)),
            RegionalDate(id: "south", label: "南方做法 · 腊月廿四", dateRule: .lunar(12, 24))
        ],
        teaser: "一年里送灶神上天的日子",
        sections: [
            ContentSection(type: "intro", title: "这是什么日子", paragraphs: ["P1 示例段落：谢灶是农历年末的家庭年俗，各地日期与做法不同。"]),
            ContentSection(type: "prepare", title: "准备什么", paragraphs: ["P1 示例段落：以家庭常见物品为主，具体清单待内容团队定稿。"]),
            ContentSection(type: "steps", title: "传统做法（记述）", paragraphs: ["P1 示例段落：本节仅作民俗文化记述，不提供明火/焚化操作细则。"]),
            ContentSection(type: "safety", title: "安全与环保", paragraphs: ["请遵守当地消防与环保规定；不在禁火区域使用明火。"]),
            ContentSection(type: "notes", title: "说明", paragraphs: ["各地做法不同，此处为常见做法记述；不涉及宗教场所与教职人员。"])
        ],
        sources: [ContentSource(kind: "reference", title: "P1 示例正文（占位）", note: "非最终内容；P2 由内容团队接入")],
        license: "original",
        version: 0
    )

    public static let qingMing = ContentItem(
        id: "qingming",
        title: "清明",
        category: ["festival", "solar_term", "ancestor"],
        dateRule: .solarTerm(term: "清明"),
        regionalDates: nil,
        teaser: "扫墓祭祖、踏青的日子",
        sections: [
            ContentSection(type: "intro", title: "这是什么日子", paragraphs: ["P1 示例段落：清明既是节气，也是祭祖与踏青的传统节日。"]),
            ContentSection(type: "steps", title: "传统做法（记述）", paragraphs: ["P1 示例段落：祭扫与踏青的传统做法记述，具体内容待内容团队定稿。"]),
            ContentSection(type: "safety", title: "安全与环保", paragraphs: ["焚香烧纸请遵守墓园与防火规定；提倡无痕祭扫。"]),
            ContentSection(type: "notes", title: "说明", paragraphs: ["只讲民俗文化，不做吉凶判断。"])
        ],
        sources: [ContentSource(kind: "reference", title: "P1 示例正文（占位）", note: "非最终内容；P2 由内容团队接入")],
        license: "original",
        version: 0
    )

    public static let dongZhi = ContentItem(
        id: "dongzhi",
        title: "冬至",
        category: ["festival", "solar_term"],
        dateRule: .solarTerm(term: "冬至"),
        regionalDates: nil,
        teaser: "冬至大如年，一年里夜最长的一天",
        sections: [
            ContentSection(type: "intro", title: "这是什么日子", paragraphs: ["P1 示例段落：冬至既是节气，也是传统节日，民间有“冬至大如年”的说法。"]),
            ContentSection(type: "steps", title: "传统做法（记述）", paragraphs: ["P1 示例段落：各地有吃饺子、汤圆等不同食俗，具体内容待内容团队定稿。"]),
            ContentSection(type: "notes", title: "说明", paragraphs: ["只讲民俗文化，不做吉凶判断。"])
        ],
        sources: [ContentSource(kind: "reference", title: "P1 示例正文（占位）", note: "非最终内容；P2 由内容团队接入")],
        license: "original",
        version: 0
    )

    public static let chuXi = ContentItem(
        id: "chuxi",
        title: "除夕",
        category: ["festival"],
        dateRule: .lastDayOfLunarMonth(month: 12),
        regionalDates: nil,
        teaser: "一年最后一天，守岁迎新",
        sections: [
            ContentSection(type: "intro", title: "这是什么日子", paragraphs: ["P1 示例段落：除夕是农历腊月的最后一天（可能是廿九或三十）。"]),
            ContentSection(type: "steps", title: "传统做法（记述）", paragraphs: ["P1 示例段落：年夜饭、守岁等年俗的记述，具体内容待内容团队定稿。"]),
            ContentSection(type: "safety", title: "安全与环保", paragraphs: ["遵守当地烟花爆竹禁放规定；注意用火用电与饮酒安全。"]),
            ContentSection(type: "notes", title: "说明", paragraphs: ["各地做法不同，此处为常见做法记述。"])
        ],
        sources: [ContentSource(kind: "reference", title: "P1 示例正文（占位）", note: "非最终内容；P2 由内容团队接入")],
        license: "original",
        version: 0
    )
}
