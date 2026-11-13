# R14 精确视觉基线：颜色 / 字体 / 尺寸对齐

日期：2026-11-13 · 依据：`r14-final` 每屏 CSS、`docs/design/tokens.json`、`HOME-TOOLS-UPDATE.md`
代码：`App/Sources/DesignSystem/D1Theme.swift`、`D1Font.swift`、`App/LixiangApp.swift`

## 1. 颜色（已改代码，不只文档）
| Token | Light | Dark | D1Theme 字段 |
|---|---|---|---|
| bg | `#FFF8EC` | `#211D19` | bg/bg1 |
| paper | `#FFFCF5` | `#30281F` | paper/card |
| ink | `#35291F` | `#F8ECD8` | ink |
| muted | `#79634D` | `#C9B69C` | ink2 |
| line | `#E8D6BA` | `#69523B` | line |
| red | `#A63D26` | `#FFAC88` | red/accent/accentStrong/quote1 |
| gold | `#B3863D` | `#D9B675` | amber/quote2 |
| wash | `#F6E8D1` | `#403326` | soft/bg2 |

- `D1Theme.light/dark` 已替换为上述值；旧的 `F7EBDC/C0452C/3A2417` 已移除。
- 新增 `Color.r14Red / r14RedDeep / r14Gold / r14Ink` 动态色（随系统浅深解析），并替换各 Feature 里散落的旧硬编码红/金。
- `LixiangApp` 改为 `D1ThemedRoot`：从 `@Environment(\.colorScheme)` 解析 token，**system 模式深色不再恒定 light**。
- 证据：`shots/r14-home-r14tokens-light.png`、`r14-home-r14tokens-dark.png`。

## 2. 字体（设计期望 Songti SC，但 iOS 无内置）
设计给了字体定义，未给字体二进制；**不购买/不上传字体**。

实际探测（iPhone 17 Pro 模拟器，XCTest `FontAvailabilityTests`）：
```
D1Typography fonts
Kailasa: Kailasa,Kailasa-Bold
songti_chosen=fallback:system-serif
```
- `STSongti-SC-*`/`STSongtiSC-*`/`Songti SC` 均不可用；无 Kaiti 家族（仅有 Kailasa，名字含 Kai 但不是楷体）。
- 解析顺序：`STSongti-SC-Bold` → `STSongti-SC-Regular` → `STSongti-SC-Light` → `STSongtiSC-*` → `Songti SC` → **系统 serif**。
- `Text.d1SerifFont` / `D1FontModifier(design:.serif)` 已统一走 `D1Typography.serifFont`，与实际渲染一致。
- 楷体：`Kaiti SC` → `KaitiSC-Regular` → `STKaiti` → … → 系统 serif。
- **已知偏差**：真机是否带 Songti 未验证；无字体二进制时，视觉与设计稿宋体存在字面差异，记为已知缺陷，不宣称 PASS。

## 3. 动态字号
- 正文/UI：`@ScaledMetric(relativeTo: .body)`，上限 2.0×。
- 标题/大数字 serif：上限 1.4×；楷体/大数字：1.2×。
- 设计字号：H1 30 / H2 19 / 卡片题 17 / 正文 15 / 次文 12 / 注释 10；最小正文 12、注释 10。
- 测试入口：DEBUG `-LixiangTypeScale xl|xxl|xxxl|a1..`；证据 `shots/r14-{home,almanac,compass}-xlarge.png`。

## 4. 尺寸/间距/图标/素材
- 4pt 栅格；手机页边距 18–20，iPad 24–26；卡片内 14–20；卡距 10–14；圆角 14–24；触控 ≥44；底部 Tab 避让 ~84（实现用 140–150 inset）。
- 图标：5 Tab 用设计 `tab-*` imagesets（calendar/suishi/TabSelection/countdown/settings），template 渲染；罗盘用 `compass-dial`；签筒/签条/签纸用冻结 fortune 素材。
- 素材完整性：**目前只有冬季 `winter` 插画与 10 条样签**；完整四季/岁时插画与完整签库未交付，列为生产内容缺口，不宣称全齐。
- 逐设备证据（当前）：iPhone portrait 浅/深、iPad portrait 两列、iPad landscape 5 Tab（XCUITest）、Duo Closed Portrait 5 Tab、Duo Open Portrait（历史内屏）；Duo 其余姿态 NOT RUN。

## 5. 验收口径
- 每页按 `screens.json` 188 状态逐项对照 HTML/PNG；PASS 必须有原生截图 + 设备/系统/commit 证据；未测标 NOT RUN。
- 团队非作者 QA（calendar-qa / superwebqa）独立复核；Lead/Codex 最终 review。


## 6. Fortune 关键帧说明（QA 零交叉）
按 `ApprovedFortuneCore.js`：
- 180ms：`angle = 5*sin(0) = 0`，press≈1 → 与 0ms 画面相同（边界零帧）。
- 600ms：`s = 1`，`sin(4π) = 0`，lift 从 600ms 开始为 0 → 与 0ms 画面相同（边界零帧）。
- 运动证据用 300ms（正向轻摇）、450ms（反向）、800ms（升签中段）、900ms（接近升起）、1050ms（reveal 开始）、1450ms（结果）。
- 180/600 的“同图”是冻结动画数学的必然结果，不是帧注入失败；不因此改动画核心/素材。
