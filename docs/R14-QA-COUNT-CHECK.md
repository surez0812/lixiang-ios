# R14 页面计数对照（screens.json vs QA 矩阵）

- 权威源：`/Users/surezhang/work/ZhaoYao/work/lixiang-design-handoff-20261113/docs/design/r14-final/screens.json`
- 矩阵：`{MATRIX}`

| 页面 | screens.json | 矩阵行数 | 一致 |
|---|---:|---:|---|
| home | 17 | 17 | ✅ |
| almanac | 30 | 30 | ✅ |
| folklore | 12 | 12 | ✅ |
| countdown | 12 | 12 | ✅ |
| settings | 12 | 12 | ✅ |
| selection | 12 | 12 | ✅ |
| daily | 13 | 13 | ✅ |
| folklore-detail | 15 | 15 | ✅ |
| countdown-detail | 17 | 17 | ✅ |
| fortune | 24 | 24 | ✅ |
| compass | 24 | 24 | ✅ |
| **合计** | **188** | **188** | ✅ |

## 规则
- 不合并 folklore/folklore-detail、countdown/countdown-detail；不把详情页重复计入根页。
- 矩阵只由 `scripts/r14-matrix-gen.py` 从 screens.json 生成；本检查失败即阻断 QA 交付。
