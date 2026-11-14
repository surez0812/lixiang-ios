# 交互状态抽检（Selection 结果 / Countdown 详情）

- 证据：`qa/evidence/portrait-states/`；iPhone 16 Pro portrait 1206×2622。

## Selection 结果
- 入口：择日 →「看看可参考的日期」→ 结果列表。
- 结果：**PASS**（补充 S-01，无独立设计 188 行）。
- 证据：`r14-iphone-selection-results.png` `3bf0ce2f…`。
- 检查：年份显示 **2026年11月/12月**，无千分位「2,026」；每条含日期/宜/忌/「看当日」；非空结果。
- 边界（空结果/倒置/周末/纪念冲突）**NOT RUN**。

## Countdown 详情
- 入口：`-LixiangDeepLink "lixiang://countdown/first" -LixiangSeedCountdown 1`；first 作为首条 id。
- 结果：**PASS**（设计行 97）。
- 证据：`r14-iphone-countdown-detail.png` `9334afc4…`。
- 检查：生日 / 2027-02-06 / 还有 85 天 / 农历·每年 / 本地通知 09:00；字段完整。
- 权限分支/编辑/删除/通知实际到达 **NOT RUN**。

- 矩阵：188 行 32 PASS/0 FAIL/156 NOT RUN + S-01；不 merge/发布/提审。

## Selection 结果 dark（补充 S-02）
- **PASS**：`qa/evidence/portrait-states/r14-iphone-selection-results-dark.png` `fd5fdeef…`。
- 深底可读；日期/2026 年月份/宜/忌/「看当日」完整；无千分位年份。
- 与 light 结果列表结构一致；无新增偏差。
