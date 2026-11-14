# B / 166-169 通知权限注入复测（904fa930）

- 包：`P1/Lixiang-R14-1.0-13-notify-904fa930-debug-simulator.tar.gz`
  - tar `fc9068b7…`；binary `b111ad1a…`；commit `904fa930`
- 设备：仅 `R14-QA-iPhone` `0B71AEF4…`；未碰 4 台锁定机。
- 脚本：`scripts/r14-qa-b-notify.sh`；证据：`qa/evidence/qa-b-notify/`。
- **全部为注入模拟，不是系统原生弹窗/设置返回证据。**

## 观察
| 状态 | 注入 | 截图 | 观察 |
|---|---|---|---|
| 请求前说明（详情） | `-LixiangNotifyPrepromptDetail` | `preprompt-detail.png` | 弹窗「开启本地通知提醒？」/「暂不开启/去开启」；未直接弹系统权限 |
| 请求前说明（列表） | `-LixiangNotifyPreprompt` + Tab3 | `preprompt-list.png` | 弹窗「开启纪念日提醒？」；同上 |
| 拒绝态 | `-LixiangNotifyDenied` | `denied.png` | banner「通知未开启；App 内提醒仍可见。」+「去设置」；但开关仍显示为开（状态不一致） |
| 允许态 | `-LixiangNotifyAuthorized` | `authorized.png` | 无 banner，本地通知提醒开关开；注入状态 |
| 设置返回 | `-LixiangNotifySettingsReturn` | `settings-return.png` | 画面与 denied 相同，未证明 inactive→active 重读 |
| 列表 preprompt | `-LixiangNotifyPreprompt` + Tab3 | `preprompt-list.png` | 同一说明弹窗 |

## 判定
- **166-169 全部保持 NOT RUN**：
  - 166 仅证明注入说明弹窗存在，未证明真实系统权限请求链路；
  - 167 系统原生弹窗未出现/未由 XCUITest 点击；
  - 168 允许态仅注入；
  - 169 denied 与 settings return 画面相同，且 denied 时开关仍为开，存在状态一致性疑点。
- 未使用注入冒充原生 PASS；四态齐 + 原生系统弹窗/设置返回证据后再评。
- 仍未标记任何矩阵行 PASS；矩阵保持 100 PASS/33 FAIL/55 NOT RUN。

## notify2 复测（fc233807）
- 包：tar `cdcb6ad3…`；binary `6b83a616…`；commit `fc233807`；仅 R14-QA-iPhone。
- denied：**修复**——详情开关关且 disabled；caption「系统通知已拒绝；开关不可开启，请去设置允许通知。」+ banner/去设置。
- settings-return：early（5s）仍是启动 loading；late（20s）开关仍关、banner 消失、显示「未开启提醒」；**未出现 expected authorized/开关可操作**。
- 结论：166-169 仍 **NOT RUN**；注入 denied 已修，但 settings-return 未证明 authorized，原生弹窗/真机设置返回仍缺。

## notify3 复测（0b3202ca）
- 包：tar `c4a1ccc4…`；binary `60945fd6…`；commit `0b3202ca`；仅 R14-QA-iPhone。
- `-LixiangNotifySettingsReturn`：
  - 8s：**仍为启动 loading**，未出现 denied 开关关+banner；
  - 18s：进入详情，开关**仍关**、显示「未开启提醒」，未出现 authorized/开关可操作；banner 也不在。
- 结论：预期 8s denied → 18s authorized 的状态迁移**未复现**；166-169 仍 **NOT RUN**。

## notify4 marker 复测（3a8b4e8b）
- 包：tar `53c77722…`；binary `7f923ec2…`；commit `3a8b4e8b`；仅 R14-QA-iPhone。
- `-LixiangNotifySettingsReturn` 轮询截图：
  - 8s：启动 loading；
  - 12s：首页（尚未进入详情）；
  - **16s 起：详情出现 marker「notify.status=authorized」**，但开关仍为**关**、caption 仍「未开启提醒」；20/25/30/35s 均同。
- 结论：marker 出现，但 UI 未迁移到「开关开可操作」的 authorized 态；banner 也未见。B 仍 **NOT RUN**，需 dev 修 marker 与 UI 状态同步。

## notify5 binding 复测（d221c56b）
- 包：tar `83be486f…`；binary `f248cabb…`；commit `d221c56b`；仅 R14-QA-iPhone。
- `-LixiangNotifySettingsReturn` 轮询（≤40s）：
  - ~12s：详情 denied，marker `notify.status=denied toggle=0`；开关关、caption「系统通知已拒绝…」、banner 在。
  - ~16s：marker **`notify.status=authorized toggle=1`**；开关开、enabled、banner 消失、caption 消失。
  - 20/25/30/35/40s 保持 authorized toggle=1。
- **缺陷关闭**：marker 与 UI 状态同步（denied→authorized 迁移）；**注入模拟**，非原生系统弹窗/真机设置返回。
- **166-169 行仍 NOT RUN**；需真机/原生系统弹窗与设置返回证据后再复评。
