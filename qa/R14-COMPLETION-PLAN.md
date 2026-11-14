# 历象 R14 完成计划（未完成项看板）

- 更新时间：2026-11-14｜实现基线 HEAD `38b34c5a`（clean-38b34c5a，以最新 clean 包为准）｜**不做 TestFlight，不给 Sure 测试包**

## 总览：矩阵 188 = ✅ 100 PASS / ⚠️ 33 FAIL / ⏳ 55 NOT RUN

> 未完成项按真实状态列出；设计稿、示例、局部截图**不算 PASS**。

## 完成门禁（全部关闭后才提供测试包）

1. 矩阵 188 行：PASS 或经 Lead 批准的 NOT RUN（不得用设计稿/示例替代）
2. 33 FAIL 全部关闭；55 NOT RUN 逐行有证据或批准原因
3. UI/视觉 B1–B4 + Hero C1–C3 关闭；12 hero status 转正且 QA PASS
4. 内容 D1/D2 覆盖与行为验完；read/重试/跨日/version/alt PASS
5. 设备证据 E1–E4 齐；真机通知/长图/替代测试方案落地
6. 交付 F1/F2 完成；F3 byte-identical 有结论；无测试插件、build-only 包就绪
7. 以上全部关闭后，才生成测试包/给 Sure；否则不提供

## 时间线

| 阶段 | 重点 | 负责 |
|---|---|---|
| 第 1–2 天 | 关闭 A1/A3/B1–B4/E1–E2/C1 证据；Duo 33 FAIL 在 clean-38b34c5a 上逐行复验启动 | Codex + QA + dev + PM |
| 第 3–4 天 | A2 Tabletop/Tent、A4 非 Duo 17 行、C2/C3 资产/映射、E3 长图（设备窗口依赖） | QA + PM + designer |
| 第 5–6 天 | D1/D2 内容行为、B2 全分支、F1 构建/签名/归档（设备证据依赖窗口） | dev + QA + PM |
| 第 7–8 天 | F2 文档统一、E4 替代测试、F3 复现结论、全量回归（真机证据依赖设备窗口） | QA + Lead |
| 第 9 天 | 完成门禁评审：188 行 PASS/批准 NOT RUN；仅此之后生成测试包 | Lead + QA |

## 未完成项清单


### 矩阵-FAIL

| ID | 项 | 状态 | 证据/缺口 | 负责人 | 依赖 | 验收标准 | 优先级 | ETA |
|---|---|---|---|---|---|---|---|---|
| A1 | Duo Closed Landscape / Open Portrait / Open Landscape × 11 页（33 行） | FAIL（33） | Codex A/B 任务：最新 clean 包 clean-38b34c5a 逐行复验；缺口：需在 clean-38b34c5a 上逐行复验；旧包/设计稿不算 | Codex + QA | clean-38b34c5a | 33/33 行 PASS，截图/录屏留档 | P0 | 3 天 |

### 矩阵-Tabletop/Tent

| ID | 项 | 状态 | 证据/缺口 | 负责人 | 依赖 | 验收标准 | 优先级 | ETA |
|---|---|---|---|---|---|---|---|---|
| A2 | Tabletop/Tent 28 行：physical=Partially Open + rotation / design=OpenPortrait；Tent≡Closed Landscape（复用） | NOT RUN（28） | 按约定：Tabletop physical=Partially Open+rotation，design=OpenPortrait；Tent≡Closed Landscape（复用不独立测）；缺口：剩余 28 行逐行实测/复用证据；不是「Device Hub 无入口」 | QA + Codex | 设备/姿态窗口 | 28/28 逐行 PASS 或如实 NOT RUN 原因 | P0 | 2 天 |

### 矩阵-Duo状态

| ID | 项 | 状态 | 证据/缺口 | 负责人 | 依赖 | 验收标准 | 优先级 | ETA |
|---|---|---|---|---|---|---|---|---|
| A3 | 10 个 Duo 状态：147/148/151/152/153/154/181/182/184/185 | NOT RUN（10） | 既有 rail/pose 截图不完整；缺口：修复后未按姿态复验 | QA + Codex | clean-38b34c5a（Codex A/B 任务） | 10/10 逐行 PASS | P0 | 2 天 |

### 矩阵-非Duo

| ID | 项 | 状态 | 证据/缺口 | 负责人 | 依赖 | 验收标准 | 优先级 | ETA |
|---|---|---|---|---|---|---|---|---|
| A4 | 17 行非 Duo：85-90 内容详情、163、164、166-169、170-174 | NOT RUN（17） | 内容/权限/长图证据缺；缺口：详情 read/重试/跨日/version/权限/长图未验 | QA + dev + PM | 内容接入/测试账号/长图方案 | 17/17 行 PASS | P1 | 3 天 |

### UI

| ID | 项 | 状态 | 证据/缺口 | 负责人 | 依赖 | 验收标准 | 优先级 | ETA |
|---|---|---|---|---|---|---|---|---|
| B1 | UI-001 iPhone light/dark 已 scoped；iPad/Duo real、dark current build、UI-001 全设备未全验 | PARTIAL | PM 二轮 UI 差异报告 + r14-pm-* 截图；serif 已用 Noto 修复、almanac 当日岁时已存在；缺口：iPad/Duo real、dark current build、UI-001 light/dark 全设备未全验 | designer + dev + QA | 最新 clean 包 | iPhone/iPad/Duo 亮暗全验，视觉清单关闭 | P0 | 2 天 |
| B2 | HOME-TOOLS：17 状态、天气加载/失败/拒绝、长城市名、Dynamic 全档 | NOT RUN/PARTIAL | 17 首页状态离线检查（旧）；缺口：真实构建/权限/长城市名/动态字体未全验 | dev + QA | 权限/网络注入 | 17 状态 + 全分支 PASS | P0 | 2 天 |
| B3 | Closed compact：真实 Duo Closed/iPad/rail 未验 | NOT RUN | 无真实设备证据；缺口：compact/rail 仅设计/模拟 | QA + Codex | 真实 Duo/iPad | Closed/iPad/rail PASS | P0 | 2 天 |
| B4 | Liquid Glass：iOS27 原生/真机/Reduce Transparency 未验 | NOT RUN | 仅截图观感；无真机材质/降透明证据；缺口：玻璃真实性、导航/底栏、深色未验 | dev + QA | 真机 iOS27 | 真机 + Reduce Transparency PASS | P0 | 3 天 |

### Hero

| ID | 项 | 状态 | 证据/缺口 | 负责人 | 依赖 | 验收标准 | 优先级 | ETA |
|---|---|---|---|---|---|---|---|---|
| C1 | 12 条内容 hero 已接 App；但 events-12.json hero.status 仍 pending-design | PARTIAL | 12 条 hero 已接 App；QA/Codex 已完成资产/映射/12 详情/16:9/fallback/label scoped 复核；缺口：events-12.json hero.status 仍 pending-design；39 可用资产仅 12 条接 App；24 节气/其余节日页面接入未决；无 dark/iPad/Duo 专用变体；EN accessibility/locale NOT RUN | PM + dev + QA | hero status/接入决策 | 12 hero status 转正且 QA PASS | P0 | 1 天 |
| C2 | 39 可用资产仅 12 条接入；24 节气/其余节日是否接页面未定；无 dark/iPad/Duo 专用变体 | PARTIAL | candidates 39 可用（24+15）+1 test；缺口：映射/页面接入未决；无 dark/iPad/Duo 变体 | PM + designer + dev | 页面需求确认 | 接入清单+变体策略确认 | P1 | 3 天 |
| C3 | 39 可用中 12 条 hero 已接 App；其余资产逐张 QA/页面映射未完成 | PARTIAL | 首批 33 PASS / 3 待修 / 1 test；后修复 3 + 补 2；12 hero 已接 App；缺口：其余 27 资产逐张 QA/页面映射未完成；EN accessibility NOT RUN | QA + PM | QA 复核 | 39 张逐张 PASS/弃用记录；EN alt 验 | P1 | 2 天 |

### 内容

| ID | 项 | 状态 | 证据/缺口 | 负责人 | 依赖 | 验收标准 | 优先级 | ETA |
|---|---|---|---|---|---|---|---|---|
| D1 | 12 条文审通过并接入；若设计覆盖 24 节气/更多节日，文案未全量 | PARTIAL | Codex ALL_12_APPROVED；缺口：24 节气/更多节日正文未生产；仅 12 条 | PM + 内容 | 设计范围确认 | 覆盖范围确定且正文齐 | P1 | TBD（内容生产） |
| D2 | 内容行 85-90/163/174 的 read/重试/跨日/eventID/version/alt 未验 | NOT RUN | 内容接入完成但行为未验；缺口：read/失败重试/跨日/版本/alt 未测 | QA + dev | 内容服务/注入 | 6 项行为 PASS | P1 | 2 天 |

### 设备/证据

| ID | 项 | 状态 | 证据/缺口 | 负责人 | 依赖 | 验收标准 | 优先级 | ETA |
|---|---|---|---|---|---|---|---|---|
| E1 | iPad landscape 真实窗口、Duo real compact、dark | NOT RUN | r14-pm-ipad-* 仅部分页；缺口：真实窗口/compact/dark 未全验 | QA | 真实设备/窗口 | 设备矩阵证据齐 | P0 | 2 天 |
| E2 | 166-169 真机通知（前置/允许/拒绝/设置返回） | NOT RUN | 无真机权限证据；缺口：权限全分支未测 | QA | 真机/新装 | 4 行 PASS | P0 | 2 天 |
| E3 | 170-174 长图口径/采集（2500/1650/12000） | NOT RUN | 长图方案未定；缺口：采集工具/拼接/口径未定 | QA | 长图方案 | 5 行长图证据 PASS | P1 | 2 天 |
| E4 | QA pty/SwiftPM 无法跑 UI test 的替代方案 | NOT RUN | 环境限制已知；缺口：需替代测试路径（XCUITest/真机手工） | QA + Lead | 工具/权限决策 | 替代方案确定并可复现 | P1 | 2 天 |

### 交付

| ID | 项 | 状态 | 证据/缺口 | 负责人 | 依赖 | 验收标准 | 优先级 | ETA |
|---|---|---|---|---|---|---|---|---|
| F1 | 最新 clean 包/版本递增/签名/归档脚本；最终 build-only 无测试插件 | PARTIAL | clean 包 clean-38b34c5a 与构建记录；缺口：版本/签名/归档脚本未最终化；测试插件需移除 | dev + Lead | clean-38b34c5a | build-only 包可复现且签名/归档齐 | P0 | 2 天 |
| F2 | source bundle/INDEX/QA 文档更新到最新 HEAD | PARTIAL | 文档多处旧 HEAD；缺口：需统一到最新 HEAD | PM + QA | 最新 HEAD | 文档一致、SHA 可核 | P1 | 1 天 |
| F3 | byte-identical 复现 | NOT PASS（未解决） | 构建可复现性未达 byte-identical；缺口：产物元数据/时间戳导致差异；无法逐字节复现 | dev + Lead | 构建流水线 | byte-identical 或明确不可达结论 | P0 | TBD |
| F4 | 不发布/不提审/不合并；不做 TestFlight、不提供测试包 | POLICY（持续） | Lead/Sure 指令；缺口：所有未完成项关闭前不提供测试包 | 全体 | 完成门禁 | Gate 关闭后才生成测试包 | P0 | 持续 |

## 外部阻塞
- Duo Tent/Tabletop：按约定复用 Closed Landscape；剩余为 28 行实测/复用证据
- 真机 iOS27 / Reduce Transparency / 通知：依赖设备窗口
- byte-identical 复现：构建流水线未解决
- 24 节气/更多节日正文与素材变体：设计范围未最终确认

## 说明
- 本页不宣称任何未完成项已完成；更新时只改状态与证据链接。


## 新增范围（Sure 2026-11-14 确认，已并入计划）

### C4 · Hero 图全量（24 节气 + 所有传统节日）
- 状态：NOT DONE（新增）
- 范围：24 节气 + 全部传统节日；节日清单由 PM 明确列全（至少现有 15 + 下元/祭祖/寒食/龙抬头/社日/观莲等按设计范围）
- 生成：Aliyun wanx，**普通图片 API key**；不用 token/top plan；预算 **≤¥50**（已花 ¥11.4，余 ¥38.6）
- 验收：全部先生成；PM/QA 逐张审；16:9 webp ≤120KB；无伪文字/水印/人物/宗教场所；key_source/inventory/usage 完整
- 负责人：PM + QA
- 依赖：节日清单确认；预算
- ETA：1–2 天

### D3 · 岁时正文全量（24 节气 + 所有传统节日，qwen4）
- 状态：NOT DONE（新增）
- 范围：与 C4 同一清单；**先做 prompt 模板 + 3–5 个样例给 Sure review**，通过后批量
- 模板依据：`templates/CONTENT-PROMPT.md`、`festival-article.schema.json`、`webpages/template-sample.html`、`winter.html`、`daily-kindness.html`、`festival-article.css`
- 输出：结构化 JSON/sections + 模板 HTML 片段；**最终 HTML 由模板/渲染器生成，不直接信模型原始 HTML**
- 每页 header hero 不在 webpage 内做；App 用 hero 图
- 验收：来源/地区差异/无效果承诺/无脚本/权限/安装引导/重复 tab；手机/iPad/Duo/暗色样式；样例先 review
- 负责人：PM + 内容
- 依赖：样例 review；设计范围
- ETA：模板+样例 1–2 天；全量 TBD

## 更新后的完成门禁
1. C4 全量 hero 生成+QA 完成；D3 全量正文+样例 review+QA 完成
2. 24 节气 + 全部传统节日清单确认并逐项有图/有文
3. 其余 A/B/C/D/E/F 未完成项关闭
4. 以上全部关闭后，才生成测试包/给 Sure；不做 TestFlight/不提供测试包
