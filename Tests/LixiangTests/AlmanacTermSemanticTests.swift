import XCTest
@testable import Lixiang
import LixiangCalendarCore

final class AlmanacTermSemanticTests: XCTestCase {
    private let pack = PlainLanguageLoader.load()

    func testSemanticNamespaceAvoidsCrossDomainHits() {
        let jisi = AlmanacTermSemantics.explanation(for: "祭祀", pack: pack)
        XCTAssertFalse(jisi.contains("寅日"), "祭祀不得命中神煞日解释: \(jisi)")
        XCTAssertFalse(jisi.contains("不宜"), "祭祀定义不得带判断: \(jisi)")

        let juejing = AlmanacTermSemantics.explanation(for: "掘井", pack: pack)
        XCTAssertFalse(juejing.contains("井星"), "掘井不得命中二十八宿解释: \(juejing)")
        XCTAssertFalse(juejing.contains("造作"), "掘井不得命中星宿造作解释: \(juejing)")

        let kaishi = AlmanacTermSemantics.explanation(for: "开市", pack: pack)
        XCTAssertFalse(kaishi.contains("开日"), "开市不得命中建除开日: \(kaishi)")
        XCTAssertFalse(kaishi.contains("建除"), "开市不得命中建除: \(kaishi)")

        let potu = AlmanacTermSemantics.explanation(for: "破土", pack: pack)
        XCTAssertFalse(potu.contains("破日"), "破土不得命中建除破日: \(potu)")
    }

    func testRequiredYiJiTermsCovered() {
        let required = ["祭祀","祈福","求嗣","开光","嫁娶","纳采","订盟","入宅","移徙","安床","修造","动土","起基","上梁","破土","安葬","开市","纳财","交易","立券","出行","赴任","求医","治病","理发","针灸","进人口","整手足甲","栽种","牧养","掘井","开池","放水","开渠","造桥","拆卸","破屋","坏垣","补垣","作灶","造仓","塞穴","平治道涂","扫舍","伐木","捕捉","畋猎","会亲友","词讼","诸事不宜","馀事勿取"]
        let missing = required.filter { pack.term(named: $0) == nil }
        XCTAssertTrue(missing.isEmpty, "yi-ji 词条缺失: \(missing)")
    }

    func testNoBlockedOrPlaceholderDefinitions() {
        let pack = PlainLanguageLoader.load()
        let bad = pack.terms.filter { t in
            let z = t.zh.trimmingCharacters(in: .whitespacesAndNewlines)
            return z.isEmpty || z.hasPrefix("—") || ["禁用","TBD","待补","占位","跳过"].contains { z.contains($0) }
        }
        XCTAssertTrue(bad.isEmpty, "存在 blocked/占位词条: \(bad.map(\.term))")

        let med = pack.terms.filter { t in ["预约","理疗","医嘱","剂量"].contains { t.zh.contains($0) } }
        XCTAssertTrue(med.isEmpty, "存在医疗指令/改义词条: \(med.map { ($0.term, $0.zh) })")
    }

    func testEditorApprovedSemantics() {
        let pack = PlainLanguageLoader.load()
        let jisi = pack.term(named: "祭祀")?.zh ?? ""
        XCTAssertTrue(jisi.contains("家庭纪念") || jisi.contains("追思"), jisi)
        XCTAssertFalse(jisi.hasPrefix("—") || jisi.contains("禁用"), jisi)
        let zaomiao = pack.term(named: "造庙")?.zh ?? ""
        XCTAssertTrue(zaomiao.contains("庙宇") || zaomiao.contains("祠堂"), zaomiao)
        let potu = pack.term(named: "破土")?.zh ?? ""
        XCTAssertTrue(potu.contains("墓地") || potu.contains("阴宅"), potu)
        let dongtu = pack.term(named: "动土")?.zh ?? ""
        XCTAssertTrue(dongtu.contains("阳宅"), dongtu)
        let jinrenkou = pack.term(named: "进人口")?.zh ?? ""
        XCTAssertTrue(jinrenkou.contains("收养") || jinrenkou.contains("新成员"), jinrenkou)
        let zhenjiu = pack.term(named: "针灸")?.zh ?? ""
        XCTAssertTrue(zhenjiu.contains("不替代"), zhenjiu)
        XCTAssertFalse(zhenjiu.contains("理疗"), zhenjiu)
    }

    func testAnzangAndCangDefinitions() {
        let pack = PlainLanguageLoader.load()
        let anzang = pack.term(named: "安葬")?.zh ?? ""
        XCTAssertTrue(anzang.contains("下葬") || anzang.contains("入土"), anzang)
        XCTAssertFalse(anzang.contains("整理") || anzang.contains("遗物") || anzang.contains("收纳"), anzang)
        let cang = pack.term(named: "造仓")?.zh ?? ""
        XCTAssertTrue(cang.contains("仓库") || cang.contains("储存"), cang)
        XCTAssertFalse(cang.contains("收纳柜") || cang.contains("储物间"), cang)
    }

    func testPMEditorApprovedRound2() {
        let pack = PlainLanguageLoader.load()
        let checks: [(String, [String], [String])] = [
            ("安葬", ["安葬", "入土", "墓地"], ["整理遗物", "收纳"]),
            ("祈福", ["祈愿", "祝福", "心愿"], ["散步", "放松"]),
            ("谢土", ["答谢土地"], ["新房清扫", "清扫整理收尾"]),
            ("开光", ["启用仪式", "不构成宗教劝诱"], ["首次清洁", "清洁启用"]),
            ("求嗣", ["祈求子嗣", "家族延续"], ["备孕"]),
        ]
        for (term, musts, forbidden) in checks {
            let zh = pack.term(named: term)?.zh ?? ""
            XCTAssertFalse(zh.isEmpty, "缺词条: \(term)")
            for m in musts { XCTAssertTrue(zh.contains(m), "\(term) 缺关键词 \(m): \(zh)") }
            for f in forbidden { XCTAssertFalse(zh.contains(f), "\(term) 含错误措辞 \(f): \(zh)") }
        }
        let all = pack.terms.map(\.zh)
        let bad = all.filter { z in ["整理遗物", "散步放松", "新房清扫", "首次清洁启用", "备孕计划"].contains { z.contains($0) } }
        XCTAssertTrue(bad.isEmpty, "全量仍有错误释义: \(bad)")
    }

    func testEnglishNeutralAndAligned() {
        let pack = PlainLanguageLoader.load()
        let must: [(String, [String])] = [
            ("安葬", ["burying", "cemetery"]), ("祈福", ["blessings", "wishes"]),
            ("谢土", ["thanks to the land"]), ("开光", ["consecrating"]),
            ("求嗣", ["children", "family continuity"]), ("造仓", ["granary"]),
        ]
        for (term, words) in must {
            let en = pack.term(named: term)?.en ?? ""
            XCTAssertFalse(en.isEmpty, "\(term) 缺英文")
            for w in words { XCTAssertTrue(en.lowercased().contains(w.lowercased()), "\(term) 英文缺 \(w): \(en)") }
        }
        let forbiddenEN = ["Sort and store", "Take a relaxing walk", "Set up shelves", "cleaning", "preparing for pregnancy"]
        let all = pack.terms.map(\.en)
        for f in forbiddenEN {
            XCTAssertFalse(all.contains { $0.localizedCaseInsensitiveContains(f) }, "全量 en 仍含旧措辞: \(f)")
        }
        // zh/en 同义性最低要求：已修正的 6 条 en 不引入宗教劝诱/吉凶/医疗指令
        let forbiddenMeaning = ["religious promotion", "fortune-telling", "medical advice"]
        for term in ["安葬","祈福","谢土","开光","求嗣","造仓"] {
            let en = pack.term(named: term)?.en ?? ""
            XCTAssertFalse(forbiddenMeaning.contains { en.localizedCaseInsensitiveContains($0) && !en.localizedCaseInsensitiveContains("without") && !en.localizedCaseInsensitiveContains("not") && !en.localizedCaseInsensitiveContains("does not") }, "\(term) en 含劝诱/预测/医疗指令: \(en)")
        }
    }

    func testPMEditorApprovedRound3FestivalsAndNayin() {
        let pack = PlainLanguageLoader.load()
        let musts: [(String, [String], [String])] = [
            ("上巳节", ["农历三月初三", "祓禊", "文化说明"], ["散步", "踏青赏花"]),
            ("重阳节", ["农历九月初九", "登高", "敬老"], ["陪长辈", "爬山散步"]),
            ("大林木", ["纳音", "五行", "活动无关"], ["逛公园", "换盆"]),
            ("海中金", ["纳音", "五行", "活动无关"], ["捡贝壳", "海边散步"]),
            ("路旁土", ["纳音", "五行", "活动无关"], ["沿路边", "散步走走"]),
        ]
        for (term, must, forbid) in musts {
            let zh = pack.term(named: term)?.zh ?? ""
            XCTAssertFalse(zh.isEmpty, "缺词条 \(term)")
            for m in must { XCTAssertTrue(zh.contains(m), "\(term) 缺 \(m): \(zh)") }
            for f in forbid { XCTAssertFalse(zh.contains(f), "\(term) 仍含活动句 \(f): \(zh)") }
            let en = pack.term(named: term)?.en ?? ""
            XCTAssertFalse(en.isEmpty, "\(term) 缺英文")
            XCTAssertFalse(en.lowercased().contains("walk"), "\(term) en 仍含活动句: \(en)")
        }
        // 本次范围 5 条已修；其它活动式词条（如 山头火）留待 PM 追加审校，不在此断言全量
    }

    func testFallbackIsNeutral() {
        let text = AlmanacTermSemantics.explanation(for: "不存在的词条XYZ", pack: pack)
        XCTAssertTrue(text.contains("传统黄历用语"))
        XCTAssertFalse(text.contains("寅日") || text.contains("建除") || text.contains("星宿"))
    }
}
