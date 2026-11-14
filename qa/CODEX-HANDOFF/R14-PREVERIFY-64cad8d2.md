# R14 Codex 前置 pre-verify：64cad8d2（JISI/造庙 en）+ 329843f5（Daily 导出）

- 生成：2026-11-14 08:10 +0800
- QA 设备：`R14-QA-iPhone` `0B71AEF4-1E34-47A3-937A-3A097A0D0362`；**未触碰 4 台锁定机 / R14-Duo**。
- 状态：**QA pre-verify 完成**；桥任务可移出 HOLD 交 Codex。

## 1. 包信息
### A) 64cad8d2 JISI/造庙 en
| 项 | 值 |
|---|---|
| commit | `64cad8d249f137b2aa2f760e947419943aa68d77` |
| 路径 | `P1/Lixiang-R14-1.0-13-jisi-en-64cad8d2-debug-simulator.tar.gz` |
| tar SHA256 | `58d3cdb899e3726fa8593f4850f40d5e5f5778135224b289106b8d4889894fc3` |
| binary SHA256 | `4d196dae5603188de49babc85b40bfdda86e4daa7fc7e471c39b527c996a52a6` |
| 版本/build | 1.0 (13) |
| bundle | `xin.zhaoyao.lixiang` |
| mapping | `yi-ji-mapping.json` 260 entries，SHA `a78f19c9…` |

### B) 329843f5 Daily 导出
| 项 | 值 |
|---|---|
| commit | `329843f5` |
| 路径 | `P1/Lixiang-R14-1.0-13-export-329843f5-debug-simulator.tar.gz` |
| tar SHA256 | `ebb85cd2…` |
| binary SHA256 | `bc8c2cd4…` |
| 导出 | `r14-share-export.png` 1080×1350、SHA `d72ab323…`、无 alpha、QR 解码成功 |

## 2. QA 已跑结果
1. **静态包身份 PASS**：A tar/binary/Info 匹配；A 包含 NotoSerifSC Regular/Bold（**Songti/Kaiti 仍缺，系统 serif 回退为已知偏差**）。
2. **全量 en 占位扫描 PASS**：898 条（panel-terms/v2/yi-ji 合并），empty en **0**，精确占位（`—`/`-`/`blocked`/`TBD`/`placeholder`/`(skip)`）**0**；宽泛扫描中 “blocked earth-energy” 是正常语义，不是占位。
3. **UI smoke PASS**：QA 机冷启动 8s 出完整 Home；`-LixiangPlainTerm 祭祀/造庙` 实拍 zh+en 中性说明，无占位、无宗教劝诱。
   - `qa/evidence/qa-jisi-verify/祭祀.png`、`造庙.png`、`home-8s.png`。
4. **Daily 导出补充项 PASS**：329843f5 导出 1080×1350、无透明/裁切、QR 可扫（`https://apps.apple.com/app/id6833252283`）。
5. **dev 自测不冒充 QA 结果**：dev 报告 AlmanacTermSemanticTests 11/11、ContentCatalog 5/5、DailyShareExport 1/1；QA 本机无法重跑 xcodebuild（SwiftPM/sandbox 缓存权限受阻），以上作为 dev 报告记录，QA 独立证据为静态+UI。

## 3. 测试点/预期（交 Codex）
- 祭祀/造庙：PlainTermSheet zh+en 均非占位，en 含 rites/temples or ancestral halls，无宗教劝诱。
- 全量 en：无 `—`/`blocked`/`TBD`/`placeholder`/`(skip)` 占位；正常语义词不误判。
- 冷启动：8s 内 Home 完整（本机 PASS）。
- Daily 导出：1080×1350、SHA `d72ab323…`、无裁切/透明边、QR 可扫。
- 不得改矩阵 100/33/55；内容 12 条仍 draft/pending。

## 4. 已知限制
- 正式 12 条内容仍未 approved；ContentCatalog draft 门禁有效，示例不冒充内容完成。
- 166-169 原生通知仍缺真机；170-174 长图仍 NOT RUN；164 内容缺口。
- 本 pre-verify 不改 188 矩阵，不得据此将内容缺口行标 PASS。

## 5. 12 条内容审批 QA 用例
- 见 `qa/CODEX-HANDOFF/CONTENT-12-QA-CASES.md`；审批后执行，不先接入。
