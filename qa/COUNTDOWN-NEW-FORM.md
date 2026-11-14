# Countdown 新建/校验（行165）

- **PASS**：
  - `r14-countdown-new-form-empty.png`（`01872ae6…`）：新增倒计日表单，名称空时「保存」灰色禁用，「取消」可用。
  - `r14-countdown-new-form-filled.png`（`d2eaf443…`）：输入名称后「保存」红色可用。
- 覆盖：新建入口 + 名称必填校验 + 保存可用性切换。
- 同一入口的权限弹窗/系统权限/允许/拒绝返回（行166-169）仍 **NOT RUN**。
- 证据：`qa/evidence/countdown-new-form/`。
