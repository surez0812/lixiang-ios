# 内容/文案计划与状态（PM）

- 2026-11-14 08:05｜Sure 出门期间：PM=文案/内容计划与任务安排；QA=验证/case/Codex 材料；dev=开发；Lead=进展/Codex 沟通
- 边界：不写代码/不启模拟器；内容文件走独立路径 `qa/content/events-12.json`（SHA `a77aaba1…`），未再写 App 资源

## 1. 12 条内容 compliance 计划与审批协调
- 审批任务：桥 `TASK-20261114-0820`（Codex 审批）；PM 负责材料齐备与状态跟踪
- 交付物：`qa/content/events-12.json`（12 条，reviewStatus=draft）+ `qa/CONTENT-12-COMPLIANCE.md`（来源/红线核验）
- 流程：draft →（PM 提交 Codex 审）→ in_review →（Codex/内容负责人签核）→ approved → dev 受控接入
- **审批通过后给 dev 的 approved 列表/字段**：id、title、category、dateRule、regionalDates、teaser、sections、sources、license、version、reviewStatus="approved"（12 条逐条 id；未通过的单独列 blocker，不混入）
- 状态：**12 条 draft 已备，待桥任务审批**；预计审批后 1 个工作日内回填 approved 清单
- 来源核验：机构 https 6 家 HTTP 200（cma/gov/wenming/ihchina/news/dpm）；红线扫描仅「不作吉凶预测」否定式

## 2. 四季素材
| 项 | 状态 | 计划 | 验收 |
|---|---|---|---|
| 春/夏/秋 样板 | 未开始（现仅冬季 1 套） | designer 先出 **1 套样板**（建议春）交 PM 审；再补齐 2 套 | R14 暖纸/留白/纸纹；375+iPad；亮暗无裁切；hero/节气映射；文件 SHA |
| 24 节气图 | 部分复用 | 按 `PLAN-SUISHI` 图位核对；缺图补 | 24/24 有图+alt |
| 交付物 | — | 3 套 ×（hero+细节）webp≤120KB、16:9；来源/授权说明 | PM 审后进内容包 |
- 结论：**designer 现有 R14 风格可延展，可交付，非必须外部**；ETA 样板 2–3d、全 3 套 3–5d

## 3. 完整签库（外部生产）
| 项 | 结论 | 计划 |
|---|---|---|
| 签库范围 | **需外部内容生产**（签文创作/审核非设计/开发可独立完成）；10 样签≠完整库 | 外部作者按签种/签号/签诗/签意/建议/等级生产；PM 定 schema+合规规则；QA 抽检；本地 JSON 固化，不调 AI 上线 |
| 交付物 | JSON（全量）+ SHA + 签种/等级分布 + 审核记录 | 建议 2–4 周内容工程；分 3 批（每批抽检） |
| 验收 | 同日同签、无占位、无预测/劝诱、签文完整、排版可容纳长文 | QA 抽检 + PM 终审 |

## 4. 其它文案/内容任务（优先级）
| 优先级 | 任务 | 交付物 | owner | 备注 |
|---|---|---|---|---|
| P0 | 12 条 compliance 审批协调 | approved 列表/字段、状态回填 | PM+Codex | 桥 `TASK-20261114-0820` |
| P0 | 术语 zh/en 修正（33 条活动化 + 6 条旧 en + 祭祀/造庙） | 审校报告 §6–§10、替换清单 | PM+内容 owner | 已给建议句 |
| P1 | 四季素材样板 | 1 套样板+规格 | designer+PM | 先春 |
| P1 | 岁时 10 页正文定稿（含 12 条内） | 正文+图位+来源 | PM | 与 12 条合并 |
| P2 | 完整签库外部生产 | 全量 JSON+SHA | 外部+PM | 2–4 周 |
| P2 | 文案审校/改写（Codex 可协助） | 审校清单/改写稿 | PM+Codex | 敏感词/活动句/中英一致 |
| P3 | 分享卡/SEO/商店文案 | 文案包 | PM | 提审前 |

## 5. 下一步（2 天节奏）
1. 提交 12 条到 `TASK-20261114-0820`，跟踪 in_review/approved
2. designer 春样板 + PM 验收；签库外部作者招募/规格
3. 术语 33+6 条替换清单交内容 owner；QA 准备 Codex 证据
4. 每 2 天报：审批状态/样板/签库/阻塞


## 5. 节气/节日素材补产（Sure 2026-11-14 批准，Aliyun wanx）
- 预算 **≤ ¥50**；PM 执行；详见 `qa/ASSET-PLAN-ALIYUN.md`
- 历史复用：`ops/DASHSCOPE-REQUEST.md`、`proposals/.../rich/prompts.json`/`run_wanx.py`；`wanx2.1-t2i-plus`、1024×1365、¥0.2/张、seed 20261111
- 最低范围：24 节气 + 12 重要节日；建议首批 36 张；关键节日可 2 候选
- 交付：raw/params.json/usage-log.csv/selection.md + 候选 webp（≤120KB，16:9 裁切）
- 与 Codex 测包并行；12 条 hero 在素材验收前仍 pending-design，内容行 NOT RUN
