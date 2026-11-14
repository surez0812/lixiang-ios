# QA Evidence Index（R14）

- 设计源：`design/r14-final/screens.json` SHA256 `ea505be1…`
- 矩阵：`docs/R14-QA-MATRIX.md`
- 主报告：`qa/FIRST-BATCH.md`、`qa/FINAL-QA-SUMMARY.md`
- 证据根：`qa/evidence/`

| 目录 | 内容 |
|---|---|
| `firstbatch-v2/` | 首批 phone/iPad 主态 |
| `portrait-states/` | phone 竖屏/结果/倒计日/状态 |
| `ipad-landscape/`、`ipad-landscape-dark/` | iPad 横屏 light/dark（含 XCUITest real） |
| `ipad-portrait/`、`ipad-portrait-dark/`、`ipad-portrait-routes/` | iPad portrait light/dark 5 Tab + 路由 |
| `ipad-compass-hour/` | iPad Compass 时方位 177-180 |
| `ipad-countdown-detail/` | iPad countdown detail 99-102 |
| `compass-hours/`、`compass-selector/`、`compass-day/` | Compass 12 时辰/选择器/日方位 |
| `fortune-result/` | Fortune 结果态 v3（133/135/137/139/141/143/145） |
| `home-full/` | Home 完整首屏 light/dark |
| `almanac-plain-off/` | Almanac 白话关 phone/iPad/Duo |
| `daily-redesign/` | Daily 新卡片 light |
| `countdown-detail-phone/` | phone countdown detail light/dark |
| `duo-closed-routes/` | Duo Closed 7 路由 + T-10/T-9 |
| `dark-pages/`、`visual-v2/`、`weather-fortune/`、`dynamic-v2/` | dark/天气/fortune/动态字体补充 |

## PM 复核映射（folklore / settings / folklore-detail / fortune frames）

> 目的：证明这些页面/画布的**实现截图已存在**，避免 PM 重复截。仅映射证据，不因“有图”把内容缺口行标 PASS。

### Folklore（岁时列表）
| 画布 | 行 | 证据 |
|---|---:|---|
| phone-light | 1 | `dev-evidence/P1/shots/r14-tokens-folklore-light.png` |
| phone-dark | 2 | `dev-evidence/P1/shots/r14-tokens-folklore-dark-v2.png` |
| iPad portrait light | 3 | `dev-evidence/P1/shots/r14-ipad-portrait-tab1.png` |
| iPad portrait dark | 4 | `dev-evidence/P1/shots/r14-ipad-portrait-dark-tab1.png` |
| iPad landscape light | 5 | `dev-evidence/P1/shots/r14-ipad-landscape-tab1.png` |
| iPad landscape dark | 6 | `dev-evidence/P1/shots/r14-ipad-landscape-dark-tab1.png` |

### Settings（设置）
| 画布 | 行 | 证据 |
|---|---:|---|
| phone-light | 49 | `dev-evidence/P1/shots/r14-tokens-settings-light.png` |
| phone-dark | 50 | `dev-evidence/P1/shots/r14-tokens-settings-dark-v2.png` |
| iPad portrait light | 51 | `dev-evidence/P1/shots/r14-ipad-portrait-tab4.png` |
| iPad portrait dark | 52 | `dev-evidence/P1/shots/r14-ipad-portrait-dark-tab4.png` |
| iPad landscape light | 53 | `dev-evidence/P1/shots/r14-ipad-landscape-tab4.png` |
| iPad landscape dark | 54 | `dev-evidence/P1/shots/r14-ipad-landscape-dark-tab4.png` |

### Folklore detail（岁时详情，内容门禁）
| 画布/状态 | 行 | 证据 | 说明 |
|---|---:|---|---|
| phone-light 内容准备中 | 85 | `dev-evidence/P1/shots/r14-folklore-detail-content-pending.png` | 内容门禁态；正文未接入，不标 PASS |
| Duo closed（仅参考） | — | `dev-evidence/P1/shots/r14-duo-closed-folklore-detail.png` | **Duo 不算 iPhone/iPad**，仅作布局参考 |
| iPad portrait light/dark（locked） | 87/88 | `qa/evidence/r14-ipad-portrait-folklore-detail-{light,dark}.png` | 本次补拍：iPad portrait locked/78天；正文仍内容缺口，行保持 NOT RUN |
| iPad landscape light/dark | 89/90 | — | 仍缺；XCUITest 构建受阻（SwiftPM 缓存权限），未用假图；保持 NOT RUN |

### Fortune 动画时间点（补充证据）
| 文件 | 状态 |
|---|---|
| `r14-fortune-frame0.png` | 待机 |
| `r14-fortune-frame180/300/450/600/800/900/1050.png` | 动画时间点（F-02/F-03 数学零交叉为 NOTE，不判失败） |
| `r14-fortune-frame1450.png` | 结果态全显 |

- 以上 frame 图用于 M/F 补充项，不新增 188 矩阵行。

### Duo Codex 最终归档
- 路径：`dev-evidence/P1/shots/codex-duo-20261113-2340/`
- 内容：`REPORT.md`、`cases.csv`、`closed-landscape/`、`open-portrait/`、`open-landscape/`、`open-landscape-settled/`、`metadata.json`、`installed-bundle-verification.json`、`SHA256SUMS`。
- **归档实测 SHA256 `690a26b6…`**；修复后 tar `2314dd8e…`/binary `1d2661de…` 尚未重新 Duo 验证，不能拿此归档给修复包 PASS。
- 注意：`742a1af4…` 是后续重打包，不是本实测归档；`690a26b6…` 与 `2f24610a…` 为本次 Codex 实测身份。

### PM 修复截图
- `dev-evidence/P1/shots/r14-pm-*`（home/almanac/iPad/compass 等）
- `dev-evidence/P1/shots/r14-boot-3s.png`、`r14-boot-10s.png`
- 结论见 `qa/PM-FIX-RECHECK.md`。

## PM 二轮：页面 × 画布 × 状态 → 证据（新版）

> `已有` = 文件存在且已映射；`确缺` = 本轮无有效证据，NOT RUN。文件路径均相对 `dev-evidence/P1/shots/`。

### Folklore（岁时列表）
| 页面/状态 | 画布 | 证据 | 结论 |
|---|---|---|---|
| 默认 | phone-light | `r14-tokens-folklore-light.png` | 已有 |
| 默认 | phone-dark | `r14-tokens-folklore-dark-v2.png` | 已有 |
| 默认 | iPad portrait light | `r14-ipad-portrait-tab1.png` | 已有 |
| 默认 | iPad portrait dark | `r14-ipad-portrait-dark-tab1.png` | 已有 |
| 默认 | iPad landscape light | `r14-ipad-landscape-tab1.png` | 已有 |
| 默认 | iPad landscape dark | `r14-ipad-landscape-dark-tab1.png` | 已有 |

### Settings（设置）
| 页面/状态 | 画布 | 证据 | 结论 |
|---|---|---|---|
| 默认 | phone-light | `r14-tokens-settings-light.png` | 已有 |
| 默认 | phone-dark | `r14-tokens-settings-dark-v2.png` | 已有 |
| 默认 | iPad portrait light | `r14-ipad-portrait-tab4.png` | 已有 |
| 默认 | iPad portrait dark | `r14-ipad-portrait-dark-tab4.png` | 已有 |
| 默认 | iPad landscape light | `r14-ipad-landscape-tab4.png` | 已有 |
| 默认 | iPad landscape dark | `r14-ipad-landscape-dark-tab4.png` | 已有 |

### Daily（每日一句）
| 页面/状态 | 画布 | 证据 | 结论 |
|---|---|---|---|
| 默认（新卡片） | phone-light | `r14-daily-redesign-light.png` | 已有 |
| 默认 | phone-dark | `qa/evidence/dark-pages/r14-daily-redesign-dark.png` | 已有（QA 归档） |
| 默认 | iPad portrait light | `r14-ipad-portrait-daily-light.png` | 已有 |
| 默认 | iPad portrait dark | `r14-ipad-portrait-daily-dark.png` | 已有 |
| 默认 | iPad landscape light | `r14-ipad-landscape-light-daily-v3.png` | 已有 |
| 默认 | iPad landscape dark | `r14-ipad-landscape-dark-daily-v3.png` | 已有 |

### Fortune（每日一签）
| 页面/状态 | 画布 | 证据 | 结论 |
|---|---|---|---|
| 结果态 | phone-light | `r14-fortune-result-paper-phone-light.png` | 已有 |
| 结果态 | phone-dark | `r14-fortune-result-paper-phone-dark.png` | 已有 |
| 结果态 | iPad portrait light | `r14-ipad-portrait-light-fortune-result-v3.png` | 已有 |
| 结果态 | iPad portrait dark | `r14-ipad-portrait-dark-fortune-result-v3.png` | 已有 |
| 结果态 | iPad landscape light | `r14-ipad-landscape-light-fortune-result-v3.png` | 已有 |
| 结果态 | iPad landscape dark | `r14-ipad-landscape-dark-fortune-result-v3.png` | 已有 |
| 动画/待机 | 补充 | `r14-fortune-frame{0,180,300,450,600,800,900,1050,1450}.png` | 已有 |

### Selection（择日）
| 页面/状态 | 画布 | 证据 | 结论 |
|---|---|---|---|
| 默认 | phone-light | `r14-selection-redesign-light.png` | 已有 |
| 默认 | phone-dark | `qa/evidence/dark-pages/r14-selection-redesign-dark.png` | 已有（QA 归档） |
| 默认 | iPad portrait light | `r14-ipad-portrait-selection-light.png` | 已有 |
| 默认 | iPad portrait dark | `r14-ipad-portrait-selection-dark.png` | 已有 |
| 默认（双列/real） | iPad landscape light | `r14-ipad-landscape-selection-real.png` | 已有 |
| 默认（双列） | iPad landscape dark | `r14-ipad-landscape-dark-selection-v2.png` | 已有 |

### Folklore detail（岁时详情）
| 页面/状态 | 画布 | 证据 | 结论 |
|---|---|---|---|
| 内容准备中 | phone-light | `r14-folklore-detail-content-pending.png` | 已有（内容门禁） |
| locked/78 天 | iPad portrait light | `qa/evidence/r14-ipad-portrait-folklore-detail-light.png` | 已有（本次补拍） |
| locked/78 天 | iPad portrait dark | `qa/evidence/r14-ipad-portrait-folklore-detail-dark.png` | 已有（本次补拍） |
| 默认 | iPad landscape light/dark | — | **确缺**（XCUITest 构建被 sandbox/SwiftPM 阻塞） |
| Duo 参考 | Duo closed | `r14-duo-closed-folklore-detail.png` | 仅参考，不算 iPhone/iPad |

### PM 二轮“缺证据”结论
- folklore / settings / daily / fortune / selection 的 **iPad 与深色**：**全部已有**，见上表，不需要重复截。
- **确缺/NOT RUN**：
  - 真机 glass 材质：无真机，NOT RUN。
  - Reduce Transparency：未测，NOT RUN。
  - iPad Dynamic Type：只有 iPhone X5 证据；iPad 未测，NOT RUN。
  - folklore-detail iPad landscape light/dark：确缺，NOT RUN。
- 上述均为证据/运行时限制，不把“有图”误标为对应矩阵行 PASS；矩阵以 `docs/R14-QA-MATRIX.md` 为准。

## Codex reachability ledger（独立，不等于 188 验收矩阵）
- `dev-evidence/P1/shots/codex-rail-route-b3d89116/`（67 files）
  - build `b3d89116`；tar `0c140de1…`；binary `73e10df9…`
  - coverage: **30 REACHED + 1 REACHED UI ONLY + 2 OBSERVED LOADING + 75 NOT RUN ON THIS BUILD = 108**
  - REPORT 明确：REACHED 不是 PASS；Tabletop/Tent 仍 NOT RUN；Duo 环境启动阻塞属环境问题。
- `dev-evidence/P1/shots/codex-fix-e83753a8/`（51 files）
  - build `e83753a8`；tar `d9787ccf…`；binary `92d236b4…`
  - **旧快照，结果独立保留**，不并入 b3d89116。
- **用途仅证据关联**；`coverage.json` 是 reachability ledger，**不是 188 approval matrix**；不得用 ledger 覆盖矩阵 PASS/FAIL。
- 下一包 `02a2a50f` 待验证：安葬等语义修复；启动 timing 仍 open。

## Codex focused handback（2026-11-14）
- `dev-evidence/P1/shots/codex-bilingual-8c4119b1/`（29 files）
  - build `8c4119b1`；tar `7b5b6dbb…`；binary `a036b0bc…`；iPad 181 files 一致。
  - 内容：6 词中英文专项原图、terms-detail-sheet、per-term logs、semantics.json、SHA256SUMS。
- `dev-evidence/P1/shots/codex-content-02a2a50f/`（23 files）
  - build `02a2a50f`；isolated startup PTY profiles；含 profile/profile-pty、semantics.json、identity。
- `dev-evidence/P1/shots/CODEX-QA-FOLLOWUP-SUMMARY.md`：全轮汇总。
- 4 台预留模拟器已 shutdown，数据保留；QA 未操作。
- **仍不覆盖 188 矩阵**；Tabletop/Tent 28 行（14 对）NOT RUN；REACHED/专项 closure 不等于 PASS。

### QA 基线探测（非 Duo）
- 脚本：`scripts/r14-qa-baseline-probe.sh`
- 证据：`qa/evidence/qa-baseline-probe/`（8s 与 25s；tar 7b5b6dbb… / binary a036b0bc… / commit 8c4119b1）
- 仅 R14-QA-iPhone `0B71AEF4…`；未碰 4 台锁定机。
- 结论：无注入时 8s loading、25s 可进 countdownDetail/列表/locked folklore；**164/166-169 不判 PASS**。

### A 离线/失败/重试（9804c16e）
- 包：tar `1645f834…` / binary `00f751fc…` / commit `9804c16e`。
- 证据：`qa/evidence/qa-a-offline/`；脚本 `scripts/r14-qa-a-offline.sh`。
- 状态：loading / offline-uncached / offline-cached / load-failed / retry-success；另有 45s 复核与 unlocked 缓存测试。
- 行164 仍 NOT RUN：缓存正文无法证明（正式内容未接入）；详见 `qa/QA-A-OFFLINE.md`。

### B 通知权限（904fa930，注入模拟）
- 包：tar `fc9068b7…` / binary `b111ad1a…` / commit `904fa930`。
- 证据：`qa/evidence/qa-b-notify/`；脚本 `scripts/r14-qa-b-notify.sh`。
- 状态：preprompt-detail / preprompt-list / denied / authorized / settings-return。
- **注入模拟，不是原生系统弹窗**；166-169 仍 NOT RUN；详见 `qa/QA-B-NOTIFY.md`。

### B notify2（fc233807）
- 包 tar `cdcb6ad3…` / binary `6b83a616…` / commit `fc233807`。
- 证据：`qa/evidence/qa-b-notify2/`；denied 已修（开关关 disabled+caption+banner）；settings-return late 未 authorized；166-169 仍 NOT RUN。

### C longshots
- 路径：`dev-evidence/P1/longshots/`（4 PNG + manifest，1206px 宽）。
- home 1876.7pt / almanac 1779.3pt / daily 1670.7pt / folklore-detail 1648.0pt。
- 均有启动 loading 混入/拼接不完整；170-174 仍 NOT RUN；详见 `qa/QA-C-LONGSHOTS.md`。

### B notify3 / C longshots-final（0b3202ca）
- B：tar `c4a1ccc4…` / binary `60945fd6…`；证据 `qa/evidence/qa-b-notify3/`；settings-return 8s loading、18s 仍关，未 authorized；166-169 NOT RUN。
- C：`dev-evidence/P1/longshots-final/`；home1534.7 / almanac1373.0 / daily1537.7 / folklore874.0pt；存在 tabbar 重复/拼接不连续、目标高度不足；170-174 NOT RUN。

### B notify4 / C longshots-notab（3a8b4e8b）
- B：tar `53c77722…` / binary `7f923ec2…`；`qa/evidence/qa-b-notify4/`；16s marker authorized 但开关仍关，B NOT RUN。
- C：`dev-evidence/P1/longshots-notab/`；home1472.7 / almanac2293.3 / daily1954.7 / folklore874.0pt；无 tabbar 改善，Daily 接缝不连续；170-174 NOT RUN。

### B notify5 / C longshots-notab（d221c56b）
- B：tar `83be486f…` / binary `f248cabb…`；`qa/evidence/qa-b-notify5/`；12s denied toggle=0 → 16s authorized toggle=1（注入模拟）；UI 同步缺陷关闭；166-169 仍 NOT RUN。
- C：`dev-evidence/P1/longshots-notab/`；无 tabbar 改善；home1472.7 / almanac2293.3 / daily1954.7 / folklore874.0pt；170-174 NOT RUN。

### 启动 / §8 语义（79c68100）
- 包：tar `f8ac7079…` / binary `647d95bb…` / commit `79c68100`。
- 冷启动：`qa/evidence/qa-startup/`（8s 已出内容）。
- §8 术语弹层：`qa/evidence/qa-s8-terms/`（上巳节/重阳节/大林木/海中金/路旁土 zh+en）。
- 结论：启动 8s PASS；§8 语义内容通过；188 矩阵不因此改行（内容缺口仍 NOT RUN）。

### §9.4 节日/动作语义（2f9b5417）
- 包：tar `149b4f47…` / binary `e2a75fda…` / commit `2f9b5417`。
- 证据：`qa/evidence/qa-s9-festivals/`（25 张实拍术语弹层）。
- 10 节日语义通过；9 动作类 zh 可接受但 en 仍祈使（捕捉/畋猎 “Go…”），需修；随机 6 条中性。
- 矩阵内容缺口行仍 NOT RUN；详见 `qa/QA-S9-FESTIVALS.md`。

### §9 动作类 en 修复（d092769c）
- 包：tar `66b7cabcc…` / binary `d7632436…` / commit `d092769c`。
- 证据：`qa/evidence/qa-en-fix/`；重点 5 条 + 除夕/重阳/金匮实拍。
- 全量 450 terms en 无 Go/See/Get/Visit 开头；语义修正通过；内容缺口行仍 NOT RUN。

### 终版文档关联（d092769c）
- 启动/§8：`qa/QA-STARTUP-S8.md`
- §9.4 节日/动作：`qa/QA-S9-FESTIVALS.md`
- en 动作修复：`qa/QA-S9-EN-FIX.md`
- B 通知：`qa/QA-B-NOTIFY.md`（注入模拟；原生弹窗失败）
- C 长图：`qa/QA-C-LONGSHOTS.md`
- Codex：`codex-bilingual-8c4119b1/`、`codex-content-02a2a50f/`
- 外部阻塞：`qa/EXTERNAL-BLOCKERS.md` / `P1/R14-EXTERNAL-REQUESTS.md`

### Daily 分享导出像素（补充项）
- 计划/状态：`qa/QA-D01-EXPORT.md`；目标 1080×1350 PNG。
- 已生成并测量：`qa/evidence/daily-share-export/r14-share-export.png`；1080×1350、无 alpha、SHA `d72ab323…`；QR 解码成功。**PASS（补充项）**。

### Codex interim（d092769c）
- `qa/CODEX-INTERIM-d092769c.md`：祭祀 en 运行时 FAIL、12 targets 到达但 countdown 8s loading、10 词覆盖限制、mini 冷装 8s 未达标、桥 HOLD 状态过期。
- 仅供记录；矩阵仍 100/33/55。

### Codex 12 条内容审批结果
- `qa/CODEX-CONTENT-REVIEW.md`：REJECT 0/12；理由机构主页/无文章级来源、public-domain 未证实、缺 hero/unlockOffset、xiayuan/yulanpen 措辞。
- Codex audit：`handoff/codex-bridge/evidence/content-12-approval/audit.json` SHA `f473ad17…`；快照 SHA `a77aaba1…`。
- 内容缺口行 85-90/163/174 仍 NOT RUN；等 PM 新 JSON 后重新 pre-verify。

### 内容 v2 pre-verify
- `qa/CODEX-HANDOFF/R14-PREVERIFY-content-v2.md`：SHA 4e799ea7；表格结构通过；第2来源仍机构首页、xiayuan teaser 26>23 → 未通过，任务保持 HOLD。

### Codex 桥结果（2026-11-14）
- JISI en：`qa/CODEX-BRIDGE-RESULTS.md`；PASS bounded；仅词条弹层，非 188 PASS；证据 `codex-bridge/evidence/jisi-en-verify/codex-iphone16/`。
- 静态代码审查：CHANGES_REQUESTED；P1 通知 refresh 覆写、P2 prepare 旧日期、P2 Dynamic Type。
- 交付可复现审查：CHANGES_REQUESTED；manifest 首段路径/SHA 错配、PACK-NOTES 旧 build4、commit 构建/干净构建 NOT RUN。

### 内容 v3 pre-verify
- `qa/CODEX-HANDOFF/R14-PREVERIFY-content-v3.md`：8ed18682；结构/teaser/字段/红线 PASS；22 wiki URL QA 环境 000（环境 blocker），任务已移桥 Codex 核验。

### staticfix 2fe101a1 pre-verify
- `qa/CODEX-HANDOFF/R14-PREVERIFY-staticfix-2fe101a1.md`：P1 policy 代码 PASS/集成覆盖缺口；P2 race PASS；Text 删除固定重载+xLarge 截图无裁剪，无专门单测；包 tar/binary 匹配。
- 任务 `TASK-...0850` 已移出 HOLD。

### Codex interim 追加（d092769c）
- mini 22s 12/12 路由到达但非正式内容/188 PASS；注入离线/失败/loading/retry 与通知态仅模拟；iPad post identity mismatches=[]，binary d7632436…；桥 outbox 空，static/content/daily 排队。见 `qa/CODEX-INTERIM-d092769c.md`。

### Duo cold interim（duo-cold）
- `evidence/duo-cold/results.json`：fresh-home 8s content.ready 8.65s/home.appear 8.68s，8s 预计 loading；12/22s 待 Codex 判读；layout `isDuo=true landscape=false shortSide=382 canvas=duo-closed-portrait rail=false`。不判 PASS/FAIL。

### Duo Closed Landscape tab0 interim
- `duo-closed-landscape/tab0.jsonl`：isDuo=true landscape=true shortSide=432 native=1398x2034 scene=678x466 geo=594x432 canvas=duo-closed-landscape rail=false；content.ready 2475ms/home.appear 2503ms（process≈4.2s，总≈6.7s）；非 fresh-install，不与 duo-cold 混写，不判 PASS。

### Codex SESSION-NOTES 限制
- 真机 unavailable → 166-169 原生通知 NOT RUN；注入模拟不能代替。
- 冷启动非全机隔离基准；8s 完整 Home ≠ 首帧 t≤8.000s 精确证明。
- `0B71AEF4` 0810 窗口暂未使用则保持暂停，等 Lead 释放。

### Duo Closed Landscape tab0–3 22s interim
- tab0–3 有 22s 截图（`canvas=duo-closed-landscape rail=false`）；tab4 仅 jsonl 未完成；Closed Landscape 采样，非其他姿态；不判 PASS/FAIL，矩阵不变。

### Codex content v3（8ed18682）
- `qa/CODEX-CONTENT-REVIEW.md`：11/12 APPROVE，xiayuan REJECT（放河灯无来源）；APPROVED_FOR_INTEGRATION=false；11 条不接入，hero pending-design。
- 桥归档：`archive/20261114-content-12-approval-v2/`；delta 用例：`qa/CODEX-HANDOFF/XIAYUAN-DELTA-CASES.md`。

### xiayuan delta pre-verify（63722767）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-xiayuan-v3.md`：仅 xiayuan 变化；无放河灯；其余 11 条同 v3；PASS，任务移桥。全文件 3 处放河灯在未改的 zhongyuan/yulanpen。

### 内容接入 Runbook（待授权）
- `docs/R14-CONTENT-INTEGRATION-RUNBOOK.md`；脚本 `scripts/r14-content12-integrate.py`。
- 当前无 `ALL_12_APPROVED=true`、outbox 空，未执行接入；等 PM approved SHA 后按 12/12 preverify→dry-run→apply→抽检。

### Duo Closed Landscape 10/12 interim
- tab0–4 + almanac/compass/daily/fortune/selection 有 22s 截图；缺 folkloreDetail/countdownDetail；rail=false；未完成 12 targets，不判 PASS。

### P1 reminder intent 集成（1238789c）
- 包 tar `ee7d3440…` / binary `62b970e1…`；`R14ReminderIntentUITests` 42.8s PASS（dev 报告）；截图 initial-off/preprompt/enabled/disabled；覆盖 toggle/item 0→1→0，P1 集成缺口关闭。DEBUG 注入，非原生权限。

### 12/12 approved preverify（c686e354）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-content-approved-c686e354.md`：12/12 approved；与 63722767 仅 reviewStatus 差异；structure/hero pending/unlock10 PASS；待 apply→抽检。

### Codex static-review-v2（1238789c）
- `qa/CODEX-STATIC-REVIEW-V2.md`：CHANGES_REQUESTED；P1 静态 CLOSED/UI notDetermined→authorized 转换 OPEN；P2 prepare 静态 CLOSED；P2 DynamicType OPEN（custom size 二次缩放）。
- 归档 `archive/20261114-static-review-v2/`；旧 2fe 结果保留；后续新任务 ID/不可变 revision。

### Codex Daily 导出独立验证（0810）
- `qa/CODEX-BRIDGE-RESULTS.md` 第4节；D-01 更新为 QA+Codex 独立 PASS；183文件匹配、1080×1350、SHA d72ab323、CoreImage QR 解码；仅指定 fixture。
- 归档 `handoff/codex-bridge/archive/20261114-daily-export-verify/`；R14-QA-iPhone 已释放。

### 12 条内容接入抽检（2516718c）
- `qa/CONTENT12-INTEGRATION-QA.md`；包 tar 21ac9abd/binary a2fd2c9a/events 79b80283；12/12 approved；xiayuan 无放河灯，zhongyuan/yulanpen 未变；详情可读；发现 chongyang 过去日期 0 天仍锁定、footer 仅首来源、hero pending；内容行仍 NOT RUN。

### Codex 基线 d092769c 完整报告
- `qa/CODEX-BASELINE-D092769C.md`：PARTIAL/NOT ACCEPTED；144 PNG/CSV/JSON；Duo Open 0/12@22s、Partial 0/12@22s 白屏/90s timeout、Closed 9/12@22s；iPad folkloreDetail SpringBoard；8s 仅 iPhone16/iPad；原生通知/Tabletop/Tent NOT RUN；基线 JISI en FAIL（followup 64cad 单独 PASS）。
- 矩阵保持 100/33/55；REACHED/注入不记 PASS。
- Daily 导出计数更正：329843f5 = **183 files/mismatches=[]**；baseline d092 = 181，分开；导出 PASS 不变。

### pastdate/footer 修复抽检（8e213b5c）
- `qa/PASTDATE-FIX-QA.md`：chongyang 真实日期已过去/已解锁、详情可读；未来38天仍锁定；footer 2 sources；12 详情截图；两缺陷 UI CLOSED；内容行仍 NOT RUN。

### static closeout pre-verify（5509c8e4）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-staticcloseout-5509c8e4.md`：P2 fixedSize 二次缩放 PASS（xLarge/a2 无裁切）；P1 UI 转换 4/4（settingsReturn/relaunch，注入）；events 12 approved 未回退；任务移桥新 ID。

### 干净重建补充（5509c8e4）
- `qa/REPRO-BUILD-5509c8e4.md`：BUILD SUCCEEDED；events 79b80283、字体/资源一致、可执行 40,136B；二进制 SHA 不同（debug UUID/路径）→ 可构建/资源可复现，byte-identical 不可复现；Review 包含 LixiangTests.xctest，发布包应 build-only 移除。

### build-only clean 包身份 preverify（474b12c8）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-clean-474b12c8.md`：tar 7547f91c/binary c382c07b/commit 474b12c8/events 79b80283；无 PlugIns/xctest；dev 报告 package-check PASS；QA 直接执行脚本遇 SwiftPM 缓存权限环境限制。

### Codex static closeout 0915（PARTIAL）
- `qa/CODEX-STATIC-CLOSEOUT-0915.md`：DynamicType 二次缩放静态 CLOSED/视觉覆盖 OPEN；P1 转换/恢复/手动开启 CLOSED，手动关闭持久化测试 OPEN；内容/past 回归 CLOSED；矩阵不变。
- 归档 `archive/20261114-static-closeout-v2/`。

### static closeout v3 pre-verify（a29373e9）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-staticcloseout3-a29373e9.md`：manual disable 1→0+重启无 seed 持久化测试；actual/fallback xl+a2 截图、FontAvailabilityTests；events 79b80283 未回退；任务移桥新 ID。

### Codex static closeout v3（PARTIAL）
- `qa/CODEX-STATIC-CLOSEOUT-V3.md`：manual disable CLOSED；forced fallback OPEN（Noto 分支未 gate，日志与实际渲染不一致）；fixedSize 仍 CLOSED；矩阵不变。
- 归档 `archive/20261114-static-closeout-v3/`。

### forced fallback pre-verify（6d6e14e6）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-fontfallback-6d6e14e6.md`：serifFontName forced=nil（Noto gate）、strategy 同源、test 断言实际 Font=.system(serif)；actual/forced xl+a2 截图；同次日志 P1 未找到待 Codex；任务移桥新 ID。

### Codex static closeout v4
- `qa/CODEX-STATIC-CLOSEOUT-V4.md`：forced fallback/诊断 CLOSED；XL/a2 截图接受；同次 raw log→截图 linkage OPEN（证据缺口）；其他 CLOSED 未回退；矩阵不变。
- 归档 `archive/20261114-static-closeout-v4/`。

### linkage 同次取证 pre-verify（6d6e14e6）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-linkage-6d6e14e6.md`：manifest 5dcc866e；三 run log/PNG SHA 全匹配；actual/forced flags/LXFONT 对应；时间顺序/设备一致；build-only 无 PlugIns/xctest；任务移桥。

### Codex linkage 结果（6d6e14e6）
- `qa/CODEX-LINKAGE-6d6e14e6.md`：CLOSED（限三次团队运行）；manifest/tar/binary/6 logs+PNG SHA 独立匹配；三 run flags/LXFONT/设备/容器一致；forced fallback+linkage 关闭；static-review 链全部关闭；矩阵不变。

### build-only clean 候选（83b4fa98）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-clean-83b4fa98.md`：tar 2d4ab7d0/binary 748e32ac/commit 83b4fa98/events 79b80283；无 PlugIns/xctest；dev package-check PASS；仅身份检查。

### 源码交付 bundle（83b4fa98）
- `qa/CODEX-HANDOFF/SOURCE-BUNDLE-83b4fa98.md`：bundle SHA e68a0763…；HEAD 83b4fa98；`git bundle verify` okay；完整历史；仅 HEAD；不 push/merge。

### 当前交付 checksum 清单（83b4fa98）
- `qa/CODEX-HANDOFF/DELIVERY-CHECKSUMS-83b4fa98.md`：清单 SHA d34a3903（旧 654648f9 作废）；shasum -c 全部 OK；matrix/final/defect/clean/bundle 一致；矩阵 lint 100/33/55。

### clean 候选 83b4fa98 smoke
- `P1/shots/r14-clean-candidate-smoke.png` SHA **94067d9c…**（文件 hash；91475fd2 是预览归一化副本）；1206×2622；QA-iPhone 启动 Home 可见；仅 smoke，不记 UI/188 PASS。

### 交付 checksum 再刷新（83b4fa98）
- `qa/CODEX-HANDOFF/DELIVERY-CHECKSUMS-83b4fa98.md`：清单 SHA `3ab50f93…`（旧 d34a3903/654648f9 作废）；shasum -c 全部 OK；FINAL-STATUS `a12c1fa3…`；矩阵 100/33/55。

### Review 文档包（83b4fa98）
- `qa/CODEX-HANDOFF/REVIEW-DOCS-83b4fa98.md`：tar SHA 633de261…；61K/42 entries；仅文档无二进制；嵌套 checksum 3ab50f93；INDEX §15；矩阵不变。

### Duo 姿态约定/映射（10:45）
- `qa/DEVICE-POSE-CONVENTIONS.md`：Tabletop=Partially Open+rotation；Tent≡Closed Landscape。
- 截图 `P1/shots/duo-tabletop-devicehub-user.webp` SHA `07961e7e…`（882×1324）。
- `qa/DUO-POSE-MAPPING.md`：12页×2 + 额外矩阵行均 NOT RUN；Tent 仅 candidate，Tabletop 必须单独测；矩阵不变。

### 28 行口径复核（14 对）
- `qa/DUO-POSE-MAPPING.md` 已扩为 14 对（含 149/150/155/156/183/186）；全部 NOT RUN。
- `FINAL-QA-SUMMARY`/`CODEX-BASELINE-D092769C`/`DUO-CODEX-FINAL`/`FIRST-BATCH` 已统一为 28 行（14 对）；矩阵 SHA 不变。

### Tabletop design=OpenPortrait（Sure 确认）
- `qa/DEVICE-POSE-CONVENTIONS.md`/`qa/DUO-POSE-MAPPING.md`/`qa/EXTERNAL-BLOCKERS.md` 已标注 physical=PartiallyOpen+rotation、design=OpenPortrait；Tabletop/Tent statuses 仍 NOT RUN；矩阵不变。

### Tabletop design=OpenPortrait 更新
- `qa/DEVICE-POSE-CONVENTIONS.md` `589ffa33…`；`qa/DUO-POSE-MAPPING.md` `0dedd3bb…`；`qa/EXTERNAL-BLOCKERS.md` `fc3ee2b8…`；`qa/CODEX-INTERIM-d092769c.md` `…`；statuses 仍 NOT RUN。

### UI-001 bottom bar / 季节素材
- `qa/CODEX-UI-PRIORITY.md`：UI-001 源码定位 + 三态/5Tab/详情/浅深色/设备分批用例；矩阵不改。
- `qa/SEASONAL-ART-INVENTORY.md`：根目录 48 终稿 WebP；candidates 37（24 节气+12 节日+1 test），PM 口述 46 张差 9 张待清单；daxue-light 207KB 超 120KB；与 UI-001 分开。

### 阿里云素材视觉抽检（37 candidates）
- `qa/ASSET-QA-ALIYUN.md`：37=24节气+12节日+1 test；33 PASS/3待修（fest-laba 空白、fest-xiezao 伪文字、term-dashu 水印）/1排除；全部 16:9 1024×576 RGB ≤120KB；缺下元/祭祖；root daxue-light 207KB spec 缺陷；hero pending/内容行 NOT RUN。

### 阿里云素材复检清单
- `qa/ASSET-ALIYUN-RECHECK.md`：37/产品36；待修复检 laba/xiezao/dashu、补 xiayuan/jizu、root daxue 压图；通过前不接 App；矩阵不改。

### UI-001 uifix pre-verify（8094de4d）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-uifix-8094de4d.md`：源码 overlay 正确；但 light-mid=light-bottom 同 SHA，三态 bottom 未成立；UI test 未断言无底带/末项/5Tab/详情；iPad/Duo NOT RUN。**preverify 未通过，任务留 HOLD**。

### 阿里云素材复检 v2（39/38）
- `qa/ASSET-QA-ALIYUN.md`：6 项复检 PASS（laba c1ae3793、xiezao 71c14231、dashu c213edbc、xiayuan b3e0bb7f、jizu 3f733ceb、root daxue-light 1b6e2610 115,952B）；candidates 39=产品38+test1；hero pending/内容行 NOT RUN。

### 素材复检 PASS / UI-001 HOLD
- `qa/ASSET-ALIYUN-RECHECK.md`：6项 PASS；39=38+1；hero pending、不接 App。
- UI-001 `qa/CODEX-HANDOFF/R14-PREVERIFY-uifix-8094de4d.md`：preverify 未通过（mid=bottom 同 SHA/断言不足），任务 HOLD；iPad/Duo NOT RUN。

### Codex Tabletop/Tent（rows-28）
- `qa/CODEX-POSE-TABLETOP-TENT.md`：PARTIAL UI/UX；28行 14 FAIL_UI/11 PARTIAL/2 PASS_STATE_ONLY/1 NOT_RUN；UI-001 复现、HOME-TOOLS 122pt、Closed compact 两栏缺失；矩阵不改。
- `qa/DUO-POSE-MAPPING.md` 已并入 rows-28 verdict。

### UI2 pre-verify（4f52f40a）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-ui2-4f52f40a.md`：A iPhone 三态 distinct+月历可点+5Tab+push/back PASS；B phone/xL 部分 PASS（17状态/天气全态 NOT RUN）；C ForceCompact 不作验收、真实 Duo NOT RUN；任务移桥。

### Codex UI2 PARTIAL 更正
- A 仅 dark 三态独立 PASS；light 三态 OPEN（需要 QA iPhone 重抓）；B equal-height 改善但 final token/centering 仍不符 OPEN；C 只有 DEBUG force、无自动 compact，NOT RUN。preverify/task 已更正。

### UI2 light 重抓/更正
- Codex：dark 三态 PASS；light 三态 OPEN（mid=first、bottom 未建立）。
- QA 尝试：`qa/evidence/ui2-light-recapture/light-first-qa.png` SHA `489d3596…`；mid/bottom 因 xcodebuild pty/SwiftPM 权限无法抓取，不能当独立三态。
- C 更正：仅 DEBUG force，无自动 compact；B final token/centering OPEN。矩阵不变。

### UI3 pre-verify（46f47ff4）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-ui3-46f47ff4.md`：A HOME-TOOLS final phone/xL PASS（17状态/天气全态 NOT RUN）；B compact selector 代码/单测4/4 PASS（真实 Duo/iPad/rail NOT RUN）；C UI-001 OPEN（light 三态仍缺）；任务移桥。

### Codex UI3（46f47ff4）
- `qa/CODEX-UI3-46F47FF4.md`：A/B/C scoped CLOSED（A normal/xL light；B static selector；C iPhone16Pro/iOS18.6 light 三态+末项点击）；17状态/天气全态/真实 Duo/iPad/dark/iOS27 NOT RUN；矩阵不变。
- 下一步用例 `qa/UI-NEXT-REAL-COMPACT-IPAD-DARK-CASES.md`（需设备窗口）。

### 12 条 hero 映射/视觉复核
- `qa/CONTENT-HERO-QA.md`：映射12/12完整/PASS；bytes/SHA/尺寸匹配；视觉6 PASS/5 alt待修/1 yulanpen待修（偏浅且与中元近似）；qingming选择待确认；未接 App/hero pending/内容行 NOT RUN。

### 12 hero delta 复检
- `qa/CONTENT-HERO-RECHECK.md`：5 张 alt 修正 + yulanpen 新图/复用理由；只复检 delta；candidates 40=39可用+1test，¥11.2；通过前不接 App，hero pending，内容行 NOT RUN。

### 12 hero delta 复检结果
- `qa/CONTENT-HERO-RECHECK.md`：映射 256135dd 全匹配；chunjie/qingming/xiezao/jizu alt 通过；dongzhi alt 仍错（黄坛非灯笼）；yulanpen 新图区分中元/无红线，但偏浅、alt“暮色”不符；delta 未全通过，不接 App；39可用+1test，¥11.4。

### hero 最后一轮 delta（2项）
- 仅 dongzhi/yulanpen alt 与画面一致 + mapping 新 SHA/bytes；通过后交 dev；hero pending/内容行 NOT RUN；矩阵不改。详见 `qa/CONTENT-HERO-RECHECK.md`。

### hero 最终 delta PASS
- `qa/CONTENT-HERO-MAP.md` SHA `53c79f16…`；dongzhi/yulanpen alt 与画面一致；12行 path/bytes/SHA/16:9 全匹配。
- `qa/CONTENT-HERO-RECHECK.md` 最终 PASS；12 hero 仍 pending待 dev 集成；内容行 NOT RUN；矩阵不变。

### 12 hero 集成验收准备
- `qa/HERO-INTEGRATION-CASES.md`：dev 放 `App/Resources/Content/Heroes/<id>.webp`，UI 按 id 加载/缺失回退 winter；12/12 显示+alt+无拉伸、缺失回退、events 不改；hero 仍 pending，内容行 NOT RUN；矩阵不变。

### 12 hero 集成 pre-verify（0198a031）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-hero-0198a031.md`：bundle 12 webp 与 candidates SHA 匹配；QA iPhone 12详情 hero 实拍 PASS（dongzhi 重试）；团队 qingming 截图错页已重拍；fallback 静态/单测；内容行 NOT RUN；任务移桥。

### Codex hero 集成（scoped PARTIAL）
- `qa/CODEX-HERO-0198A031.md`：12资产/映射/alt/QA截图 PASS；详情固定220非16:9自适应 OPEN；缺失fallback运行时截图 OPEN；EN accessibility NOT RUN；矩阵不改。
- 剩余用例 `qa/HERO-REMAINING-CASES.md`（phone/iPad 16:9、fallback、EN）。

### hero v2 pre-verify（de01327c）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-hero2-de01327c.md`：宽度派生16:9、去固定220；phone/iPad截图无拉伸；DEBUG missing-hero fallback截图 winter；12资源未回退；EN accessibility NOT RUN；内容行 NOT RUN；任务移桥。

### Codex hero2（de01327c）
- `qa/CODEX-HERO2-DE01327C.md`：16:9/fallback 视觉 scoped CLOSED；12资源未回退；**known-ID fallback label OPEN**（画面 winter 但 label 仍原 alt）；EN NOT RUN；内容行 NOT RUN；矩阵不变。
- `qa/HERO-REMAINING-CASES.md` 已加 known-ID fallback label 用例。

### hero3 a11y pre-verify（38b34c5a）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-hero3-38b34c5a.md`：resolve image+label 同源；forced/unknown 中性“岁时插画”，正常原 alt；ContentHeroTests 6/6 + UI test dev 报告；12资源/16:9/content 未回退；EN/内容行 NOT RUN；任务移桥。

### Codex hero3（38b34c5a）
- `qa/CODEX-HERO3-38B34C5A.md`：fallback-label scoped CLOSED；resolve 同源；独立 runtime/AX/VoiceOver NOT RUN；12资产/16:9/events 未回退；内容行 NOT RUN；矩阵不变。
- 下一步 `qa/CONTENT-DETAIL-ROWS-CASES.md`（85-90/163/174 真实日期/多设备/深色/长图）。

### 内容详情行 85-90/163/174 验收
- `qa/CONTENT-DETAIL-ROWS-QA.md`：85/86/87/88 有默认详情补充截图但缺 eventID/version/read/retry/alt；89/90 无 landscape（screenConfig 无 mode）；163 缺已读/跨日；174 无长图；全部保持 NOT RUN；矩阵不变。

### clean 38b34c5a 身份 preverify
- `qa/CODEX-HANDOFF/R14-PREVERIFY-clean-38b34c5a.md`：tar 36d20ef2/binary b4ddbe8e/commit 38b34c5a/events 79b80283；build-only 无 PlugIns/xctest；身份 PASS。
- `qa/DEVICE-WINDOW-REQUESTS.md`：iPad landscape、长图、真机通知、Duo 窗口需求。

### Codex 1445 interim
- `qa/CODEX-1445-INTERIM.md`：真实 Duo Closed compact 自动生效但 FAIL_UI（tools 空白高/超出下边缘/被 tab 胶囊遮挡）；OpenPortrait tools 正常但不推断整页；startup content.ready 4–5.4s/真实 Home +~20s，需 same-run firstContentFrame。
- `qa/STARTUP-FIRSTFRAME-EVIDENCE.md`：首帧证据接收模板；8s/content.ready 不替代首帧。

### compactfix pre-verify（5ce982b8）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-compactfix-5ce982b8.md`：toolsRow fixedSize、compact inset160、firstContentFrame DEBUG log；包/commit 匹配；真实 Duo/首帧证据未到，任务移桥。

### Codex 1445 interim OpenLandscape rail
- `qa/CODEX-1445-INTERIM.md`：OpenLandscape 侧栏 FAIL_UI（几何不符/遮挡）；规格 right23/w50/h252/top401、5×48、tab44/icon25；Closed compact FAIL_UI 保持不重试。
- 设计保真用例 `qa/UI-DESIGN-FIDELITY-CASES.md`：逐屏原稿对照几何/避让/颜色字号；到达≠通过。

### railfix pre-verify（b6c6e33f）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-railfix-b6c6e33f.md`：R14SideRail right23/w50/h252/top401、5×48、tab44/icon25、reserve58；overlay safeArea 折算；测试2/2 dev 报告；真实 Duo 几何待 Codex；矩阵不变。

### Codex 1445 iPad/Compact/Dark + Duo43
- `qa/CODEX-1445-IPAD.md`：PARTIAL+FAIL_UI（iPad portrait 误两栏/landscape 压缩、detail 布局不符、UI-001 三态 PARTIAL、Closed tools 遮挡）。
- `qa/CODEX-1445-DUO33.md`：43行 2 FAIL_UI/16 PARTIAL/25 NOT_RUN/0 PASS_UI；CSV 逐行；Tent 继承 Closed。
- `qa/DUO-POSE-MAPPING.md` 已并入 Duo43 verdict；矩阵不改。

### iPad/Detail/UI-001 三态用例
- `qa/IPAD-LAYOUT-CASES.md`：iPad portrait 全宽竖排（不得误两栏）、landscape 两栏 sizing、detail 左摘要/右文章、UI-001 真实三态滚动、compact/rail 引用；矩阵不改。

### Codex 1530/1545 ACK
- `qa/CODEX-1445-INTERIM.md`：1530 compactfix PARTIAL（空白/末项改善；胶囊压卡边待设计、44/token/dark未测；firstContentFrame marker不判性能）；1545 railfix NOT ACCEPTED（OpenLandscape 持续 loading，rail几何/避让/5tab/dark NOT RUN）。
- `qa/RAIL-REVALIDATION-CASES.md`：home.appear/firstContentFrame/LXRAIL frame 硬门禁 + rail 原稿几何/避让。

### layoutfix pre-verify（2b55da5a）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-layoutfix-2b55da5a.md`：root safeArea 移除、iPad wide 仅 landscape、portrait 单列、wide detail 左摘要右文章、CATransaction firstContentFrame；测试 79/79 dev 报告；真实设备待 Codex；矩阵不变。

### Codex 1600 layoutfix ACK
- `qa/CODEX-1445-INTERIM.md`：布局修好项；sidebar x867 vs design878 FAIL_UI（右距34应23/偏左11pt）；iPad 字号/卡片/纸面比例 PARTIAL；UI-001 无三态；矩阵不变。

### railx pre-verify（9f3881a4）
- `qa/CODEX-HANDOFF/R14-PREVERIFY-railx-9f3881a4.md`：x=geoW+safeRight-width-right=878；expectedX(951)=878/1032=959；常量未回退；真实 Duo LXRAIL/避让/5tab/浅深待 Codex；矩阵不变。
