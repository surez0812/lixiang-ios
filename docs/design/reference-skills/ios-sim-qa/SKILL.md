---
name: ios-sim-qa
description: 在 macOS iOS 模拟器上跑 QinTuner QA：用 xcrun simctl + xcodebuild（纯 bash，禁止 open/Terminal/AppleScript）。要单用例优先、唯一 xcresult、失败留现场、沙箱/伪终端限制如实标 NOTRUN 时加载。
whenToUse: 当需要验证 iOS 工程（默认 QinTuner）在模拟器上的单测/UI 测试、复跑 PR 验收，或排查“沙箱会话里 xcodebuild / 模拟器跑不了”时。
---

# iOS 模拟器 QA

本 skill 只负责“怎么跑、怎么判、怎么留证据”。工具就是 `xcrun simctl` + `xcodebuild`，不借 GUI、不借终端。

## 必须遵守

1. 只操作名字 `Qin-` 开头的模拟器；绝不 `simctl shutdown all`。
2. 只用 bash 执行；禁止 `open xx.command`、osascript、AppleScript、Terminal。不要用“打开 .command 借 Terminal 拿 PTY”的野路子——macOS 沙箱会拦，并弹 `"xxx" can't be opened because Sandbox is not allowed to open documents in Terminal`。
3. 每次 `-resultBundlePath` 唯一；复跑换 `--label`，不覆盖旧结果。
4. 先 `--single` 单用例确认环境，再 `--full` 跑验收子集；不要一上来全量。
5. 失败或 NOTRUN 都要保留现场（截图、设备日志、app 容器、xcodebuild 日志、xcresult、设备/运行时清单）；不清理 DerivedData、不 shutdown 设备。
6. xcodebuild 报 `Pseudo Terminal Setup Error`（或日志出现 pseudo-terminal）→ 标 **NOTRUN**，不重试、不换姿势绕过、不伪报 PASS/FAIL。

## 脚本

`scripts/qa-sim.sh`（相对本 skill 目录；源文件 `team/runbooks/qa-sim.sh`，改动时两处同步）。

```bash
# 0) 只检查：打印将执行的命令，不 boot、不跑
bash scripts/qa-sim.sh --repo <guqin-tuner> --dry-run

# 1) 单用例（默认模式）
bash scripts/qa-sim.sh --repo <guqin-tuner> --label pr35 --device Qin-PR33-390

# 2) 单用例通过后跑验收子集
bash scripts/qa-sim.sh --repo <guqin-tuner> --label pr35-full --device Qin-PR33-390 --full

# 3) 复跑：换新 label
bash scripts/qa-sim.sh --repo <guqin-tuner> --label pr35-retry1 --device Qin-PR33-390 --full

# 4) 指定单个用例
bash scripts/qa-sim.sh --repo <guqin-tuner> --label pr35-single --device Qin-PR33-SE3 \
  --only QinTunerTests/OrientationPolicyTests/testDuoRotates
```

`--repo` 不传时从当前目录向上找 `QinTuner.xcodeproj`；`--device` 可传名字或 UDID（名字必须 `Qin-` 开头），不传则自动挑 iOS 18.6 的 `Qin-*`，优先未 booted 的设备。

## 判定

| 退出码 | 含义 |
|---|---|
| 0 | PASS（必须 exit 0 + summary 计数） |
| 1 | FAIL（测试失败 / xcodebuild 失败 / 超时 124） |
| 2 | 用法或前置错误（缺工具、repo 不对、非 Qin- 设备） |
| 3 | **NOTRUN**：会话环境被沙箱限制，不绕过 |
| 4 | 已有 runner 占用（锁），等它结束 |

- 只有 `Pseudo Terminal Setup Error` / boot 阶段 `simctl` 被拒（permission/sandbox）才是 NOTRUN；普通测试失败照实标 FAIL。
- 不要只凭日志里出现 `** TEST FAILED` 或部分输出判 PASS/FAIL，以退出码和 `.summary.txt` 的计数为准。

## 输出

都在 `<repo>/.qa/`（已 gitignore）：

- `qa-<label>-<RUN_ID>.xcresult` 唯一结果包
- `qa-<label>-<RUN_ID>.log` 首行起为 `tested_sha` / `dirty_files` / 设备 / 运行时
- `qa-<label>-<RUN_ID>.summary.txt` 可直接贴交付说明（`status=` `counts=` `reason=`）
- `qa-<label>-<RUN_ID>.evidence/` 仅非 PASS：`screenshot-fail.png`、`device-log-3m.log`、`app-data/`、`xcodebuild.log`、`xcresult-tests.json`、`MANIFEST.txt`

交付时贴：`RESULT` 行、设备/运行时、`tested_sha`/`dirty_files`、`counts`、`xcresult` 路径；非 PASS 再贴 evidence 路径与 `reason`。

## 已知坑

- Xcode 27.2 解析 iOS 27.2 runtime 版本号报 `invalidDigitCount(91016)`；默认 `--runtime 18.6` 规避，要 27.2 显式 `--device Qin-PR33-Duo` 或 `--runtime 27.2`。
- `EXIT=143` 一般是墙钟超时被杀，不是测试失败；先 `--only` 单用例定位，再考虑调大 `--timeout`。
- 沙箱会话里证据一律落 `<repo>/.qa`，不要往 `/tmp` 或仓库外写。
- 并发：脚本自带锁，只防脚本自己；确认没有别的矩阵在跑同一设备。
- 更细的团队跑法、交接清单见 `references/qa-runbook.md`。
