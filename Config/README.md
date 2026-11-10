# Config

xcconfig 分层（沿用昭杳既有 App 工程约定）：`Base.xcconfig` ← `Debug/Release.xcconfig` ← 本地 `Local.xcconfig`（不入库）。

- `LIXIANG_BUNDLE_ID = xin.zhaoyao.lixiang`（Lead 2026-11-11 定；**备案后不要改**）
- `LIXIANG_MIN_IOS = 17.0`
- `SWIFT_VERSION = 6.0`
- App 显示名：中文「历象」/ 英文「Lixiang」

> 签名团队、XcodeGen `project.yml`、`Debug/Release.xcconfig` 在视觉方向定稿、工程生成阶段加入。
