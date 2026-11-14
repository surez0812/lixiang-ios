# Codex hero2 结果归档（de01327c）

- 任务：`TASK-20261114-1320-hero2-de01327c`
- 包：commit `de01327c`；tar `16e72ee5…`；binary `dee094c4…`；events `79b80283…`。
- 结果：**scoped code/artifact review**；无独立设备运行/全量批准。
- 归档：`handoff/codex-bridge/archive/20261114-hero2-de01327c/`；证据 `evidence/hero2-de01327c/`。
- **矩阵 100/33/55 不改；12 hero 仍 pending；内容行 85-90/163/174 NOT RUN。**

## CLOSED（scoped）
- **16:9**：`Color.clear.aspectRatio(16/9).overlay{resizable.scaledToFill}.clipped()`；去固定220；phone/phone-xLarge/iPad 团队截图宽幅无变形/异常裁切；精确跨宽度/locale/设备像素容差 NOT RUN。
- **fallback 视觉**：DEBUG forceMissing return nil→`Image("winter")`；团队 fallback 截图显示冬季图，非空白/破图；独立注入/运行 NOT RUN。
- **12资源**：12 webp 独立解码1024×576，与固定源/0198a031 byte-equal；mapping/alt 无回退；EN 元数据存在但运行时 EN/VoiceOver NOT RUN。

## 新 accessibility bug — OPEN（窄范围）
- **known ID 图片失败/forceMissing 时**：画面回退 winter，但 `accessibilityLabel(for: knownID)` 仍返回该 ID 原 alt（如重阳 fallback 播报菊花/秋山，实际显示冬季图）。
- unknown ID 才用通用“岁时插画”；实际 VoiceOver 未跑。
- 修复：图片失败时同步回退 neutral fallback label，或让 image+alt 一起解析；修后用新包复验。
- 不因此否定 fallback 视觉关闭；也不把该 bug 当修复。

## 边界
- 内容 JSON 未改；内容行 NOT RUN；矩阵不改；不发布。
