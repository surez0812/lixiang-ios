# 宜忌白话编辑审校（PM，只读）

- 2026-11-14｜对象：`content/drafts/plain-language/json/yi-ji-mapping.json`（260 条）与 App 同源；只读审校，不改代码/内容
- 依据：已批准内容规则（民俗参考、不预测/不恐吓/不劝诱、不替代医疗、来源公版）；Codex 编辑口径确认
- 扫描：260 条中 **2 条占位**（`—（禁用…）`）、无 TBD/待补/暂无；其余字段完整

## 1. P0：占位被当解释（必修）
| 词条 | 现状 | 判定 | 建议最终措辞（zh / en） |
|---|---|---|---|
| **祭祀** | `—（禁用：宗教类术语）` | **内容缺口**：不能作为白话；若 UI 显示「已解释」= 误导 | **中性版**：「传统民俗中指备办供品、行礼表达追思与敬意的活动；现代可理解为家庭纪念/追思，按个人与家庭习惯，不作宗教劝诱、不预测。」/ "A traditional folk practice of making offerings and paying respects; today it can be understood as family remembrance, following personal and family custom." |
| **造庙** | `—（禁宗教词，跳过）` | 同上，**内容缺口** | 「传统民俗/历史语境中指修建庙宇、祠堂等祭祀建筑；可作为历史文化知识了解，不构成宗教劝诱。」/ "Historically, building temples or ancestral halls; understood as cultural history, not religious persuasion." |

**若审核仍不允许宗教相关表述**：两条都**不得显示为「已解释」**——UI 隐藏白话入口/徽标，或标「本词条暂不提供白话」，不得把「—（禁用）」当解释。

## 2. P1：破土 vs 动土（语义混淆）
| 词条 | 现状 | 问题 |
|---|---|---|
| 破土 | 「开挖地基、动第一锹土」 | 与动土**完全相同**；传统多用于**墓地/阴宅开挖、安葬**语境（也泛指动第一锹土） |
| 动土 | 「开挖地基平整土地」 | 传统多用于**阳宅建筑/修造开工**，范围更广 |
**推荐措辞**：
- 破土：「传统上多指墓地/阴宅开挖或安葬相关的动土，也泛指动第一锹土；现代工程施工以规范为准。」/ "Traditionally ground-breaking for graves/burial, also the first spadeful; modern work follows codes."
- 动土：「传统上多指阳宅建筑开工、翻土修造；不等于所有破土/安葬事项。」/ "Traditionally starting building or renovation on residential property."

## 3. P1：生活化改写是否改义
| 词条 | 现状 | 问题 | 推荐措辞 |
|---|---|---|---|
| 进人口 | 「迎接新生儿或领养孩子」 | **窄化**：传统含收养/接纳新成员（不限新生儿） | 「迎接新成员加入家庭（如收养、接家人同住）；传统也指接纳人口。」/ "Welcoming a new family member, including adoption or a relative moving in." |
| 针灸 | 「预约做一次肩颈理疗」 | **改义 + 医疗建议**：针灸≠肩颈理疗，且“预约理疗”是行动指令 | 「进行针灸治疗（传统民俗参考，不替代医疗建议；治疗请遵医嘱）。」/ "Acupuncture treatment; folk reference only, not medical advice." |

## 4. P2：其他抽查
- 260 条中除上述 2 条外，无「—/TBD/待补/暂无/禁用」占位
- 未发现「为传统黄历用语，是否适合…」泛化句（该句式在当前 mapping 中 0 条）
- 建议后续全量人工抽检：含「祭祀/祈福/开光/安葬/破土/动土」等敏感词条，确认口径一致

## 5. 结论与动作
1. **祭祀/造庙**：给中性释义，或明确「不显示为已解释」——二选一，不能保留占位当解释
2. **破土/动土**：拆分为不同措辞（上述）
3. **进人口/针灸**：按推荐改回中性、无医疗指令
4. 以上为内容建议，**未改 JSON/代码**；需 owner 执行并回归扫描（0 占位、0 医疗指令、敏感词双人复核）

## 6. 追加（2026-11-14）：Codex b3d89116 运行时问题 —「安葬」误写

### P0 安葬（必修）
- 现状：`安葬 => 整理故人遗物妥善收纳`（讲整理遗物，**不是下葬**）
- 判定：**语义错误**，不能作为解释；用户可见会误导
- **建议最终措辞**：`传统民俗中指将逝者安葬入土、或安置于墓地的仪式；各地做法不同，此处仅作文化说明，不涉及宗教劝诱或吉凶预测。`
- en: `Traditional funerary rite of burying the deceased or placing them in a cemetery; regional customs vary; cultural note only.`

### 同类「生活化改写导致改义」抽查（建议一并修）
| 词条 | 现状 | 问题 | 建议 |
|---|---|---|---|
| **祈福** | 「去公园散步放松身心」 | 完全改义：祈福≠散步 | 「传统民俗中指祈愿祝福、表达心愿的活动；可理解为对美好生活的祝愿，不涉及宗教劝诱或预测。」 |
| **谢土** | 「新房完工后清扫整理收尾」 | 漏掉核心：谢土=工程/建房后答谢土地的传统仪式 | 「传统民俗中指建房/工程完工后答谢土地的仪式；现代可理解为完工收尾的民俗纪念。」 |
| **开光** | 「给新物件做首次清洁启用」 | 改义：开光≠清洁 | 「传统民俗中指为神像/器物举行启用仪式；作为文化知识了解，不构成宗教劝诱。」若审核不允许，UI 不显示为已解释 |
| **求嗣** | 「和家人商量备孕计划」 | 偏现代、丢失传统语义 | 「传统民俗中指祈求子嗣/家族延续；现代可理解为家庭生育计划的文化表述。」 |
| 修坟/立碑/入殓/成服/移柩/启钻/合寿木 | 现有措辞基本对应 | — | 保留，建议与安葬统一「传统民俗指…」句式 |
- 扫描：mapping 260 条中丧葬相关 8 条；**「整理遗物」类误写仅安葬 1 条**；另发现祈福/谢土/开光 3 条改义（非「遗物」但同属语义漂移）
- 未改 JSON/代码；需内容 owner 执行后回归扫描（0 占位、0 改义、敏感词双人复核）

## 7. 追加（2026-11-14）：6 条修正词的中性英文（en 会显示在 PlainTermSheet）

- 背景：Codex 确认 `PlainTermSheet` 显示 `t.en`；仅改 zh 不够 → 以下 **zh 与 en 必须成对更新**；不涉宗教劝诱/吉凶预测/医疗指令
- 建议最终文案（可直接落 mapping）：

| 词条 | 建议 zh | 建议 en |
|---|---|---|
| **安葬** | 传统民俗中指将逝者安葬入土、或安置于墓地的仪式；各地做法不同，此处仅作文化说明，不涉及宗教劝诱或吉凶预测。 | Traditional funerary rite of burying the deceased or placing them in a cemetery; regional customs vary; cultural note only. |
| **祈福** | 传统民俗中指祈愿祝福、表达心愿的活动；可理解为对美好生活的祝愿，不涉及宗教劝诱或预测。 | Traditional folk practice of offering blessings and wishes; a cultural expression of hope, not religious persuasion or prediction. |
| **谢土** | 传统民俗中指建房或工程完工后答谢土地的仪式；现代可理解为完工收尾的民俗纪念。 | Traditional rite of giving thanks to the land after building or construction is completed; a cultural closing custom. |
| **开光** | 传统民俗中指为神像或器物举行启用仪式；仅作文化知识了解，不构成宗教劝诱。 | Traditional rite of consecrating a statue or ritual object; cultural knowledge only, not religious persuasion. |
| **求嗣** | 传统民俗中指祈求子嗣、家族延续；现代可理解为家庭生育计划的文化表述。 | Traditional folk wish for children and family continuity; a cultural expression of family planning. |
| **造仓** | 传统民俗中指建造粮仓/仓库；现代可理解为修造储物空间。 | Traditional term for building a granary or storehouse; modern equivalent: constructing storage space. |

- 说明：现 mapping 中 6 条 zh/en 均为旧生活化改写（如 安葬 "Sort and store departed one's belongings"、祈福 "Take a relaxing walk outdoors"、造仓 "Set up shelves, organize storage room"），**zh/en 需同时替换**
- 未改代码；落库后回归：`t.zh`/`t.en` 同步、无宗教劝诱词（灵验/保佑/功德/改运）、无医疗指令、无「整理遗物/散步/收纳柜」等改义

## 8. 追加（2026-11-14）：5 条语义疑点（活动建议 ≠ 术语释义）

| 词条 | 现状 | 问题 | 建议 zh | 建议 en |
|---|---|---|---|---|
| **上巳节** | 去河边散步踏青赏花 | 把节日写成活动建议 | 传统节日，农历三月初三；旧俗临水祓禊、踏青游春，各地做法不同；此处仅作文化说明。 | Traditional festival on the third day of the third lunar month; old customs include riverside purification and spring outings; cultural note only. |
| **重阳节** | 陪长辈爬山散步 | 把节日写成活动建议 | 传统节日，农历九月初九；旧俗登高、赏菊、敬老，现代延续敬老文化；仅作民俗文化说明。 | Traditional festival on the ninth day of the ninth lunar month; old customs include climbing, chrysanthemum viewing and honoring elders; cultural note. |
| **大林木** | 逛公园散步，给绿植换盆 | 纳音名被写成活动 | 六十甲子纳音之一，传统五行分类名称，用于纪年/文化标识；与日常活动无关。 | A nayin (sexagenary cycle) element name, a traditional Five-Elements classification label; not an activity. |
| **海中金** | 去海边散步捡贝壳 | 纳音名被写成活动 | 同上：纳音五行名称，传统分类标识，非活动。 | A nayin element name, traditional classification label; not an activity. |
| **路旁土** | 沿路边散步走走 | 纳音名被写成活动 | 同上：纳音五行名称，传统分类标识，非活动。 | A nayin element name, traditional classification label; not an activity. |
| （造仓已列 §7） | — | — | — | — |
- 判定：5 条均为**语义漂移**（节日→活动、纳音→活动），不得作为释义；zh/en 成对替换
- 扫描建议：对节日类/纳音类/神煞类术语统一套「是什么/文化背景」句式，禁止写成「去…/陪…/逛…」活动句

## 9. 追加（2026-11-14）：山头火 + 全量「纳音/节日名当活动」遗漏扫描

### 9.1 山头火（新增，必修）
- 现状：`山头火 => 早起爬山看日出`（纳音名被写成活动）
- 建议 zh：`六十甲子纳音之一，属火类，是传统五行分类/纪年标识；与日常活动无关，仅作文化知识。`
- 建议 en：`A nayin (sexagenary cycle) fire-type element name; a traditional Five-Elements classification label; not an activity.`

### 9.2 全量扫描结果（同类语义漂移，共 33 条）
判定口径：术语应为「是什么/文化背景」，不能写成「去…/陪…/逛…」活动句；下列需 zh/en 成对重写。

**A. 纳音名当活动（9 条）**
`大林木`(逛公园换盆)、`大海水`(去游泳)、`天上火`(晒被子)、`山头火`(爬山看日出)、`海中金`(海边捡贝壳)、`路旁土`(沿路散步)、`大驿土`(车站出行)、`沙中土`(沙坑堆沙堡)、`钗钏金`(戴首饰约会)
→ 统一建议：「六十甲子纳音之一，属X类，传统五行分类名称；非活动。」
en：`A nayin element name (X type) in the sexagenary cycle; a traditional classification label, not an activity.`

**B. 节日名当活动（10 条）**
`上巳节`、`下元节`、`中元节`、`元宵节`、`劳动节`、`社日节`、`端午节`、`观莲节`、`重阳节`、`龙头节`
→ 统一建议：「传统节日，农历日期/文化背景 + 民俗做法；各地不同；仅作文化说明。」（已给上巳/重阳 §8 样例）
en：`Traditional festival; lunar date and customs vary by region; cultural note only.`

**C. 神煞/建除/星宿名当活动（14 条）**
`金匮`(整理钱包)、`玄武`(检查门锁)、`玉堂`(收拾书桌)、`闭`(收拾房间)、`开`(出门办事)、`收`(催收尾款)、`参`(出门跑步)、`奎`(整理书桌)、`室`(收拾卧室)、`心`(整理卧室)、`氐`(整理房间)、`鬼`(整理旧物)、`鸣吠`(带宠物打疫苗)、`母仓`(整理厨房)
→ 统一建议：「[建除十二神/二十八宿/吉神/凶煞]名，传统历法术语；解释其文化含义，非活动建议。」
en：`A traditional almanac term (day officer/stellar mansion/deity); cultural meaning, not an activity suggestion.`

### 9.3 说明
- 上述 33 条均属**语义漂移**；当前活动句不得作为「已解释」显示
- 扫描方法可复用：`zh` 以动作动词开头/含 去/陪/逛/散步/爬山/出门 等，且术语本身是纳音/节日/神煞名
- 未改 JSON/代码；落库后回归：活动句=0、zh/en 成对、无宗教/医疗/预测

## 9.4 备注：节日文案「去活动化」确认（2026-11-14）

- dev 将重阳「赏菊」改为「菊花文化」，**可接受**（过扫描且不丢文化）；但建议统一为「节令物候/文化传统」句式，避免只换一个词。
- 推荐节日中性句（均不含 去/陪/赏 等动作词开头；保留文化要素）：
| 词条 | 建议 zh | 建议 en |
|---|---|---|
| 重阳节 | 传统节日，农历九月初九；旧俗登高、菊花、敬老等文化传统；现代延续敬老文化。 | Traditional festival on the ninth day of the ninth lunar month; old customs include climbing, chrysanthemums and honoring elders. |
| 上巳节 | 传统节日，农历三月初三；旧俗临水祓禊、春游踏青等文化传统。 | Traditional festival on the third day of the third lunar month; old customs include riverside purification and spring outings. |
| 端午节 | 传统节日，农历五月初五；粽子、龙舟、艾草等节令文化。 | Traditional festival on the fifth day of the fifth lunar month; seasonal culture of zongzi, dragon boats and mugwort. |
| 元宵节 | 传统节日，农历正月十五；汤圆、灯会、猜谜等节令文化。 | Traditional festival on the fifteenth day of the first lunar month; seasonal culture of tangyuan and lantern fairs. |
| 中元节 | 传统民俗节日，农历七月十五；祭祖追思、河灯等传统民俗。 | Traditional folk festival on the fifteenth day of the seventh lunar month; ancestral remembrance and river lanterns. |
| 下元节 | 传统道历节日，农历十月十五；民俗文化说明。 | Traditional Taoist-calendar festival on the fifteenth day of the tenth lunar month; cultural note. |
| 观莲节 | 传统民俗节日，农历六月廿四；荷花与夏日民俗文化。 | Traditional folk festival on the twenty-fourth day of the sixth lunar month; lotus and summer folk culture. |
| 龙头节 | 传统民俗节日，农历二月初二；理发、春耕等传统民俗文化。 | Traditional folk festival on the second day of the second lunar month; haircuts and spring farming customs. |
| 社日节 | 传统民俗节日，春社/秋社；邻里聚会、社祭等传统民俗文化。 | Traditional spring/autumn community festival; neighborhood gatherings and local rites. |
| 劳动节 | 公历五月一日；劳动与休憩的现代节日文化。 | Modern holiday on May 1; culture of work and rest. |
- 原则：节日词条只解释「是什么/日期/文化要素」，**不写行动建议**；扫描禁止「去/陪/赏/逛」等开头或活动句
- 未改 JSON/代码

## 10. 追加（2026-11-14）：「祭祀」英文确认 + en 占位扫描

### 10.1 祭祀 en（确认可用）
- 建议最终 en：`Traditional folk practice of preparing offerings and performing rites to express remembrance and respect; in modern life it can be understood as family memorial or remembrance, according to personal and family custom; not religious persuasion or prediction.`
- 与 zh「传统民俗中指备办供品、行礼表达追思与敬意的活动；现代可理解为家庭纪念/追思，按个人与家庭习惯，不作宗教劝诱、不预测。」**语义对齐** → 接受
- 与造庙（§1）同批落库；若审核仍不允许宗教相关，UI 不显示「已解释」

### 10.2 en 占位扫描（260 条）
- 真正 blocked/占位：**2 条**——`祭祀`（`— (blocked: religious term)`）、`造庙`（`— (skip)`）
- 其余 7 条含 "skip" 的是**正常英文语义**（如 诸事不宜/馀事勿取/危/寒食节/丁不剃头…），非占位，不判 FAIL
- 结论：落库时仅需替换祭祀/造庙两条 en（及 §6/§7 的旧错误 en）；其余保持
