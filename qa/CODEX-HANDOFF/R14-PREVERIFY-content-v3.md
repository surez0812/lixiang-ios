# 12 条内容 v3 pre-verify（8ed18682）

- 对象：`qa/content/events-12.json` SHA `8ed1868238ba8ba2d73b6c58c46e536d6db0617bcd7a2289a29e7fca99ed06e5`；12 draft。
- **结论：结构/字段/红线 PASS；来源为具体条目 URL，但 QA 环境网络不可达 → 可移桥，需 Codex 侧核验 URL。**

## 1. 结构/字段 PASS
- 12 ids 完整；sections≥2；teaser 15–23（xiayuan=18）；license=original + licenseNote；hero.status=pending-design；unlockOffset=10；全部 draft。
- source schema 无 url 字段，URL 在 `sources.note`；每条 2 条具体 Wikipedia 条目（共 22 个 unique URL），非机构首页。

## 2. 来源可达性
- 22 个 zh.wikipedia URL 逐条 `curl -m 6` 均 `000`（超时）；`web_fetch` 也失败。
- **环境网络限制 blocker**；不断言 404/无效，需 Codex 侧访问核验。
- 与 v2 差异：第2来源已从机构首页改为具体 Wikipedia 条目；xiayuan teaser 26→18。

## 3. 红线
- 命中「赏月」为中秋文化习俗；「预测」均在“不作吉凶预测”否定语境；无医疗指令/宗教劝诱/吉凶承诺。
- 结论：红线 PASS。

## 4. 结论
- 仅 URL 可达性受阻，其余 PASS → 按 Lead 规则移桥，Codex 复审时核验 URL/来源支撑。
- 内容缺口行 85-90/163/174 仍 NOT RUN；矩阵不变。
