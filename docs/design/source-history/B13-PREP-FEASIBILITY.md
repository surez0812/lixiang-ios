# B13 预备实现可行性（不落地；2026-11-12）

> 只做可行性/改动面/回退/风险，不写代码。三屏布局等 Sure 过稿。
> 代码事实：iOS **deploymentTarget 17.0**；工程 Xcode 27.2（SDK iOS 27.2）；全仓无 `UIScreen.main / UIDevice.orientation / horizontalSizeClass` 使用；无 `glassEffect/ultraThinMaterial`；底部 tab 为**自绘浮动 pill**（`D1TabBar`）；日详情分页为 `TabView(.page)`。

## 1) Liquid Glass 导航栏
- **可行**：iOS 26+ 用 `.glassEffect()` / `.buttonStyle(.glass)` / `GlassEffectContainer`；仅用于导航/工具层（顶部返回/分享/搜索、底部 tab），内容卡不玻璃化
- **iOS 17 回退**：`if #available(iOS 26, *) { ... } else { .ultraThinMaterial }`；可用 `@Environment(\.d1)` 加 `glassAvailable` 变量避免散落
- **改动面**：`RootView`（Tab 栏）、`MonthScreen`/`DayDetail` 自定义顶栏、`QuoteSheet`/`DailyVerse` 的 toolbar；约 4–6 处
- **工作量**：1–2 dev 天（含亮暗/对比度）
- **风险**：玻璃与暖纸/朱印 D1 语言冲突（需 designer 定 alpha/tint）；iOS 26 模拟器/真机验证成本；低版本回退视觉一致性
- **建议**：等三屏布局定稿后与导航层一起做；先只做「工具层玻璃、内容纸面」

## 2) 定制 QR（风格化但可扫）
- **可行**：CoreImage `CIQRCodeGenerator` 生成**标准 QR**（纠错 **Q/M**、quiet zone ≥4 模块）；叠加我们风格的外框/角标/暖色底，**不覆盖数据模块**；中心 logo ≤ 15% 面积且不压定位图案
- **改动面**：`ShareCard.swift`（`qrImage`）→ 生成后合成边框/角标（`UIGraphicsImageRenderer` 或 CIComposite），尺寸仍 220px；分享卡与「每日一句」共用
- **工作量**：0.5–1 dev 天
- **风险**：过度装饰导致扫码失败（必须在 3 台设备 × 相机/微信扫一扫实测，暗色底反色需谨慎）；QR 内容 URL 变更需 webdev 落地页
- **建议**：保留「标准码 + 细边框 + 角落印章水印」，不做大面积重绘

## 3) iPad 合并分屏（单日详情 + 月历两列）
- **可行**：`NavigationSplitView`（iOS 16+）或自定义 `HStack`；**landscape 占满高、portrait 堆叠**；左列单日 `TabView(.page)` 切日（已有 `DayPagerScreen` 可复用），右列月历（34pt 格 6 行）
- **改动面**：`RootView` 路由（新增 iPad regular 分支）、`MonthScreen`（嵌入右列）、`DayDetail`（左列 + 去掉自身 nav 冲突）、`DayPagerScreen`（列内自适应宽度）
- **工作量**：3–4 dev 天（含状态同步：选日 ↔ 月历高亮 ↔ 左右滑）
- **风险**：`TabView(.page)` 在窄列的手势/滚动冲突（已有单页验证）；`NavigationSplitView` 与现有自定义导航栈冲突（需统一）；Selection 双向同步时序
- **建议**：先做「只读两列」验证布局与性能，再加选日联动

## 4) iPhone Duo 适配（用 iphone-duo-readiness 流程）
- **基础事实**：工程 built against **iOS 27.2 SDK** → 属 **27.1+ tier**（内容可铺满内屏、toolbar/tab 转**垂直**、可用 ReservedRegion/Arrangement APIs）；这一步是最大杠杆，但也意味着**底部 bars 变垂直**，必须验证内容适配
- **静态扫描（全仓）**：✅ 无 `UIScreen.main`、无 orientation 分支、无 `horizontalSizeClass` 断言、无固定设备宽度表；⚠ **自绘 `D1TabBar` 浮动 pill 是 hand-rolled**，系统垂直栏布局不可见 → Duo 内屏会与系统/安全区冲突风险最高
- **改动面**：
  1. Duo tier 确认 + 真机/模拟器开关（0.5d）
  2. **底部 tab**：改用系统 `TabView`/`TabViewStyle`（或为 hand-rolled 补 ReservedRegion/垂直布局）（2–3d）
  3. 安全区：移除对称 inset 假设（检查 `padding(.horizontal, 18)` 等）；背景 bleed、前景避开折叠（1–2d）
  4. Hero/满宽图 `scaledToFill` 在宽屏裁切（center 42% 已有 focal 近似）→ 按尺寸类选 fill/fit（0.5d）
  5. poses（开/合/悬停/平放）+ Split View 1/2、1/3、Slide Over、Stage Manager 手测（2d QA）
- **工作量**：静态适配 ~4–6 dev 天 + QA 2 天；**不建议在 build13 内做**（三屏重构优先）
- **风险**：垂直 tab 是 27.1 tier 的强制行为（不改 tab 就重叠）；Duo 模拟器/真机可用性需确认；`NavigationStack` 标题栏与垂直栏叠加
- **建议**：Phase 1 只到「iPhone 闭合外屏显示正常 + tier 确认」；Phase 2 内屏/多任务；先做系统 TabView 迁移，再谈折叠动效

## 回退与版本矩阵（统一）
| 能力 | iOS 17 | iOS 26 | iOS 27.1+ |
|---|---|---|---|
| 玻璃导航 | ultraThinMaterial | glassEffect | glassEffect（更完整） |
| 分屏 | NavigationSplitView | 同 | 同 + 垂直 bars |
| QR | CoreImage 全支持 | 同 | 同 |
| Duo 全屏/垂直栏 | — | 居中/避让 | 铺满 + ReservedRegion |

## 结论
- QR 可最快做（0.5–1d，风险低）；Liquid Glass 1–2d（等风格稿）；iPad 分屏 3–4d；Duo 4–6d+QA —— 四项均**不放入 build13**，列入 build14/1.1 候选。
- 前置：三屏 D1 定稿 → 导航层统一（玻璃）→ iPad 分屏 → Duo（tab 迁移是硬前提）。
