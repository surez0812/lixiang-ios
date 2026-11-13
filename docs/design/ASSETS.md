# R14 视觉资产清单（交 dev 接入）

来源：`r14-final/assets`、`r14-final/ios-handoff`、`r14-final/tools`；本清单只登记，不复制大文件到文档目录。

## 1. Tab 图标（5 枚）
目录：`r14-final/assets/tab-icons/`；Xcode：`r14-final/ios-handoff/LixiangAssets.xcassets/`
| Tab | SVG | PDF（矢量模板） | PNG 1x/2x/3x | Asset |
|---|---|---|---|---|
| 日历 | `tab-calendar.svg` | `tab-calendar.pdf` | 28/56/84 | `tab-calendar.imageset` |
| 岁时 | `tab-suishi.svg` | `tab-suishi.pdf` | 28/56/84 | `tab-suishi.imageset` |
| 择日 | `tab-selection.svg` | `tab-selection.pdf` | 28/56/84 | `TabSelection.imageset`（注意大小写命名） |
| 倒计日 | `tab-countdown.svg` | `tab-countdown.pdf` | 28/56/84 | `tab-countdown.imageset` |
| 设置 | `tab-settings.svg` | `tab-settings.pdf` | 28/56/84 | `tab-settings.imageset` |

- 规格：28×28 canvas；内容安全 2px；描边 1.8，round cap/join；`currentColor`，SwiftUI `.renderingMode(.template)`；选中 red、未选 ink3/muted。
- ⚠️ 设计 README 仍写“4 枚”，R14 实际为 5 Tab；`tab-selection` 资产已存在，dev 按 5 枚接入，README 待 PM 更新（不改素材）。
- 建议 Asset Catalog 用 PDF（preserve vector），无需 1x/2x/3x PNG；若用 PNG 按 28/56/84。

## 2. Fortune 冻结资产（不可改）
目录：`r14-final/assets/`
| 资产 | 文件 | 冻结 SHA256（ApprovedMotionManifest） |
|---|---|---|
| 签筒 | `fortune-cup.png` | `e581f193a6243219d022cb8aae2cd34a4c79754f7411dccea74fa46f73bd914a` |
| 签条 | `fortune-stick.png` | `69386dd57e90f3650f3dabc7d8c585ba3d42d8667245e990578dbc88a78bda26` |
| 签纸 | `fortune-paper.png` | `9741cf8667a3d9f98ede942d59206ed008d59508eca3aec50e19ffa285a67e66` |
| 演示 GIF | `fortune-demo.gif` | `0bcfeaa810369bd482bd359ac2815c7197b5b45dd9fe4a098408eeeb24179a67` |
| 演示 MP4 | `fortune-demo.mp4` | `fe14e215f65bf7780d87923586ebcb160b20d385618c8b34fb0adebc2ff330eb` |
| 动画时间线 | `ios-handoff/AnimationTimeline.json` | `83c1b6db35fc6635791d5a06a097b532ee7ff9100977abe1f5767c08f12159fe` |
- Xcode：`ios-handoff/LixiangAssets.xcassets/`：`fortune-cup.imageset`、`fortune-stick.imageset`、`fortune-paper.imageset`；另 `compass-dial.imageset`。
- Manifest：`r14-final/ApprovedMotionManifest.json`（scriptSHA256 `e05161ad…`，durationMs **1450**）；参考 HTML `approved-r7/fortune-demo.html` SHA `e239518e…`。
- Timeline 关键：press 0–180 / shake 180–600 / lift 600–1050 / reveal 1050–1450；reducedMotion opacity-only 150ms；同日同签按 Asia/Shanghai；本地 JSON，不调 AI。
- Core：`r14-final/ApprovedFortuneCore.js`；样本 `ios-handoff/fortune-samples.json`（10 条，非完整签库）。
- Swift 参考：`ios-handoff/FortuneAnimationView.swift`、`FortuneAdaptiveDemoView.swift`、`DailyDrawStore.swift`。
- **接入验收**：不改动作数学/素材；5 关键时间点、跳过/减少动态/中断/折叠/同日跨日必须原生验证；PNG/mp4 只作离线证据。

## 3. 其他设计资产
| 资产 | 路径 | 说明 |
|---|---|---|
| 罗盘盘面 | `assets/compass-dial.png` / xcassets `compass-dial.imageset` | 1134×1146，透明裁边；不得重绘 |
| 节气/季节插画 | `r14-final/assets/`、`SeasonalArt/` | 16:9 webp/设计原图；见 `ASSET-PROMPTS.md` |
| 岁时正文模板 | `r14-final/templates/`、`webpages/` | festival-article.css 等；App 端 WKWebView 用 |
| 首页工具卡 | `HOME-TOOLS-*` | 自适应等高、不硬编码 112/156 |
| 品牌/年份 | 无印章资产；R14 无印章 | 不要从旧 final-revision 引入印章 |

## 4. 接入顺序
1) 建 Asset Catalog（PDF tab + fortune/compass 原图）→ 校验 SHA。
2) Dynamic color tokens（TOKENS.md）→ 浅/深/高对比。
3) Fortune 冻结动画（manifest/timeline/core）→ 五关键时间点原生截图。
4) 188 屏 HTML/PNG 对照（见 VISUAL-ACCEPTANCE.md）。
