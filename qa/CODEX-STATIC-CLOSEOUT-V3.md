# Codex static closeout v3 结果归档

- 任务：`TASK-20261114-0945-static-closeout-v3-a29373e9`
- 结果：**PARTIAL CLOSEOUT**
- 包：commit `a29373e9`；tar `a4d8a21e…`；binary `6c6ccabb…`；1.0(13)
- 归档：`handoff/codex-bridge/archive/20261114-static-closeout-v3/`；证据 `evidence/static-closeout-v3-a29373e9/`
- **矩阵不变 100 PASS / 33 FAIL / 55 NOT RUN；PARTIAL 不等于 FULL。**

## 1. 手动关闭持久化 — CLOSED
- `testManualDisablePersistsAcrossRelaunch` 真正 seed ON→断言1→点OFF→断言0→terminate→重启无seed→仍0/0；3 张截图一致。
- 旧 `testAuthorizedDoesNotOverrideSeededReminderOff` 仍保留误导性 OFF→tap→OFF tail/comment；不用于证明手动关闭，建议清理；新专用测试已补覆盖。
- 测试运行/未重跑为团队报告，Codex 未独立执行。

## 2. 字体 actual/forced fallback — **OPEN（真实缺陷）**
- `D1Font.serifFont` 先无条件解析 Noto 并返回 `.custom(fixedSize:)`；`!forceSerifFallback` 只 gate 了 Songti 分支。
- 内置 Noto 可用时，`-LixiangForceSerifFallback` **不能绕过 Noto**；而 `serifStrategy` 在 flag 下立即返回 `system-serif-forced` → **日志/渲染不一致**，日志不能证明实际分支。
- `FontAvailabilityTests` 只验证正常 Noto 可用/策略，不验证 forced 路径。
- actual/fallback xl/a2 截图无可确认的 forced 分支证据；P1 中也无独立 LXFONT 运行日志（不声称全局不存在）。
- 修复：gate Noto 分支或 forced 时 early-return system serif；诊断与实际一致；同一次运行提供 forced xl/a2 截图+日志。无需移除内置字体。
- fixedSize 二次缩放修复仍 CLOSED。

## 结论
- 手动关闭测试 CLOSED；forced fallback OPEN（产品缺陷/证据不一致）。
- 不把 PARTIAL 当 FULL；等 dev 新包/新任务 ID 复审；内容行仍 NOT RUN；矩阵不变。
