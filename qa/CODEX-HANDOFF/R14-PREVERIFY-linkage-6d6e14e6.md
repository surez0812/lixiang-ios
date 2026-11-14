# linkage 同次取证 pre-verify（6d6e14e6）

- 证据根：`P1/linkage-6d6e14e6/`
- 包：tar `53cd8114…`；binary `29a69a6f…`；commit `6d6e14e6`；1.0(13)；build-only。
- manifest SHA `5dcc866e…`；设备 `R14-Build-iPhone CFF55DB9…`。
- QA 未操作设备；仅文件/日志/截图核对。

## 1. manifest SHA
- manifest.json 实际 SHA `5dcc866e0b5f18773b31b574f0b924919e672b68c0fde8d8695a9ae139169846`，与 Lead 一致。
- 三个 run 的 log/PNG SHA 与 manifest **逐项一致**：
  - actual-xl shot `530a22a6…` / log `2c52df01…`
  - forced-xl shot `67670f40…` / log `ce26f547…`
  - forced-a2 shot `3f7929cf…` / log `e0bc640d…`
- 截图均 1206×2622。

## 2. flags / LXFONT 对应
- actual-xl：`LXLAUNCH ... -LixiangTypeScale xl`；`LXFONT serifStrategy=NotoSerifCJKsc-fixedSize forceFallback=false`。
- forced-xl：`... -LixiangTypeScale xl -LixiangForceSerifFallback`；`LXFONT ... system-serif-forced forceFallback=true`。
- forced-a2：`... -LixiangTypeScale a2 -LixiangForceSerifFallback`；同 forced 日志。
- log 内 `LXLAUNCH args` 与 manifest launchFlags 一致；`LXFONT` 行与 manifest 一致；不是只靠文件名。

## 3. 包/版本/结构
- tar/binary/commit 匹配；Info 1.0(13)；App 无 PlugIns、无 *.xctest（build-only）。
- 该包为 linkage 取证新构建，binary 与旧 6d6e14e6 包不同属正常；commit 相同。

## 4. 时间/设备
- runUTC：actual 01:57:23 → forced-xl 01:57:43 → forced-a2 01:58:03；间隔约 20s，顺序合理。
- manifest generatedAt 01:58:22；设备统一 CFF55DB9；日志 native 1206×2622/geo 402×778 一致。
- 未发现跨设备/跨 run 混用证据。

## 5. 结论
- **linkage pre-verify PASS**；证据缺口（同次 raw log↔截图）已补。
- 任务 `TASK-20261114-1010-linkage-6d6e14e6.md` 移出 HOLD；Codex 只复核 linkage。
- 内容行 85-90/163/174 仍 NOT RUN；原生 166-169 仍 NOT RUN；矩阵 100/33/55 不变。
