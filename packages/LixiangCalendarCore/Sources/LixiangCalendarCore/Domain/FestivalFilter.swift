import Foundation

/// 月历/日详情只显示「节气 + 中国传统节日 + 中国法定节日」，
/// 过滤掉万圣节/感恩节/情人节/圣诞节等非中国节日（Lead 2026-11-11 验收意见 1）。
public enum FestivalScope: String, Codable, Sendable, CaseIterable {
    /// 中国范围（默认）：节气/传统节日/中国法定节日；过滤西方及其他地区节日
    case cn
}

public enum FestivalFilter {
    /// 中国传统节日（来自农历节日表）
    public static let traditional: Set<String> = [
        "春节", "元宵节", "龙头节", "龙抬头", "上巳节", "寒食节", "清明节", "端午节",
        "七夕节", "中元节", "中秋节", "重阳节", "下元节", "腊八节", "小年", "除夕",
        "填仓节", "祭灶节", "社日节", "天穿节", "浴佛节",
        "寒衣节", "花朝节", "春社", "秋社", "尾牙", "观莲节", "分龙节", "冬至节"
    ]
    /// 中国法定/公历节日（保留少量用户预期项；不含西方节日）
    public static let statutory: Set<String> = ["元旦", "劳动节", "国庆节"]

    public static func filtered(_ names: [String], scope: FestivalScope = .cn) -> [String] {
        switch scope {
        case .cn: return filteredCN(names)
        }
    }

    private static func filteredCN(_ names: [String]) -> [String] {
        var seen = Set<String>()
        return names.filter { name in
            guard traditional.contains(name) || statutory.contains(name) else { return false }
            return seen.insert(name).inserted
        }
    }
}
