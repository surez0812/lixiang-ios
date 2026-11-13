# 历象 R14 · 设计交接索引（designer 维护）

来源（唯一基线）：`work/lixiang-design-handoff-20261113/docs/design/`
- `IMPLEMENTATION-HANDOFF.md`（冲突消解/门禁）
- `PAGE-CONTRACTS.md`（11 类页面 + 验收）
- `r14-final/R14-DESIGN-SPEC.md`、`R14-COVERAGE.md`、`screens.json`
- `r14-final/index.html`（188 屏可点原型 + PNG 索引）
- `r14-final/HOME-TOOLS-UPDATE.md`（首页双卡最后补充）

本目录交付（给 dev/QA）：
| 文件 | 用途 |
|---|---|
| `TOKENS.md` | D1 色值/字号/间距/圆角/玻璃控制/触控规格 |
| `ASSETS.md` | tab 图标、fortune 冻结素材、motion manifest、compass dial 清单与 SHA |
| `VISUAL-ACCEPTANCE.md` | 逐页视觉对照方法/严重度/差异分级 |
| `SCREEN-VISUAL-CHECKLIST.csv` | 188 屏逐条对照表（待 QA 填原生截图与差异） |
| `SCREEN-SUMMARY.md` | 12 画布 × 188 状态计数与重点风险 |

状态：设计稿/PNG 为离线合成，不是原生截图；真实设备 safe area/玻璃/动态字体需原生验证。设计侧只读，不写产品代码。

## 路径约定
- 设计 PNG/HTML 基址：`work/lixiang-design-handoff-20261113/docs/design/r14-final/`
- CSV 中 `design_html`/`design_png` 均为该基址下的相对路径。
- 本目录（`work/lixiang-r14/docs/design/`）为设计侧只读交付；不写 App 产品代码。
