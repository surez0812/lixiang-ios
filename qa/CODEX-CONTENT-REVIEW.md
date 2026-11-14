# Codex 12 条内容审批结果（REJECT 0/12）

- 对象：`qa/content/events-12.json` SHA `a77aaba128489edde263fb325700bd9ee0d1a64a2fdef5c0c5db42f5a5cdccf4`（全部 draft）。
- 结论：**APPROVE 0/12，REJECT 12/12**；`APPROVED_FOR_INTEGRATION=false`。
- 归档证据（Codex）：
  - `handoff/codex-bridge/evidence/content-12-approval/audit.json` SHA `f473ad17…`
  - `events-12.snapshot.json` SHA `a77aaba1…`
  - `source-access.md` SHA `db4eaa14…`
  - `events-12-static-check.json`：结构 12/12、issues 空
  - `CODEX-SHA256SUMS`

## REJECT 理由
1. **来源仅为机构主页**：CMA/IHChina 等 URL 只到首页，缺文章级来源；gov 403、wenming redirect loop 仅代表本环境不可访问，不断言全局不可用；机构主页可达不等于条目事实已核。
2. **public-domain 未证实**：仅标 license，无 provenance 证据。
3. **缺 hero**：12 条全部 `has_hero=false`。
4. **缺 unlockOffset**：12 条全部 `has_unlockOffset=false`。
5. **措辞**：xiayuan/yulanpen 需修订（Codex 指出的措辞项）。
6. 结构本身 12/12 通过（sections/teaser 长度/static check issues 空），但内容与来源不达审批标准。

## 矩阵/行状态
- 内容缺口行 **85-90 / 163 / 174 继续 NOT RUN**；不因 Codex 审批或结构通过改 PASS。
- 188 矩阵保持 **100 PASS / 33 FAIL / 55 NOT RUN**。

## 后续流程
1. PM 修订 `events-12.json`（补文章级 https 来源/许可证据、hero、unlockOffset、xiayuan/yulanpen 措辞），给新 SHA。
2. QA 按 `qa/CODEX-HANDOFF/CONTENT-12-QA-CASES.md` 重新 pre-verify（结构/来源/红线/地区差异/门禁）。
3. pre-verify 通过后才放桥任务复审；当前 content-12 任务已从 inbox 移入 archive，避免 Codex 重复处理旧 JSON。

## v3 审批结果（8ed18682，Codex 2026-11-14）
- 输入：`qa/content/events-12.json` SHA `8ed1868238ba8ba2d73b6c58c46e536d6db0617bcd7a2289a29e7fca99ed06e5`；12 draft。
- **approved=11/12；APPROVED_FOR_INTEGRATION=false**。
- APPROVE：dongzhi/qingming/chunjie/zhongqiu/zhongyuan/laba/yulanpen/xiezao/jizu/shangsi/chongyang。
- **REJECT xiayuan**：所列下元节/道教来源未找到“放河灯”依据；官方河灯材料多指七月中元，不能推定十月下元；需补具体地区/日期来源或删除该细节后再复核。
- 11 条 approved **不接入**：等 xiayuan 修完、全部 12 条 approved 后再走受控接入脚本；approve ≠ UI/PAGE-CONTRACTS 通过；hero 仍 pending-design。
- Codex 桥结果已归档：`handoff/codex-bridge/archive/20261114-content-12-approval-v2/`。
- 内容行 85-90/163/174 仍 **NOT RUN**；矩阵不变 100/33/55。

## xiayuan delta preverify（待新 SHA）
1. 删除/替换“放河灯”（不将“未找到”写成“不存在”）；如保留需具体地区/日期来源。
2. 保留“传统信仰说法/非客观效果”限定，不写吉凶承诺。
3. 其余 11 条字段/正文与 SHA 8ed18682 版本一致（diff 只应涉及 xiayuan）。
4. 12 条 teaser≤23、sources 2 具体条目、license=original+licenseNote、hero pending-design、unlockOffset=10 保持。
5. 通过后重新 preverify，再交 Codex 复审；不先接入。

## xiayuan delta（新 63722767）
- 仅 xiayuan 改动；xiayuan 已无“放河灯”，保留三元节/祭水官/解厄与传统信仰非客观效果限定；其余 11 条与 v3 快照完全一致。
- 全文件仍有 3 处“放河灯”在 zhongyuan/yulanpen（既有已 APPROVE、未改）；若要求全文件无该词需另改两条并重审。
- delta preverify PASS；任务移桥 Codex 复审；内容行仍 NOT RUN。

## 审批后接入 Runbook 就绪（未执行）
- Runbook：`docs/R14-CONTENT-INTEGRATION-RUNBOOK.md`
- 接入脚本：`scripts/r14-content12-integrate.py`（默认 dry-run；`--apply` 备份并拒绝 draft）
- 当前门禁：Codex `outbox/` 空，xiayuan task 在 `inbox/`；**尚无 `ALL_12_APPROVED=true`**，不执行接入。
- 后续顺序：PM 将 12 条改 approved 新 SHA → QA 12/12 approved preverify → dry-run → apply → 新 followup 包 + 12 页抽检。
- 边界：hero 仍 pending-design；内容行 85-90/163/174 仍需 UI 证据，不能因接入标 PASS；矩阵不变。

## 12/12 approved preverify（c686e354）
- 与快照 63722767 比较：除 reviewStatus→approved 外 0 差异；12/12 approved、version=1；hero pending-design、unlockOffset=10。
- approved preverify PASS；Lead 可受控 apply→新 followup 包→QA 抽检 12 页。
- 内容缺口行仍 NOT RUN，接入不等于 UI/188 PASS。
