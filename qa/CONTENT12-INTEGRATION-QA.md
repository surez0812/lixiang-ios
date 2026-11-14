# 12 条内容接入抽检（2516718c）

- 包：`P1/Lixiang-R14-1.0-13-content12-r2-2516718c-debug-simulator.tar.gz`
  - tar `21ac9abd…`；binary `a2fd2c9a…`；commit `2516718c`
  - events.json `79b80283…`：12 items / 12 approved；App bundle 仅 events.json，无 `.bak`。
- 设备：`R14-QA-iPad 415BFB3F…`（未用 0B71/锁定机）；证据 `qa/evidence/content12-sample/`。

## 数据/结构
- 12/12 approved、version=1；teaser 15–23；sections≥2；sources 2；license=original+licenseNote；hero=pending-design；unlockOffset=10。
- xiayuan **无放河灯**；zhongyuan/yulanpen 原有表述未变（仍含放河灯，属既有 approved 内容）。
- 12 条详情截图在 `-LixiangDebugDate` 对应日期下均显示正文（非“内容准备中”）。

## UI 抽检
- 列表页：可见 9 条卡片（下元/冬至/腊八/谢灶/春节/祭祖/清明/上巳/盂兰盆），数据 12 条；未滚动截全 12 卡。
- 详情：正文/日期/teaser/sections 可见；`xiayuan` 实拍无放河灯且保留“传统信仰民俗说法，非客观效果”。
- **来源显示**：详情 footer 仅见第一来源（如「維基百科·下元節」），json 有 2 sources；第二来源未在首屏 footer 展示（待确认是否需展开）。
- **hero**：仍 pending-design；页面复用通用冬季插画，不是 12 条各自 hero 资产。
- **真实日期锁**：`chongyang`（2026-10-18，已过去）在 2026-11-14 仍显示「还有 0 天解锁」并锁定；`-LixiangDebugDate 2026-10-18` 才显示正文 → 过去日期解锁判定疑似缺陷，需修/确认。
- 其余未来条目按日期锁定，属预期；只有 xiayuan 在 9 天前解锁。

## 矩阵/结论
- 内容接入本身可用；**内容行 85-90/163/174 仍 NOT RUN**（需对照 UI 证据逐行评估），不能因接入 PASS。
- hero pending-design；矩阵不变 100/33/55。
