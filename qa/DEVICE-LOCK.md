# 设备锁定通知（Codex 复测中）

时间：2026-11-14 00:17（Asia/Shanghai）

以下设备自即日起为 Codex 专属，QA/脚本**不得 launch/rotate/stop/reinstall/erase/install**，直到 Lead 通知解锁：
- R14-Duo `B77A1A25-079D-4A2B-89D0-0642963F70AB`
- iPhone 16 Pro `0975B8A6-A868-424A-BDA7-EC40F97D823B`
- iPhone 13 mini `94207526-8B38-427D-AF65-DCD899C3F8C1`
- iPad Pro 13 `91DA70AC-C500-40CF-A339-30B5CD3177A8`

- QA 现有截图/证据不受影响；需补拍请等解锁或改用其他设备。
- Codex 复测包：tar `2314dd8e…` / binary `1d2661de…`，1.0(13)。
- **旧归档** `690a26b6…`（binary `2f24610a…`）与 **新复测包** 结果必须分开记录，不得混写 PASS/FAIL。
- 本轮未对上述设备执行任何操作。

## 设备完整性校验更新（2026-11-14）
- Codex 发现污染：
  - `94207526`（iPhone 13 mini）与 `91DA70AC`（iPad Pro 13）的 Lixiang 二进制 / debug dylib / Info.plist 相对冻结包 `2314dd8e` 已改变；**其初始截图被排除**。
  - `0975B8A6`（iPhone 16 Pro）与 R14-Duo 仍匹配冻结包。
- dev 已另建专用构建模拟器：`R14-Build-iPhone`、`R14-Build-iPad`。
- QA 继续**不触碰**上述 4 台锁定设备；待 Codex 重装冻结包后再继续。
- 此前 QA 截图按 Lead 指示保留；不用于证明 Codex 冻结包完整性。

## R14-QA-iPhone 临时移交 Codex（2026-11-14 08:xx）
- `0B71AEF4-1E34-47A3-937A-3A097A0D0362` 已交 Codex 执行 0810 Daily 导出验证（覆盖安装、不擦数据）。
- QA 暂停对该机 install/launch；无进行中的设备任务。释放后按 Lead 通知恢复。

## 释放（2026-11-14）
- Codex 0810 Daily 导出验证完成，`0B71AEF4` 已释放；QA 恢复使用前确认无其他 Codex 进程。
