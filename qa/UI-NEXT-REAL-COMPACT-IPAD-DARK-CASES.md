# 下一步验收用例：真实 Duo Closed compact / iPad / dark（需设备窗口）

- 前置：新 immutable 包（当前 46f47ff4 或后续）+ SHA/commit；真实设备窗口；**不使用 `-LixiangForceCompactLandscape` 作为验收**。
- 本轮只验 A/B/C 范围外：真实 compact 渲染、iPad、dark；矩阵暂不改。

## 1. Duo Closed Landscape compact
- 姿态：Device Hub Closed + 旋转至 landscape；scene≈678×466，geo≈594×432，canvas `duo-closed-landscape`，rail=false。
- 预期：`R14HomeLayoutMode` 自动 compact（>=480 && width>height），Home 左 Hero+tools/右 almanac+month 紧凑分区；不是竖排 Hero 主导。
- 检查：首屏两栏关系、Hero/tools 可读、月历进入视口、无双栏裁切、底部胶囊 overlay 无全宽实心带、5 Tab/末项可点、详情返回。
- 证据：姿态截图 + scene/geo 日志 + 包身份；不得用 force 截图。

## 2. iPad
- Portrait/landscape + light/dark；重点 744 边界：>=744 应 wide（双列），不得误入 compact。
- 检查：双列滚动、工具卡等高/对齐、分享横布局、卡片边界、底部/侧边导航规则。
- 真实 Duo OpenLandscape rail 模式不机械套 bottom bar。

## 3. Dark
- 同包 iPhone/真实 Duo/iPad 的 dark：capsule/玻璃材质、无全宽底带、末项可点、5 Tab/详情返回；不能沿用旧 build dark。
- iOS27 native Liquid Glass 单独标 NOT RUN，除非实际运行。

## 4. 记录
- 每项：设备/姿态/runtime/包 SHA、首/中/底截图、scene/geo、Tab/末项/详情结果；不把到达当 PASS。
- 17 状态/天气全态/长城市/Dynamic 全档仍可另批；素材 38/12 hero pending；矩阵不改。

## 5. Closed compact tools 遮挡（新增，UI-001/HOME-TOOLS）
- 真实 Duo Closed Landscape（自动 compact，非 force）：
  - tools 面板不得出现过大空白高度；
  - icon/标题/说明/操作不得贴近/超出下边缘；
  - 不得被浮动 tab 胶囊遮挡；末项/操作可点。
- 浅/深各一次；OpenPortrait 正常不能替代 Closed compact。
- 当前 interim FAIL_UI；等 dev 修后新包复测；矩阵不改。
