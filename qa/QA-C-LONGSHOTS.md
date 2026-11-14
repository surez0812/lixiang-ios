# C 长图核验（P1/longshots-notab，3a8b4e8b）

| 页面 | 实际 point | 实际 px | 观察 | 判定 |
|---|---:|---|---|---|
| home | 1472.7 | 1206×4418 | 无 tabbar、连续；高度<2500 | NOT RUN |
| almanac | 2293.3 | 1206×6880 | 无 tabbar、连续；高度>1650，但按 Lead 统一口径不评 PASS | NOT RUN |
| daily | 1954.7 | 1206×5864 | 无 tabbar；接缝不连续；高度<12000 | NOT RUN |
| folklore-detail | 874.0 | 1206×2622 | 单帧 locked/内容准备中；高度<2400 | NOT RUN |

- 记录“无 tabbar”改进；170-174 保持 NOT RUN；164 仍内容缺口 NOT RUN。
- 证据：`dev-evidence/P1/longshots-notab/`（manifest 与 SHA）。
