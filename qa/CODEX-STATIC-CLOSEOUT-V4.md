# Codex static closeout v4 结果归档

- 任务：`TASK-20261114-1000-static-closeout-v4-6d6e14e6`
- 结果：**forced fallback 实现/诊断 CLOSED；XL/a2 截图接受；同次 raw log→截图 linkage OPEN（证据缺口，不是代码缺陷）**
- 包：commit `6d6e14e6`；tar `ee28120a…`；binary `77a6939b…`；1.0(13)
- 归档：`handoff/codex-bridge/archive/20261114-static-closeout-v4/`；证据 `evidence/static-closeout-v4-6d6e14e6/`
- **矩阵不变 100 PASS / 33 FAIL / 55 NOT RUN；无整体发布验收。**

## 结论
1. **forced bypass CLOSED（静态）**：`serifFontName(forceFallback:)` forced=true 立即 nil，早于 Noto/Songti 查询；`serifFont` nil→system serif，非 nil→custom(fixedSize)；旧无条件 Noto 分支已移除；测试断言 nil、实际 Font==system serif、正常 Noto strategy。
2. **诊断/渲染一致 CLOSED（静态）**：`serifStrategy` 从 serifFontName 派生；Root LXFONT 使用同一 flag/property；不再 forced 日志+Noto 渲染。strategy 只描述字体族选择，不等于所有 glyph OS 替换证据。
3. **XL/a2 截图 ACCEPTED（仅限提供 Home viewport）**：actual/forced 可见 serif/sans-like CJK 差异；a2 标题换行；无明显横向裁切；a2 下方卡片部分在视口外，不等于裁切/全滚动通过；团队截图非独立运行。
4. **同次 log→截图 linkage OPEN（证据缺口）**：P1/repo 未找到 raw LXFONT 运行日志，只有 preverify/closeout 文字提及；截图文件名/09:46 时间不能绑定本次 binary/flags/strategy。需已有 actual/forced raw log 片段 + 运行时间/session + 启动参数 + 包/二进制身份 + 截图 hash/manifest；不得伪造日志/在只读任务重跑。
5. **其他 CLOSED 未回退**：a29373e9→6d6e14e6 仅 D1Font/FontAvailabilityTests；manual disable、通知生产逻辑、approved 内容、past readability、fixedSize 未变；events `79b80283` 不变。

## 后续
- dev 用 CFF55 做一次**同次运行取证**：raw LXFONT log + actual/forced 截图 + 包身份/命令/SHA manifest；完成后 Lead 新建 task ID，Codex 只复核 linkage。
- 内容行 85-90/163/174 仍 NOT RUN；原生通知 166-169 仍 NOT RUN；不碰设备/不发布。
