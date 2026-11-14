# Codex static closeout 0915 结果归档

- 任务：`TASK-20261114-0915-static-closeout-5509c8e4`
- 结果：**PARTIAL CLOSEOUT**（固定版本只读审查；未跑 App/测试、未操作设备）
- 包：commit `5509c8e4`；tar `cdeed8b8…`；binary `b4b887ee…`；1.0(13)
- 归档：`handoff/codex-bridge/archive/20261114-static-closeout-v2/`；证据 `evidence/static-closeout-5509c8e4/`
- **矩阵不变 100 PASS / 33 FAIL / 55 NOT RUN；PARTIAL 不等于 FULL。**

## 逐项
| 项 | 状态 | 说明 |
|---|---|---|
| DynamicType 二次缩放（产品缺陷） | **CLOSED（静态）** | `.custom(name, fixedSize:)` 去掉二次缩放；system fallback 未变 |
| 字体视觉/fallback 覆盖 | **OPEN（证据完整性）** | 仅看团队 4 张截图；未证明启动参数/实际加载字体/fixed commit/运行时字号；无 forced-fallback/cap 实测 |
| P1 settingsReturn desired=false | CLOSED（静态/测试设计） | denied→authorized 后 item=0/toggle=0；未独立重跑，注入非原生 |
| P1 desired=true 恢复 | CLOSED（测试设计） | 独立转换测试；运行时 4/4 为团队报告 |
| P1 手动开启重启持久化 | CLOSED（测试设计） | ON→item=1→重启无 seed→1 |
| **P1 手动关闭持久化** | **OPEN（测试缺陷，非产品缺陷）** | 当前测试先置 0 再点 OFF，实际是“请求开启”不是 1→0；需先 ON→断言1→OFF→断言0→重启仍0 |
| 12 approved 内容回归 | CLOSED（精确比较） | bundle events = 源；相对 63722767 仅 reviewStatus 变化；`79b80283…` |
| past readability 回归 | CLOSED（静态） | helper 允许 today/past，标签已过去/已解锁；测试未重跑 |

## 结论
- 产品缺陷（二次缩放/P1 intent）静态修复成立；证据覆盖不完整，手动关闭测试设计需修。
- 不把 PARTIAL 当 FULL；原生 166-169 仍 NOT RUN；内容行仍 NOT RUN；矩阵不变。
