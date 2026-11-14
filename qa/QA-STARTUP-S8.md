# 启动 / §8 语义复核（79c68100）

- 包：tar `f8ac7079…`；binary `647d95bb…`；commit `79c68100`；仅 R14-QA-iPhone。
- 冷启动：卸载→安装→冷启动；8s/12s/20s 截图。
  - **8s 已出完整 Home 内容**（Hero/日期/双卡/黄历），无「准备中」白屏；12s/20s 保持。
  - 结论：**冷启动 8s 内容就绪 PASS**（本包/本机实测）。
- §8 语义（`-LixiangPlainTerm` 弹层实拍）：
  - 上巳节：文化说明（临水祓禊/踏青，各地做法不同），en cultural note → **PASS（语义内容）**
  - 重阳节：文化说明（登高/赏菊/敬老），en cultural note → PASS
  - 大林木/海中金/路旁土：纳音分类，明确“用于纪年/文化标识；与日常活动无关” → PASS
  - 不再出现活动建议；对应矩阵内容缺口行仍不自动 PASS，仍按内容缺口 NOT RUN。
- 证据：`qa/evidence/qa-startup/`、`qa/evidence/qa-s8-terms/`。
- 不 merge/发布/提审。
