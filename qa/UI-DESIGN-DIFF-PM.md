# 历象 iPhone/iPad 实现 vs R14 设计稿 视觉差异核查（PM，非作者）

- 2026-11-13｜基线实现 HEAD `bf5fa110`（`feat/r14-implementation`）；实现截图 `handover/calendar-20261111/dev-evidence/P1/shots/`、QA 证据 `work/lixiang-r14/qa/evidence/`；设计基线 `docs/design/r14-final/*.png` + `tokens.json`/`SCREEN-VISUAL-CHECKLIST.csv`
- 范围：11 页 × iPhone portrait / iPad portrait+landscape，浅/深；**不含 Duo**（Codex 负责）；未启动模拟器
- 方法：设计 PNG 与实现截图逐页对照（尺寸/顺序/对齐/字号/间距/材质/颜色/图片）；代码仅用于查证（`App/Sources/Features/`）
- 判定：PASS / 偏差（可量化差异）/ 缺失（设计有、实现无）/ 未覆盖（无对应截图或需真机）

## 0. 证据覆盖说明（诚实边界）
- 设计 PNG：home/almanac/compass/daily/fortune/selection/folklore/folklore-detail/countdown/countdown-detail/settings 的 phone/ipad 变体齐全
- 实现截图：home/almanac/compass/daily/fortune/selection/countdown/... 有 r14-* / QA 截图；**folklore/folklore-detail/settings 的 iPad 与部分深色态未找到一一对应截图** → 标「未覆盖」，不以设计稿猜测实现
- 本文只对**已实际对照的截图**下 PASS/偏差/缺失结论；未对照项写「未覆盖，需补截图」

## 1. home（对照：设计 `home-phone-light.png` ↔ 实现 `r14-home-r14tokens-light.png`，浅色 iPhone）
| 维度 | 设计值/位置 | 实现观察 | 判定 | 证据 |
|---|---|---|---|---|
| 布局 | Hero 卡 → 日期/农历/干支/时辰 → **今日岁时 + 今日纪念 两张卡** → 每日一句红卡 → 每日一签/今日天气双卡 → 今日黄历 → Tab | 无「今日岁时」「今日纪念」两卡；其余顺序一致 | **缺失** | 设计图 vs `r14-home-r14tokens-light.png` |
| 对齐 | 左右 24pt；双卡等宽等高、同行对齐 | 左右约 24pt 一致；双卡等高、对齐 | PASS | 同上 |
| View 大小 | Hero 高约 430/812；每日一句红卡高约 210 | Hero 约 430；红卡约 220 | 偏差（+10） | 同上 |
| 比例 | 留白大、无密网格 | 一致 | PASS | 同上 |
| 字体 | 日期 **宋体/serif** 约 30；quote serif | 日期呈现 **无衬线粗体**（PingFang），quote 似衬线但需核 | **偏差（serif 回退）** | 同上 |
| 间距 | 卡距 16–20；组距 24 | 视觉接近；黄历卡距底部偏紧 | 偏差（轻微） | 同上 |
| Liquid Glass | Tab bar 为玻璃胶囊、内容可穿透 | Tab bar 近不透明渐变/色块，玻璃感弱 | **偏差（重点）** | 同上 |
| 颜色 | bg `#F6EFE4`/paper `#FFFBF2`/ink `#2B2118`/red `#B23A2A` | 主色接近，需逐 token 数值核 | 偏差（待数值） | `tokens.json` vs 实现 |
| 图片 | winter 插画、签筒、天气 icon、tab 图标 | winter/签筒/图标一致；tab 图标形状有差异（日历/岁时） | 偏差（轻微） | 同上 |

**home 结论**：2 项缺失/重点（今日岁时+纪念卡、Tab bar 玻璃）+ serif 回退；Hero/双卡/红卡布局基本一致。

## 2. almanac（对照：`almanac-phone-light.png` ↔ `r14-almanac-v3.png`（有效态））
| 维度 | 设计值/位置 | 实现观察 | 判定 | 证据 |
|---|---|---|---|---|
| 布局 | 红卡：标题/日期/农历/干支/**黄帝纪元·道历·佛历**/**当日岁时**/前后一天 → 白卡宜忌（白话全解开关/逐项可读/每项标题+解释） | 红卡有标题/日期/农历/干支/纪元/前后一天，**无「当日岁时」**；白卡有宜忌/开关/逐项可读，但**无每项白话解释**（开关 OFF 态） | **缺失（当日岁时）+ 偏差（解释态）** | `r14-almanac-v3.png` vs 设计 PNG |
| 对齐 | 24pt；红卡圆角 24 | 24pt 一致；圆角接近 | PASS | 同上 |
| 字号 | 日期 serif 约 30；红卡标签 | 日期**无衬线粗体**；其余接近 | **偏差（serif）** | 同上 |
| 颜色 | 页面 bg 暖纸 `#F6EFE4`；红卡实色/微渐变；白卡 paper | 页面为**橙黄渐变背景**（非暖纸纯色）；红卡深红渐变 | **偏差（高，token 不一致）** | tokens.json vs 实现 |
| 玻璃 | 导航/底栏玻璃胶囊 | 底栏胶囊有玻璃感；返回按钮普通圆 | 偏差（部分） | 同上 |
| 状态异常 | — | `r14-almanac.png` 为**空白+警告三角**错误态（另一 shot），说明存在渲染失败/未完成态 | **需 dev 排查** | `r14-almanac.png` |

## 3. compass（对照：`compass-phone-light.png` ↔ `r14-compass-day-light.png` / `r14-compass-hour.png`）
| 维度 | 设计 | 实现 | 判定 | 证据 |
|---|---|---|---|---|
| 布局 | 盘面居中 → 日/时切换 → 十二时辰 → 五吉神/煞方 → 右上「值神罗盘」玻璃按钮 | 盘面/切换/时辰/方位存在；按钮玻璃与位置需核 | 偏差（待核） | 设计 PNG / 实现 shot |
| 大小 | 盘面直径约 330/375 宽 | 接近 | PASS（待量测） | 同上 |
| 字体 | 标题 serif | 无衬线 | 偏差（serif） | 同上 |
| 玻璃 | 返回/按钮 glass | 普通色块风险 | 偏差（重点） | 同上 |
| 图片 | compass-dial 素材 | 使用 dial？需核资产 | 未覆盖（待核） | 代码/资产 |

## 4. daily（`daily-phone-light.png` ↔ `r14-daily-redesign-light.png`）
- 布局/长文/出处/分享入口：基本一致（PASS，细节字号待核）；serif 回退与 glass 同前（偏差）；分享卡 QR 未在截图内（未覆盖）。

## 5. fortune（`fortune-phone-light.png` ↔ QA `fortune-result/`、`r14-fortune-*`）
- 1450ms 冻结核心/结果态/标题常驻：需录屏/时间点截图，当前截图只能看静态结果（未覆盖动画）；签筒/签纸素材位置需核；serif/glass 同上。

## 6. selection（`selection-phone-light.png` ↔ `r14-selection-*`）
- 表单/结果布局基本一致；日期选择器/结果跳转需交互验证（未覆盖交互）；serif/glass 同前。

## 7. folklore / 8. folklore-detail（`folklore-phone-light.png`/`folklore-detail-*` ↔ 实现截图缺失）
- **未覆盖**：未找到实现侧一一对应截图；列表/详情/离线/未解锁/长图状态无法在本轮下结论；需 dev 补 shot 或 QA 证据后复核。

## 9. countdown / 10. countdown-detail（`countdown-phone-light.png` ↔ `r14-countdown-*.png`）
- 列表/最近天数/详情/新建表单/通知提示：有截图，布局基本一致（PASS）；Tab 最近天数样式/0 字符串需核；serif/glass 同前。

## 11. settings（`settings-phone-light.png` ↔ `fix4-settings-light.png`/`m1-rename-settings.png`）
- 分组/版本行存在；**版本行来源需核真实 build**；行高/分组标题字号待核（偏差轻微）；glass 无（设置页无导航玻璃）；serif 同前。

## 12. 高危偏差清单（需优先修）
1. **home 缺「今日岁时」「今日纪念」两卡**；**almanac 红卡缺「当日岁时」**→ 高
2. **Liquid Glass 未真实呈现**：Tab bar/导航多为不透明色块（设计为玻璃胶囊可穿透）→ 高（R14 核心语言）
3. **serif/宋体回退**：日期/大标题/农历日等设计为衬线，实现呈无衬线粗体 → 高（视觉气质）
4. **almanac 页面背景为橙黄渐变而非暖纸 token、宜忌缺逐项白话解释**；`r14-almanac.png` 存在空白错误态 → 高
5. **home 红卡高度 +10pt、卡距偏紧** → 中
6. folklore/folklore-detail 无实现对照截图 → 高（无法验收，需补证据）

## 13. 仅轻微差异清单
- tab 图标形状、天气/签筒图标细节、部分卡距 2–4pt、深色态 token 未逐值核、iPad 截图缺少对照（需补）

## 14. 下一步
- dev 补 folklore/folklore-detail/settings iPad/深色 + fortune 动画时间点截图；补 today 岁卡/纪念卡；核 glass 实现（`.glassEffect`/Material 是否真用）；核 serif 字体（Songti）回退原因（Info.plist 字体/中文 fallback）
- 本报告不替代真机/QA；不 push/不 merge
