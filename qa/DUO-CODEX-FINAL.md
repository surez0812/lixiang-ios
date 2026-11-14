# Duo Codex 最终证据 reconcile

- 证据：`dev-evidence/P1/shots/codex-duo-20261113-2340/`（REPORT.md、cases.csv、3 个已到达姿态目录、open-landscape-settled、metadata.json、installed-bundle-verification.json、SHA256SUMS）。
- 归档 SHA256：**`690a26b6…`**（修复前实测包）；修复后 tar `2314dd8e…` / binary `1d2661de…` 尚未重新跑 Duo，不并入 PASS。
- R14-Duo `B77A…` 本轮**未操作**；证据直接来自 Codex 归档。

## cases.csv 事实
- 60 组合 = 5 姿态 × 12（5 tab + 7 路由）。
- 36 条 observation = `FAIL_AT_OBSERVATION`（6s 空白或 detail 返 home），仅 3 个已到达姿态：closed-landscape / open-portrait / open-landscape。
- 24 条 Tabletop/Tent = `NOT RUN`（无独立物理姿态控件）。

## 矩阵 reconcile（按实际行号）
- **33 条唯一 Duo 矩阵行 FAIL**（3 姿态 × 11 个唯一页面；`selection` 在 5 tab 与 7 路由中各出现一次，同姿态同页面只能映射到同一行，故 36 个 case observation 对应 33 个唯一行）。
- **24 条 Tabletop/Tent 行 NOT RUN**。
- **13 条闭合态既有 PASS 保留**（closed-portrait 11 页面 + fortune 结果/almanac 白话关 2 条）；Codex 未覆盖，不作为 Codex PASS。
- 其余 Duo 额外状态（fortune 结果/罗盘时态/almanac 白话关等）**NOT RUN**，理由“Codex 未覆盖”。
- 实际总计：**100 PASS / 33 FAIL / 55 NOT RUN**（Duo：13 PASS / 33 FAIL / 38 NOT RUN；非 Duo：87 PASS / 0 FAIL / 17 NOT RUN）。
- 说明：36 为 **case observation 数**；188 行是 **matrix row 数**。36/35 目标需要把 3 个重复 `selection` case 重复计行或把未测额外状态强行标 FAIL，均属硬凑；本轮按实际行号如实 reconcile。

## Codex reachability ledger（补充，不改矩阵）
- `codex-rail-route-b3d89116/`：build `b3d89116`，tar `0c140de1…`，binary `73e10df9…`；67 files；108 cases：30 REACHED / 1 UI-only / 2 LOADING / 75 NOT RUN。
- `codex-fix-e83753a8/`：build `e83753a8`，tar `d9787ccf…`，binary `92d236b4…`；51 files；旧快照独立保留。
- **reachability ledger ≠ 188 approval matrix**；REACHED 不是 PASS，不用其覆盖当前 100 PASS / 33 FAIL / 55 NOT RUN（Duo 行映射差异见上）。
- 安葬等语义修复在下一包 `02a2a50f` 验证；启动 timing 仍 open。

## Focused handback defect closures（限定记录，不改矩阵）
1. mini Daily 右溢出：e83753a8 确认修复；b3d89116 复核排版。
2. 黄历 substring 错配：祭祀/针灸/进人口/整手足甲/动土/开池/掘井/破土/开市逐项释义；安葬等 6 词 zh+en 在 8c4119b1 实测 **6/6** 弹层中英文正确、无溢出。
3. Duo rail：Open Landscape 右 rail 5 tab、Home 双栏不被压住；Closed Landscape 保留底栏；PartiallyOpen portrait 正常。
4. countdownDetail 重复 case：seeded 与正常列表点击均进入真实生日详情（iPhone16Pro/mini）。
5. 冷启动：02a2a50f PTY `prepare.done 691ms` / `content.ready 4425ms`；8s 截图仍 loading、22s 黄历可见；8c `term ready 3917ms`、22s 真实词条弹层。**不证明所有 8s 启动通过**；普通 console 无实时日志单列。
- 明确不改：188 矩阵仍 100 PASS / 33 FAIL / 55 NOT RUN；Tabletop/Tent 28 行（14 对）NOT RUN；分享导出像素、native Liquid Glass、完整 locale/内容校对、其余未跑组合均不宣称通过。
