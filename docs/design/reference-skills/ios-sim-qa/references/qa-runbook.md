# QA 跑法：iOS 模拟器（纯 simctl + xcodebuild）

> 脚本：`team/runbooks/qa-sim.sh`（bash，可执行；自包含，不依赖仓库内 `_common.sh`）
> 适用：guqin-tuner 的 PR QA / 复测 / 回归。矩阵脚本（`pr35-qa.sh`）照旧，本脚本是 QA 的标准单次跑法与重试入口。
> 状态：2026-11-09 起草，**尚未跑过真实 runner**（当时 390/18.6 矩阵在跑，按要求没有启动第三条 runner）；只做了 `bash -n` 与 `--dry-run` 校验。

## 1. 契约（先看这个）

1. **bash 执行，绝不 `open` / osascript / AppleScript / Terminal**。拿 PTY 不靠借 GUI。
2. **`-resultBundlePath` 每次唯一**：`.qa/qa-<label>-<UTC 时间戳>-<pid>-<随机数>.xcresult`。
3. **先单用例再全量**：默认 `--single`（1 个 unit case）；通过后再 `--full`。
4. **失败保留现场**：截图、设备日志、app 容器、xcodebuild 日志、xcresult、设备/运行时清单，全部进 `.evidence/`；不清理 DerivedData、不 shutdown 模拟器。
5. **沙箱限制如实标 NOTRUN**：xcodebuild 报 `Pseudo Terminal Setup Error` → 退出码 3 / `status=NOTRUN`，不重试、不换姿势绕过、不伪报 PASS/FAIL。
6. 只碰 `Qin-` 开头的模拟器；不 `simctl shutdown all`；一次只允许一个 runner（内置锁）。

## 2. 标准命令

```bash
# 0) 只检查：打印将执行的 xcodebuild 命令，不 boot、不跑
bash team/runbooks/qa-sim.sh --repo work/guqin-tuner --dry-run

# 1) 先单用例（默认模式；默认用例 CompactBreakpointTests/testUITestBreakpointsMatchTunerMetrics）
bash team/runbooks/qa-sim.sh --repo work/guqin-tuner --label pr35 --device Qin-PR33-390

# 2) 单用例通过后跑验收子集（CompactBreakpointTests + OrientationPolicyTests + TunerBottomGapUITests）
bash team/runbooks/qa-sim.sh --repo work/guqin-tuner --label pr35-full --device Qin-PR33-390 --full

# 3) 重试：换新 label（旧 xcresult/证据不会被覆盖）
bash team/runbooks/qa-sim.sh --repo work/guqin-tuner --label pr35-retry1 --device Qin-PR33-390 --full

# 4) 指定单个用例
bash team/runbooks/qa-sim.sh --repo work/guqin-tuner --label pr35-single --device Qin-PR33-SE3 \
  --only QinTunerTests/OrientationPolicyTests/testDuoRotates
```

- `--device` 可传名字或 UDID（名字必须 `Qin-` 开头）；不传则自动挑 **iOS 18.6** 的 `Qin-*`，优先未 booted 的，避免踩正在跑矩阵的设备。
- `--timeout` 默认 single=900s / full=2700s / all=3600s；超时按 FAIL(124) 记，并留现场。
- `--all` 跑整个 scheme（慢，仅必要）。

## 3. 输出（都在 `<repo>/.qa/`，已 gitignore）

| 文件 | 内容 |
|---|---|
| `qa-<label>-<RUN_ID>.xcresult` | xcodebuild 结果包（唯一） |
| `qa-<label>-<RUN_ID>.log` | 第一行起就是 `tested_sha` / `dirty_files` / 设备 / 运行时 / 时间 |
| `qa-<label>-<RUN_ID>.summary.txt` | `status=` `exit=` `reason=` `counts=` 等，可直接贴进交付说明 |
| `qa-<label>-<RUN_ID>.summary.json` | xcresulttool summary（有结果时） |
| `qa-<label>-<RUN_ID>.evidence/` | **仅非 PASS**：`screenshot-fail.png`、`device-log-3m.log`、`app-data/`、`xcodebuild.log`、`xcresult-tests.json`、`simctl-*`、`MANIFEST.txt` |

stdout 末行固定为机器可读的 `RESULT: PASS|FAIL|NOTRUN ...`。

## 4. 退出码

| 码 | 含义 |
|---|---|
| 0 | PASS |
| 1 | FAIL（测试失败 / 超时 124 / xcodebuild 失败） |
| 2 | 用法或前置错误（缺 xcodebuild、repo 不对、非 Qin- 设备等） |
| 3 | **NOTRUN**：会话环境被沙箱限制（伪终端 / 模拟器不可达），不绕过 |
| 4 | 已有 runner 占用（锁），等它结束 |

## 5. 为什么默认 18.6

Xcode 27.2 解析 iOS 27.2 runtime 版本号会报 `IDESchemeActionDeviceRecord: versionAndBuild = 27.2 (24B91016s), error = invalidDigitCount(91016)`。矩阵里 390 / SE3 都跑在 iOS 18.6 上可规避，所以自动选设备默认 `--runtime 18.6`；要 27.2 显式传（例如 `--device Qin-PR33-Duo` 或 `--runtime 27.2`）。

## 6. QA 交接清单

跑前：
- [ ] `--dry-run` 看一眼 device / runtime / 命令（不 boot）
- [ ] 确认没有别的矩阵在跑同一设备（脚本锁只防脚本自己）
- [ ] 新 label（复测不要复用旧 label）

跑后（把这几项贴回交付说明）：
- [ ] `RESULT:` 行 + `.summary.txt` 的 `counts=`
- [ ] `tested_sha` / `dirty_files`
- [ ] `qa-*.xcresult` 路径
- [ ] 非 PASS：`.evidence/` 路径 + `reason`

## 7. 已知边界

- 沙箱会话里 `simctl bootstatus` 或 `xcodebuild` 被拒 → 脚本标 **NOTRUN**（boot 阶段）或按伪终端规则标 NOTRUN，不会重试。
- 本脚本自包含；等矩阵结束后若想并入仓库，直接 `cp team/runbooks/qa-sim.sh work/guqin-tuner/scripts/mac/qa-sim.sh` 即可，与 `scripts/mac/test.sh` 同一套 `.qa/` 约定。
- `dirty_files` 已排除 `DerivedData*`（矩阵的 `DerivedData-pr35-qa/` 未 ignore，否则会虚高到四位数）。
