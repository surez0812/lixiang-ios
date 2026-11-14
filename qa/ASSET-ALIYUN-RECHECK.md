# 阿里云素材复检清单（待 PM 交付后执行）

- 基线：candidates **37 个文件 / 产品 36 + test 1**；root 48 张终稿；PM 计划补下元/祭祖 2 张。
- 当前结论：33 PASS / 3 待修 / 1 test 排除；root `term-daxue-light` 207,196B 超 120KB。
- 复检通过前**不接 App**；12 hero pending-design；内容行 85-90/163/174 NOT RUN；与 UI-001 分开；矩阵不改。

## 必修复检
| 项 | 当前问题 | 复检 acceptance |
|---|---|---|
| `fest-laba.webp` | 近空白 2.6KB | 新 SHA；可识别腊八主题；16:9 1024×576；≤120KB；无伪文字/水印/人物 |
| `fest-xiezao.webp` | 左侧伪文字/不可辨汉字 | 删除伪文字；暖纸/留白/2–4色；新 SHA/尺寸/体积 |
| `term-dashu.webp` | 顶部极细伪文字/签名水印 | 去水印/签名；新 SHA；≤120KB |
| `fest-xiayuan.webp`（补） | 缺失 | 下元节题材；16:9 ≤120KB；无宗教劝诱/场所/符咒 |
| `fest-jizu.webp`（补） | 缺失 | 祭祖题材（克制、无人物/脸/手）；safety 语义不靠图 |
| root `term-daxue-light.webp` | 207,196B >120KB | 压至 ≤120KB；新 SHA；尺寸 1500×1880/可解码；若仍超限记 spec 缺陷 |

## 全量回归
- 37/+2 候选逐张 SHA/尺寸/体积/可解码；16:9；≤120KB。
- 24 节气/12 节日题材与季节复核；无伪文字/水印/签名/人物/脸/手/宗教场所/符咒。
- 记录通过/待修清单；不修改素材、不接 App、不改矩阵。

## 复检结果（2026-11-14，全部 PASS）
- `fest-laba` `c1ae3793…` 18,666B；`fest-xiezao` `71c14231…` 18,200B；`term-dashu` `c213edbc…` 70,666B；`fest-xiayuan` `b3e0bb7f…` 23,882B；`fest-jizu` `3f733ceb…` 32,624B；root `term-daxue-light` `1b6e2610…` 115,952B / 1500×1880。
- 39 candidates = 产品38 + test1；24节气+14节日；花费 ¥11.0；6项全部 PASS。
- 12 hero 仍 pending-design；不接 App；内容行 NOT RUN；矩阵不改。
