# R14 缺陷/补充项关闭日志（非 188 矩阵）

> 只记录“具体缺陷是否关闭”；**不等于对应 188 行 PASS**。矩阵仍以 `docs/R14-QA-MATRIX.md` 为准（100 PASS / 33 FAIL / 55 NOT RUN）。

| # | 缺陷 | 状态 | 证据/包 | 备注 |
|---|---|---|---|---|
| 1 | mini Daily 右溢出 | CLOSED | e83753a8 / b3d89116；QA | 375pt 无横溢；导出 D-01 另列 |
| 2 | 黄历 substring 错配 | CLOSED | 8c4119b1 6 词 + §8/§9/§9.4 | zh/en 实拍；不等于全词条 |
| 3 | Duo 右 rail / Closed 底栏 | CLOSED（旧包） | b3d89116；`codex-rail-route-b3d89116` | 最新 d092 姿态复测未完成；矩阵 33 FAIL 未改 |
| 4 | countdownDetail 重复 case/占位 | CLOSED | b3d89116 | seeded + 列表点击真实详情 |
| 5 | 祭祀/造庙 en 占位 | CLOSED (bounded) | followup `64cad8d2`；桥 RESULT 0800 | iPhone16Pro 运行时中性无占位；非全量语义审批 |
| 6 | 静态审查 P1 通知 refresh 覆写用户关闭 | 静态/测试设计 CLOSED；手动关闭测试 v3 CLOSED；原生 NOT RUN | `c40772cc` + `1238789c`；Codex v2 `RESULT-...revision-1238789c` | **notDetermined→authorized 未覆盖**（mock 在 init 即 authorized）；需 settingsReturn 转换测试，重启复读未证 |
| 7 | 静态审查 P2 prepare 旧日期写回 | 静态 CLOSED | `344d0602`；Codex v2 | 代际 token/并发合并；测试调度覆盖有限 |
| 8 | 静态审查 P2 Text DynamicType | CLOSED（限证据范围）：fixedSize + forced fallback/diagnostic + 同次 linkage（Codex v4/linkage） | Codex v2：@ScaledMetric + `.custom(name,size:)` 二次缩放，cap 失效 | 改用 `.custom(name,fixedSize:)` 或单一缩放；需 Noto/fallback/xLarge/accessibility 核验；xLarge 无横裁≠cap 正确 |
| 9 | Daily 分享导出像素 | CLOSED（QA+Codex 独立） | `329843f5`；QA `ccc0f7f2`；Codex 0810 PASS | 1080×1350、SHA `d72ab323…`、无 alpha、QR 独立解码；仅 fixture 状态 |
| 10 | 启动 8s（QA iPhone） | PASS（本机） | `79c68100`；QA `7e74b011` | mini/Duo 8s 未达标，环境/时序限制 |
| 11 | 12 条岁时正文 | 12/12 APPROVED (editorial) | v3 `8ed18682` 11 APPROVE；xiayuan `63722767` APPROVE；ALL_12_APPROVED=true | 待 PM 改 reviewStatus approved + 受控接入；内容行仍 NOT RUN；hero pending |
| 12 | 交付 manifest 首段配对 / PACK-NOTES | FIXED（文档） | `R14-DELIVERY-INDEX`；源码 PACK-NOTES `9609b1e` | 历史包内旧 PACK-NOTES 不删，标注非凭据；二进制由 commit 构建仍 NOT RUN |

## 不在本日志内
- 188 行矩阵状态、Tabletop/Tent 28 行（14 对）、166-169 真机通知、170-174 长图、四季素材/签库：均按外部阻塞/内容缺口处理，未关闭。

- 2026-11-14 归档：Codex static-review-v2 `CHANGES_REQUESTED`；P1 静态 CLOSED/UI 转换 OPEN、P2 prepare 静态 CLOSED、P2 DynamicType OPEN；后续新任务 ID/不可变 revision。详见 `qa/CODEX-STATIC-REVIEW-V2.md`。
- 2026-11-14 内容接入抽检：12/12 approved 已入包且详情在日期条件下可读；发现 (a) chongyang 过去日期仍显示 0 天锁定（真实日期路径），(b) 详情 footer 仅显示第一来源（json 2 sources），(c) hero 仍 pending-design/通用图；内容行仍 NOT RUN。
- 2026-11-14 pastdate 修复抽检：chongyang 真实过去日期已显示「已过去/已解锁」且详情可读；未来>10天仍锁定；footer 显示全部 2 来源。两缺陷 UI CLOSED（补单测建议）；内容行仍 NOT RUN。

- 2026-11-14 static closeout：P1 settingsReturn/relaunch UI 4/4（注入）、P2 fixedSize 二次缩放修复 + xLarge/a2 截图；两项 pre-verify PASS，交 Codex 复评；原生通知仍 NOT RUN。
- 2026-11-14 干净重建补充（5509c8e4）：固定 commit 独立 worktree 构建 SUCCEEDED，资源/events 一致、可执行大小同 40,136B；二进制 SHA 因 debug UUID/路径不同 → byte-identical reproducible 仍 NOT PASS；测试插件需 build-only 包移除。

- 2026-11-14 Codex static closeout 0915 归档：PARTIAL；DynamicType 二次缩放静态 CLOSED/视觉覆盖 OPEN；P1 desired 转换/恢复/手动开启持久化 CLOSED，手动关闭持久化测试 OPEN（测试缺陷）；内容/past 回归 CLOSED；矩阵不变。详见 `qa/CODEX-STATIC-CLOSEOUT-0915.md`。

- 2026-11-14 closeout v3：manual disable 1→0+重启无seed 测试已补；actual/forced fallback xl/a2 截图+FontAvailabilityTests；QA preverify PASS，交 Codex。

- 2026-11-14 Codex closeout v3：manual disable 1→0+重启 CLOSED；forced fallback OPEN（真实缺陷：Noto 分支无条件返回，-LixiangForceSerifFallback 不能绕过；诊断日志却报 forced）；等 dev 新包。详见 `qa/CODEX-STATIC-CLOSEOUT-V3.md`。

- 2026-11-14 forced fallback v4：serifFontName forced 直接 nil（Noto 也 gate）；strategy 同源；FontAvailabilityTests 断言实际 Font=.system(serif)；actual/forced xl/a2 截图有字形差异；QA preverify PASS，交 Codex。

- 2026-11-14 Codex closeout v4：forced fallback 实现/诊断 CLOSED，XL/a2 截图接受；同次 raw LXFONT log→截图 linkage OPEN（证据缺口）；其他 CLOSED 未回退；矩阵不变。详见 `qa/CODEX-STATIC-CLOSEOUT-V4.md`。

- 2026-11-14 linkage 取证：manifest SHA 5dcc866e，三 run log/PNG SHA 与 manifest 一致；flags/LXFONT/时间/设备匹配；build-only 无测试插件；QA preverify PASS，交 Codex 复核 linkage。

- 2026-11-14 Codex linkage 结果 **CLOSED（限三次新团队运行）**：manifest/tar/binary/6 logs+PNG SHA 独立匹配；三 run flags/LXFONT/设备/容器一致；安装二进制与包内一致。字体 forced fallback + linkage 关闭；static-review 链全部关闭（不表示 188/原生通知/全设备 PASS）。详见 `qa/CODEX-LINKAGE-6d6e14e6.md`。

- 2026-11-14 UI2 preverify（4f52f40a）：A iPhone UI-001 三态/末项/5Tab/详情 PASS；B HOME-TOOLS phone/xL 部分 PASS（17状态/天气全态 NOT RUN）；C Closed compact 真实 Duo NOT RUN（ForceCompact 不作验收）；矩阵不变。

- 2026-11-14 UI3（46f47ff4）Codex scoped CLOSED：A HOME-TOOLS normal/xLarge light；B compact selector 静态实现；C iPhone16Pro/iOS18.6 light 三态+末项点击。**不写成全量 PASS**：17状态/天气全态/真实 Duo compact/iPad/dark/iOS27 Liquid Glass NOT RUN；矩阵不变。

- 2026-11-14 Codex hero3（38b34c5a）：fallback-label 缺陷 CLOSED（fixed-source review，resolve 同源；known forced→winter+岁时插画；normal→原 alt）；独立 runtime/AX/VoiceOver NOT RUN；12资产/16:9/events 未回退；内容行仍 NOT RUN；矩阵不变。
- 2026-11-14 Codex 1445 iPad/compact/dark：PARTIAL + FAIL_UI（Duo Closed tools 空白/遮挡；iPad portrait 误两栏；landscape 压缩/空白；detail 整体布局不符；UI-001 三态仍 PARTIAL）。
- 2026-11-14 Codex 1445 Duo43：2 FAIL_UI（row8/11）/16 PARTIAL/25 NOT_RUN/0 PASS_UI；REACHED≠PASS；Tabletop 未跑、Tent 继承 Closed；矩阵不改。
- 2026-11-14 Codex 1530 compactfix PARTIAL：Closed compact tools 空白/末项清障改善；胶囊初始压卡边待设计决策，44/token/dark 原稿未量测；firstContentFrame 仅 onAppear marker，不判性能；矩阵不改。
- 2026-11-14 Codex 1545 railfix NOT ACCEPTED：OpenLandscape 未到 rendered Home（持续 loading），rail 几何/避让/5tab/dark NOT RUN；dev 查 content.ready→layout；阻塞待修，矩阵不改。
- 2026-11-14 Codex 1600 layoutfix（2b55da5a）：Duo OpenLandscape 可到 Home（home.appear/firstContentFrame），iPad portrait 单列、landscape 两栏+detail 左摘要右文章；FAIL_UI sidebar x867 vs design878（右距34应23，偏左11pt，safe-area 待修）；iPad 字号/卡片/纸面比例 PARTIAL；UI-001 仅 first/after-drag 无三态；矩阵不改。
