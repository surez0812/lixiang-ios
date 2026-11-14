# Pre-verify: staticfix 2fe101a1（三项 Codex 静态审查修复）

- 包：`P1/Lixiang-R14-1.0-13-staticfix-2fe101a1-debug-simulator.tar.gz`
- tar `faf6bce287c917fd653e048f6c941fd05f675e98bc1b22c2de3e7db79fd935cf`
- binary `7e572940c0518e64c552956f78fa79b34ccb8282e1870398cf0044b2a26e456f`
- commit `2fe101a1e1847d12ed42d41ef3fcab8d3641fc10`；1.0(13)
- QA 未操作设备（静态只读 + 交付 xLarge 截图）；不碰 0B71/锁定机。

## 1. P1 reminder intent（c40772c）
- **代码 diff 正确**：新增 `ReminderIntentPolicy`；Detail 使用 `desiredReminder` + `effectiveReminder`；authorized refresh 仅在 desired=true 时 persist；denied 只显示 off/disabled，不清 desired。
- **测试断言**：`NotificationReminderIntentTests` 3/3 覆盖 policy 三态（authorized+false 保持 false；denied 保留 desired；手动 enable 才 persist）。
- **覆盖缺口**：测试是纯 policy 单测，未直接实例化 `CountdownDetailScreen`/`NotificationPermissionCenter` 验证“打开详情不写持久化”的集成路径；Codex 复评应重点检查该路径。
- 结论：**代码 PASS；测试覆盖为 policy 级，非端到端**。

## 2. P2 prepare generation/race（344d060）
- **代码正确**：select 自增 generation；prepare 记录 date+gen；almanac 与 prewarm 两处写回前 guard；prepareInFlight 合并并发；select 同步写 selectedDate/cachedAlmanac/festivals/hourIndex/ready。
- **测试**：`SelectedDayPrepareRaceTests.testStalePrepareDoesNotOverwriteNewSelection` 直接构造 SlowEngine 竞态，断言旧 prepare 不覆写新日期、ready=true。
- 结论：**PASS**（测试真实覆盖竞态）。

## 3. P2 Text Dynamic Type（2fe101a1）
- **代码**：删除 `extension Text { d1Font/d1SerifFont }` 固定字号重载（D1Font.swift 原 99–105 段已删）；调用点统一解析到 View 的 `@ScaledMetric` modifier。
- **静态检查**：无剩余 `extension Text`；`.d1Font/.d1SerifFont` 调用均走 View modifier。
- **测试**：无专门 Text 单测；以 xLarge 截图为准。
- **截图**：`P1/shots/r14-p2-home-xl.png`、`r14-p2-almanac-xl.png`；1206×2622；Home 标题/双卡/黄历无横向裁切；Almanac 列表可滚动、无横向截断（底部内容超出首屏属滚动）。
- 结论：**代码/截图 PASS；无专门单测**。

## 4. 其他
- 包 tar/binary/Info 1.0(13) 匹配；dev 报告 `LixiangTests 63/63 PASS`、`NotificationReminderIntentTests 3/3`、race test PASS；QA 无法重跑 xcodebuild（SwiftPM/sandbox 缓存限制），以上测试结果为 dev 报告 + 静态断言检查，不冒充 QA 运行结果。
- 已知缺口/不改矩阵：166-169 原生权限、164 内容缺口、170-174 长图、Duo 等仍不变；188 矩阵保持 100/33/55。

## 5. 桥
- 本 preverify 通过（有 P1 集成覆盖缺口、Text 无专门单测，交 Codex 复评重点核）。
- 任务：`TASK-20261114-0850-static-review-v2-verify.md` 移出 HOLD。

## 6. P1 集成断言 delta（1238789c，P1UI）
- 新包：`P1/Lixiang-R14-1.0-13-p1intent-1238789c-debug-simulator.tar.gz`
  - tar `ee7d3440…`；binary `62b970e1…`；commit `1238789c`；1.0(13) 匹配。
- 新增 `-LixiangSeedReminderOff` DEBUG seed，将条目 reminderEnabled 置 false。
- `R14ReminderIntentUITests`（dev 报告 42.8s PASS）实际断言：
  1. authorized + item 原关闭：marker `notify.status=authorized toggle=0 item=0`，toggle=0、enabled；
  2. 手动开启 → preprompt「去开启」→ `toggle=1 item=1`；
  3. 再关闭 → `toggle=0 item=0`。
- 截图：`r14-reminder-intent-initial-off/preprompt/enabled/disabled.png`（1206×2622），与断言一致。
- **P1 集成覆盖缺口关闭**（证据为 dev UI test + 截图；QA 未独立重跑 XCUITest；仍为 DEBUG 注入，不是原生权限）。
- 桥任务已更新到 `1238789c` 包，保持 inbox；未操作设备。
