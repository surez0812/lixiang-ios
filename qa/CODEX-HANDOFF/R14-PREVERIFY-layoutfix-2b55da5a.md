# layoutfix pre-verify（2b55da5a）

- 包：`P1/Lixiang-R14-1.0-13-layoutfix-2b55da5a-debug-simulator.tar.gz`
  - tar `e609b56a…`；binary `b466bb19…`；commit `2b55da5a…`；1.0(13)；events `79b80283…`。
- QA 未操作设备；源码/测试复核。

## 修复代码（PASS 静态）
- **root 启动回归** `eac07eb`：删除 view body 内 key-window `safeAreaInsets` 访问；rail 改用 `geo.safeAreaInsets`，恢复 content.ready→layout；启动卡 loading 根因按 dev 结论移除。
- **iPad A** `cf3e909`：`R14HomeLayoutMode.mode` wide 仅 `width>=744 && width>height`；iPad portrait 1032×1376 → standard 单列；wide padding 20/24。
- **iPad B** `2b55da5`：detail 宽屏 `wideBody` 左 summary/右 hero+article（hero 不全宽）；Home wide hero 更高；新增 iPad layout/three-state UI tests。
- **firstContentFrame** 改 CATransaction completion（HomeScreen 改动在 2b55da5 中；需设备 log 确认实际 marker）。
- 测试：`LixiangTests` 79/79、iPad layout/三态 UI tests 为 dev 报告；QA 未重跑。
- 12 内容/events/hero 未改；矩阵 100/33/55 不变。

## 待设备验证
- Duo OpenLandscape：home.appear/firstContentFrame/LXRAIL frame；rail 设计几何、避让、5tab、浅深。
- iPad portrait 单列/landscape 两栏/detail 左摘要右文章；UI-001 iPad 三态真实滚动；均需 Codex lease 新包证据。
- 静态代码不替代真实截图；不预判 PASS。
