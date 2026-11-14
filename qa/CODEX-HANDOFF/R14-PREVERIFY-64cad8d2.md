# R14 followup pre-verify 交接（Codex 前置，QA 执行）

- 生成时间：2026-11-14 08:05 +0800
- dev HEAD：`64cad8d249f137b2aa2f760e947419943aa68d77`（followup；基线 `d092769c` 未改）
- 内容：祭祀/造庙 en 去占位（PM 口径）+ 精确占位扫描；无其它代码改动
- 状态：**未由 dev 直接发 Codex**；按流程先由 QA pre-verify，再由 Lead/QA 放桥任务

## 1. 包信息（由 Lead/QA 打包填写）
| 项 | 值 |
|---|---|
| commit | `64cad8d249f137b2aa2f760e947419943aa68d77` |
| tar | （待 QA 填写） |
| binary Lixiang | （待 QA 填写） |
| 版本/build | 1.0 (13) |
| 设备 | 仅 R14-Build-iPhone `CFF55DB9…` / R14-Build-iPad `EB0894B9…` |

## 2. dev 自测（已执行）
- Build：`xcodebuild build -destination 'id=CFF55DB9-F228-4205-B307-FB4A074D6753'` **PASS**
- `AlmanacTermSemanticTests` **11/11 PASS**（含祭祀/造庙 zh+en 非占位、全量 en 占位扫描）
- `ContentCatalogTests` 5/5 PASS（envelope/fallback/approved+version 门禁）
- `DailyShareExportTests` 1/1 PASS（导出 360×450pt@3x=1080×1350，SHA `d72ab323…`，与运行时导出一致）
- `R14NotifySettingsReturnUITests` PASS（注入态 marker/开关同步；非原生权限通过）
- 全量 `LixiangTests` 基线 57/57（新增后 59 含 followup 测试）

## 3. QA pre-verify 清单（必做）
1. 安装包启动 smoke：Home 8s 内出内容（当前基线数据 content.ready 1.9–3.2s）
2. 黄历 → 白话全解 → 点「祭祀」：PlainTermSheet 显示中性 zh+en，**无 “—/blocked/skip” 占位**
3. 点「造庙」：同上，en 含 “temples or ancestral halls”
4. 全量词条 en 扫描：`—`/`blocked`/`TBD`/`placeholder`/`(skip)` = 0；正常 “skip cooking/fortune” 不误判
5. Daily 分享页：`r14-share-export.png` 1080×1350、SHA `d72ab323…`
6. 确认未触碰 4 台锁定机 / R14-Duo

## 4. 证据路径
- `dev-evidence/P1/shots/r14-notify-ui-denied.png` / `r14-notify-ui-authorized.png`
- `dev-evidence/P1/shots/r14-daily-share-export.png`（1080×1350）
- `dev-evidence/P1/shots/r14-qa-cold2-8s.png`（8s 完整 Home）
- `dev-evidence/P1/shots/r14-folklore-offline/failed/offline-detail/retry-success.png`

## 5. 12 条正式内容（待 Codex 审批，不接入）
- 文件：`qa/content/events-12.json`，SHA `a77aaba128489edde263fb325700bd9ee0d1a64a2fdef5c0c5db42f5a5cdccf4`
- 12 items，envelope `{version:1, items[12]}`；全部 `reviewStatus=draft`、`version=1`（**不得自行改 approved**）
- dev 只读校验：schema 对齐 ContentItem（id/title/category/dateRule/teaser/sections≥2/sources/license/version；`regionalDates` 合法）；teaser 15–23 字；sources 均 https；dateRule 10 lunar + 2 solarTerm
- loader 兼容：`ContentCatalog` 支持 envelope；当前资源仍为 4 条示例（`App/Resources/Content/events.json` SHA `33c75b2b…`，**示例≠正式内容**）
- 审批后动作：受控 commit 将 12 条写入 `App/Resources/Content/events.json`（保持 reviewStatus=approved 由 PM/Codex 给出），报文件 SHA/items/approved 数

## 6. 当前 NOT RUN（不随本包改变）
- 164 缓存正文（内容准备中）；170-174 长图（高度/内容/接缝未达标）；166-169 原生通知权限（仅注入模拟）；Duo Tabletop/Tent 等
