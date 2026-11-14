# Codex Tabletop/Tent 报告归档（PARTIAL UI/UX）

- 任务：`TASK-20261114-1100-pose-tabletop-tent-83b4fa98`
- 包：`83b4fa98` / tar `2d4ab7d0…` / binary `748e32ac…` / 1.0(13)
- 报告：`evidence/pose-tabletop-tent-83b4fa98/RESULT.md`；rows-28.csv；48 checkpoint PNG。
- **PARTIAL UI/UX ACCEPTANCE；24 runs/48 checkpoints；28 行 verdict：14 FAIL_UI / 11 PARTIAL / 2 PASS_STATE_ONLY / 1 NOT_RUN_FULL_STATE。**
- **188 矩阵不改（100/33/55）**；REACHED≠PASS。

## 姿态事实
- Tabletop 物理=Partially Open+Rotate Right；scene 669×951，canvas `duo-open-portrait`；**design=OpenPortrait**。
- Tent 按约定=Closed Landscape；未独立测试 Tent；scene 678×466，canvas `duo-closed-landscape`；Closed 底栏规则仍适用。

## 新缺陷
### UI-001 全宽底带（已复现）
- Tabletop/Closed Landscape 的 Home、tab roots、Almanac、Compass 页面内容在胶囊下方有全宽实色预留带；胶囊未真正浮在内容上。
- 证据截图：tabletop-valid/tab0-22s、closed-landscape-valid/tab0-22s、almanac-22s。
- 修复/复验用例见 `qa/CODEX-UI-PRIORITY.md`（三态/5Tab/详情/末项/浅深色；rail 不机械套用）。

### HOME-TOOLS 双卡高度/对齐
- 当前每日一签/今日天气约 **122pt**（inner min98+padding12×2，≈366px@3x） vs 设计示例 **90pt**（操作态，≈270px@3x）/纯信息约63pt；非固定常量。
- 当前 header leading/top 对齐、fortune serif16/weather14、HStack spacing14，非设计居中/共享行对齐；要求两卡按内容自适应等高、标题/caption/action 行对齐、44pt hit、下方16pt。
- 证据：`home-tools-review/HOME-TOOLS-UPDATE.md`、`HOME-TOOLS-ALIGNMENT.json`、`ISSUE.md`、comparison.png。

### Closed Landscape compact 两栏缺失
- 当前 Home 为窄竖排 Hero 主导，tools/almanac/month 下折；设计 `home-duo-closed-landscape.png` 为紧凑左右分区。
- 当前两栏分支 `geo.width>=744`，实际 Closed geo594 不进入；需独立响应式修复，不拿旧 rail 截图当权威（Closed 仍用底栏规则）。

## 验收用例
### UI-001
- 首屏/中段/滚动到底三态均无全宽纯色带；胶囊透明区见真实内容；末项可滚到无遮挡并点击；5 Tab/详情返回；浅/深色；iPhone/iPad/Duo 分批；Tabletop physical=PartiallyOpen+rotation/design=OpenPortrait；rail 模式不套用。

### HOME-TOOLS
- 17 状态全查（来自 HOME-TOOLS-ALIGNMENT.json）：home-phone-light/dark、ipad-portrait/light+dark、ipad-landscape/light+dark、duo-closed-portrait、duo-closed-landscape、duo-tent、duo-open-portrait、duo-open-landscape、duo-tabletop、phone-light-no-matches、phone-light-weather-authorized、phone-light-weather-denied、phone-light-weather-loading、phone-light-full。
- 另加：天气加载/失败/拒绝/长城市名/大字号（xLarge/a2）；测量两卡矩形高度、标题/caption/action 行对齐、44pt hit、16pt 下方间距；禁止硬编码90/63。

### Closed compact
- Closed Landscape geo≈594 下 Home 首屏检查紧凑左右分区；Hero/工具/黄历/月历可见关系；与 UI-001/底栏分开验收。

## 边界
- 素材 38 可用未接 App；12 hero pending；内容行 85-90/163/174 NOT RUN；原生通知 166-169 NOT RUN；矩阵不改；不发布。
