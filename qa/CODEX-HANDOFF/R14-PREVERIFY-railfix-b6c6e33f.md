# railfix pre-verify（b6c6e33f）

- 包：`P1/Lixiang-R14-1.0-13-railfix-b6c6e33f-debug-simulator.tar.gz`
  - tar `7dcaaab9…`；binary `ecd6cb86…`；commit `b6c6e33f…`；1.0(13)；events `79b80283…`。
- QA 未操作设备；源码/常量/测试复核。

## 常量/布局（PASS 静态）
- `R14SideRail`：right23/width50/height252/top401；slot48×5；tab44；icon25；horizontal pad3；vertical pad6；reserved58。
- 派生自洽：48×5+6×2=252；44+3×2=50；reserved=58。
- rail overlay 改为 `topTrailing` + key-window safeAreaInsets 折算 top/right；内容 `safeAreaInset(trailing, reserve58)`；**rail 模式不使用 bottom overlay**。
- `SideRailMetricsTests` 2/2（dev 报告）：常量/派生；`LixiangTests` 78/78；QA 未重跑。
- DEBUG `LXRAIL design/frame/reserved` 日志已加；真实 Duo OpenLandscape 截图/日志 **NOT RUN**（待 Codex lease）。

## 边界
- 不把静态常量当真实几何 PASS；需 Codex 按原稿并排验证 global frame/遮挡/5 tab/浅深。
- 矩阵 100/33/55 不变；events/内容未改；不发布。
