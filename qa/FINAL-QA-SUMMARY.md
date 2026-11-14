# R14 Final QA Summary（Codex Duo 报告并入前）

- 对照：`r14-final/screens.json` SHA256 `ea505be157c6ceb3bc57eabe0fb00feef3eaf7d990fa6d2b8ad22264224e7409`
- 矩阵：`docs/R14-QA-MATRIX.md`；188 行 **100 PASS / 33 FAIL / 55 NOT RUN**。
- 本总结为 **Duo 并入前版本**；71 条 Duo 行待 Codex 报告后终版。不是 R14 最终放行结论。

## 1. 188 行状态
| 状态 | 数量 |
|---|---:|
| PASS | 100 |
| FAIL | 33 |
| NOT RUN | 55 |

- 55 NOT RUN 中：**Duo 38 行**（Codex 专属，未触碰 R14-Duo UDID `B77A1A25-079D-4A2B-89D0-0642963F70AB`）；**非 Duo 17 行**。Duo 合计 13 PASS / 33 FAIL / 38 NOT RUN。
- 计数校验：`docs/R14-QA-COUNT-CHECK.md` / `scripts/r14-count-check.py` 均 188 行，分页计数一致。

## 2. 剩余非 Duo NOT RUN（17）
| 行 | 页面/状态 | 原因 |
|---|---|---|
| 85/86 | folklore-detail phone light/dark 默认 | 正文内容门禁：仅为 P1 示例段落/「内容准备中」，正式内容未接入；不能评正文可读。 |
| 87-90 | folklore-detail iPad portrait/landscape light/dark | 同内容缺口，且无对应 iPad 详情有效证据。 |
| 163 | folklore-detail 今日解锁/已读边界 | 仅 5 天 P1 示例段落，正文为占位稿，不能评正文/已读边界。 |
| 85-90 | folklore-detail phone/iPad 默认 | 正式 12 条岁时内容未接入，示例稿/内容准备中不得 PASS。 |
| 163 | folklore-detail 今日解锁边界 | 正式内容缺口，仅示例稿。 |
| 164 | folklore-detail 离线/加载失败 | 四态已测，但“缓存正文”仅内容准备中；保持 NOT RUN/内容缺口。 |
| 166-169 | countdown-detail 权限四态 | 模拟器无 notifications privacy service，原生弹窗失败；真机缺，NOT RUN。 |
| 170-174 | 长图 | 目标高度/内容/接缝不达标；不用首屏冒充，NOT RUN。 |

## 3. 补充项（不计入 188）
- X-01..X-05：Dynamic Type XL/字体放大 PASS。
- W-01..W-05：天气授权/拒绝/加载/失败 PASS；W-06 设置返回 NOT RUN。
- F-01/F-04/F-05 PASS；F-02/F-03 NOTE（数学零交叉帧，不作失败）。
- M-01..M-04：运动帧 PASS。
- S-01/S-02：Selection 结果 light/dark PASS。
- D-01：Daily 分享预览 PASS；导出像素 1080×1350 PASS（补充项）。
- C-00..C-23：15 个时点覆盖 12 时辰 PASS；五神位置固定待设计最终确认。
- H-01/H-02：Home 完整/多内容首屏 PASS；行 170 长图仍 NOT RUN。
- T-10/T-9：NOTE/内容缺口（示例稿 version=0 被门禁拦截）。

## 4. 已知缺陷 / 限制
1. **字体**：Songti/Kaiti 字体缺失，回退系统 serif；为已知设计偏差，不标 PASS。
2. **内容缺口**：Folklore 详情正式正文未接入（P1 示例段落）；T-10/T-9 也因内容门禁不可读。
3. **长图**：170-174 最新 longshots 高度/内容/接缝不达标，不能评 PASS。
4. **权限/VoiceOver/真机**：通知权限、动态语音、真机/DeviceHub 未覆盖；W-06/166-169 等保持 NOT RUN。
5. **Duo**：71 行由 Codex 测试；本轮未 boot/erase/install/launch/rotate R14-Duo，避免并行。
6. **构建环境**：`r14-build.sh` 的 SwiftPM 缓存阻塞（exit 74）已复现修复：清理 `.qa/{DerivedData,SourcePackages,swiftpm-cache,home}` 后当前 HEAD 连续 exit 0；QA 使用 dev build `1.0 (13)` 验证。

## 5. 交付包（非代码变更）
- HEAD `bf5fa110`；tar SHA256 `742a1af4…`；同次构建二进制 `2f24610a…`，版本 1.0(13)。
- 演示录屏：`shots/r14-demo-iphone.mp4`。
- 矩阵计数：100 PASS / 33 FAIL / 55 NOT RUN。

## 6. 环境
- **设备锁定/污染（2026-11-14）**：R14-Duo / iPhone 16 Pro / iPhone 13 mini / iPad Pro 13 专属 Codex，QA 不得 launch/rotate/stop/reinstall。Codex 校验发现 iPhone 13 mini `94207526` / iPad Pro 13 `91DA70AC` 的二进制/debug dylib/Info.plist 相对冻结包 `2314dd8e` 改变，初始截图排除；dev 另建 `R14-Build-iPhone`/`R14-Build-iPad`。详见 `qa/DEVICE-LOCK.md`。
- Codex 复测包 tar `2314dd8e…` / binary `1d2661de…`，与旧归档 `690a26b6…` 分开记录。
- iPhone 16 Pro 模拟器、iPad Pro 13 模拟器；iPhone 13 mini 用于 phone plain-off 复验。
- Duo Closed 仅使用此前外屏证据；当前 Duo 设备已交 Codex，不再操作。
- 未使用 GUI/AppleScript；使用 `xcrun simctl` + XCUITest（含 iPad 旋转）。

## 7. Duo / Codex 最终 reconcile
- cases.csv 60 组合：**36 case observations FAIL_AT_OBSERVATION**；矩阵实际 Tabletop/Tent **28 行（14 对）NOT RUN**（原 24 目标口径不含 4 个额外状态行）。
- 映射到唯一矩阵行：**33 FAIL**（3 姿态 × 11 唯一页面；selection 在 tab 与 route 重复，36 observation 对应 33 行），**28 Tabletop/Tent 行（14 对）NOT RUN**，**13 既有 closed-portrait PASS 保留**；其余 Duo 额外状态 NOT RUN。
- **实际整体 100 PASS / 33 FAIL / 55 NOT RUN**；36/35 目标需要重复计 3 个 selection case 或硬改未测行，未硬凑。
- 归档 SHA `690a26b6…`；修复后 tar `2314dd8e…` 尚未重跑 Duo。未操作 R14-Duo。

## 8. Codex reachability ledger
- `b3d89116` / tar `0c140de1…` / binary `73e10df9…`：108 cases，30 REACHED + 1 UI-only + 2 LOADING + 75 NOT RUN；REACHED ≠ PASS。
- `e83753a8` / tar `d9787ccf…` / binary `92d236b4…`：旧快照独立保留。
- 安葬等语义修复待 `02a2a50f`；启动 timing 仍 open。

## 9. Codex focused handback（缺陷关闭，限定）
- mini Daily 右溢出修复（e837 确认；b3d 复核）。
- 黄历 substring 错配：9 词逐项释义；安葬等 6 词 zh+en 在 8c4119b1 实测 6/6。
- Duo rail：Open Landscape 右 rail 5 tab/Home 双栏；Closed Landscape 底栏；PartiallyOpen portrait 正常。
- countdownDetail seeded/列表点击均真实生日详情（iPhone16Pro/mini）。
- 冷启动：02a PTY prepare.done 691ms/content.ready 4425ms，8s 仍 loading、22s 黄历可见；8c term ready 3917ms、22s 词条弹层；**不证明所有 8s 通过**；普通 console 无实时日志。
- 不宣称：188 矩阵保持 100 PASS/33 FAIL/55 NOT RUN；Tabletop/Tent 28 行（14 对）NOT RUN；Daily 分享导出已测得 **1080×1350 / SHA `d72ab323…` / QR 解码成功 → 补充项 PASS**；native Liquid Glass/全 locale/其余未跑组合不通过。
- 4 台预留模拟器已 shutdown、数据保留；本轮未操作。

## 10. 终版 QA 同步（d092769c）
- **启动**：冷启动 8s 已出完整 Home 内容（PASS）。
- **§8 语义**：上巳节/重阳节/大林木/海中金/路旁土 zh+en 实拍通过（文化说明/纳音分类）。
- **§9/§9.4**：10 节日中文语义通过；动作类 en 已改为 “Traditional term for …”，全量 450 terms 无 Go/See/Get/Visit 开头；实测通过。
- **B 通知**：notify5 marker/UI 同步缺陷关闭（注入模拟）；**166-169 仍 NOT RUN**，原生系统弹窗/真机设置返回未测。
- **164/170-174 仍 NOT RUN**：164 缓存正文为内容准备中；170-174 高度/内容/接缝不达标。
- 外部阻塞详见 `qa/EXTERNAL-BLOCKERS.md`；模拟器 notifications privacy service 缺失，原生弹窗尝试失败，未记 PASS。
- **Daily 分享导出像素**：已实测 1080×1350、无 alpha、SHA `d72ab323…`、QR 解码成功；补充项 **PASS**。
- 矩阵不变：100 PASS / 33 FAIL / 55 NOT RUN。

## 10. 结论与下一步
- 当前 100 PASS / 33 FAIL / 55 NOT RUN，**不能宣布 R14 完成**。
- 待 Codex Duo 报告：并入 71 条 Duo 行 → 重跑 `r14-matrix-lint.py` / `r14-count-check.py` → 出终版矩阵与总结。
- 非 Duo 收尾优先：长图采集、Folklore 正式内容接入、通知权限/VoiceOver、W-06。
