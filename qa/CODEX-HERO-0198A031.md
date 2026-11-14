# Codex hero 集成结果归档（0198a031）

- 任务：`TASK-20261114-1245-hero-0198a031`
- 包：commit `0198a031`；tar `7330647b…`；binary `c07fca6d…`；events `79b80283…` 未改。
- 结果：**scoped PARTIAL**；读取只读、未操作设备/未重跑测试。
- 归档：`handoff/codex-bridge/archive/20261114-hero-0198a031/`；证据 `evidence/hero-0198a031/`。
- **矩阵 100/33/55 不改；12 hero 仍 pending；内容行 NOT RUN。**

## PASS
- 12 资产/映射/alt：bundle root 12 webp 与固定 commit byte-equal；Pillow 独立解码 1024×576/16:9。
- 12 详情 QA 截图（含 dongzhi-retry2、修正的 qingming）可见对应标题/hero，无错页/缺失；Codex 仅检视团队证据，非独立设备运行。
- ZH/EN alt 全有；实际 VoiceOver/locale 切换未跑。

## OPEN
### 1) 详情容器非 16:9 自适应
- 源码 `resizable().scaledToFill().frame(height:220).clipped()`，固定高、非 `.aspectRatio(16/9)`；不拉伸但可能跨宽度裁切。
- 手机截图无明显变形，不代表 phone/iPad 精确 16:9 容器；需澄清“固定220 vs 响应16:9”验收口径并补多设备。

### 2) 缺失 fallback 运行时证据
- 代码路径 unknown→nil→Image("winter")/alt“岁时插画”；`ContentHeroTests` 覆盖 nil/alt/cache，但 fallback 测试未断言实际渲染 winter 图。
- 无 missing-fixture 设备截图；运行时非空白/不破图 **NOT RUN**。

### 3) EN accessibility
- 当前详情调用默认中文 `accessibilityLabel`；EN 元数据存在≠运行时 EN 本地化；VoiceOver/EN locale **NOT RUN**。

## 边界
- events.json 未改；内容行 85-90/163/174 仍 NOT RUN。
- 不发布/提审/合并；不改 188 矩阵。
