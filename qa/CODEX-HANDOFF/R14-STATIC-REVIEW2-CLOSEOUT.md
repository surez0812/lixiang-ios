# R14 Codex static-review-v2 closeout（P2 DynamicType / P1 UI 转换覆盖）

HEAD：`8e213b5ca59a2f0a970e7d211dfe36d8567b4e06`（在 2fe101a1 之后独立 followup；未 push/merge）

## 1) P2 DynamicType（二次缩放）— 已修
- commit `f920354e`（D1Font.swift）
- `D1Typography.serifFont` / `kaitiFont` 在 @ScaledMetric 缩放+cap 后改用 **`.custom(name, fixedSize: size)`**，不再被 SwiftUI 自动二次缩放；Noto/Songti/系统 serif fallback 行为一致
- 证据（Noto 实际加载，非 fallback）：
  - xLarge Home：`r14-fontfix-home-xl3.png`
  - xLarge Almanac：`r14-fontfix-almanac-xl2.png`
  - accessibility2 Almanac：`r14-fontfix-almanac-a2b.png`（标题/正文/按钮可见、无裁切，可滚动）
  - xLarge Daily：`r14-fontfix-daily-xl.png`
- 手动检查：a2 下日期标题换行显示、按钮/正文不截断；xLarge 首屏完整

## 2) P1 UI 转换覆盖 — 已补
- commit `3951fdd0`（tests，无生产行为改动）
- 覆盖：
  1. `testSettingsReturnDoesNotEnableUserDisabledItem`：`-LixiangSeedReminderOff + -LixiangNotifySettingsReturn`，等待 denied→authorized marker 后仍 `toggle=0 item=0`
  2. `testSettingsReturnRestoresDesiredTrueItem`：desired=true 时 authorized 后恢复 `toggle=1 item=1`
  3. `testManualEnablePersistsAcrossRelaunch`：手动开启→持久化→重启（不 seed）仍 item=1
  4. `testAuthorizedDoesNotOverrideSeededReminderOff`：authorized 初始仍 item=0
- 2026-11-14 09:10 在 HEAD 8e213b5 重跑 **4/4 PASS（120.1s）**
- 说明：settingsReturn 为**注入模拟**；原生系统弹窗/真机仍 NOT RUN（166-169）

## 3) 未回退内容/过去日期修复
- 内容 12 approved（`79b80283…`）与 past readability（`45cbd7c`）保持
- `LixiangTests` 66/66 PASS（上一轮）；ContentCatalog 12/12 approved 断言保持

## 4) 设备
- 仅 CFF55DB9；未操作 B77A/0975B8A6/94207526/91DA70AC/0B71AEF4/Duo
