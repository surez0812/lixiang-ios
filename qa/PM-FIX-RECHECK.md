# PM 修复截图复核（HEAD 6e183cf3 前交付图）

- 证据目录：`dev-evidence/P1/shots/r14-pm-*`、`r14-boot-3s/10s.png`；仅静态图复核，未操作 R14-Duo。
- 本轮为 PM 视觉复核，不新增 188 矩阵行；结论供 PM/Lead 决定是否回写实现。

| 项 | 证据 | 结论 |
|---|---|---|
| Home 两常驻卡 | `r14-pm-home-light/dark.png` | **PASS**：今日岁时、今日纪念两卡常驻；亮/暗可读。 |
| Almanac 当日岁时 | `r14-pm-almanac-festival.png` | **PASS**：2026-12-22 冬至「当日岁时 冬至」行可见。 |
| Almanac 暖纸背景 | `r14-pm-almanac-light/dark.png` | **PASS**：暖纸底与暗色变体均可见；无白底突兀。 |
| 白话逐项 | `r14-pm-almanac-vernacular.png` | **PASS**：开关开，逐项含义可读。 |
| 真玻璃 tabbar | `r14-pm-home-*`、`r14-pm-almanac-*` | **视觉通过/待运行时确认**：胶囊浮层+透出底色；静态图不能证明真实 Liquid Glass 材质。 |
| serif 回退位 | 上述截图 | **仍为系统 serif 回退**；Songti/Kaiti 缺失未解决，不标字体 PASS。 |
| 黄历卡间距 | `r14-pm-almanac-*` | **未充分证明**：首屏只到宜忌列表；未见完整黄历卡全貌，保留待验。 |
| iPad 两卡 | `r14-pm-ipad-home-light2.png` | **偏差提示**：iPad Home 未见今日岁时/纪念两卡（仅每日一签/天气）；若两卡要求覆盖 iPad，需补。 |
| 冷启动 | `r14-boot-3s/10s.png` | 3s 为“历象·正在准备今日”加载态（非白屏）；10s 已进入首页 → **改善 PASS** |
| 重复/命名 | `r14-pm-ipad-almanac-light.png` 与 `dark.png` 同 SHA `789af868…` | 需 dev 确认是否误拷；不影响手机结论。 |
