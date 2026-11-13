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
            ("上巳节", ["农历三月初三", "祓禊", "文化传统"], ["散步", "踏青赏花"]),
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

    func testPMEditorApprovedRound4FullScan33() {
        let pack = PlainLanguageLoader.load()
        let nayin = ["大林木","大海水","天上火","山头火","海中金","路旁土","大驿土","沙中土","钗钏金"]
        let festivals = ["上巳节","下元节","中元节","元宵节","劳动节","社日节","端午节","观莲节","重阳节","龙头节"]
        let terms = ["金匮","玄武","玉堂","闭","开","收","参","奎","室","心","氐","鬼","鸣吠","母仓"]
        let activity = ["爬山","逛公园","散步","看日出","捡贝壳","游泳","晒被子","出门","收拾","整理","戴首饰","堆沙堡","打疫苗","催收","跑步","车站","赏花","赏菊","陪长辈","去"]
        for term in nayin {
            let zh = pack.term(named: term)?.zh ?? ""
            let en = pack.term(named: term)?.en ?? ""
            XCTAssertTrue(zh.contains("纳音") && zh.contains("活动无关"), "\(term) 纳音释义不完整: \(zh)")
            XCTAssertTrue(en.lowercased().contains("nayin") && en.lowercased().contains("not an activity"), "\(term) en 不完整: \(en)")
            for a in activity { XCTAssertFalse(zh.contains(a), "\(term) 仍含活动短语 \(a): \(zh)") }
        }
        for term in festivals {
            let zh = pack.term(named: term)?.zh ?? ""
            let en = pack.term(named: term)?.en ?? ""
            XCTAssertTrue(zh.contains("节日") || zh.contains("公历五月一日"), "\(term) 非节日释义: \(zh)")
            XCTAssertTrue(en.lowercased().contains("festival") || en.lowercased().contains("holiday"), "\(term) en 非节日: \(en)")
            for a in ["去", "陪", "赏", "逛"] { XCTAssertFalse(zh.contains(a), "\(term) 仍含活动建议 \(a): \(zh)") }
        }
        for term in terms {
            let zh = pack.term(named: term)?.zh ?? ""
            let en = pack.term(named: term)?.en ?? ""
            XCTAssertTrue(zh.contains("传统历法术语") || zh.contains("传统择日"), "\(term) 非术语释义: \(zh)")
            XCTAssertFalse(zh.contains("宜做") || zh.contains("宜 "), "\(term) 写成宜做某事: \(zh)")
            XCTAssertTrue(en.lowercased().contains("traditional almanac term"), "\(term) en 非术语: \(en)")
        }
        // 全量分类扫描：纳音/值神/28宿/建除不得写成活动句
        let nayinAll = ["海中金","炉中火","大林木","路旁土","剑锋金","山头火","涧下水","城头土","白蜡金","杨柳木","泉中水","屋上土","霹雳火","松柏木","长流水","沙中金","山下火","平地木","壁上土","金箔金","覆灯火","天河水","大驿土","钗钏金","桑柘木","大溪水","沙中土","天上火","石榴木","大海水"]
        for term in nayinAll {
            let zh = pack.term(named: term)?.zh ?? ""
            XCTAssertTrue(zh.contains("纳音") && zh.contains("活动无关"), "\(term) 纳音仍漂移: \(zh)")
        }
        let valueGods = ["青龙","明堂","天刑","朱雀","金匮","天德","白虎","玉堂","天牢","玄武","司命","勾陈"]
        for term in valueGods {
            let zh = pack.term(named: term)?.zh ?? ""
            XCTAssertTrue(zh.contains("值神名") || zh.contains("传统历法术语"), "\(term) 值神仍漂移: \(zh)")
        }
        let mansions = Array("角亢氐房心尾箕斗牛女虚危室壁奎娄胃昴毕觜参井鬼柳星张翼轸").map(String.init)
        let officers = ["建","除","满","平","定","执","破","危","成","收","开","闭"]
        for term in mansions + officers where term != "危" {
            let zh = pack.term(named: term)?.zh ?? ""
            XCTAssertTrue(zh.contains("传统历法术语"), "\(term) 星宿/建除仍漂移: \(zh)")
        }
        // en 祈使动词开头 = 0（Go/See/Get/Visit/Take/Make/Try/Enjoy）
        let imperative = try! NSRegularExpression(pattern: "^\\s*(Go|See|Get|Visit|Take|Make|Try|Enjoy)\\b", options: [.caseInsensitive])
        for t in pack.terms {
            let r = NSRange(t.en.startIndex..<t.en.endIndex, in: t.en)
            XCTAssertNil(imperative.firstMatch(in: t.en, options: [], range: r), "\(t.term) en 以祈使动词开头: \(t.en)")
        }
        let activityVerbs = ["去","陪","逛","散步","爬山","收拾","整理","赏花","赏菊","出门"]
        for t in pack.terms {
            XCTAssertFalse(t.zh.isEmpty || t.en.isEmpty, "\(t.term) zh/en 为空")
            if nayinAll.contains(t.term) || valueGods.contains(t.term) || mansions.contains(t.term) || officers.contains(t.term) {
                for v in activityVerbs { XCTAssertFalse(t.zh.contains(v), "\(t.term) 仍含活动动词 \(v): \(t.zh)") }
            }
        }
    }

    func testJisiEnglishNotBlocked() {
        let pack = PlainLanguageLoader.load()
        let t = pack.term(named: "祭祀")
        XCTAssertNotNil(t)
        let zh = t?.zh ?? "", en = t?.en ?? ""
        for marker in ["—", "blocked", "TBD", "待补", "placeholder"] {
            XCTAssertFalse(zh.contains(marker), "祭祀 zh 含占位: \(zh)")
            XCTAssertFalse(en.lowercased().contains(marker.lowercased()), "祭祀 en 含占位: \(en)")
        }
        XCTAssertTrue(en.contains("offerings") && en.contains("remembrance"), "祭祀 en 未对齐: \(en)")
        // 全量 en 占位扫描
        for term in pack.terms {
            for marker in ["—", "blocked", "TBD", "待补", "placeholder"] {
                XCTAssertFalse(term.en.lowercased().contains(marker.lowercased()), "\(term.term) en 含占位 \(marker): \(term.en)")
            }
        }
    }

    func testFallbackIsNeutral() {
        let text = AlmanacTermSemantics.explanation(for: "不存在的词条XYZ", pack: pack)
        XCTAssertTrue(text.contains("传统黄历用语"))
        XCTAssertFalse(text.contains("寅日") || text.contains("建除") || text.contains("星宿"))
    }
}
