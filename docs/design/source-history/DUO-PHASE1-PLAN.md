# iPhone Duo · Phase 1 计划（只计划，不落地；2026-11-12）

> 来源：`skills/iphone-duo-design-notes.md`（`bedd1b49…`，古琴经验，实机 **NOTRUN**，不可当通过证据）+ `reviews/B13-PREP-FEASIBILITY.md`（`ecc44d22…`）。
> 明确：**不写代码、不进 build13 三屏布局**；Phase1 目标 build13/14，Phase2 build14。

## 0) 基线事实
- 工程 iOS SDK **27.2** → Duo **27.1+ tier**（内屏铺满、toolbar/tab **转垂直**、可用 reserved regions）
- 静态扫描：无 `UIScreen.main`/orientation/设备宽表/`horizontalSizeClass` 断言；**自绘 `D1TabBar` 浮动 pill 与自绘顶部 header 是最大风险**（不参与系统垂直栏/fold 避让）
- 部署目标 17.0（回退：iOS17 无 Duo API，普通布局；iOS26 居中/避让）

## 1) Phase 1 范围（只做姿态骨架与姿态安全，不做完整六姿态）
**目标姿态（先两板）**
1. **tabletop 上/下**：上半内容（**无按钮**）/ 下半控制区（tab 平放）
2. **tent 左/右**：左内容 / 右控制 + 右侧竖胶囊
3. **closed/open 竖向**：compact 单列 + 底 tab
4. **open 横向**：两栏（可延后到 Phase1 末）
5. **compact 降级**：Split 334 / Slide Over / Stage Manager 自由尺寸 → 单列、不跨折痕

**不做**：hinge 动效、双屏 accessory、自定义折叠动画、六姿态全套一次性。

## 2) 实现顺序（Lead 定）
1. **系统容器替换**：自定义 `D1TabBar`/header → 系统 `TabView`/`NavigationStack` toolbar（**不自绘**）；先保证 closed/open 竖屏
2. **目标板**：tabletop 上/下 + tent 左/右（先两张）
3. **fold region**：`GeometryProxy.reservedRegions(.division)`，27pt 带 + 两侧 24；frame 已含 margins **不二次加**；不可用回退单栏
4. **安全区**：内屏竖顶 84/底 95、横右 84；背景 bleed、前景避开折叠；状态栏保留
5. **compact 降级**：短边 **≥600 判内屏**（勿只看窗口宽）；Split <600 仍内屏 → 单列
6. **验收**：姿态/旋转/折叠不 reload、滚动位置保持、触控 ≥44、Reduce Transparency 控制条不透明

## 3) 竖导航规范（实现时）
- `toolbarVerticalEdge`/trait 读侧（**不硬编码左右**）；固定宽、弹性高、**symbol-only**；item 同时给 title+image；**无手插 spacer**；mixed text/symbol 项 `.axisBehavior(.horizontal)`；overflow 交系统（nav 页先压 toolbar、tab 页先压 tab）
- tabletop 下控制：56/44/66 + 边距 24–28，系统底 tab；控制条不透明 surface（Reduce Transparency）

## 4) 目标板与验收（含 NOTRUN）
| 目标板 | 验收 | 证据 |
|---|---|---|
| closed 竖（466×678 近似） | 单列/底 tab；无右裁 | 模拟器截图（真机 NOTRUN） |
| open 竖（669×951） | 单列/底 tab；安全区 84/95 | 模拟器截图 |
| open 横（951×669） | 两栏+竖 tab；无重叠 | 模拟器（若 API 可用） |
| tabletop 上/下 | 上无按钮；下控制 56/44/66；无折叠遮挡 | 模拟器（姿态 API）/真机 **NOTRUN** |
| tent 左/右 | 内容/控制分侧；右侧胶囊不压内容 | 模拟器/真机 **NOTRUN** |
| Split 1/2、1/3、Slide Over、Stage Manager | 单列、不跨折痕、44pt | 模拟器 |
| 折叠/展开中途 | 不 reload、滚动保持、轻量 relayout | 模拟器（真机 NOTRUN） |

- **iOS27.1+ 垂直 bar 行为**：closed 外屏 compact/底 tab；open 内屏 regular/竖 tab（系统决定，需实测确认）
- **证据规则**：模拟器可出的标「sim」；姿态/折叠相关真机实验一律 **NOTRUN**（古琴经验：不可把设计约束当证据）

## 5) Phase 2（build14，单列）
- **系统 TabView 迁移完成**（替换 `D1TabBar`）+ 6 姿态全套 + 折叠/多任务
- 折叠 region 与 Arrangement APIs（若 27.1 可用）
- 键盘 accessory、相机/多窗口（如产品需要）
- 依赖：Phase1 目标板 PASS；真机可用性；designer 六姿态稿

## 6) 风险与依赖
- **最大风险**：自绘 bar/header（必须先换系统容器，否则 27.1 tier 竖栏会重叠）→ Phase1 第 1 步
- Hero `scaledToFill` 宽屏裁切（按尺寸类选 fill/fit / focal）
- 对称 inset 假设（全仓排查 `padding(.horizontal, 18)` 类）
- Duo 模拟器/真机可用性未定 → 证据 NOTRUN；不影响 Phase1 代码结构
- 不阻塞 build13 三屏布局（Sure 稿优先）

## 7) 结论
- Phase1 = 系统容器 + 两目标板 + fold/安全区 + compact 降级；**不改三屏布局**，不写代码直至 Sure 拍板
- 工作量预估：Phase1 **4–6 dev 天 + 2 天 QA（模拟器/真机）**；Phase2 另 3–5 天
