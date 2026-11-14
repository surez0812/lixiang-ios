# Codex 桥结果归档（2026-11-14）

- 来源：`handoff/codex-bridge/outbox/`
- 矩阵不变：**100 PASS / 33 FAIL / 55 NOT RUN**。

## 1. JISI en 验证 RESULT-TASK-20261114-0800
- `status=DONE`；`functional_result=PASS (bounded scope)`
- 设备：iPhone16Pro `0975B8A6…`（Codex 完成时早于后续锁定；记录原设备，不外推）
- 包：`64cad8d2`；tar `58d3cdb8…`；binary `4d196dae…`；1.0(13)
- 结果：祭祀/造庙 PlainTermSheet zh+en 中性无占位；全量包 JSON 4415 en 字段占位 0（raw 1 个 “blocked earth-energy” 正常语义）；yi-ji 260 空 en=0。
- **边界**：仅词条弹层覆盖，不是全量语义/医疗/宗教措辞审批；**不等于 188 PASS**；QA 只记补充 PASS，不整批。
- 证据：`evidence/jisi-en-verify/codex-iphone16/`。

## 2. 静态代码审查 RESULT-TASK-20261114-0825
- `review_outcome=CHANGES_REQUESTED`（只读审查，未运行 App）
- P1：系统权限刷新无条件开启用户关闭的倒计日提醒（`CountdownDetailScreen.swift:124–128`、`NotificationPermissionCenter.swift`）；查看详情即可改持久化选择。
- P2：prepare 旧日期写回（`SelectedDayStore.swift:83–87`），需按 selectedDate/generation 校验或取消过期任务。
- P2：Text Dynamic Type 分流（`D1Font.swift:99–105` 等）；固定 `.system(size:)` 绕过 ScaledMetric，需运行验证大字布局。
- 其他：ContentCatalog draft 门禁未发现直接放行；无确认 P0，但不等于无崩溃/竞态。
- 状态：dev 已接；修复后需逐项复验。

## 3. 交付可复现审查 RESULT-TASK-20261114-0830
- `review_outcome=CHANGES_REQUESTED`
- PASS：d092/64cad 命名包 tar/binary 与 INDEX 一致；版本 1.0(13)；两个 commit 对象存在；复现基础/旧包保留有记录。
- **FAIL**：manifest 首段通用包路径/SHA 配错（通用包实际 `2314dd8e…`，标 `66b7…`）；PACK-NOTES 仍是旧 build4/旧 mapping，不能作当前构建凭据。
- **NOT RUN**：二进制确由 commit 构建、干净构建可复现/哈希一致（Codex 未重建验证）。
- 建议：交付唯一当前索引，逐包完整 commit/tar/binary/资源哈希/构建工具/清洁状态/已验证矩阵；不把旧追加段落当当前状态。
- 状态：交付文档问题由 Lead 修；矩阵不改。

## 矩阵
- 仍 **100 PASS / 33 FAIL / 55 NOT RUN**；JISI 只补充 PASS，不改 188。

## 4. Daily 导出验证 RESULT-TASK-20261114-0810
- `status=DONE`；`result=PASS (specified export fixture)`
- 设备：R14-QA-iPhone `0B71AEF4…`；覆盖安装未卸载/擦数据；183 文件与冻结包逐字匹配。
- 包：`329843f5`；tar `ebb85cd2…`；binary `bc8c2cd4…`。
- 导出：1080×1350；PNG SHA `d72ab323…`；RGB 无 alpha/透明边；二维码 CoreImage 独立解码 `https://apps.apple.com/app/id6833252283`。
- 边界：仅指定 fixture/经典默认状态，不代表全部经典/超长文案/动态字体/全设备。
- **D-01 更新为 QA + Codex 独立 PASS（补充项）**；矩阵不变。
- 计数更正：Daily 导出实际校验 **183 files，mismatches=[]**；此前 181 为转录错误。**baseline d092=181 是另一 build**，分开不混用。导出 PASS 结论不变。

## 5. 干净重建补充证据（commit 5509c8e4）
- 证据：`qa/REPRO-BUILD-5509c8e4.md`
- 固定 commit `5509c8e4` 独立 worktree + 全新 DerivedData：`BUILD SUCCEEDED`。
- 重建 App vs 审查包：
  - events.json SHA 相同 `79b80283…`；NotoSerifSC Regular/Bold 均在；bundle 89 files。
  - 主可执行大小相同 **40,136B**；**SHA 不同**（重建 `d49cbefe…` vs 包内 `b4b887ee…`）。
  - 差异仅 `Lixiang`/`Lixiang.debug.dylib`（debug UUID/路径非确定性），资源一致。
- **结论：可构建、资源/内容可复现；byte-identical 二进制不可复现，不能声称 reproducible-build PASS。**
- 审查包因先跑测试含 `PlugIns/LixiangTests.xctest`；最终发布包应 build-only 移除该测试插件；现有 immutable 包不改。
- 矩阵不变 100/33/55。

## 6. 源码交付 bundle（83b4fa98）
- 路径：`P1/Lixiang-R14-source-83b4fa98.bundle`
- SHA256 `e68a0763…`；HEAD `83b4fa981cda87770bd9a19b86254fd6bd2e85b7`。
- QA 独立执行 `git bundle verify`：**okay**；完整历史；sha1；仅 HEAD ref。
- 用途：交 Codex/交付方 `git fetch` 审阅；不 push/不 merge。
- 已记入 `R14-DELIVERY-INDEX.md`；矩阵不变。

## 7. 当前交付 checksum 清单（更正）
- `P1/R14-CURRENT-SHA256SUMS` 新 SHA `d34a3903…`（旧 `654648f9…` 作废：含 INDEX 自身循环）。
- QA `shasum -c` 全部 OK：clean tar 2d4ab7d0、source bundle e68a0763、matrix 0e5b4998、FINAL-STATUS 4b473b11、DEFECT-CLOSURE-LOG e1e220ec。
- INDEX §14 已同步；矩阵 lint 188 行/100/33/55。

- 交付 checksum 再刷新：`R14-CURRENT-SHA256SUMS` = `3ab50f93…`（旧 d34a3903/654648f9 作废）；shasum -c 全部 OK；FINAL-STATUS `a12c1fa3…`；INDEX §14 同步。

## 8. Review 文档包（83b4fa98）
- `P1/R14-REVIEW-DOCS-83b4fa98.tar.gz` SHA `633de261…`；约 61K；42 entries（37 files+5 dirs）。
- 含 p1 交付索引/决策/外部请求/当前 checksum、repo-qa 总结/索引/CODEX 文档/matrix；无 App 二进制/大证据。
- 嵌套 CURRENT-SHA256SUMS = `3ab50f93…`；INDEX §15 已记；矩阵不变。
