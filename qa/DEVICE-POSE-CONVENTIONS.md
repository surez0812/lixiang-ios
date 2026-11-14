# Duo 姿态测试约定（Sure 2026-11-14 10:45 确认）

> 这是测试执行约定，不是 188 矩阵 PASS 声明。矩阵仍以 `docs/R14-QA-MATRIX.md` 为准（100 / 33 / 55）。

## 参考证据
- Sure 提供的 Device Hub Tabletop 截图：`P1/shots/duo-tabletop-devicehub-user.webp`，SHA256 `07961e7e75c0757eaaeabe57d0eaf8f4162455cbda0b7ea7f8f39cc7eddf01ca`
- 图中：半展开、像笔记本支起；底部橙色折叠图标对应 AX 控件 **Partially Open**；界面没有单独叫 “Tabletop” 的按钮。

## 1. Tabletop
- **物理姿态/Device Hub 操作**：选择 **Partially Open**（橙色折叠图标 / AX `Partially Open`），再结合**旋转方向**得到 Tabletop（半展开、笔记本式）。
- **设计映射**：`Tabletop = Duo OpenPortrait 设计`（Sure 2026-11-14 确认；“Tabletop=OpenPortrait” 正确）。Tabletop 行按 **OpenPortrait 的设计/布局规格**验收，不是按 PartiallyOpen portrait 的布局。
- 不存在独立 “Tabletop” 按钮；不能再说“无入口”。
- Tabletop **必须单独测试**；不能拿普通 OpenPortrait 截图替代 Tabletop 姿态，也不能用 ClosedLandscape 替代。
- 记录时写清：`pose=Tabletop (Partially Open + rotation)`、`design=OpenPortrait`、实际 scene/nativeBounds、旋转方向。

## 2. Tent
- Device Hub **没有明确 Tent 状态**。
- 按 Sure 约定：**Tent ≡ Closed Landscape**。
- Tent 行可复用 Closed Landscape 的实测证据；报告必须写“**按约定等同 Closed Landscape**”，**不得声称独立测过 Tent**。
- 不得把 Tent 说成 OpenPortrait/PartiallyOpen。

## 3. 与设计矩阵的关系
- **设计映射无冲突**：Tabletop = **OpenPortrait 设计**；Device Hub 物理姿态 = Partially Open + rotation。两者是“设计画布”与“设备姿态”的区别。
- Tabletop 验收：在 Tabletop 姿态下，UI 应按 **OpenPortrait 设计规格**呈现；记录 `design=OpenPortrait`。
- Tent 按约定等同 Closed Landscape，设计/证据均用 Closed Landscape；报告写“按约定等同”。
- 在逐行证据齐前，Tabletop/Tent 相关行保持 **NOT RUN**；不自行改 188 statuses。

## 4. 当前证据状态
- Codex 已实测 PartiallyOpen portrait：22s 多白屏，桌面启动最终 Home；CLI launch 90s timeout/无进程；详情未验证。
- Codex 已实测 Closed Landscape：9/12 at22（tab0–4 + 若干 route）；可作为 Tent 约定复用的基础，但需逐行判读。
- Tabletop 尚需按 Partially Open+rotation 重新测；不能用旧 PartiallyOpen 结果直接当 Tabletop。

## 5. QA 归档核验（2026-11-14）
- 参考截图 `P1/shots/duo-tabletop-devicehub-user.webp` 实际 SHA256 `07961e7e75c0757eaaeabe57d0eaf8f4162455cbda0b7ea7f8f39cc7eddf01ca`；882×1324。
- 已同步 `qa/EXTERNAL-BLOCKERS.md`：Tabletop 不再写“无入口”；Tent 按约定等同 Closed Landscape，不称独立测。
- 24 目标行（12 页×2）及矩阵现有额外状态行在逐行证据前仍 NOT RUN；映射表见 `qa/DUO-POSE-MAPPING.md`。

## 6. 设计映射确认（Sure 2026-11-14 后续）
- “Tabletop=OpenPortrait” 指**设计画布映射**：Tabletop 使用 Duo OpenPortrait 设计/布局验收。
- 物理姿态仍为 Partially Open+rotation；记录写 `physical=Tabletop(PartiallyOpen+rotation) design=OpenPortrait`。
- 不以 OpenPortrait 物理姿态替代 Tabletop 物理姿态测试。
