# forced font fallback pre-verify（6d6e14e6）

- 包：`P1/Lixiang-R14-1.0-13-fontfallback-6d6e14e6-debug-simulator.tar.gz`
  - tar `ee28120a…`；binary `77a6939b…`；commit `6d6e14e6…`；1.0(13)
- events.json `79b80283…`（12 approved 未回退）。
- QA 未操作设备；静态/测试/截图证据。

## 1. forced 绕过 Noto（PASS）
- `serifFontName(weight:forceFallback:)`：`forceFallback=true` **立即 return nil**，Noto 分支同样被 gate；`serifFont` 用该解析结果，forced 时返回 `.system(design:.serif)`。
- `serifStrategy(forceFallback:)` 与 `serifFontName` 同源；不再出现「日志 forced 但渲染 Noto」。
- `FontAvailabilityTests` 新增实际 Font 断言：
  - `serifFontName(forceFallback:true) == nil`
  - `serifStrategy(forceFallback:true) == system-serif-forced`
  - `serifFont(...forceFallback:true) == .system(size:17, design:.serif)`
  - 正常路径非 nil + Noto strategy
- **不是只断言 strategy**。

## 2. 截图（团队证据边界）
- `r14-fontfix2-actual-xl.png`、`r14-fontfix2-forced-xl.png`、`r14-fontfix2-forced-a2.png`（1206×2622）；actual/forced 可见字形差异（forced 为 system serif），无横向裁切；a2 标题/卡片换行可见。
- **同次 LXFONT 运行日志在 P1 目录未找到**（不声称全局不存在）；请 Codex 侧核验同次日志。
- 不要求伪造无字体环境。

## 3. 未回退
- manual disable 1→0+重启测试保持；fixedSize 二次缩放保持；12 approved/past readability 未动；events `79b80283` 不变。
- 内容行 85-90/163/174 仍 NOT RUN；矩阵 100/33/55。

## 4. 结论
- 包/commit/测试/events 匹配；forced fallback 代码+实际 Font 测试+截图 PASS（运行日志待 Codex 核）。
- 任务 `TASK-20261114-1000-static-closeout-v4-6d6e14e6.md` 移出 HOLD；新 task ID。
