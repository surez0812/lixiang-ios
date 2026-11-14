# static-review-v2 closeout pre-verify（5509c8e4）

- 包：`P1/Lixiang-R14-1.0-13-staticcloseout-5509c8e4-debug-simulator.tar.gz`
  - tar `cdeed8b8…`；binary `b4b887ee…`；commit `5509c8e4…`；1.0(13)
- events.json `79b80283…`：12 approved 内容未回退。
- QA 未操作设备（静态/证据审核）；不碰 0B71/锁定机。

## 1. P2 DynamicType（f920354）— PASS
- `D1Typography.serifFont/kaitiFont` 在 @ScaledMetric 缩放+cap 后改用 `.custom(name, fixedSize:)`，消除二次缩放；Noto/Songti/系统 serif fallback 一致。
- 截图：`r14-fontfix-home-xl3.png`、`r14-fontfix-almanac-xl2.png`、`r14-fontfix-almanac-a2b.png`、`r14-fontfix-daily-xl.png`（1206×2622）；xLarge/a2 标题/正文/按钮可见，无横向裁切；Almanac 内容超出首屏属可滚动。
- `LixiangTests 66/66` 为 dev 报告；QA 未独立重跑。

## 2. P1 UI 转换（3951fdd）— PASS（测试证据）
- `R14ReminderIntentUITests` 4/4（dev 09:10 HEAD 8e213b5 重跑，120.1s）：
  1. settingsReturn desired=false → authorized 后 `toggle=0 item=0`（不覆写）
  2. desired=true → authorized 后恢复 `toggle=1 item=1`
  3. 手动开启→重启（不 seed）仍 `item=1`
  4. authorized 初始 + 用户关闭仍 `item=0`
- settingsReturn 为注入模拟；原生通知/真机 166-169 仍 NOT RUN。

## 3. 内容未回退
- events.json 12/12 approved（79b80283）与 past readability 保持；本次修复不影响内容。
- 内容行 85-90/163/174 仍 NOT RUN；矩阵不变 100/33/55。

## 4. 结论
- 包/commit/测试/closeout 匹配；DynamicType + P1 转换两项 pre-verify PASS（测试/截图为 dev 证据，QA 静态核）。
- 任务 `TASK-20261114-0915-static-closeout-5509c8e4.md` 移出 HOLD 交 Codex；新 task ID，不复用 0850。

## 6. Codex 0915 复审补充（PARTIAL）
- DynamicType 二次缩放静态 CLOSED，但视觉/fallback 覆盖 OPEN；P1 手动关闭持久化测试 OPEN（测试先置0再点OFF，非1→0）；详见 `qa/CODEX-STATIC-CLOSEOUT-0915.md`。此前“4/4 PASS”仅 QA/dev 证据，不等于 Codex FULL。
