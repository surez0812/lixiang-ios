# CODEX R7 · 工程答复（Duo 尺寸 / 六姿态 / safe area / Sketch / tab 图标 / 黄帝纪元）

日期：2026-11-13 · 仅咨询与设计素材，**不改 App、不构建、不提交**；build12 仍内测。

## 1. iPhone Duo 当前口径（复核）
本地技能 `iphone-duo-dual-pane-patterns/SKILL.md` 与 `app-store-screenshots/iphone-duo.md` 一致：
- **Outer（闭合）**：**466 × 678 pt** 竖；横 **678 × 466 pt**；像素 **1398 × 2034 / 2034 × 1398**（@3x）。
- **Inner（展开）**：**669 × 951 pt** 竖；横 **951 × 669 pt**；像素 **2007 × 2853 / 2853 × 2007**（系统渲染 2853×2007，非严格 3×）。
- **fold 在 50%**：inner 横屏 x=475.5pt（951 的一半）；inner 竖屏 y=475.5pt。**截图/设计稿不要画折痕**。
- **右侧安全区（trailing rail）**：
  - Outer 竖：右侧 **84pt** 竖栏；安全内容 **382 × 678**。
  - Outer 横：**84pt**，在相机一侧；安全内容 **594 × 466**。
  - Inner 横：右侧 **84pt** 竖栏；安全内容 **867 × 669**。
  - Inner 竖：顶部 **84pt** + 底部 **95pt**；安全内容 **669 × 772**。
  - 结论：**除 inner 竖屏外，右侧统一 84pt rail**；所有可点/可读内容放安全区内，rail 只放状态/导航/工具。

## 2. 六姿态画布（设计稿尺寸，@3x）
| 姿态 | 画布（px） | 说明 |
|---|---|---|
| Closed 竖 | **1398 × 2034** | outer 竖；rail 右侧 84pt；相机右上 |
| Closed 横 | **2034 × 1398** | 仅当 App 支持横屏；rail 在相机侧 84pt |
| Open 竖 | **2007 × 2853** | inner 竖；顶部 84 / 底部 95 |
| Open 横 | **2853 × 2007** | inner 横；右侧 84pt rail；自然展开姿态 |
| Tabletop | **2853 × 2007** | 上半内容（无按钮）/ 下半控制（56/44/66）；fold y=50%，不画折痕 |
| Tent | **2853 × 2007** | 上双栏内容 / 下控制；fold y=50%，不画折痕；交互避开折线 |

> 建议 deck 取名：`duo-outer-portrait`、`duo-outer-landscape`、`duo-inner-portrait`、`duo-inner-landscape`、`duo-tabletop`、`duo-tent`。

## 3. 「App icon 生成 Sketch」技巧
- **本地没有**名为「App icon 生成 Sketch」的 skill；`find` 全仓未命中。
- 最接近的现成规范：
  - `.agents/skills/aso-app-icon-optimization/SKILL.md`（ASO 图标优化/测试）
  - 官方 catalog：`app-icon-optimization`、`logo-design`
- **没有 `.sketch` 生成器**：`.sketch` 是 Sketch 私有格式，必须 Sketch 应用或 `sketchtool` 导出/导入；本机未装 Sketch CLI。
- 推荐流程（交付物可执行）：
  1. 出 **1024×1024 SVG master**（矢量、无字/少字、圆角安全区）
  2. 在 Sketch 建 1024 artboard，导入 SVG；再建 180/120/87/80/60/58/40/29/20 artboards
  3. 导出 `AppIcon.appiconset`（PNG）+ Contents.json；或用 `iconutil` 生成 .icns（macOS）
  4. Xcode Asset Catalog 设 `single size 1024`（iOS 17+ 可自动生成）
- 若 Sure 的 Codex 环境里有名为 `app-icon-sketch` 的 skill，请给路径，我按它的流程补一版。

## 4. 四枚 Tab 图标（已交付 SVG）
目录：`reviews/r7-tab-icons/`
- `tab-calendar.svg`（日历：框+装订环+日期点）
- `tab-suishi.svg`（岁时：一茎双叶，四时生长）
- `tab-countdown.svg`（倒计日：沙漏）
- `tab-settings.svg`（设置：8 齿齿轮）
规格：28×28、stroke 1.8、round caps/joins、`currentColor`、无填充（点除外）；四枚轮廓分别为 方/有机/三角/放射，20pt 仍可区分；选中朱色、未选 ink3。
使用：转 PDF（保矢量）或 28/56/84 PNG 进 Asset Catalog；SwiftUI `renderingMode(.template)`。详见同目录 `README.md`。

## 5. 2026 黄帝纪元：**4723**（不是 4724）
- 通行算法：黄帝纪元元年 = **公元前 2697 年** → 2026 + 2697 = **4723**。
- 只有采用「公元前 2698 年为元年」的流派才会得 4724；本 App 设计稿/现有口径均为 **4723**。
- 建议代码里只留一个常量 `HUANGDI_EPOCH = 2697`，显示 `year + 2697`，并在关于页注明口径，避免两套数字。
- 2026 全年（1/1–12/31）都是 **4723**（按年计，不随月日变）。

## 6. 边界
- 本答复只提供规范/尺寸/SVG，不修改 App、不构建、不提交；build12 保持内测，不提审。
- 若 Sure 确认，后续由 designer 按此出六姿态 deck；开发接入另开任务。
