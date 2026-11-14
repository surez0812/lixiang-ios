# static closeout v3 pre-verify（a29373e9）

- 包：`P1/Lixiang-R14-1.0-13-staticcloseout3-a29373e9-debug-simulator.tar.gz`
  - tar `a4d8a21e…`；binary `6c6ccabb…`；commit `a29373e9…`；1.0(13)
- events.json `79b80283…`（12 approved 未回退）。
- QA 未操作设备；仅静态/测试/截图证据。

## 1. 手动关闭持久化（PASS）
- 新增 `testManualDisablePersistsAcrossRelaunch`：
  - seed ON（`-LixiangSeedCountdown 1`，无 `-LixiangSeedReminderOff`）→ 断言 `toggle=1 item=1`
  - 点击 OFF → 断言 `toggle=0 item=0`
  - terminate → 重启无 seed → 断言仍 `toggle=0 item=0`
- **不再复用 authorized+off 初始测试**；原测试缺陷已修正。
- 运行 4/4/66/66 均为 dev 报告；QA 未独立重跑。

## 2. 字体实际/forced fallback（PASS，证据有边界）
- `D1Typography.serifStrategy` + DEBUG `-LixiangForceSerifFallback`；`FontAvailabilityTests` 断言 `NotoSerifCJKsc-fixedSize` 且 force=false。
- 截图：`r14-font-actual-xl.png`、`r14-font-fallback-xl.png`、`r14-font-fallback-a2.png`（1206×2622）；actual/fallback 均无横向裁切，a2 标题换行/卡片换行可见。
- 未在 P1 目录找到独立 LXFONT 运行日志文件；以上为代码+测试+截图证据，运行日志请 Codex 侧核验。
- 不要求伪造无字体环境；forced fallback 通过 DEBUG 参数实现。

## 3. 未回退
- DynamicType fixedSize、P1 desired 转换/恢复/手动开启重启、12 approved 内容、past readability 均未在本次 diff 中回退；events `79b80283` 不变。
- 内容行 85-90/163/174 仍 NOT RUN；矩阵 100/33/55 不变。

## 4. 结论
- 包/commit/测试/events 匹配；手动关闭与字体 fallback 两项 QA pre-verify PASS（运行日志为 dev 报告/截图，QA 未重跑）。
- 任务 `TASK-20261114-0945-static-closeout-v3-a29373e9.md` 移出 HOLD；新 task ID。

## 5. Codex v3 结果更正（PARTIAL）
- 手动关闭测试 CLOSED；**forced fallback OPEN（真实缺陷）**：Noto 分支无条件返回，`-LixiangForceSerifFallback` 不能绕过；`serifStrategy` 却报 forced，日志/渲染不一致。此前 QA 对字体 fallback 的 PASS 仅基于截图+测试，未发现该分支缺陷，现更正。
