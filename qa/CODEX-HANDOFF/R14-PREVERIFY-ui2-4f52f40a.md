# UI-001/HOME-TOOLS/compact pre-verify（4f52f40a）

- 包：`P1/Lixiang-R14-1.0-13-ui2-4f52f40a-debug-simulator.tar.gz`
  - tar `33922f78…`；binary `b3e2c7e6…`；commit `4f52f40a…`；1.0(13)；events `79b80283…`。
- QA 未操作设备；源码/测试/团队截图复核。

## A. UI-001（PASS，限 iPhone 证据）
- light three states SHA 两两不同：first `75671e82…` / mid `258f37a9…` / bottom `6997c93e…`；dark 也两两不同（`e9819fe8…`/`804be5cd…`/`8fb0c4f2…`），不再 mid=bottom。
- `R14TabBarOverlayUITests` 真实滚动至画面不再变化；断言 mid≠first、bottom≠mid；月历标题存在且 `isHittable`；5 Tab 逐个断言页面标识；黄历 push→`返回`→Home。
- 截图 first/bottom 未见全宽实色底板，内容延伸至胶囊后；胶囊 overlay 方向符合。**仅 iPhone 浅/深三态证据**；iPad/Duo 未测。

## B. HOME-TOOLS（部分 PASS，范围受限）
- 源码：`toolsRow` GridRow 等高/自适应，去掉 inner minHeight98；icon+title 同行 minHeight28；action 44pt；16pt gap（padding2+spacing14）。
- `R14HomeToolsUITests` phone/xl：标题 midY 对齐、开启定位高度≥44；截图 phone/xl 双卡等高、无横向裁切。
- **17 状态/天气加载/失败/拒绝/长城市/大字号全态 NOT RUN**；测试未直接断言两卡等高/16pt/图标-标题同排，只覆盖 phone+xl。

## C. Closed compact（NOT RUN，代码口径更正）
- `4f52f40a` **只有 DEBUG `-LixiangForceCompactLandscape` 分支，没有自动 `480≤width<744` 条件**；不能写“代码已实现自动 compact”。
- 真实 Duo Closed Landscape/iPad/rail 未测；`ForceCompact` 截图仅调试结构，**不作验收**。
- ForceCompact 截图存在明显窄列/文字截断迹象，但不能据此判产品缺陷，也不能判 PASS；真实姿态待测。

## 结论
- A 仅 dark 三态为 Codex 独立 PASS；**light 三态 OPEN**（light mid 与 first 同图、bottom 未建立）；B equal-height 改善但 final token/centering 仍不符，**OPEN**；C 只有 DEBUG force、无自动分支，**NOT RUN**。整体 **PARTIAL**，不宣称 A/B/C 完成。
- 不改 188 矩阵（100/33/55）；iPad/Duo/17状态/真实 compact 仍待后续。

## D. Codex 复核后更正（2026-11-14 12:15）
- **A**：Codex 独立仅 dark 三态+交互 PASS；**light 三态 OPEN**（light mid=first、bottom 未建立）；团队截图不能算 Codex 独立。
- **QA 重抓尝试（R14-QA-iPhone `0B71AEF4`）**：已安装 `4f52f40a` 并抓到 `qa/evidence/ui2-light-recapture/light-first-qa.png`（1206×2622，SHA `489d3596…`）；mid/bottom 无法独立抓取：
  - `xcodebuild test-without-building` 预构建 UI test 失败 `Pseudo Terminal Setup Error / Operation not permitted`；
  - 常规 `xcodebuild test` 仍被 SwiftPM `ManifestLoading/...dia` 权限阻断；
  - 无 pty/输入自动化，simctl 无 touch/scroll，不能用截图代替滚动证据。
  - 结论：**light mid/bottom 仍未独立建立**，不能把团队三图当 QA 独立证据。
- **B**：equal-height 改善，但 final token/centering 仍不符：padding8/gap2/居中/heading14 vs 当前12/6/leading/16，操作行约102 vs 90 示例；**OPEN**，dev 已接。
- **C 口径更正**：`4f52f40a` **只有 DEBUG `-LixiangForceCompactLandscape` 分支，无自动 `480≤width<744` 条件**；真实 Closed/Duo/iPad/rail **NOT RUN**；不得写“代码已实现自动 compact”；ForceCompact 截图不作验收。
- 矩阵仍 100/33/55；不得把 PARTIAL 当 PASS。
