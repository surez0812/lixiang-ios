# R14 动态字体（xLarge）抽检

- 方式：`-LixiangTypeScale xl`（Lead/dev 已实测）；本 QA 使用 dev 证据并目视核对，非 `simctl content_size`。
- 状态：**PASS（补充项，不属于 188 设计状态行）**；矩阵 188 行不新增，避免计数口径污染。
- 覆盖 5 页（xLarge）：
  1. Home：`qa/evidence/dynamic-v2/xl-home.png` SHA `c43e4d3e…`；双卡/标题/Hero 可读。
  2. Almanac：`qa/evidence/dynamic-v2/xl-almanac.png` SHA `3f230e4d…`；宜忌列表可滚动、无裁切首屏。
  3. Compass：`qa/evidence/dynamic-v2/xl-compass.png` SHA `86ba8761…`；罗盘/图例可读。
  4. Daily：`qa/evidence/dynamic-v2/xl-daily.png` SHA `d2963f1f…`；正文换行/分享入口可见。
  5. Folklore detail：`qa/evidence/dynamic-v2/xl-folklore-detail.png` SHA `e118095e…`；紧凑头/锁定态不重叠。
- 说明：只验证字体放大布局；VoiceOver、最大 Accessibility 字号（a1）、旋转组合未测 → NOT RUN。


## 字体已知偏差
- 模拟器无 Songti/Kaiti；实现回退系统 serif。与设计宋体字面不同，**不标 PASS**，记为已知偏差。
