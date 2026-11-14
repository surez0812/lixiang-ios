# 12 条岁时正文 Compliance/来源核验（PM）

- 2026-11-14｜对象：`App/Resources/Content/events.json` **SHA `15938a92…`**（已加 reviewStatus="draft"）
- 结论：**结构/来源可达/内容红线 PASS；状态保持 draft，待人工 compliance 签核后改 in_review→approved**

## 1. 结构
- `{version:1, items:[12]}`；每条含 id/title/category/dateRule/regionalDates/teaser/sections/sources/license/version/**reviewStatus**
- teaser≤40、sections≥2、sources≥1、无占位/待定稿/示例稿
- `reviewStatus` 统一 **draft**（dev 规则：draft 只显示「内容准备中」，不 markRead；approved 才作为正式正文）

## 2. 来源可达性（2026-11-14 实测 HTTP）
| URL | HTTP |
|---|---|
| https://www.cma.gov.cn/ | **200** |
| https://www.gov.cn/ | **200** |
| https://www.wenming.cn/ | **200** |
| https://www.ihchina.cn/ | **200** |
| https://www.news.cn/ | **200** |
| https://www.dpm.org.cn/ | **200** |
- 每条 sources 均带机构名 + `https://…` + 访问日期；为机构主页/栏目，具体条目页 compliance 阶段补 note

## 3. 内容红线扫描
- 禁止词库（灵验/保佑/功德/消灾/改运/必/一定/保证/治疗/处方/疗效/包治/福报/报应/天必/注定/法事/开光）：仅命中 **「预测」2 次**，均为**「不作吉凶预测」否定式免责**，非预测表述
- 无医疗指令（无“治疗/处方/疗效/包治”）；无宗教劝诱（道佛条目均写“文化说明，不涉及宗教劝诱”）
- 仪式（谢灶/祭祖）有 safety 段：明火/消防/环保/无烟祭扫
- 地区差异：谢灶 regionalDates north/south + 正文说明；祭祖 清明/中元/除夕 regionalDates + notes；其余条目 notes 说明“各地做法不同”

## 4. 敏感表述复核
- 祭祀/祭祖/盂兰盆：均以“追思/孝亲/文化记述”表述，无仪轨指导、无宗教劝诱
- 下元/中元：注明“民俗文化说明，不作吉凶预测”
- 结论：**无高风险表述**；具体条目页 URL 与史实核对需 compliance 人工终审

## 5. 审核状态与后续
- 当前：**draft**（全部 12 条）
- 建议：内容合规签核 → 改 `in_review`；发布审核 → `approved`；未 approved 前 dev 不展示为正式正文
- 未改代码；本文件只记录核验结论
