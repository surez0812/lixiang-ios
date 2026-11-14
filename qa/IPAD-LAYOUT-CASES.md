# iPad 布局/detail/UI-001 三态复验用例（需真实窗口）

- 前置：新 immutable 包；真实 iPad portrait/landscape；浅/深；逐屏对照 `docs/design/r14-final`；矩阵不改。
- 当前 1445 FAIL/PARTIAL：portrait 误两栏、landscape 压缩/下空白、detail 整体布局不符、UI-001 三态 PARTIAL。

## A. iPad portrait（1032×1376 逻辑）
1. 原稿 portrait 应为**全宽竖排**，不得 `width>=744` 误入 wide 两栏。
2. Home：Hero/工具/黄历/月历顺序、无大块未使用空白；工具卡等高/居中。
3. 浅/深各一次；底栏/胶囊无全宽底带。

## B. iPad landscape（1376×1032 逻辑）
4. 原稿两栏：左 Hero+tools / 右黄历+月历；顶部内容不压缩、下方无异常空白。
5. token/字体/spacing 对照原稿；月历/卡片边界；12 状态至少首页。
6. 浅/深各一次；UI-001 胶囊 overlay。

## C. Detail（iPad landscape dark）
7. 原稿左摘要/右文章 composition；当前全宽 header/hero 不符需修。
8. hero 16:9；header 信息层级；sources；正文可滚动；末项可点。
9. chongyang 真实可读 + 锁定 xiezao 各一；浅/深。

## D. UI-001 三态（真实滚动）
10. 实际拖动必须产生可辨位移；first/mid/end 三张 SHA 两两不同；重复图不能当三态。
11. 三态均无全宽纯色底带；胶囊透明区见内容；末项可滚到胶囊上方并点击。
12. 记录滚动位置/截图/容器 frame；浅/深。

## E. Real compact/rail
13. 真实 Duo Closed compact：tools 内容自适应无空白/遮挡；见 `UI-NEXT-REAL-COMPACT-IPAD-DARK-CASES.md`。
14. OpenLandscape rail：逐屏原稿几何/避让/颜色字号；见 `UI-DESIGN-FIDELITY-CASES.md`。
15. 到达≠PASS；矩阵不改；不发布。
