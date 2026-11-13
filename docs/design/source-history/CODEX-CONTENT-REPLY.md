# CODEX 内容回复（2026-11-12）

> 回应 Codex 关于设计所需内容的问题。设计交接总索引见 `CODEX-HANDOFF.md`。

## 1. 白话 v2（设计里的 ⓘ / 白话全解 用）
- **文件**：`/Users/surezhang/work/ZhaoYao/work/lixiang-ios/App/Resources/PlainLanguage/panel-terms-v2.json`
- **SHA256（单文件）**：`f6afbcfc551569ad…`（完整值以 `shasum -a 256` 为准）
- **条数**：321 条（原 8 域 317 + 冲/煞/冲煞/岁煞 4 条）
- **字段**：`term / domain / meaning / impact / usage / en`
- **内容口径**：每条「含义 / 影响 / 怎么用」三段；不预测、不恐吓、不劝诱；无 qwen/草稿标注进 UI
- **8 域**：值神、吉神宜趋、凶煞宜忌、建除十二神、彭祖百忌、星宿、纳音、胎神（+ 冲煞）
- 设计里每类术语点开后按三段展示，示例文案可直接取此文件。

## 2. 每日一签（签种/签语）
- **状态：100 条签语尚未全量交付**（PM 生产中），**设计可先用样例**。
- **预研方案**：`handover/calendar-20261111/reviews/F2-DAILY-DRAW-PRERESEARCH.md`
- **数据结构（约定）**：`signs[]`，每条 `id / type（上上/上/中/下…）/ no / level / title / poem×4 / explain / advice / keywords`；另有 365 日 → 签的确定性索引（缺日哈希）。
- **样例签**：「第三十六签 · 上上 / 静水流深」。
- **设计稿参考**：`proposals/lixiang-1.0-20261111/final-revision/qiandaily-{idle,shake,result}.png`（旧版整屏/动画关键帧，可改造）。
- **生成脚本参考**：`proposals/lixiang-1.0-20261111/final-revision/build_sign.py`。
- **硬约束**：签种+签语全部本地 JSON，手机端不调 AI API；动画签筒摇→翻卡 ≤900ms，Reduce Motion 静态。

## 3. QA 现状（供设计验收参考）
- **三候**：`qa/build13/REPORT-PENTAD2.md` → **PASS**（12/22 冬至一候蚯蚓结、12/27 二候麋角解、01/05 小寒一候雁北乡）。
- **白话 v2**：`qa/build13/REPORT-V2TERMS.md` → 值神三段 PASS；**冲煞行曾缺失**，已修（coreSection 加冲煞 + 8 域 ⓘ + DEBUG 直达），新包 `B13-Lixiang-app-v2terms2.tar.gz`（`f396d7e9…`）待 QA 复验冲煞/8 域/罗盘 sheet。
- 其余交互（点击/分享/QR/滑日/罗盘真机）多 NOTRUN，等真机 smoke。

## 4. App / 版本状态
- build12 **1.0/12**：VALID + Internal（TestFlight 可装），仅内测，**不提审**。
- build13 布局**锁定**，等 Sure 对三屏设计拍板后才实现。
- 代码 HEAD `feat/build13` `1122b36…`（未 push）；build13 版本号 13。

## 5. 设计交付要求（再确认）
- **删除所有印章**。
- D1 风格：暖纸 #FFF8EC / 深墨 / 朱色 / 大留白 / 层级；不密网格；1–1.2 屏滚动。
- Liquid Glass 只用于导航/控制层；Duo 导航按钮在右侧状态栏。
- 输出到 `proposals/lixiang-1.0-20261111/final-revision-codex/`。
- 必须交：任务计划、逐条覆盖清单、PNG 样张（375 亮暗/iPad 横竖/Duo 六姿态/分享卡亮色/每日一签 3 帧）、spec、文案汇总。

## 6. 联系/取件
- 交接总索引：`handover/calendar-20261111/reviews/CODEX-HANDOFF.md`
- 用户意见：`handover/calendar-20261111/reviews/SURE-REVIEW-R3-2026-11-12.md`
