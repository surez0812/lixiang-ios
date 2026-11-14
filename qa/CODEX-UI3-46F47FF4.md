# Codex UI3 结果归档（46f47ff4）

- 任务：`TASK-20261114-1215-ui3-46f47ff4`
- 包：commit `46f47ff4`；tar `869ca3e3…`；binary `3ef685a1…`；1.0(13)
- 设备：iPhone 16 Pro `0975B8A6…` iOS18.6 simulator；安全覆盖安装，无卸载/擦除。
- 结论：**A/B/C 在声明范围内 CLOSED**；非全量产品/矩阵批准。
- 证据：`handoff/codex-bridge/evidence/ui3-46f47ff4/`（包含独立 light 三态/末项点击/安装身份）；归档 `archive/20261114-ui3-46f47ff4/`。
- **矩阵 100/33/55 不改。**

## A HOME-TOOLS — CLOSED（观察范围）
- 固定源码：padding8/spacing2/heading14-600/icon22/居中/等高 Grid/action44/16pt；无固定总高。
- 独立观察 normal + xLarge light：卡居中、等高、明显变短；无横向裁切；截图 `codex-light-first.png`、`codex-light-xl-first.png`。
- 精度/触控 tolerance 测试只审源码未独立执行；**17状态/长城市/天气全态/其他设备 NOT RUN**。

## B compact selector — CLOSED（静态实现）
- 实际 GeometryReader 调 `R14HomeLayoutMode`：>=744 wide；>=480 && width>height compact；否则 standard；force 保留。
- 单测4个函数/边界已审，团队执行非独立重跑；**真实 Duo Closed/iPad/rail NOT RUN**，源码不证明渲染。

## C UI-001 — CLOSED（该设备/runtime 的 light）
- iPhone16Pro/iOS18.6 独立真实滚动：light first/mid/bottom raw 帧不同；内容可在胶囊后继续滚动；旧全宽实色底带未复现。
- 末项日期 6 实际点击进入 2026-12-06 黄历详情并返回（`codex-light-last-date-almanac.png`）。
- **本 build dark 未跑；iOS27 native Liquid Glass NOT RUN**；不把旧 dark 证据改名。

## 范围外
- 全 weather 状态、真实 compact/Duo/iPad、native Liquid Glass、其他 matrix 行未测。
- Tabletop 必须独立姿态；Tent 可复用真实 Closed Landscape 但标“按约定等同”，不称独立测。
- 素材 38 可用 / 12 hero pending / 内容行 NOT RUN；不发布。
