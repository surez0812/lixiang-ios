# 历象 R14 实施计划（2026-11-13）

基线：`codex-review-v13` 的 **R14 + HOME-TOOLS-UPDATE**，交接目录
`/Users/surezhang/work/ZhaoYao/work/lixiang-design-handoff-20261113/docs/design/`
（`IMPLEMENTATION-HANDOFF.md`、`PAGE-CONTRACTS.md`、`SCREEN-INVENTORY.md`、`r14-final/`）。
本计划写于开发分支 `feat/r14-implementation`（worktree `work/lixiang-r14`），基线 commit `98c5c0a`（build13 收口）。

## 0. 授权与边界
- 允许：设计→开发、在独立开发分支实现、模拟器/真机自测、团队 QA、交付可运行 App 与代码供 Codex/Sure review。
- 不允许：App Store 提审/对外发布/生产部署/合并他人分支/权限扩张/付费/自动合并；不动设计工作树实现。
- build12 不作为本次成品；不覆盖/不冒称已验证；不改其他项目。
- 设计冻结件：`ApprovedMotionManifest.json`（1450ms core/assets SHA）、`ApprovedFortuneCore.js`、`AnimationTimeline.json`、`ios-handoff/LixiangAssets.xcassets`、`templates/` 与 `webpages/`。

## 1. 范围（requirements）
| ID | 要求 | 证据 |
|---|---|---|
| R01 | 5 Tab：日历、岁时、择日、倒计日、设置；无旧 day/左右滑日/独立择日 panel | 路由表+导航测试 |
| R02 | 普通 iPhone 仅竖屏浅/深；iPad 横竖浅/深；Duo 六姿态；**Splitview 排除** | 12 画布矩阵 |
| R03 | **Tabletop = Open Portrait 669×951**，共享布局/路由语义/状态不丢；不做横屏 | 14 状态对照 |
| R04 | 首页双卡内容自适应**等高**，图标+粗体同排，标题/说明行分别对齐；取消 112/156pt；触控≥44pt、距下 16pt | 17 首页状态 + 大字号/长城市 |
| R05 | 黄历任意所选日整组重算（黄历/时辰/岁时/方向），前一天/后一天；跨月/跨年/闰年/时区 | 日期链路测试 |
| R06 | 白话开/关两态，逐项解释 vs 紧凑保留全部字段；本机持久化 | 双向恢复测试 |
| R07 | 罗盘独立页，日/时、十二时辰、五吉神/煞方；普通 iPhone/iPad 右上「值神罗盘」玻璃文字按钮；Duo 侧栏关系 | 初入/12 时辰/往返 |
| R08 | 每日一句四传统、完整经文/出处/含义/应用、分享卡 QR；亮色分享、无印章 | 长文/扫码/分享失败 |
| R09 | 一签 1450ms 冻结核心/素材，标题 0–1450ms+结果常驻；结果全显无内部滚动；减少动态/中断/同日同签 | Manifest SHA + 5 时间点 |
| R10 | 岁时根 Tab 列表（类别/日期/剩余/解锁/未读）；详情 eventID+contentVersion；未解锁不泄正文；Web 正文 | 0/10/11/15 天/版本未读 |
| R11 | 择日：事项/起止/周末/不与纪念冲突；结果→带日期黄历 | 合法/倒置/空/跨月 |
| R12 | 倒计日多条：名称/日期/历法/重复/提醒；Tab 显示最近未来天数（0 显示字符串 0）；详情编辑/删除/通知 | 多条/0/10/11/无记录 |
| R13 | 设置：外观/历法显示/经典偏好/术语/提醒/许可/关于隐私支持；版本来自真实 build | 重启/跨页/系统切换 |
| R14 | 权限只用后请求；拒绝不阻断核心；设置返回重读；不编造城市 | 权限全分支 |
| R15 | 无印章；暖纸/深墨/朱色/大留白；Liquid Glass 仅导航控制 | 视觉审查/PNG 对照 |
| R16 | 真实数据/完整签库/ContentVersion；HTML fixture/10 样签/示意权限不冒充实现 | 数据来源表+测试 |
| R17 | 188 状态矩阵逐项 PASS/FAIL/NOT RUN（区分真机/模拟器/设计） | QA 矩阵+截图/录屏 |

## 2. 页面 → 状态（共 188，逐项以 `screens.json` 为准）
按完整 page 字段分组（11 类，不合并前缀、不重复计详情页）：

| page | 状态数 |
|---|---:|
| home | 17 |
| almanac | 30 |
| compass | 24 |
| daily | 13 |
| fortune | 24 |
| folklore | 12 |
| folklore-detail | 15 |
| selection | 12 |
| countdown | 12 |
| countdown-detail | 17 |
| settings | 12 |
| **合计** | **188** |

QA 矩阵必须从 `screens.json` 逐条生成（按 page/mode/state/file 唯一行），不得手工聚合或按前缀合并。

## 3. 阶段与里程碑
| 阶段 | 内容 | 退出条件 |
|---|---|---|
| P0 基线/契约 | 分支/worktree、设计资产只读导入、12 画布构建脚本、需求矩阵登记 | 计划/矩阵/资产 SHA 入库；基线可构建 |
| P1 数据/状态 | 日期选择 store、黄历整组重算、岁时/节日、时辰/方位、四传统内容、签库、倒计日 store、设置持久化 | 单元测试；一条「日期→黄历→罗盘→返回」链路 |
| P2 导航/设备 | 5 Tab 根、路由、iPhone/iPad/Duo 六姿态、Tabletop=OpenPortrait、safe area/侧栏、Splitview 排除 | 12 画布空壳/导航 PASS |
| P3 逐页实现 | 11 类页面按 screens.json 状态；先 home→almanac→compass，再 daily/fortune/selection，再 folklore/countdown/settings | 每页状态自测+截图 |
| P4 内容/权限/动画 | 完整签库、岁时模板/内容版本、天气定位、通知、WKWebView 离线/失败、冻结动画核对 | 内容/权限分支测试；Manifest SHA |
| P5 团队 QA | 非作者 QA、设备矩阵、E2E 场景、缺陷修复回归 | 188 矩阵 + 截图/录屏 + 已知缺陷 |
| P6 交付 | App 路径/SHA/版本/build、源码 commit、复现步骤、PASS/FAIL/NOT RUN、Codex review 包 | 交付清单齐全 |

依赖：P1→P2→P3→P4→P5；P0 先行。设备适配与页面实现可并行但以 P2 根壳为前置。
时间不作虚假承诺：以 3 名 iOS 开发 + 1 QA + PM/设计支持估算 **4–6 周**（含返工），按 2 天节奏报实际进度与偏差。

## 4. 任务/责任人/依赖/验收
| 卡 | 任务 | 责任人 | 依赖 | 验收证据 |
|---|---|---|---|---|
| T0 | 基线/资产/矩阵/构建脚本 | PM+Lead | — | 计划+矩阵+12 画布脚本+资产 SHA |
| T1 | Root/5Tab/路由/设备适配（iPhone portrait、iPad、Duo 6 姿态、Tabletop=OpenPortrait） | calendar-dev | T0 | 导航测试+12 画布空壳截图 |
| T2 | 数据层：日期 store、黄历重算、岁时/节日、时辰/方位、设置/四传统/签库/倒计日 | calendar-dev | T0 | 单测+链路测试 |
| T3 | Home + Almanac + Compass | calendar-dev2 | T1,T2 | 17/30/24 状态截图+交互 |
| T4 | Daily + Fortune + Selection | calendar-dev3 | T1,T2 | 13/24/12 状态+动画 5 时间点 |
| T5 | Folklore/详情 + Countdown/详情 + Settings | calendar-dev4 | T1,T2 | 27/12/12/29/12/12 状态 |
| T6 | 内容：完整签库、岁时模板/版本、来源许可、分享 QR | PM+designer | T2 | 内容清单+SHA+版本表 |
| T7 | 权限/天气/通知/WKWebView/离线 | calendar-dev4 | T5 | 权限全分支+离线/失败测试 |
| T8 | 视觉/设计对照（tokens/间距/PNG 差异） | designer | T1 | 逐页差异清单+PASS |
| T9 | 团队非作者 QA/设备矩阵/录屏 | calendar-qa | T3–T7 | 188 状态矩阵+PASS/FAIL/NOT RUN |
| T10 | 构建/交付包/复现/回滚 | Lead+calendar-dev | T9 | App 路径/SHA/版本/commit/命令 |

## 5. 设备矩阵（12 画布）
- phone-light / phone-dark：375×930（仅竖屏）
- iPad portrait / landscape × light/dark：834×1194、1194×834
- Duo：closed portrait 466×678、closed landscape 678×466、tent 678×466、open portrait 669×951、open landscape 951×669、tabletop 669×951（=open portrait 布局）

模拟器：iPhone 17 Pro（或 16 Pro）、iPad Pro 13、Duo（UDID 既有）。真机：能拿到则补；拿不到标 NOT RUN。

## 6. 验收场景（每页/全局）
启动/返回/重复点击；切 Tab；旋转/折叠/展开/tabletop/tent 中断；权限拒绝/取消/设置返回；无网/加载失败/重试；长文/动态字号/VoiceOver；日/时切换与跨日持久化；冷启动恢复；分享取消/失败/重复；同日同签/跨日重抽；通知安排/取消/修改。

## 7. 风险
- 188 状态量大，单 dev 不可行 → 4 人并行（T3–T5 文件目录隔离）。
- 设计 HTML 为离线合成，非原生；safe area/hinge/玻璃/键盘/滚动需原生验证。
- Duo 模拟器与 iOS 27 SDK 依赖环境；无真机则相关项标 NOT RUN。
- 内容缺口（签库仅 10 样、岁时正文）需内容线并行；未齐的页面用明确占位并标 NOT RUN，不冒称完成。
- 与 build13 内容线/主站并行：本分支独立，不 merge，不动其他 worktree。
- 固定日期 fixture 不得上线：数据层单测覆盖跨日/跨年/闰年/时区。

## 8. 交付定义（Done）
- 12 画布可运行 App + 188 状态矩阵（PASS/FAIL/NOT RUN，含证据）。
- 源码 `feat/r14-implementation` 精确 commit + diff；App 路径/SHA256/版本/build。
- 构建复现命令与依赖；冻结素材 SHA 核对；已知缺陷/NOT RUN 清单；回滚点。
- 作者自测 + 非作者 QA + Lead review；团队通过后交 Codex 独立 review，再等 Sure 验收。不提审/不发布。

## 5. P0 执行状态（2026-11-13）
- 设计资产**只读**导入：`App/Sources/DesignSystem/R14Assets.xcassets`（tab-calendar/tab-suishi/TabSelection/tab-countdown/tab-settings/compass-dial/fortune-cup/paper/stick）+ `R14Design/{ApprovedMotionManifest,AnimationTimeline,ApprovedFortuneCore.js}`；设计工作树未修改。
- 构建验证：xcodegen + xcodebuild Debug **BUILD SUCCEEDED**；`Assets.car` 已含上述 imageset。
- 矩阵：`docs/R14-SCREEN-MATRIX.csv`（188 状态，11 页面 × 12 画布）、`docs/R14-CANVAS-MATRIX.csv`（脚本 `scripts/gen-r14-canvas.sh`，只读设计树）、`docs/R14-REQUIREMENTS-MATRIX.csv`（R01–R17 → task/owner/证据）。
- 基线：`feat/r14-implementation` @ `98c5c0a`（worktree `work/lixiang-r14`）；不改 build13/不 merge。
- T1/T2 下一里程碑：5-Tab Root + Route + DevicePolicy 根壳（12 画布空壳）+ 单元测试（selectedDate 整组重算）。

## 6. 设备/路由政策（实现口径）
- iPhone：仅 portrait（`UIDevice` 不做横屏；`supportedInterfaceOrientations` 只 portrait）。
- iPad：portrait/landscape 均支持；宽屏（≥744pt 短边序）双列布局。
- Duo：closed-portrait 466×678 / closed-landscape 678×466 / tent 678×466 / open-portrait 669×951 / open-landscape 951×669 / tabletop 669×951；Tabletop 使用 OpenPortrait 布局容器，切换保留 selectedDate/tab/滚动状态。
- Split View/Stage Manager：v1.0 排除（不实现）。
- 5 Tab：日历/岁时/择日/倒计日/设置；路由 `home, almanac(date), compass(date, hour), daily, fortune, folklore, folklore-detail(eventID,version), selection, countdown, countdown-detail(id), settings`；无旧 day/pager 路由。
