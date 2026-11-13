# R14 设计资产导入清单（只读来源 → 开发分支）

来源根：`/Users/surezhang/work/ZhaoYao/work/lixiang-design-handoff-20261113/docs/design/r14-final/`
导入日期：2026-11-13；导入人：Lead（P0）

## 已导入 App 资源
| 目标 | 来源 | 说明 |
|---|---|---|
| `App/Resources/Assets.xcassets/*.imageset` | `ios-handoff/LixiangAssets.xcassets/` | TabSelection、tab-calendar/suishi/selection?/countdown/settings、compass-dial、fortune-cup/paper/stick |
| `App/Resources/Fortune/ApprovedMotionManifest.json` | `ApprovedMotionManifest.json` | 1450ms 冻结核心/素材 SHA 清单 |
| `App/Resources/Fortune/ApprovedFortuneCore.js` | `ApprovedFortuneCore.js` | 动作数学参考（只读参考，不直接运行） |
| `App/Resources/Fortune/AnimationTimeline.json` | `ios-handoff/AnimationTimeline.json` | 关键帧时间线 |
| `App/Resources/Fortune/fortune-samples.json` | `assets/fortune-samples.json` | 10 条样签（不是完整签库） |

## 冻结 SHA（必须与 Manifest 对齐）
- `fortune-cup.png` `e581f193a6243219d022cb8aae2cd34a4c79754f7411dccea74fa46f73bd914a`
- `fortune-stick.png` `69386dd57e90f3650f3dabc7d8c585ba3d42d8667245e990578dbc88a78bda26`
- `fortune-paper.png` `9741cf8667a3d9f98ede942d59206ed008d59508eca3aec50e19ffa285a67e66`
- `ApprovedMotionManifest.json` `56eb23d500e50e40c1fc4247b4902a83068b18efda1af79a9994b33cb8674ad3`
- `ApprovedFortuneCore.js` `e05161ade7050d35af8ac2a9dca423a9a803f38ab988825c46f73f01a7a96c4b`

## 工具
- `scripts/r14-build-sim.sh <UDID> [screenshot.png]`：xcodegen → xcodebuild → install → launch → 可选截图。
- 设备：iPhone 17/16 Pro（竖屏）、iPad Pro 13（横竖）、Duo（六姿态）；模拟器列表见 `xcrun simctl list devices available`。
