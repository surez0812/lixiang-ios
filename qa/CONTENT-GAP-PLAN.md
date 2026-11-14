# R14 内容缺口与补齐计划（PM）

- 2026-11-14｜依据 `docs/R14-FAIL-NOTRUN-PLAN.md`（行85-90/163/174）与 PM UI 二轮复核；只读，不改代码/不启模拟器
- 目标：内容侧 FAIL/NOT RUN 可闭环；**示例稿只能标内容缺口，不能 PASS**

## 1. 正式 12 条岁时正文（#85–90/163/174）
| # | slug | 类型/模板 | 来源 | 审核状态 | 接入格式/版本 |
|---|---|---|---|---|---|
| 1 | dongzhi | solarTerm/T1 | 公版节气/民俗志 | 正文待 PM 定稿；素材现为占位 | `/events/dongzhi/index.json` v1；hero 必填 |
| 2 | qingming | solarTerm/T1 | 公版 | 同上 | 同上 |
| 3 | chunjie | traditional/T2 | 公版 | 同上 | 同上 |
| 4 | zhongqiu | traditional/T2 | 公版 | 同上 | 同上 |
| 5 | xiayuan | tao/T3 | 公版道历 | 同上；nonPersuasionNote 必填 | 同上 |
| 6 | zhongyuan | tao/T3 | 公版 | 同上 | 同上 |
| 7 | laba | buddhist/T3 | 公版佛典 | 同上；经典出处+免责 | 同上 |
| 8 | yulanpen | buddhist/T3 | 公版 | 同上 | 同上 |
| 9 | xiezao | ritual/T4 | 公版民俗 | 同上；safetyNote+南北 regionalDates | 同上 |
| 10 | jizu | ritual/T4 | 公版民俗 | 同上；safetyNote+regionalDates | 同上 |
| 11 | shangsi | traditional/T2 | 公版（新增，替换活动稿） | 语义修正中（见审校 §8） | v1 |
| 12 | chongyang | traditional/T2 | 公版（新增） | 语义修正中 | v1 |
- 统一要求：hero≥1（16:9 webp≤120KB）、sources≥1 真实 https、teaser≤40、sections≥2、contentVersion=1、unlockOffset=10、regionNotes 与地区差异节去重
- 审核流：draft→in_review→approved→published；editor 提交/admin 审批不得自审；示例稿（含 `CONTENT_PENDING`/占位）**不得发布/不得标 PASS**

## 2. 四季素材/完整签库
### 2.1 四季素材
| 项 | 现有 | 缺口 | 补齐计划 | 验收 |
|---|---|---|---|---|
| 四季 hero/节气图 | **仅冬季 1 套**（winter） | 春/夏/秋 各 1 套（24 节气复用+季节底图） | designer 出 3 套（各 3 尺寸/iPad/暗色）；PM 配节气映射表 | 4 季×375/1440 亮暗无裁剪；文件 SHA |
| 节气 24 图 | 部分复用 | 24 节气专属/复用清单 | 按 `PLAN-SUISHI` 图位逐一核对 | 24/24 有图且 alt |
### 2.2 完整签库
| 项 | 现有 | 缺口 | 补齐计划 | 验收 |
|---|---|---|---|---|
| 签条 | **10 条样本** | 正式签库（签种/签号/签诗/签意/建议/等级） | PM 按已批流程生成全量（本地 JSON，不调 AI 上线）；同签规则固化 | N 条全量 JSON+SHA；同日同签；无占位 |
| 动画 | 1450ms 核心已冻结 | 全量签条展示适配 | dev 按 ApprovedMotionManifest 接入；QA 5 时间点 | Manifest SHA 一致；结果全显 |
- 明确：10 条样本≠完整签库；示例不得标 PASS。

## 3. 中英/术语/排版终审（结合 UI 二轮）
| 项 | 状态 | 待办 |
|---|---|---|
| 术语 zh/en 成对 | en 仍多处旧错误（安葬/祈福/谢土/开光/求嗣/造仓） | 按审校 §6/§7 落库；`PlainTermSheet` 回归 t.en |
| 活动句 vs 释义 | 上巳/重阳/大林木/海中金/路旁土 5 条 | 按 §8 改中性 zh/en |
| almanac 当日岁时行 | 仍缺 | dev 补行；PM 提供当日岁时数据字段 |
| serif/宋体 | 仍无衬线 | dev 修字体；designer 给 token |
| home 黄历卡遮挡 | 仍延伸至 tabbar | dev 修 safe area/滚动 |
| folklore/detail/settings iPad+深色 | 缺证据 | dev/QA 补截图后 PM 复审 |
| 长图/全量滚动证据 | #170–173 NOT RUN | QA 长图采集 |

## 4. 里程碑与验收
- 2 天：12 条清单+5 条语义修正交审；四季/签库缺口计划确认
- 4 天：12 条正文定稿+hero/来源齐；冬季→四季素材首批
- 6 天：签库全量 JSON；术语 zh/en 落库回归
- 验收：12 条 publish dry-run PASS、内容门禁 0 违规、QA 抽检；示例稿不计 PASS
