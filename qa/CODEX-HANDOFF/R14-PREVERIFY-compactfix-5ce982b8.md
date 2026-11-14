# compactfix pre-verify（5ce982b8）

- 包：`P1/Lixiang-R14-1.0-13-compactfix-5ce982b8-debug-simulator.tar.gz`
  - tar `55ae8205…`；binary `cefc4c99…`；commit `5ce982b8…`；1.0(13)；events `79b80283…`。
- QA 未操作设备；源码/交付证据复核。

## 修复范围（PASS 静态）
- `toolsRow.fixedSize(horizontal:false, vertical:true)`：内容自适应，禁止 compact 高列中被拉伸/空白 panel。
- compact 分支 `.padding(.bottom, 160)`（原120）：为浮动 tab 胶囊留空间；UI-001 overlay 保留未回退。
- `LXSTARTUP firstContentFrame` 在 Home 内容 `onAppear` 下一 runloop 记录一次（DEBUG probe），区分 content.ready/首帧；不改布局/生产行为。
- 仅 HomeScreen 改动；events/12 approved 未改；76/76 为 dev 报告，QA 未重跑。

## 证据限制
- **未在 P1 找到同次 firstContentFrame 原始日志/截图**；任务文本“同次样例 8228ms”仅记录为 dev 报告，未绑定包/run；不能当最终首帧证据。
- 真实 Duo Closed Landscape 本机未测（Codex lease）；tools 空白/遮挡修复的实际布局仍待 Codex/设备窗口。
- 图 `r14-startup*` 是旧启动样例，不是本包 same-run 证据。

## 结论
- 包/commit/修复代码匹配；静态 preverify PASS；真实 Duo Closed compact、same-run firstContentFrame 为待验项，不预判 PASS。
- 任务 `TASK-20261114-1530-compactfix-5ce982b8.md` 移出 HOLD；矩阵 100/33/55 不变。
