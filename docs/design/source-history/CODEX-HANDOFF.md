# CODEX 交接包：历象三屏设计修订（2026-11-12）

> 用户（Sure）决定：三屏设计修订交给 Codex 全量重做。本文件是交接索引，Codex 从这里拿全部材料。

## 一、任务
按 Sure 第三轮意见**全量重做**三屏设计：首屏 Hero、每日一句 page、单日详情；含 iPad 横竖、iPhone Duo 六姿态、分享卡（仅亮色）、每日一签（整屏+动画）。**删除所有印章展示（太丑，全部去掉）。**

## 二、必读（按顺序）
1. **意见清单（唯一事实源）**：`handover/calendar-20261111/reviews/SURE-REVIEW-R3-2026-11-12.md`（A1–F3 逐条）
2. **上一版设计代码 + spec**（复用/改造）：
   - `handover/calendar-20261111/proposals/lixiang-1.0-20261111/final-revision/`
   - `build_rev.py`、`build_daily_rev.py`、`build_day_rev.py`（生成样张的脚本）
   - `R3-DELIVERY-SPEC.md`、`REVISION-SPEC.md`
   - 同目录 PNG 样张
3. **设计 skill**：
   - `.agents/skills/liquid-glass/`（Liquid Glass 规范）
   - `.agents/skills/iphone-duo-design-review/`（Duo 设计规范）
   - `.agents/skills/iphone-duo-*`（其余 Duo 相关）
4. **Duo 经验笔记**：`handover/calendar-20261111/skills/`（古琴团队沉淀，若有）

## 三、输出目录
`handover/calendar-20261111/proposals/lixiang-1.0-20261111/final-revision-codex/`（新建；不要覆盖 `final-revision/`）

## 四、硬性约束
1. **删除所有印章**：Hero/每日一句/单日详情/分享卡全部无印章。
2. 我们自己的 D1 语言：暖纸 `#FFF8EC` / 深墨 / 朱色 / 大留白 / 层级 / 圆角 / 对比 ≥4.5；**不密网格、不堆 20 小格**；允许 1–1.2 屏自然滚动。
3. Liquid Glass 只用于导航/控制层（iOS26 `glassEffect`/`GlassEffectContainer`/`.buttonStyle(.glass)`；iOS17 回退 `ultraThinMaterial`）。
4. iPhone Duo 按 Duo skill：**无 navigation bar，导航按钮用系统 toolbar 放右侧状态栏**；closed/open 竖屏同 iPhone；closed/open 横屏 + tent 同 iPad 横屏（详情+首页合并）；tabletop 按 Sure 分屏规则。
5. 每日一签：签种+签语**全本地 JSON**，手机端**不调 AI API**。
6. **只做设计/研究**：不改 App 源码、不构建、不 push、不提交审核。

## 五、交付物
- `CODEX-TASK-PLAN.md`（先写：意见→任务→交付物→状态）
- `CODEX-COVERAGE-CHECKLIST.md`（逐条完成+证据 文件名+SHA，不许漏）
- PNG 样张：
  - Hero 375 亮暗 + iPad 横竖
  - 每日一句 375 亮暗 + iPad 横竖
  - 单日详情 375 亮暗 + iPad 横竖
  - Duo 六姿态（close/open 竖横、tabletop、tent）
  - 分享卡（仅亮色）
  - 每日一签 3 关键帧（idle/shake/result）
- `CODEX-DELIVERY-SPEC.md`（D1 tokens/字号间距/Liquid Glass/Duo/动画/择日/动态高度）
- `CODEX-COPY.md`（签语样例 8–12 条、择日文案、白话示例）
- 交付摘要（文件/SHA/剩余内容依赖）

## 六、当前项目状态（供 Codex 参考）
- build13 布局**锁定**，等 Sure 拍板设计后才实现
- build12（1.0/12）已 VALID/Internal，仅内测，**不提审**
- 白话 v2 已交（321 条，含义/影响/怎么用），dev 接入中
- 节气三候已完成并 PASS（24×3=72 候名）
- 每日一签预研：本地 JSON 方案已定
- PM 可提供：白话 v2 内容、每日一签 100 条签语、择日卡文案

## 七、注意
- 若 `final-revision-codex/` 已存在，为失败兜底产物，**请忽略并重建**。
- 不确定处按「D1 风格 + Sure 意见」决定，并在 spec 标注假设。
