import Foundation

/// 道历/佛历展示层规则（不改上游库表；PM religion-check PASS-with-fixes 2026-11-11）
/// 规则：HIGH 错字替换 / 非劝诱名称中性化 / 历法术语与 v1.0 敏感条目不展示 / 传承归属标注。
public enum ReligionDisplay {

    /// 道历展示名（返回 nil = v1.0 不展示）
    public static func taoName(_ raw: String) -> String? {
        if taoHidden.contains(raw) { return nil }
        return taoMap[raw] ?? raw
    }

    /// 佛历展示名（返回 nil = v1.0 不展示；`result` 吉凶字段不对外）
    public static func fotoName(_ raw: String) -> String? {
        if fotoHidden.contains(raw) { return nil }
        return fotoMap[raw] ?? raw
    }

    public static var disclaimer: String {
        "道历/佛历为传统历法民俗参考，非宗教劝诱、非吉凶预测；名称与日期存在传承/地区差异。"
    }

    // MARK: - HIGH 名称错字（4 条）
    static let taoMap: [String: String] = [
        "地祗温元帅圣诞": "地祇温元帅圣诞",
        "北极紫徽大帝降": "北极紫微大帝降",
        "紫徽大帝诞": "紫微大帝诞",
        "汉恒候张显王诞": "汉桓侯张显王诞",
        // MED：去因果裁定，保留客观事件
        "五帝校定生人官爵": "五帝下降",
        "五帝校生人善恶": "五帝下降",
        "司今朝天奏人善恶": "司命朝天",
        "天腊，玉帝校世人神气禄命": "天腊之辰",
        "诸神下降，察访善恶": "诸神下降",
        "三清玉帝同降，考察善恶": "三清玉帝同降",
        "诸神考校": "诸神下降",
        // 别名规范化
        "财帛星君文财神增福相公李诡祖圣诞": "增福财神圣诞",
        "慈航(观音)成道日": "慈航成道日（道教）· 观音成道日（佛教）",
        "太清道德天尊(太上老君)圣诞": "太清道德天尊圣诞（太上老君）",
        "虚靖天师(即三十代天师弘悟张真人)诞": "虚靖天师诞"
    ]
    static let taoHidden: Set<String> = ["月朔", "月望", "月晦", "宜戒"]

    // MARK: - 佛历（v1.0 不展示 + result 不对外）
    static let fotoMap: [String: String] = [:]
    static let fotoHidden: Set<String> = ["月朔", "月望", "月晦", "牛鬼神出", "九毒日", "阴毒日", "宜戒"]
}
