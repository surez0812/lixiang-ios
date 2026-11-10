# 历象 / Lixiang Almanac · iOS

> **状态：仓库骨架初始化（2026-11-11）。本仓库当前不含产品代码。**
> UI 实现门禁：视觉方向待 Sure 定稿（3 方向重选中）；本阶段只允许仓库骨架 / 文档 / 核心包骨架。

中国万年历 iOS App（iPhone / iPhone Duo / iPad）：公历·农历·节气·节日·黄历宜忌·冲煞·吉神凶煞·彭祖百忌·福神·生日纪念日·假期调休·民俗内容按日期解锁。

- **产品名**：历象 / Lixiang Almanac
- **Bundle ID**：`xin.zhaoyao.lixiang`
- **最低系统**：iOS 17.0
- **语言**：zh-Hans + en（UI/商店/隐私；节俗正文 zh 先行、en 后补）
- **形态**：免费、无广告、无账号、无统计 SDK；核心历法全离线

## 技术栈（已定）

| 层 | 选择 |
|---|---|
| UI | SwiftUI（iOS 17+），Swift 6 语言模式 |
| 历法内核 | [`6tail/lunar-swift`](https://github.com/6tail/lunar-swift) **1.1.9（MIT，SPM，exact pin）**——**只在 `LixiangCalendarCore` 的引擎适配层 import** |
| 领域包 | `LixiangCalendarCore`（本仓库 `packages/`） |
| 工程生成 | XcodeGen（视觉方向定稿后加入 `project.yml`） |
| 测试 | Swift Testing + XCTest/UI 测试（实现阶段）；对拍 golden fixtures |
| 内容 | 结构化 JSON（原生渲染）+ 静态发布/每日解锁（`https://lixiang.zhaoyao.xin/ceremony/<slug>`） |

## 目录（当前骨架）

```
Config/                        # xcconfig（bundle id / 最低 iOS / Swift 版本）
docs/                          # 决策、致谢与许可、数据来源
packages/LixiangCalendarCore/  # 我方 SPM 包（领域层 + 引擎适配）— 当前仅占位
App/                           # App 源码目录（占位；产品代码待视觉批）
Tests/                         # App 层测试目录（占位）
scripts/                       # 构建/QA/发版脚本（占位）
```

## 开发（当前可做）

```bash
# 核心包骨架（需网络拉取 LunarSwift 1.1.9）
cd packages/LixiangCalendarCore && swift build && swift test
```

> 开发机注意（本团队 workstation）：若 PATH 中 `/usr/local/bin/git` 架构不符（`Bad CPU type`），SwiftPM 拉依赖会失败；请让 `/usr/bin/git` 优先，例如：
> `PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin swift build`

## 不在本阶段范围

- App 产品代码（UI/业务逻辑/资源）——等 Sure 批准视觉方向与 mockup
- Xcode 工程（`project.yml` / `.xcodeproj`）
- 内容正文与内容服务实现
- App Store 提审、签名、TestFlight

## 许可

本仓库代码为专有（见 `LICENSE`）。第三方依赖许可见 `docs/ACKNOWLEDGEMENTS.md`（`LunarSwift`，MIT）。
