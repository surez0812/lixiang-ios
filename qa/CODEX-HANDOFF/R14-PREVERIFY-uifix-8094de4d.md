# UI-001 fix pre-verify（8094de4d）

- 包：`P1/Lixiang-R14-1.0-13-uifix-8094de4d-debug-simulator.tar.gz`
  - tar `55a3af8e…`；binary `2b46378b…`；commit `8094de4d…`；1.0(13)；events `79b80283…`。
- QA 未操作设备；基于源码/测试/团队截图。
- **结论：pre-verify 未通过（证据/测试断言不足）；任务保持 HOLD。**

## 1. 源码（PASS）
- `R14RootView` 已改为 `tabsContent + safeAreaInset(bottom,clear 84) + overlay(alignment:.bottom)`；删除 VStack 顺序底栏/全宽底板；Duo OpenLandscape 改为 trailing safeAreaInset+overlay。
- 静态代码方向符合 UI-001；但静态代码不能替代设备三态。

## 2. 截图问题（FAIL）
- light first `105967be…`：tabbar overlay 在内容上，未见全宽实色底板。
- **light mid `9eec3fc7…` 与 light bottom `9eec3fc7…` SHA 完全相同** → 测试没有真正到达/捕获滚动到底状态。
- dark first/mid/bottom 不同 SHA，但 dark bottom 仍显示中段黄历/月历，不是明确底部末项；不能证明“滚动到底、末项可点”。
- 因此三态证据不成立；bottom 只证明重复画面。

## 3. 测试断言（FAIL）
- `R14TabBarOverlayUITests` 仅断言首屏“今日黄历”存在、日历按钮存在，随后固定 swipe + 截图；
- 未断言：无全宽纯色带、胶囊透明区可见真实内容、末项可点击、5 Tab 切页、详情进入/返回；截图本身不是断言。
- iPad/Duo 未测 → **NOT RUN**，不得用 iPhone 截图外推。

## 4. 其他
- 12 approved 内容/past readability/statically fixed items 未回退；矩阵不变 100/33/55。
- UI-001 验收仍待修复测试/补证据；不把静态代码或首屏截图当 PASS。

## 5. 建议复测
- 用可滚动容器定位最后一项/底部标识，断言真正到底；对末项执行 tap 并断言详情/反馈。
- 5 Tab 逐个切换并断言页面标识；详情 push/pop 返回；浅/深色各一次。
- iPad portrait/landscape、Duo Closed/Open/Tabletop 分批；Tabletop physical=PartiallyOpen+rotation、design=OpenPortrait；右侧 rail 不套用 bottom bar。
