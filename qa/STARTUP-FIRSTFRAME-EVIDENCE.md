# startup firstContentFrame 证据接收模板

- 目的：区分 App 准备时间与同一 run 的**首次真实渲染帧**；content.ready / 8s 截图不得替代首帧。
- 每 run 必须同一包/设备/姿态/进程，提供：
  1. `run_id`、包 tar/binary/commit、设备 UDID/型号、姿态/scene/nativeBounds、浅/深。
  2. `process_start` / `prepare.start` / `prepare.done` / `content.ready` 原始时间（含时钟源）。
  3. **`firstContentFrame` 原始时间** + 判定方法（如首张非空白/非 loading 截图的采集时间；不得改 App 代码）。
  4. 对应首帧截图（PNG/SHA/尺寸）+ 同 run log/manifest 哈希，能绑定截图与时间。
  5. 8s/12s/22s 采样仅作旁证，不称首帧。
- 验收：报告写 `firstContentFrame=...ms` 与采样限制；未提供则 **NOT RUN/证据缺口**，不能写 8s PASS。
- 矩阵不改；不发布。

## 待接收（compactfix 5ce982b8）
- 任务文本称同次样例 `firstContentFrame=8228ms`；P1 未找到原始日志/截图，暂记为 dev 报告，不当作最终证据。
- 需 Codex/设备窗口补 same-run log+截图+包/姿态 manifest。
