# iPad landscape 路由视觉对照（HEAD 新证据）

- 证据：`qa/evidence/ipad-landscape/r14-ipad-landscape-{almanac,compass,daily,fortune,selection}.png`；2752×2064。
- **结论：5 页均存在布局偏差，矩阵均标 FAIL（视觉偏差，不是崩溃）。**

| 页面 | 矩阵行 | 设计合同 | 实现 | 判定 |
|---|---:|---|---|---|
| almanac | 17 | 左 Hero+宜忌；右十二时辰 | 左 Hero 空；右宜忌+时辰 | **FAIL/偏差** |
| compass | 125 | 左控件；右罗盘+图例 | 全宽居中单列，控件在上 | **FAIL/偏差** |
| daily | 77 | 左解释；右分享卡两列 | 单列全宽，无右分享列 | **FAIL/偏差** |
| fortune | 113 | 左标题；右签筒；底部全宽按钮+跳过 | 标题左上、签筒右、按钮偏小、跳过缺失 | **FAIL/偏差** |
| selection | 65 | 左表单；右结果两列 | 单列全宽，结果不在右列 | **FAIL/偏差** |

- 不 merge/发布/提审；等 dev 修后按同一设计图复评。
