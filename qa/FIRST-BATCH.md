# R14 非作者 QA · 首批（2026-11-13）

## 构建/安装
- `scripts/r14-build.sh`：**NOT RUN / 环境阻塞**；exit 74，`xcodebuild` 无法写 `~/Library/Caches/org.swift.swiftpm/manifests`（Operation not permitted），非产品编译错误。
- 使用开发机现有构建：`DerivedData/Build/Products/Debug-iphonesimulator/Lixiang.app`，Info **1.0 (13)**，`Lixiang` SHA256 `6a504c896e0a14f5…`；安装/启动由 `scripts/r14-sim-qa.sh` 验证一次（exit 0，证据 manifest）。
- 设备：iPhone 16 Pro iOS18.6、iPad Pro 13 iOS18.6（横屏）、Duo iOS27.2 内屏（display UUID `B7790CCE-2FA8-4DA7-A92C-94F0D2A07959`）。

## 五 Tab 首屏结果
| Tab | iPhone 16 Pro | iPad Pro 13（横） | Duo 内屏 |
|---|---|---|---|
| 0 日历/home | **PASS**（20s 冷启动后） | **PASS** | NOT RUN（黑屏） |
| 1 岁时/folklore | **PASS** | **PASS** | NOT RUN（黑屏） |
| 2 择日/selection | **FAIL：占位页**「页面待实现(T3-T5)」 | **FAIL：占位页** | NOT RUN（黑屏） |
| 3 倒计日/countdown | **PASS**（空态） | **PASS** | NOT RUN（黑屏） |
| 4 设置/settings | **PASS** | **PASS** | NOT RUN（黑屏） |

- 证据：`qa/evidence/firstbatch/iPhone16Pro-tab{0-retry,1-20s,2-20s,3-20s,4-20s}.png`；`iPadPro13-tab{0..4}-20s.png`；`DuoInner-tab{0..4}.png`。
- 首次 12s 截图 iPhone 出现 Home（冷启动未完成）；20s 重拍后正常，不计产品 FAIL。
- iPad 是 **landscape** 2752×2064；未覆盖 portrait，矩阵对应 portrait 行仍 NOT RUN。
- Duo 内屏五张均同 SHA `fcff7a2e8fa49789…`、黑屏；不伪造 PASS，标 **NOT RUN**，待姿态/内屏支持修复。

## 其他
- 天气六态：首个 home 仅「开启定位」初始态；loaded/denied/loading 等 **NOT RUN**，未用参考图冒充原生。
- 动态字体/VoiceOver/E2E 16 场景：**NOT RUN**。
- 矩阵已按证据填 8 PASS / 2 FAIL / 178 NOT RUN；`docs/R14-QA-MATRIX.md` SHA `9ac6d1da…`；计数检查 `docs/R14-QA-COUNT-CHECK.md` 一致。
- 另：首屏 selection 占位属已知未实现（R14 计划 T3–T5），但已可见，按 FAIL 记录。
- 不 merge/发布/提审。
