# Sure 17 条 · 技术分析（P0/大卡/滑日/富时辰/天气/工期；read-only）

依据 `REVIEW-20261112-PLAN.md`（ddcabd41…）；不改 build9；quick wins 待建 build10 分支。

## ① P0 实现路径与风险
| # | 路径 | 风险 |
|---|---|---|
| #5 道佛设置/显示 | 已有 Core `ReligionDisplay` + Tao/Foto（spike 过）；`SettingsScreen` 加两开关（UserDefaults，默认关）；`DayDetail` 年份行/节日标签；`MonthScreen` 月格小点（B 方案）；用 `ReligionDisplay.taoName/fotoName` 过滤 | 审核宗教内容；名称缺失/道佛同日；开关组合态测试；月历信息密度 |
| #12 罗盘方向 | 已有 `HeadingProvider`（CMMotionManager yaw，`-heading` 旋转、4 态）；补 filter（1°/10Hz/120ms）、「当日总体/当前时辰」语义标注、真机 4 态验证 | **真机磁力计误差/校准**；模拟器 NOTRUN；heading 与北向定义（磁北/真北）需定 |
| #6 重复罗盘 | `DayDetail` 底部 `entries` 内罗盘入口删除，保留中段 `miniCard`/入口 | 无 |
| #14 去来源/许可 | `ContentScreen` 隐藏 `sourceLink`（详情）；谢灶 `regionalDates` 详情只显示当前 region | 列表分组保留；分享/来源许可入口放设置「关于」 |

- P0 合计 **3–4 dev 人日**（#5 2–3、#12 0.5–1 真机 debug、#6/#14 0.5）。

## ② 今日大卡重构 + #2 合并 · 改动面
- `MergedDayCard`（现有）扩展：**图高 2/3**、内容起点 1/3、quote 区改「每日一句」；新增 **节日行**（#4）；**区域点击**（#3）；
- 删除重复 quote panel（`DayDetail` 内 `quoteCard`/`内容页 quote 区`），仅保留合并卡内；
- 「每日一句」screen：`DailyVerseScreen`（可复用 `QuoteSheet` 结构，改为独立页；`读解释`→同页展开，不跳 glossary）；
- 分享：`ImageRenderer` JPEG + QR（App Store id `6833252283`）+ `ShareLink`；
- 文件面：`MergedDayCard.swift`（大改）、`MonthScreen`/`DayDetail`（接线+去重）、`QuoteSheet`→`DailyVerseScreen`、`D1Theme`（比例常量）、分享组件新增 `ShareCard.swift`；
- 风险：三处 quote 来源统一（避免双 source）；布局回归（图 2/3 后内容溢出）；点击热区与滑动冲突。
- 估算 **4–6 dev 人日**（UI 3–4 + 分享 1–2，不含内容/QR 落地页）。

## ③ #10 左右滑与滚动冲突
- 方案 A（推荐）：父层 `TabView(selection:)` + `.page`，每页 `DayDetailScreen(date:)`；垂直 ScrollView 在页内天然分离，无手势竞争；
- 方案 B：合并卡/页面 `DragGesture(minimumDistance: 25)`，要求 `horizontal > vertical*1.5` 才切日，否则放行滚动；与 NavigationStack 边缘返回冲突 → 排除左侧 20pt；
- 预取：AppState 已缓存 ±370/420 天，`onChange` 预热 ±1；切换 `withAnimation` 150ms；
- 风险：页面切换重置滚动/展开状态（需按日期保存 UIState）、TabView 分页指示器隐藏、性能（低）；
- 估算 **1–2 dev 人日**。

## ④ #9 富时辰 spike 数据字段（lunar-swift 1.1.9）
- 每时辰：`ganZhi`、`minHm/maxHm`、`yi[]/ji[]`、`tianShen`、`tianShenLuck`(吉/凶)、`chongDesc`、`sha`、五神方位（xi/fu/cai/yangGui/yinGui Desc）
- 3 天 × 12 时辰样例：`dev-evidence/P1/review-shichen-samples.csv`
- **缺**：逐时刑冲合害（仅日级 chong）、逐时神煞清单；结论：可支撑「黄黑道文字 + 五神/煞随小时 + 宜忌计数」；不建议做「综合评分」；规则需顾问/内容定口径。spike 0.5–1d。

## ⑤ #8 天气接口/权限/隐私
- 接口：**和风天气 QWeather**（key，免费开发版）首选；高德天气需 key+条款；Open-Meteo 仅原型（国内商用许可存疑）
- 权限：**不强制精确定位** → 首启询问「允许/手选城市」，拒绝用默认城市；`NSLocationWhenInUseUsageDescription`；不后台定位
- 缓存：城市+日期 key，30–60min TTL；失败回退缓存+「上次更新」；不阻塞日历
- 隐私：privacy v1.1（定位用途/服务商/缓存期限/撤回）；App 内标注数据来源；审核问询预备
- 估算 **3–5 dev 人日**（网络/缓存 1.5、定位/城市 1、UI 1、异常 0.5、隐私/审核 0.5–1）；风险：数据许可/审核；P2。

## ⑥ build 10 工期复核（dev 人日）
| 批次 | 内容 | 人日 |
|---|---|---|
| Quick wins | #6/#14/#3/#13 + #1 图 2/3 | **2–3** |
| P0 | #5 道佛 2–3 + #12 真机 0.5–1 | **2.5–4** |
| 大卡重构 | #2/#4/#3/#1 合并 + 去重 | **4–6** |
| #10 左右滑 | TabView+预取+状态 | **1–2** |
| 分享 #16 | JPEG+QR+ShareLink | **1.5–2.5** |
| 富时辰 spike #9 | 字段/规则草案 | **0.5–1** |
| 天气 #8 | 见⑤ | **3–5**（P2） |
| 合计 build10（不含天气） | — | **≈11–18 dev 人日**（+内容/designer/QA 另计） |
建议拆：build10 = quick wins + P0 + 大卡重构（≈8.5–13d）；build11 = 左右滑/分享/富时辰/天气。

## Quick wins 实现点（build10 先做）
- #6 删 `DayDetail` 底部罗盘入口（`entries` 内）
- #14 `ContentScreen` 详情隐藏 `sourceLink`；谢灶 regional 详情只显示当前 region
- #3 `MergedDayCard` 外层点击 → `Route.day(date)`（排除 quote/按钮热区）
- #13 `FestivalsScreen` 过滤 `.past`（去掉「已过·展开」）
- #1 `MergedDayCard` 图高 → 2/3（与 #2/#4 同批）
