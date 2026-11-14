# Closed Landscape compact selector（口径修正）

## 修正
- 之前 `4f52f40a` 的 `HomeScreen.compact` 仅 DEBUG force，**没有自动条件**；已改为真实 selector：
  `R14HomeLayoutMode.mode(width:height:forceCompact:)`
  - `forceCompact`（DEBUG only，`-LixiangForceCompactLandscape`）→ compact
  - `width >= 744` → wide（iPad 宽屏）
  - `width >= 480 && width > height` → **compact**（Closed Landscape geo≈594×360 命中）
  - 其它 → standard（iPhone 竖排）
- Home 分支实际调用该 selector；不再依赖 `geo.width>=744` 排除 Closed。

## 证据
- 单测 `HomeLayoutModeTests` 4/4 PASS：
  - 594×360 / 480×320 / 700×400 → compact
  - 402×874 / 479×320 → standard
  - 744×1024 / 1024×768 → wide
  - DEBUG force 仅测试注入
- 真实 Duo Closed Landscape 姿态、iPad、right rail：**NOT RUN**（无设备窗口，由 QA/Codex 后续验证）
- 调试 force 截图不作为真实姿态 PASS。
