# 12 条正式内容审批 QA 抽检用例（待 Codex/PM 审批后执行）

- 内容：`qa/content/events-12.json`（SHA `a77aaba1…`）；当前全部 draft，不接入、不标 PASS。
- 抽取：12/12 全量结构检查，另随机 4 条深度抽检。

## A. 结构（12/12）
1. 顶层 envelope `{version:1, items[12]}`；12 slug 与计划一致。
2. 每 item 必填：id/title/category/dateRule/teaser/sections/license/version/reviewStatus。
3. `sections` ≥2，每节 title+body 非空；teaser 15–23 字；`contentVersion=1`。
4. hero≥1（16:9 webp≤120KB）、alt 非空；`sources`≥1 且 https。
5. dateRule：10 lunar + 2 solarTerm；`unlockOffset=10`。
6. reviewStatus 必须 draft/in_review/approved/published；**不得自行 approved**。
7. 无 CONTENT_PENDING/占位/“示例段落”/TBD/—。

## B. 来源/授权（12/12）
- 每 source 域名/标题可核，license 写明公版/授权；无未授权转载。
- 佛道内容有 nonPersuasionNote/经典出处/免责；祭祀类有 safetyNote/regionalDates。

## C. 红线（12/12）
- 无宗教劝诱、医疗指令、吉凶预测、迷信承诺、恐吓。
- 活动类描述为文化说明，不写“去/陪/赏/逛…”建议。
- 地区差异不绝对化，不地域歧视。

## D. 地区差异（4 条深度）
- xiezao/jizu：regionalDates 与 regionNotes 不重复、不冲突。
- dongzhi/qingming：南北/地区差异表述有来源。
- shangsi/chongyang：替换活动稿；zh 只保留日期+文化要素，en “Traditional …; cultural note”。

## E. 门禁 dry-run
- draft 不得展示；approved+version>0 才可读。
- 审批后写入 `App/Resources/Content/events.json`，记录文件 SHA/items/approved 数；示例不混入。

## 执行状态
- **用例已写；等审批/接入后执行**；当前不判 PASS。
