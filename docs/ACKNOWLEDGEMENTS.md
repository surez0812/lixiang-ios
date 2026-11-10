# 致谢与第三方许可

本 App 只额外依赖一个开源库（历法内核），其余为 Apple SDK / Foundation。

| 组件 | 版本 | 用途 | 许可 | 版权 | 进 App？ | 随包许可文件 |
|---|---|---|---|---|---|---|
| [LunarSwift](https://github.com/6tail/lunar-swift)（`6tail/lunar-swift`） | **1.1.9**（SPM `exact`，commit `2397017c…`） | 公历/农历转换、节气、节日、黄历宜忌、冲煞、吉神凶煞、彭祖百忌、方位、建除、星宿、纳音、法定假日/调休等 | **MIT** | `Copyright (c) 2023 6tail` | 是（SPM 依赖） | 是：`App/Resources/Licenses/LunarSwift-LICENSE.txt`（实现阶段加入） |
| XcodeGen（开发工具） | 2.46.0 | 生成 Xcode 工程 | MIT | — | 否 | — |

## MIT 义务

- 保留版权声明与许可全文；App「设置 → 关于 → 数据来源与许可」可点开全文；官网 acknowledgements 同源。
- 本仓库**不修改**上游源码；若将来 fork/修改，须保留 MIT 声明并注明修改。
- 不使用上游名称/标识作背书或商标。

## 许可扫描

实现阶段加入 `scripts/box/license-scan.py`（沿用昭杳既有 App 工程做法）：
白名单 MIT / Apache-2.0 / BSD / Zlib / ISC（字体 OFL-1.1）；禁止 GPL / LGPL / AGPL。

## 已知上游权利链说明

LunarSwift 的节气算法在其生态中标注引自寿星天文历（`sxwnl`，无公开许可证）。本项目的处理：**只以 SPM 依赖方式使用、不复制源码**，并保留替换预案（决策 D3）。
