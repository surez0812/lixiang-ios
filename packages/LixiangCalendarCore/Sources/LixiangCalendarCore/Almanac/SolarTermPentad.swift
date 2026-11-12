import Foundation

/// 二十四节气 · 七十二候（每候 5 天）；数据固化（公版传统候名）
public enum SolarTermPentad {
    public static let names: [String: [String]] = [
        "立春": ["东风解冻", "蛰虫始振", "鱼陟负冰"],
        "雨水": ["獭祭鱼", "候雁北", "草木萌动"],
        "惊蛰": ["桃始华", "仓庚鸣", "鹰化为鸠"],
        "春分": ["玄鸟至", "雷乃发声", "始电"],
        "清明": ["桐始华", "田鼠化为鴽", "虹始见"],
        "谷雨": ["萍始生", "鸣鸠拂其羽", "戴胜降于桑"],
        "立夏": ["蝼蝈鸣", "蚯蚓出", "王瓜生"],
        "小满": ["苦菜秀", "靡草死", "麦秋至"],
        "芒种": ["螳螂生", "鵙始鸣", "反舌无声"],
        "夏至": ["鹿角解", "蜩始鸣", "半夏生"],
        "小暑": ["温风至", "蟋蟀居壁", "鹰始挚"],
        "大暑": ["腐草为萤", "土润溽暑", "大雨时行"],
        "立秋": ["凉风至", "白露降", "寒蝉鸣"],
        "处暑": ["鹰乃祭鸟", "天地始肃", "禾乃登"],
        "白露": ["鸿雁来", "玄鸟归", "群鸟养羞"],
        "秋分": ["雷始收声", "蛰虫坯户", "水始涸"],
        "寒露": ["鸿雁来宾", "雀入大水为蛤", "菊有黄华"],
        "霜降": ["豺乃祭兽", "草木黄落", "蛰虫咸俯"],
        "立冬": ["水始冰", "地始冻", "雉入大水为蜃"],
        "小雪": ["虹藏不见", "天气上升地气下降", "闭塞而成冬"],
        "大雪": ["鹖鴠不鸣", "虎始交", "荔挺出"],
        "冬至": ["蚯蚓结", "麋角解", "水泉动"],
        "小寒": ["雁北乡", "鹊始巢", "雉始雊"],
        "大寒": ["鸡始乳", "征鸟厉疾", "水泽腹坚"]
    ]

    /// 返回 (节气, 第几候 1...3, 候名, 该节气第几天)；找不到返回 nil
    public static func info(for date: LocalDate, engine: any CalendarEngine) -> (term: String, index: Int, name: String, day: Int)? {
        for back in 0...20 {
            let d = date.adding(days: -back)
            guard let term = engine.almanac(d, hour: 12).solarTerm, names[term] != nil else { continue }
            // 向前找该节气首日
            var start = d
            for b in 1...20 {
                let prev = d.adding(days: -b)
                if engine.almanac(prev, hour: 12).solarTerm == term { start = prev } else { break }
            }
            let day = max(1, start.daysBetween(date) + 1)
            let idx = min(2, max(0, (day - 1) / 5))
            return (term, idx + 1, names[term]![idx], day)
        }
        return nil
    }

    public static func badge(for date: LocalDate, engine: any CalendarEngine) -> String? {
        guard let i = info(for: date, engine: engine) else { return nil }
        return "\(i.term) · \(["一","二","三"][i.index - 1])候 \(i.name)"
    }
}
