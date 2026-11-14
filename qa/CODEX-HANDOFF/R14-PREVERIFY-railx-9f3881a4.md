# rail x fix pre-verify（9f3881a4 / fix cd9b816）

- 包：`P1/Lixiang-R14-1.0-13-railx-9f3881a4-debug-simulator.tar.gz`
  - tar `9dae0624…`；binary `4a8b6a71…`；commit `9f3881a4…`（fix parent `cd9b816…`）；1.0(13)；events `79b80283…`。
- QA 未操作设备；源码/测试复核。

## 公式/实现（PASS 静态）
- rail overlay `topLeading` + 显式 offset：
  `railLocalX = geo.width + safeRight - width - right`
  → scene951、geo867、safeRight84：x=878；right=23。
- DEBUG expectedX = geo.width+geo.safeAreaInsets.leading+safeRight-width-right；与 local x 一致。
- `R14SideRail.expectedX(sceneWidth:)` = sceneWidth-width-right；单测 expectedX(951)=878、expectedX(1032)=959。
- 常量 right23/w50/h252/top401、5×48、tab44/icon25 未回退；`SideRailMetricsTests` 3/3（dev 报告）、`LixiangTests` 79/79；QA 未重跑。

## 待真实设备
- 真实 Duo OpenLandscape：home.appear/firstContentFrame、LXRAIL frame 全局 (878,401,50,252)、与设计并排、不遮挡月历/黄历/状态/countdown、5 tab 竖直/浅深。
- 静态公式不等于设备通过；ForceCompact/模拟不可替代。
- 矩阵 100/33/55 不变。
