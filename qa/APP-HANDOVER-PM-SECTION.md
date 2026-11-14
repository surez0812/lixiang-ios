## A. 产品/内容侧移交（calendar-pm，2026-11-14）

### A1. 已完成（有据可核）
| 项 | 状态 | 证据/路径 |
|---|---|---|
| 每日一句 12 条内容 | **approved 并接入 App**（Codex ALL_12_APPROVED） | `qa/content/events-12.json`、`qa/CONTENT-12-COMPLIANCE.md` |
| 43 坑权威清单 | 定稿：24 节气 + 19 节日；**清明双挂** `term-qingming`+`fest-qingming` | `qa/CONTENT-SLOTS-43.json`（`d38a7a68…`） |
| 43 槽来源 | 每槽 2 条 https，供 Admin seed | `qa/CONTENT-SOURCES-43.json`（`b8ea49a6…`） |
| Hero 风格/模板 | 5 张已确认（v5，宣和院体工笔 + 点景人物）；模板定稿 | `qa/web-samples-v5/`、`qa/HERO-STYLE-TEMPLATE.md` |
| Webpage 样例 | 5 篇 light-only 确认（立春/清明/端午/中秋/重阳） | `qa/web-samples-v5/content/` |
| 批量 43 文/43 图 | **进行中，未完成**：文档确认基线 **13/43 文、5/43 图**（不虚报 43/43） | `qa/CONTENT-43-MANIFEST.json`、`qa/HERO-43-MANIFEST.json` |

### A2. 未完成 / 移交边界
- **剩余约 38 文 + 38 图由本团队继续**（hero 图、经文/文案、web page 内容/图）；完成后开 app 分支 PR 给 Codex，不直接改 Codex 侧。
- **App 代码侧缺陷（布局/设备/动画/路由等）移交 Codex**；本团队不接手代码实现。
- Admin 43 坑/预置数据：slots+sources 已交 Admin（task-262/M1 seed）；生产验收待上线。
- 内容门禁不变：approved 才作为正式正文；hero `pending-design` 未验收前不算 PASS；示例/占位不算完成。
- 不 TestFlight、不提供测试包、不发布/不提审；App 打包/QA 由本团队在 Codex 接管后按门禁执行。

### A3. 使用的 skill / MCP
- **skill：无**（本阶段未加载任何 skill）
- **MCP：无**（未接入/未使用 MCP server）
- 实际使用：本地 Python 脚本 + 阿里云 DashScope（图片：普通图片 key；文本：token plan qwen4）+ 本地渲染/校验脚本

### A4. 关键引用
- 内容/合规：`qa/content/events-12.json`、`qa/CONTENT-12-COMPLIANCE.md`
- 43 坑/来源：`qa/CONTENT-SLOTS-43.json`、`qa/CONTENT-SOURCES-43.json`
- Hero 模板/v5：`qa/HERO-STYLE-TEMPLATE.md`、`qa/web-samples-v5/`
- 批量清单：`qa/CONTENT-43-MANIFEST.json`、`qa/HERO-43-MANIFEST.json`、`qa/HERO-43-ALTS.json`（补齐后更新）
- 验收：`qa/ADMIN-PROD-ACCEPTANCE.md`

### A5. 交接注意
- 本文件只代表**产品/内容侧**；代码/构建/设备矩阵以 Codex 交接文档为准。
- 批量产物未完成前，任何“43/43 完成”表述均不成立；以 manifests 的 available/missing 为准。
