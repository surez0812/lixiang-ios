# 设计保真用例：Duo OpenLandscape right rail（逐屏对照原稿）

- 原则（Sure）：**逐屏对照最终原稿**；到达页面 ≠ 通过；矩阵不改。
- 前置：新 immutable 包；真实 Duo OpenLandscape 姿态；浅/深；不改代码。
- 设计规格（当前反馈）：rail `right=23, width=50, height=252, top=401`；5 slot×48；tab 44；icon 25。以最终原稿为准，数值为待核对基准。

## 1. 几何
1. rail 相对窗口右边缘/顶部位置误差（按原稿 pt）；宽50/高252；top401。
2. 5 个 slot 等距×48；tab 44×44、icon 25；无拉伸/压缩。
3. 安全区/圆角/胶囊避让；不同 Duo 姿态不机械套用。
4. 测量方法：截图坐标 + scene/nativeBounds 日志；不只凭 rail=true。

## 2. 内容避让
5. 每个 tab/route（home/almanac/folklore/countdown/settings/selection/daily/fortune/compass/detail）内容不被 rail 遮挡；可滚动末项可点。
6. 文本/按钮不压 rail；卡片/图表/月历不被裁；详情正文右侧留白合理。
7. 到达页面 ≠ PASS；逐屏截图/差异记录。

## 3. 颜色/字号/材质
8. rail 背景/选中态/未选中态/描边/阴影与最终原稿一致。
9. tab 文案/icon 字号、间距、字重；深色/浅色对照。
10. 不做“颜色近似”口头 PASS；用截图/取色/原稿对照。

## 4. 边界
11. 当前 OpenLandscape rail FAIL_UI（几何不符/遮挡）；Closed compact FAIL_UI 保持记录，不重试。
12. 等 dev 修后 targeted-retest；矩阵不改；不发布/merge。
