# Codex 静态审查 v2 结果归档（1238789c）

- 结果：`CHANGES_REQUESTED`；只读审查，未运行 App/测试、未操作设备。
- 包版本化补充：`archive/20261114-static-review-v2/RESULT-TASK-20261114-0850-static-review-v2-verify-revision-1238789c.md`
- 旧 2fe101a1 结果保留，不覆盖；任务 0850 曾原地换包，Codex 明确要求**后续新任务 ID/不可变 revision**。

## P1 reminder intent
- **原代码缺陷 CLOSED（静态）**：desired/effective 路径与 2fe 修复相同，未恢复 authorized 无条件写 true。
- **UI 转换覆盖 PARTIAL/OPEN**：`R14ReminderIntentUITests` 查找 Screen 开关、item marker，手动 preprompt/开关路径比 policy 单测强；但 `-LixiangNotifyAuthorized` 在 `NotificationPermissionCenter.init` 即设 authorized，refresh 仍 authorized，没有触发 **notDetermined→authorized onChange**；旧无条件 onChange bug 在该 mock 下也可能通过。
- 需补：desired=false + settingsReturn(denied→authorized) 或明确 refresh 转换注入，等待 authorized 后仍 toggle=0/item=0；再覆盖 desired=true 恢复；重启复读磁盘未证明。

## P2 prepare 旧日期写回
- **CLOSED（静态）**：123 与 2fe 该文件无变化；token/inFlight/发布前 guard 成立。
- 测试调度覆盖有限：`Task.yield` 不保证进入 detached；建议可控 gate，而非再加 sleep。

## P2 DynamicType
- **OPEN**：删除 Text 固定重载已确认，但 `D1FontModifier` @ScaledMetric 后 `D1Typography.serifFont` 仍 `.custom(name,size:)`，custom API 会二次缩放，标题 cap 失效；fallback 行为不同。
- 需 `.custom(name,fixedSize:)` 或单一缩放路径；Noto/fallback/xLarge/accessibility 尺寸核验；xLarge 首屏无横裁不能证明 cap 正确。

## 矩阵/状态
- 不改 188 矩阵（100/33/55）；不改原生通知 166-169；不发布/提审/合并。
