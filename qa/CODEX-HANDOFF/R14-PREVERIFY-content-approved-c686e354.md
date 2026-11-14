# 12/12 approved pre-verify（c686e354）

- 文件：`qa/content/events-12.json`
  - 新 SHA `c686e354e1f2737ebabe2c13399afe6d4ffe90c3491a4bf3abc206d07674a251`
  - 基线审核快照 `63722767…`（Codex ALL_12_APPROVED，editorial only）
- 结论：**approved pre-verify PASS**，可以执行受控接入。

## 1. 与 63722767 diff
- 12/12 `reviewStatus` 从 draft → **approved**；`version=1`。
- 除 reviewStatus 外深比较 **0 差异**（strip reviewStatus 后 JSON 完全相等）。
- 12 ids/正文/sources/license/hero/unlockOffset/teaser 均与审核快照一致。

## 2. 结构/字段
- 12/12 approved、version=1。
- teaser 15–23；sections≥2；sources 2 条；license=original + licenseNote；hero.status=pending-design；unlockOffset=10。
- **hero 仍 pending-design**：不代表图片资产已交付。
- 内容行 85-90/163/174 仍需 UI 证据，**不因 approved 自动 PASS**；188 矩阵不变 100/33/55。

## 3. 接入前检查
- `qa/content/events-12-static-check.json` SHA `550fe7bf…`（结构 issues 空）。
- 受控脚本 dry-run 由 Lead 执行通过（source 12/12、target `33c75b2b…`）；QA 未执行 `--apply`。
- 后续：Lead `--apply` → 新 followup 包 → QA 抽检 12 页（日期/teaser/sections/sources/hero pending/unlockOffset；approved 详情可读、draft 不再可读）。
