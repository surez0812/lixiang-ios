# 历象 1.0 · Interface Review（PM 版）

- 卡片：review/计划任务｜作者：calendar-pm｜日期：2026-11-11
- 依据：`handover/skills/jakub-krehel/`（README + `better-interface/SKILL.md` + 6 域 skill + `interface-review/SKILL.md`）
- 对象：`work/lixiang-ios`（HEAD `cfb84930`）+ P2a 证据 `dev-evidence/P1/shots/`（fix4 / f4 / f5 / f7 截图）+ D1 设计基线
- 范围：月历 → 日详情（宜忌/时辰/罗盘/白话）→ 节俗索引/锁定/解锁 → 倒计日（F6 进行中，仅到列表/表单骨架）→ 设置（主题三态）；明暗 × 375/iPad/Duo（Duo 仅设计稿，运行时 NOTRUN）
- 排除：官网（独立 review 由 webdev/Lead）；App 内支付/账号（无）；F6 未完成部分标 `Not verified`
- 分工：**PM 出 accessibility / writing / emotion**；**layout / typography / colors / UI polish 由 designer 出**（本文仅登记已确认的系统性问题，不替 designer 定视觉结论）

**结论：Request changes**（HIGH 5 / MEDIUM 6 / LOW 3；见下表）

---

## A. Ranked findings

严重度：HIGH = 阻断/误导/系统性；MEDIUM = 理解或效率明显受损；LOW = 局部 polish。触发项不因界面小而降级。

| # | 域 | 严重度 | 发现 | 证据 | 为什么 | 建议修法 |
|---|---|---|---|---|---|---|
| 1 | a11y | **HIGH** | **全 App 不支持 Dynamic Type**：全部字号为固定 pt，无 `relativeTo`/`dynamicTypeSize` | `App/Sources/Features/Day/DayDetailScreen.swift:38,45,69,85,126,192`；`App/Sources/Features/Calendar/MonthScreen.swift:40`；全仓 `.font(.system(size:` **130 处**（dev 实测清单，按文件/行；PM 初稿 118 为稍早计数），0 处 `relativeTo` | 低视力/大字号用户无法放大正文；FRD **A16（Dynamic Type 最大档不裁切）** 直接不成立；系统设置无效属系统性缺陷 | 建 `D1Font` token（`Font.system(size:weight:relativeTo:)` 或 text style），替换 118 处；AX 档按 design `P2-A11Y-I18N.md` AX1–AX5 降级规则验 |
| 2 | a11y | **HIGH** | **忽略「减弱动态效果」**：展开/切换/主题全部 `withAnimation`，无 reduce-motion 分支 | `DayDetailScreen.swift:77,126,192`；`FestivalsScreen.swift:151`；`SettingsScreen.swift:67`；`RootView.swift:129`；无 `accessibilityReduceMotion` | 前庭敏感用户被动看动效；skill escalation trigger | 统一 `motion` helper：reduce 时无动画/仅透明度，并保留状态标签 |
| 3 | a11y | **HIGH** | **罗盘 VoiceOver 双读**：容器文本替身与图例可视节点同时可读 | `CompassScreen.swift:53`（`.contain` + 容器 label `:66`）+ 图例行 label `:240-256`；designer fix4 复核 dump 已见两层 | 一次滑动重复朗读 5 神+煞，导航成本翻倍 | 图例 `.accessibilityHidden(true)`，或与容器合并为单一 element（顺序化 label）；补新 dump 证据 |
| 4 | a11y | MEDIUM | 「白话」开关可访问名只有「白话」，无作用域/状态说明 | `DayDetailScreen.swift:68-71`（`labelsHidden()` + 10pt 文本） | VoiceOver 读「白话，开关」，不知开关什么 | 可访问名改「白话解释」+ `accessibilityHint`「用日常语言说明今天的宜忌」 |
| 5 | a11y | MEDIUM | **文字按钮命中区不足 44pt**：展开/收起/重试仅文字或 9–11pt | `DayDetailScreen.swift:77,126,192`；`ContentScreen.swift:188,204` | 误触/难点；触控可用性（skill 44pt 为 heuristic，非 HIGH） | `.frame(minHeight:44)` + `contentShape`；视觉不变 |
| 6 | writing | **HIGH** | **「白话」不是说人话**：仍是术语 + 一段通用定义，不是「今天顺/一般/注意 + 适合做什么 + 避开什么 + 影响谁」 | `DayDetailScreen.swift:85`；`fix4-day-light` 截图：`宜 开光/裁衣/安门…` 无行动语言 | 用户看不懂「开光/裁衣/安门」，无法据此行动；Lead B1 直指 | 按 `POST-REVIEW-PLAN.md` A22：结论句 + 行动句 + 人群提示；术语收进解释页 |
| 7 | writing | **HIGH** | **专业字段无解释入口**：值神/建除/星宿/胎神/彭祖/冲煞/纳音/时辰只有原始值 | `DayDetailScreen.swift:117-124`（foldRow 仅 title+value） | 术语无路可查 = 信息孤岛；Lead B2 | A23 解释页 + 每行 chevron/「这是什么」入口 |
| 8 | writing | MEDIUM | 日详情首屏先给干支/值神，「今天好不好」被压到宜忌卡 | `DayDetailScreen.swift:20-24` 顺序 header→yiJi→shichen→folded；`fix4-day-light` | 信息层级与用户任务相反；Lead B3 | 首屏加「今日总览」卡（结论 + 3 条宜 + 2 条忌 + 人群），专业字段折叠 |
| 9 | writing | MEDIUM | 错误文案缺下一步：「内容校验失败，请重试」无原因/无替代路径 | `ContentRepository.swift:82` | skill：error 必须说怎么恢复否则 HIGH；此处有「重试」按钮，降为 MEDIUM | 「内容校验未通过，可能未更新完成。请重试；已缓存内容仍可看。」 |
| 10 | writing | LOW | 术语不统一：「白话」（日详情）vs「黄历白话」（设置） | `DayDetailScreen.swift:69`；`SettingsScreen.swift:22` | 同一功能两个名字 | 统一「白话解释」 |
| 11 | emotion | **HIGH** | **首屏无情绪钩子**：只有大日期 + 文本；无节气氛围/色彩层/插画/轻动效 | `MonthScreen.swift:40`（76pt 日期）；全仓 **0 插画、0 渐变**（`Image(` 仅 SF Symbols）；`fix4-month-light` | 「偏素、无多巴胺」（Sure 反馈）；首次打开无记忆点 | 方案 A/B（见计划）：节气色带 + 大日期呼吸微动效 + 节气卡；插画方案 B |
| 12 | emotion | **HIGH** | **关键节点无惊喜反馈**：解锁、节俗到日、倒计时 0、主题切换均无触觉/庆祝态 | 全仓 **0 处 haptics**（`sensoryFeedback`/`UIImpactFeedback` 均无）；动画仅 6 处、0.15s 切换 | 关键「值得记住的一刻」被做平；留存/口碑缺抓手 | 方案 A：`sensoryFeedback`（成功/轻触）+ 一次性「今日解锁」视觉态 + 倒计时 0 文案卡；方案 B 加节气当日插画 |
| 13 | emotion | MEDIUM | 主题三态切换无愉悦感（仅 0.15s 交叉） | `SettingsScreen.swift:67`；`ThemeSelectScreen` 无预览 | 换肤是低成本惊喜点 | 切换时展示 1 次「暖夜深棕」预览卡 + 轻微 haptic |
| 14 | emotion | LOW | 动效全为功能性，无叙事性（如翻页/节气浮现） | 6 处 `withAnimation`：`RootView:129`、`Settings:67`、`DayDetail:77,126,192`、`Festivals:151` | 不构成缺陷，但强化「素」 | 与 layout/UI 一起由 designer 定；不单独排期 |

**已检查、未发现问题（明确记录，避免暗示漏检）**
- 状态不单靠颜色：宜/忌 chips 有「宜/忌」字与分组、节俗 chip 有状态文字、罗盘徽章有汉字；375 明暗截图核过。
- 锁定态不泄密：`f7-locked-light` 仅名称/日期/天数；解锁正文未在包内（B′）。
- 错误/离线为内联卡（非全屏 modal），有「重试」。
- 空态有下一步（`f5-empty`：查看全部月份/去倒计日）。
- 触控按钮有可访问名（tab 有 `accessibilityLabel` + `isSelected`）。

**未覆盖/Not verified**
- Duo 内屏（模拟器无姿态控制，NOTRUN 按 A13）；iPad 大屏运行时（仅设计稿）；Dynamic Type 实机（无该实现，故为「不存在」而非未测）；英文界面（P2 未交付）；F6 倒计日表单/通知（进行中）；触觉反馈（无实现）。

---

## B. 与 Lead 产品 review（B1–B3）的对应

| Lead 要求 | 本文证据 | 方案落点 |
|---|---|---|
| B1 白话说人话 | #6 | A22：结论/行动/人群三段式；术语进解释页 |
| B2 解释页 8 类 | #7 | A23：8 页模板 + 路由 + 文案示例 |
| B3 信息层级先给结论 | #8 | 首屏「今日总览」卡；专业字段折叠 |
| 情感/愉悦（Sure 追加） | #11–14 | 情绪层三选项 A/B/C（计划文档） |

## C. 移交 designer 的域
layout / typography / colors / UI polish：designer 按同 skill 出（行宽/字距/断点/视觉层级/暗色/图标/圆角/动效精确值）。PM 不替其定结论；若 designer 结论与本文冲突，以证据为准并回到 Lead。

## D. 复验方式（修后）
- 同一批截图 + `file:line`；`A11yOrderTests` dump（去双读后）；Dynamic Type 最大档截图；reduce-motion 录屏/截图；haptics 证据（真机录屏或日志）。
- 验收：本文 HIGH 全清 + designer 域 HIGH 全清 → Approve。

---

## E. designer 域摘要（layout / typography / colors / UI polish / 动效）

> 只读引用：`proposals/lixiang-1.0-20261111/SKILL-REVIEW.md`（designer 按同 skill 出，3 HIGH / 5 MED / 3 LOW；本文件不重复其证据，仅汇总以便 Lead 一次看全）

**HIGH（designer）**
- **F1 时辰轴「早/晚」标记与 子/亥 标签冲突**（语义/可读；证据见其 `SKILL-REVIEW.md`）
- **F2 小字号低于可读下限**（与 PM #1 Dynamic Type 互为表里，修复一起做）
- **F3 时辰吉/平/凶只用颜色编码且无图例** → **color-only 触发项**，按 skill 必须 HIGH；并入 P0
**MEDIUM（5）**：等宽数字、同屏多个同色文本动作缺唯一主操作、橙色说明卡语义歧义、图例缩放截断、其它排版/节奏项（详见其文件）
**LOW（3）**：局部 polish（详见其文件）

**情感/愉悦（Sure 追加）designer 判断**：方案 A 克制版 **design 2–3 人日、低风险**；方案 B 节气插画 **design 8–25 人日、中风险**，建议先做 4 季验证再扩全年。
**交叉结论**：F1/F3 进 P0；F2 与 PM #1 合并为「字号体系」一项，避免重复修。
