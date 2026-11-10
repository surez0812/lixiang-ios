import Foundation

public enum YiJiKind: String, Sendable { case yi, ji }

public enum YiJiCategory: String, CaseIterable, Codable, Sendable, Identifiable {
    case worship, marriage, travel, construction, trade, funeral, other, avoidAll
    public var id: String { rawValue }
    public var title: String {
        switch self {
        case .worship: return "祭祀祈福"
        case .marriage: return "婚嫁会友"
        case .travel: return "出行迁移"
        case .construction: return "修造动土"
        case .trade: return "开市交易"
        case .funeral: return "安葬入殓"
        case .other: return "其他"
        case .avoidAll: return "诸事不宜"
        }
    }
}

public struct YiJiGroup: Identifiable, Hashable, Sendable {
    public var category: YiJiCategory
    public var items: [String]
    public var id: String { category.rawValue }
}

public enum YiJiItems {
    /// 归一：trim + 全角/半角 + 去空格（用于完全同词去重）
    public static func normalized(_ item: String) -> String {
        item.trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "\u{3000}", with: "")
    }

    /// 宜忌去重（FRD v1.2 / D1 细节修 §2）：
    /// - 完全同词去重；同一词跨「宜/忌」只保留一次（宜优先，返回 duplicates 供数据健康度告警）
    /// - 近义词不合并
    public static func dedupe(yi: [String], ji: [String]) -> (yi: [String], ji: [String], duplicates: [String]) {
        var seeYi = Set<String>()
        var yiClean: [String] = []
        for item in yi where item != "无" {
            let key = normalized(item)
            if seeYi.insert(key).inserted { yiClean.append(item) }
        }
        var duplicates: [String] = []
        var jiClean: [String] = []
        var seeJi = Set<String>()
        for item in ji where item != "无" {
            let key = normalized(item)
            if seeYi.contains(key) {
                if !duplicates.contains(item) { duplicates.append(item) }
                continue
            }
            if seeJi.insert(key).inserted { jiClean.append(item) }
        }
        return (yiClean, jiClean, duplicates)
    }
}

public enum YiJiGrouping {
    private static let keywordTable: [(YiJiCategory, [String])] = [
        (.worship, ["祭祀", "祈福", "求嗣", "斋醮", "开光", "酬神", "谢土", "解除", "沐浴", "平治道涂", "造庙", "入殓", "除服", "成服", "开生坟", "合寿木", "扫舍", "立券", "安香", "启钻"]),
        (.marriage, ["嫁娶", "纳采", "订盟", "冠笄", "会亲友", "裁衣", "纳畜", "教牛马", "造畜稠", "进人口"]),
        (.travel, ["出行", "赴任", "移徙", "入宅", "安床", "分居", "栽种", "牧养", "结网", "塞穴", "补垣"]),
        (.construction, ["修造", "动土", "起基", "上梁", "破土", "拆卸", "安门", "作灶", "造仓", "修坟", "盖屋", "竖柱", "开池", "放水", "平治道涂", "挂匾", "造车器", "雕刻", "开渠", "掘井", "造桥", "合脊"]),
        (.trade, ["开市", "交易", "纳财", "立券", "出货财", "开仓", "造仓", "修置产"]),
        (.funeral, ["安葬", "移柩", "入殓", "除服", "成服", "开生坟", "合寿木", "破土", "启钻", "修坟", "立碑"]),
        (.avoidAll, ["诸事不宜"])
    ]

    public static func groups(for items: [String], kind: YiJiKind) -> [YiJiGroup] {
        if items.contains("诸事不宜") {
            return [YiJiGroup(category: .avoidAll, items: ["诸事不宜"])]
        }
        var buckets: [YiJiCategory: [String]] = [:]
        for item in items where item != "无" {
            let category = category(for: item)
            buckets[category, default: []].append(item)
        }
        return YiJiCategory.allCases.compactMap { c in
            guard let list = buckets[c], !list.isEmpty else { return nil }
            return YiJiGroup(category: c, items: list)
        }
    }

    public static func category(for item: String) -> YiJiCategory {
        for (category, keywords) in keywordTable where keywords.contains(where: { item.contains($0) }) {
            return category
        }
        return .other
    }
}
