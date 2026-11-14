# Daily 分享导出像素验证（D-01 补充项）

- 包：`P1/Lixiang-R14-1.0-13-export-329843f5-debug-simulator.tar.gz`
  - tar `ebb85cd2…`；binary `bc8c2cd4…`；commit `329843f5`
- 设备/命令：R14-QA-iPhone；`-LixiangTab 0 -LixiangR14Route daily -LixiangDailyShare`。
- 导出文件：`r14-share-export.png`（归档 `qa/evidence/daily-share-export/`）
  - pixelWidth **1080**、pixelHeight **1350**
  - hasAlpha **no**
  - SHA256 **`d72ab323a5dc82ce1faa886314f270d07af2add6b75d8af3d3c3b0291a156919`**（与 lead 预期一致）
- 视觉：卡面无裁切/无透明边；左侧品牌/日期/标题/正文摘要/出处完整；右下二维码清晰。
- QR 解码：`zbarimg` 成功 → `https://apps.apple.com/app/id6833252283`。
- 结论：**D-01 导出补充项 PASS（QA + Codex 独立验证）**（仅补充项；188 矩阵不变）。

- Codex 独立验证（0810）：R14-QA-iPhone，183 文件逐字匹配冻结包；1080×1350、SHA `d72ab323…`、RGB 无 alpha、CoreImage QR 解码成功；结果见 `handoff/codex-bridge/archive/20261114-daily-export-verify/`。
- 计数更正：**Daily 导出 329843f5 实际 183 files，mismatches=[]**；此前 181 为转录错误。**baseline d092=181** 是另一 build，分开记录。导出 PASS 结论不变。
