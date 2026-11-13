# R14 需求→页面→任务→责任→依赖→验收 总表（PM）

- 2026-11-13｜基线：handoff `docs/design/`（IMPLEMENTATION-HANDOFF/PAGE-CONTRACTS/SCREEN-INVENTORY/r14-final）；R14 计划 `R14-IMPLEMENTATION-PLAN.md`；分支 `feat/r14-implementation`（worktree `work/lixiang-r14`，基线 `98c5c0a`）
- 范围：188 状态 / 12 画布 / 11 类页面；普通 iPhone portrait only、iPad 横竖、Duo 六姿态、Splitview 排除
- 规则：不 merge/push/发布/提审、不动设计工作树；作者自测≠团队验收，团队验收≠Codex/Sure 终验

## 1. 需求矩阵（R01–R17）
| ID | 需求 | 页面/范围 | 任务 | owner | 依赖 | 验收证据 |
|---|---|---|---|---|---|---|
| R01 | 5 Tab：日历/岁时/择日/倒计日/设置；无旧 day 路由、左右滑日、独立择日 panel | 全局导航 | 路由表/根 Tab/删除旧路由 | dev | P0 | 路由表+导航测试 |
| R02 | 普通 iPhone 仅 portrait 浅/深；iPad 横竖；Duo 六姿态；Splitview 排除 | 12 画布 | 设备矩阵/尺寸构建 | dev+designer | P0 | 12 画布截图 + 设备矩阵 |
| R03 | Tabletop = Open Portrait 669×951 共享布局；路由语义保留、状态不丢 | Duo tabletop | 姿态路由/状态恢复 | dev | R02 | 14 状态对照 + 切换不丢状态 |
| R04 | 首页双卡内容自适应等高（图标+粗体同排；标题/说明分别对齐；取消 112/156pt；触控≥44、距下16） | home 17 态 | 双卡组件/动态高度 | dev | P1 | 17 首页状态 + 大字号/长城市 |
| R05 | 黄历任意所选日整组重算；前一天/后一天；跨月/跨年/闰年/时区 | almanac 30 | 日期 store/整组重算 | dev | P1 | 日期链路测试 + 负向回归 |
| R06 | 白话开/关两态，逐项 vs 紧凑；本机持久化 | almanac | 持久化/两态 | dev+PM(术语) | R05 | 双向恢复测试 |
| R07 | 罗盘独立页：日/时、十二时辰、五吉神/煞方；iPhone/iPad 右上玻璃文字按钮；Duo 侧栏 | compass 24 | 罗盘页/按钮/侧栏 | dev | R02 | 初入/12 时辰/往返 |
| R08 | 每日一句四传统、完整经文/出处/含义/应用、分享卡 QR；亮色、无印章 | daily 13 | 已收口内容接入/分享 | dev+PM | 内容包(已 PASS) | 长文/扫码/分享失败 |
| R09 | 一签 1450ms 冻结核心/素材；标题 0–1450+结果常驻；全显无内部滚动；减少动态/中断/同日同签 | fortune 24 | 动画移植/签库 | dev+PM(签库) | ApprovedMotionManifest | Manifest SHA + 5 时间点 |
| R10 | 岁时根列表（类别/日期/剩余/解锁/未读）；详情 eventID+contentVersion；未解锁不泄正文 | folklore 27/detail 12 | 列表/详情/版本/未读 | dev+PM(内容) | 内容版本 | 0/10/11/15 天 + 版本未读 |
| R11 | 择日：事项/起止/周末/冲突；结果→带日期黄历 | selection 12 | 表单/规则/结果路由 | dev | R05 | 合法/倒置/空/跨月 |
| R12 | 倒计日多条：名称/日期/历法/重复/提醒；Tab 最近未来天数（0 显示"0"）；详情编辑/删除/通知 | countdown 29/detail 12 | store/列表/通知 | dev | R01 | 多条/0/10/11/无记录 |
| R13 | 设置：外观/历法/经典/术语/提醒/许可/关于隐私；版本来真实 build | settings 12 | 设置页/持久化 | dev | P1 | 重启/跨页/系统切换 |
| R14 | 权限只用后请求；拒绝不阻断；设置返回重读；不编造城市 | 全局 | 权限流 | dev+QA | R08/R12 | 权限全分支 |
| R15 | 无印章；暖纸/深墨/朱色/大留白；Liquid Glass 仅导航 | 全局 | 视觉对齐/验收 | designer+QA | P0 tokens | PNG 对照/视觉审查 |
| R16 | 真实数据/完整签库/ContentVersion；HTML fixture/10 样签/示意权限不冒充 | 内容 | 签库/岁时模板/来源许可 | PM+dev | 内容包 | 数据来源表+测试 |
| R17 | 188 状态矩阵逐项 PASS/FAIL/NOT RUN（真机/模拟器/设计区分） | 全部 | QA 矩阵执行 | QA | P3–P5 | 矩阵+截图/录屏 |

## 2. 页面族与任务归属
| 页面族 | 状态数 | 首批任务 | owner |
|---|---|---|---|
| home | 17 | 双卡/工具卡/今日岁时/黄历摘要+月历/5 Tab 根 | dev+designer |
| almanac | 30 | 日期整组重算/白话两态/前后一天/跨年 | dev |
| compass | 24 | 独立页/日时/12 时辰/五吉神+煞方/玻璃按钮 | dev |
| daily | 13 | 四传统接入/长文/分享 QR | dev+PM |
| fortune | 24 | 1450ms 动画/完整签库/结果全显 | dev+PM |
| folklore | 27 | 根列表/解锁/未读/节日 | dev+PM |
| folklore-detail | 12 | eventID+version/离线/长图/未解锁 | dev+PM |
| selection | 12 | 择日表单/规则/结果 | dev |
| countdown | 29 | 多条/提醒/最近天数 | dev |
| countdown-detail | 12 | 新建/编辑/删除/通知/权限 | dev+QA |
| settings | 12 | 外观/历法/经典/术语/许可/关于 | dev |

## 3. 内容任务（PM 主责）
| 项 | 现状 | 任务 | 证据 |
|---|---|---|---|
| 每日一句四传统 | ✅ 365×4 PASS（tar `48764fae…`） | 接入 R08/分享 | 四文件 SHA |
| 完整签库 | 仅 10 样签 | 签种/签语全量（本地 JSON，不调 AI）+ 同签规则 | JSON+SHA+QA 抽检 |
| 岁时正文模板/版本 | 模板初版；10 样本待正文 | T1–T4 模板定稿 + 10 页正文/图位 + contentVersion/未读 | COVERAGE+版本策略 |
| 来源/许可 | 部分有 | 公版来源表 + license/credit | 来源清单 |
| 术语/白话 | 317+ 条 v2 | 与 R06/R13 对齐 | 术语包 SHA |
| 占位/Fixture | 122 占位（10 页） | 清零，不用 fixture 冒充 | 扫描 0 |

## 4. 首批里程碑（2 天节奏）
- **M1（P0，2 天）**：分支/worktree 构建；12 画布脚本；本矩阵登记；设计资产只读导入/Manifest SHA 记录
- **M2（P1，4 天）**：日期 store + 黄历整组重算 + 一条「日期→黄历→罗盘→返回」链路（单测）
- **M3（P2，6 天）**：5 Tab 根 + iPhone/iPad/Duo 六姿态空壳/导航 PASS（Splitview 排除）
- **M4（P3 首批，8 天）**：home 17 态 + almanac 30 态 + compass 24 态（截图/状态）
- **每 2 天报**：HEAD/完成状态/阻塞/下一步；不做 merge/push/发布/提审

## 5. 角色
- PM：协调/矩阵/内容/验收证据汇总；dev：实现/自测；designer：视觉对齐/模板；QA：独立矩阵/E2E；superwebdev2/webdev：admin 线（与 R14 并行，不冲突）
