# Codex/设计 UI 优先反馈归档：UI-001 bottom tab bar

- 来源：`RESULT-20261114-UI-UX-PRIORITY-BOTTOM-BAR.md`（archive `20261114-ui-priority-bottom-bar`）。
- 结论：**UI-001 源码定位成立，待 dev ZStack/overlay 修复与设备验收**；矩阵不改。
- 源码：`App/Sources/Features/Root/R14RootView.swift:133–136`，VStack 顺序放置 `tabsContent` + `R14FloatingTabBar`，tab bar 非 overlay。
- 设计期望：内容延伸至底部；仅 Liquid Glass 胶囊浮层，无全宽纯色底；胶囊自身可遮挡经过内容；末尾操作可滚动到无遮挡。
- 修复方向：ZStack/overlay；删全宽底色；内容底部 inset；三态/5 Tab/详情/浅深色验收。

## UI-001 验证用例（待修复包）
### A. 三态（每设备/每页面）
1. 首屏：胶囊后方无全宽纯色带；透明区可见真实内容。
2. 中段滚动：tab bar 保持浮动；无底板；内容不被永久遮挡。
3. 滚动到底：末项/最后操作可滚到无遮挡位置并点击；无额外保留带。

### B. 功能/视觉
4. 5 个 Tab 逐个点击，选中态/内容正确；无白屏/错页。
5. 详情页进入/返回，tab bar 状态恢复；详情内容底部可读。
6. 浅色/深色各一遍；胶囊玻璃材质/边界正确。
7. 末项：列表最后一项、分享/编辑/关闭等底部操作可点；不被胶囊永久遮挡。

### C. 设备分批（不混写）
- iPhone Portrait：先 5 Tab + 首页入口 + 详情 + 分享/编辑 + 签。
- iPad Portrait/Landscape：双列滚动、浮层按钮、分享横布局、卡片边界。
- Duo：Closed Portrait、Closed Landscape、Open Portrait、Open Landscape、Tabletop（physical=PartiallyOpen+rotation, design=OpenPortrait）分批；右侧 rail 模式不机械套用 bottom bar。
- 每项记录：设备/页面/设计期望/实际差异/截图/修复后复验；到达页面 ≠ 视觉 PASS。

## 边界
- 本反馈只新增 UI-001；不把静态源码判断当设备截图 PASS。
- 矩阵仍 100/33/55；UI-001 修复独立验收，不改 statuses。
- 素材抽检另见 `qa/SEASONAL-ART-INVENTORY.md`，不混入 UI-001。
