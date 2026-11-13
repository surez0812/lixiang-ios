#!/usr/bin/env bash
# qa-sim.sh — iOS 模拟器 QA 标准跑法（纯 simctl + xcodebuild）
#
# 约定（交付 QA 时的契约）：
#   1. 只用 bash 执行，绝不 `open` / osascript / AppleScript / Terminal —— 不借 GUI 拿 PTY。
#   2. 每次运行 -resultBundlePath 唯一（时间戳 + pid + 随机数），不复用、不覆盖旧结果。
#   3. 默认先跑单个用例（--single，默认模式）验证环境；确认通过再 --full 跑验收子集。
#   4. 非 PASS 时保留现场：截图、设备日志、app 容器、xcodebuild 日志、xcresult 路径、设备/运行时清单，
#      不清理 DerivedData、不 shutdown 模拟器。
#   5. 若 xcodebuild 报 "Pseudo Terminal Setup Error"（会话被沙箱限制、拿不到伪终端）：
#      如实标 NOTRUN（退出码 3），不重试、不换姿势绕过、不伪报 PASS/FAIL。
#   6. 只碰名字以 Qin- 开头的模拟器（团队约定），绝不 `simctl shutdown all`。
#
# 用法（在任意目录，bash 执行）：
#   bash qa-sim.sh --repo <guqin-tuner> --label pr35 --device Qin-PR33-390
#   bash qa-sim.sh --repo <guqin-tuner> --label pr35-full --full
#   bash qa-sim.sh --repo <guqin-tuner> --label pr35-single --only QinTunerTests/OrientationPolicyTests/testDuoRotates
#   bash qa-sim.sh --repo <guqin-tuner> --dry-run        # 只打印将执行的命令，不 boot、不跑
#
# 退出码：0=PASS 1=FAIL 2=用法/前置错误 3=NOTRUN(环境被沙箱限制) 4=已有运行占用
#
# 结果位置：<repo>/.qa/  （该目录在 .gitignore 里；日志/结果/证据都在这）
#   xcresult : .qa/qa-<label>-<RUN_ID>.xcresult
#   log      : .qa/qa-<label>-<RUN_ID>.log
#   证据     : .qa/qa-<label>-<RUN_ID>.evidence/   （仅非 PASS）
#   摘要     : .qa/qa-<label>-<RUN_ID>.summary.txt （status=/reason=/counts= 等；stdout 末行 RESULT: 为机器可读状态）

set -uo pipefail

die()   { printf 'ERROR: %s\n' "$*" >&2; exit 2; }
note()  { printf '%s\n' "$*"; }
warn()  { printf 'WARN: %s\n' "$*" >&2; }

QIN_PREFIX="Qin-"
REPO=""
LABEL="qa"
DEVICE=""
RUNTIME="18.6"          # 默认 18.6：规避 Xcode 27.2 解析 iOS 27.2 runtime 版本号的 invalidDigitCount bug
MODE="single"           # single | full | all
ONLY=()                 # 额外的 -only-testing 条目（可重复 --only）
TIMEOUT=""
DRY_RUN=0
BUNDLE_ID=""

SINGLE_CASE="QinTunerTests/CompactBreakpointTests/testUITestBreakpointsMatchTunerMetrics"
FULL_TARGETS=(
  "QinTunerTests/CompactBreakpointTests"
  "QinTunerTests/OrientationPolicyTests"
  "QinTunerUITests/TunerBottomGapUITests"
)

usage() {
  cat <<'EOF'
用法: bash qa-sim.sh [选项]

  --repo DIR           guqin-tuner 仓库根（默认从当前目录向上找 QinTuner.xcodeproj）
  --label TAG         结果/日志前缀，默认 qa（建议 pr35 / pr35-retry1）
  --device NAME|UDID  指定模拟器（名字必须 Qin- 开头），默认自动挑 iOS 18.6 的 Qin- 模拟器
  --runtime VER       自动挑设备时的运行时过滤，默认 18.6
  --single            只跑默认单个用例（默认模式）
  --full              跑验收子集：CompactBreakpointTests + OrientationPolicyTests + TunerBottomGapUITests
  --all               不传 -only-testing，跑整个 scheme（慢，仅必要时）
  --only TARGET/CLASS[/METHOD]   额外 -only-testing，可重复
  --timeout SEC       墙钟超时（默认：single=900，full=2700，all=3600）
  --bundle-id ID      app bundle id，默认从 Config/Base.xcconfig 读 QIN_BUNDLE_ID
  --dry-run           只做前置检查并打印命令，不 boot、不跑测试
  -h, --help          显示本帮助

环境限制：本脚本在沙箱会话里若拿不到伪终端会直接标 NOTRUN，不会绕过。
EOF
}

# ---------- 参数 ----------
while [ $# -gt 0 ]; do
  case "$1" in
    --repo)     REPO="${2:?--repo 需要目录}"; shift 2 ;;
    --label)    LABEL="${2:?--label 需要值}"; shift 2 ;;
    --device)   DEVICE="${2:?--device 需要值}"; shift 2 ;;
    --runtime)  RUNTIME="${2:?--runtime 需要值}"; shift 2 ;;
    --single)   MODE="single"; shift ;;
    --full)     MODE="full"; shift ;;
    --all)      MODE="all"; shift ;;
    --only)     ONLY+=("${2:?--only 需要 TARGET/CLASS[/METHOD]}"); shift 2 ;;
    --timeout)  TIMEOUT="${2:?--timeout 需要秒数}"; shift 2 ;;
    --bundle-id) BUNDLE_ID="${2:?--bundle-id 需要值}"; shift 2 ;;
    --dry-run)  DRY_RUN=1; shift ;;
    -h|--help)  usage; exit 0 ;;
    *) die "未知参数: $1（--help 看用法）" ;;
  esac
done

case "$MODE" in
  single) [ -n "$TIMEOUT" ] || TIMEOUT=900 ;;
  full)   [ -n "$TIMEOUT" ] || TIMEOUT=2700 ;;
  all)    [ -n "$TIMEOUT" ] || TIMEOUT=3600 ;;
esac

# ---------- 前置：仓库 / 工具 ----------
find_repo() {
  local d="$PWD"
  while :; do
    [ -d "$d/QinTuner.xcodeproj" ] && { echo "$d"; return 0; }
    [ "$d" = "/" ] && return 1
    d="$(dirname "$d")"
  done
}

if [ -z "$REPO" ]; then
  REPO="$(find_repo)" || die "找不到 QinTuner.xcodeproj；请用 --repo 指定 guqin-tuner 仓库根"
fi
[ -d "$REPO/QinTuner.xcodeproj" ] || die "--repo 下没有 QinTuner.xcodeproj: $REPO"

XC="$(command -v xcodebuild)" || die "找不到 xcodebuild"
command -v xcrun >/dev/null 2>&1 || die "找不到 xcrun"
[ -x /usr/bin/python3 ] || die "找不到 /usr/bin/python3"

OUT="$REPO/.qa"
mkdir -p "$OUT" 2>/dev/null || die "无法创建输出目录: ${OUT}（检查沙箱写权限）"

# ---------- 模拟器选择与护栏 ----------
sim_json() { xcrun simctl list devices -j; }

sim_name_of() {  # sim_name_of <json> <udid>
  printf '%s' "$1" | /usr/bin/python3 -c '
import json,sys
u=sys.argv[1]
for devs in json.load(sys.stdin)["devices"].values():
    for d in devs:
        if d["udid"]==u:
            print(d["name"]); sys.exit(0)
sys.exit(1)
' "$2"
}

runtime_of() {  # runtime_of <json> <udid> → 例如 iOS-18-6
  printf '%s' "$1" | /usr/bin/python3 -c '
import json,sys
u=sys.argv[1]
for rt,devs in json.load(sys.stdin)["devices"].items():
    for d in devs:
        if d["udid"]==u:
            print(rt.rsplit(".",1)[-1]); sys.exit(0)
sys.exit(1)
' "$2"
}

pick_udid() {
  printf '%s' "$1" | /usr/bin/python3 -c '
import json,sys
prefix,want=sys.argv[1],sys.argv[2]
want=want.replace(".","-")
devs=json.load(sys.stdin)["devices"]
c=[]
for rt,l in devs.items():
    if "iOS" not in rt: continue
    if want and want not in rt: continue
    for d in l:
        n=d.get("name","")
        if n.startswith(prefix) and d.get("isAvailable",True):
            # 优先未 Booted 的，避免踩正在跑矩阵的设备
            c.append((1 if d.get("state")=="Booted" else 0, rt, n, d["udid"]))
c.sort(key=lambda x:(x[0],x[1],x[2]))
if c: print(c[0][3])
' "$QIN_PREFIX" "$RUNTIME"
}

JSON="$(sim_json)" || die "simctl list 失败"
UDID=""
if [ -n "$DEVICE" ]; then
  if [[ "$DEVICE" =~ ^[0-9A-Fa-f-]{36}$ ]]; then
    UDID="$DEVICE"
    NAME="$(sim_name_of "$JSON" "$UDID")" || die "找不到模拟器 UDID: $UDID"
  else
    UDID="$(printf '%s' "$JSON" | /usr/bin/python3 -c '
import json,sys
name=sys.argv[1]
for devs in json.load(sys.stdin)["devices"].values():
    for d in devs:
        if d.get("name")==name and d.get("isAvailable",True):
            print(d["udid"]); sys.exit(0)
sys.exit(1)
' "$DEVICE")" || die "找不到名为 $DEVICE 的可用模拟器"
    NAME="$DEVICE"
  fi
else
  UDID="$(pick_udid "$JSON")" || true
  [ -n "$UDID" ] || die "没有可用的 $QIN_PREFIX* 模拟器（runtime ${RUNTIME}）；用 --device 指定"
  NAME="$(sim_name_of "$JSON" "$UDID")"
  warn "未指定 --device，自动选择 $NAME ($UDID)；并发跑矩阵时请显式 --device"
fi

# 团队护栏：只碰 Qin- 模拟器
case "$NAME" in
  "$QIN_PREFIX"*) : ;;
  *) die "拒绝操作非 Qin- 模拟器：$NAME ($UDID)。本脚本只碰 $QIN_PREFIX* 设备" ;;
esac
SIRUNTIME="$(runtime_of "$JSON" "$UDID" || echo unknown)"

# ---------- 运行标识 / 路径（唯一命名） ----------
RUN_ID="$(date -u +%Y%m%dT%H%M%SZ)-$$-$RANDOM"
BASE="$OUT/qa-$LABEL-$RUN_ID"
RESULT="$BASE.xcresult"
LOG="$BASE.log"
EVID="$BASE.evidence"
DD="$OUT/DerivedData-qa-$LABEL"
LOCK="$OUT/.lock-qa-sim"

[ -e "$RESULT" ] && die "结果路径已存在（不应发生）: $RESULT"

# ---------- bundle id ----------
if [ -z "$BUNDLE_ID" ]; then
  BUNDLE_ID="$(sed -n 's/^[[:space:]]*QIN_BUNDLE_ID[[:space:]]*=[[:space:]]*//p' "$REPO/Config/Base.xcconfig" 2>/dev/null | head -1 | tr -d '[:space:]')"
  [ -n "$BUNDLE_ID" ] || BUNDLE_ID="xin.zhaoyao.qintuner"
fi

# ---------- 组装 xcodebuild 命令 ----------
XC_ARGS=(
  "$XC" -project QinTuner.xcodeproj -scheme QinTuner -configuration Debug
  -destination "platform=iOS Simulator,id=$UDID"
  -derivedDataPath "$DD"
  -resultBundlePath "$RESULT"
  -collect-test-diagnostics never
  CODE_SIGNING_ALLOWED=NO
)
case "$MODE" in
  single) [ ${#ONLY[@]} -gt 0 ] || XC_ARGS+=(-only-testing "$SINGLE_CASE") ;;
  full)   for t in "${FULL_TARGETS[@]}"; do XC_ARGS+=(-only-testing "$t"); done ;;
  all)    : ;;
esac
if [ ${#ONLY[@]} -gt 0 ]; then
  for t in "${ONLY[@]}"; do XC_ARGS+=(-only-testing "$t"); done
fi
XC_ARGS+=(test)

XCODE_VER="$(xcodebuild -version 2>/dev/null | tr '\n' ' ' | sed 's/ *$//')"
MACOS_VER="$(sw_vers -productVersion 2>/dev/null || echo unknown)"

# ---------- dry-run：只打印，不 boot、不跑 ----------
if [ "$DRY_RUN" = 1 ]; then
  note "DRY-RUN（未 boot、未启动测试）"
  note "  repo      : $REPO"
  note "  device    : $NAME ($UDID)"
  note "  runtime   : $SIRUNTIME"
  note "  mode      : $MODE"
  note "  label     : $LABEL"
  note "  bundle id : $BUNDLE_ID"
  note "  xcresult  : $RESULT"
  note "  log       : $LOG"
  note "  evidence  : $EVID (非 PASS 时)"
  note "  timeout   : ${TIMEOUT}s"
  note "  command   : ${XC_ARGS[*]}"
  exit 0
fi

# ---------- 并发锁：一次只允许一个 runner ----------
if [ -d "$LOCK" ]; then
  LOCK_PID="$(cat "$LOCK/pid" 2>/dev/null || echo '')"
  if [ -n "$LOCK_PID" ] && kill -0 "$LOCK_PID" 2>/dev/null; then
    printf 'ERROR: 已有 QA runner 在跑（pid %s，%s）。等它结束再来；不要并发跑。\n' "$LOCK_PID" "$LOCK" >&2
    exit 4
  fi
  warn "清理陈旧锁: $LOCK"
  rm -rf "$LOCK"
fi
mkdir "$LOCK" 2>/dev/null || { printf 'ERROR: 无法创建锁目录 %s\n' "$LOCK" >&2; exit 4; }
printf '%s\n' "$$" > "$LOCK/pid"
printf '%s\n' "$RUN_ID" > "$LOCK/run-id"
cleanup() { rm -rf "$LOCK"; rm -f "$OUT/.timeout-$RUN_ID"; }
trap cleanup EXIT INT TERM HUP

START_TS="$(date '+%Y-%m-%d %H:%M:%S %z')"
START_EPOCH="$(date +%s)"
QIN_SHA="$(/usr/bin/git -C "$REPO" rev-parse HEAD 2>/dev/null || echo unknown)"
QIN_DIRTY="$(/usr/bin/git -C "$REPO" status --porcelain --untracked-files=all 2>/dev/null | grep -v 'DerivedData' | wc -l | tr -d ' ')"

{
  printf '# qa-sim run: label=%s run_id=%s mode=%s\n' "$LABEL" "$RUN_ID" "$MODE"
  printf '# tested_sha=%s dirty_files=%s\n' "$QIN_SHA" "$QIN_DIRTY"
  printf '# host: macOS %s / %s\n' "$MACOS_VER" "$XCODE_VER"
  printf '# device: %s (%s) runtime=%s\n' "$NAME" "$UDID" "$SIRUNTIME"
  printf '# xcresult: %s\n' "$RESULT"
  printf '# started: %s\n' "$START_TS"
  printf '# ----------------------------------------------------------------\n'
} > "$LOG"

# ---------- boot（纯 simctl） ----------
note "==> 设备 $NAME ($UDID, $SIRUNTIME)"
BOOT_OUT="$(xcrun simctl bootstatus "$UDID" -b 2>&1)"
BOOT_RC=$?
printf '%s\n' "$BOOT_OUT" >> "$LOG"
if [ $BOOT_RC -ne 0 ]; then
  if printf '%s' "$BOOT_OUT" | grep -qiE "not permitted|operation not permitted|denied|sandbox"; then
    printf 'RESULT: NOTRUN device_boot (%s) — 不绕过，如实记录\n' "$NAME"
    exit 3
  fi
  die "模拟器启动失败（simctl bootstatus rc=${BOOT_RC}）：$(printf '%s' "$BOOT_OUT" | tail -3 | tr '\n' ' ')"
fi

# ---------- 跑测试（带墙钟超时） ----------
note "==> 模式 ${MODE}，超时 ${TIMEOUT}s"
note "    xcresult: $RESULT"
note "    log     : $LOG  （另开终端可 tail -f）"
note "    （不使用 open / osascript / Terminal）"

cd "$REPO" || die "cd $REPO 失败"
"${XC_ARGS[@]}" >> "$LOG" 2>&1 &
XCPID=$!

TIMED_OUT=0
if [ "$TIMEOUT" -gt 0 ]; then
(
  END=$(( $(date +%s) + TIMEOUT ))
  while kill -0 "$XCPID" 2>/dev/null && [ "$(date +%s)" -lt "$END" ]; do sleep 2; done
  if kill -0 "$XCPID" 2>/dev/null; then
    : > "$OUT/.timeout-$RUN_ID"
    kill -TERM "$XCPID" 2>/dev/null
    sleep 5
    kill -KILL "$XCPID" 2>/dev/null
  fi
) &
WD_PID=$!
fi

wait "$XCPID"
RC=$?
[ -n "${WD_PID:-}" ] && { kill "$WD_PID" 2>/dev/null; wait "$WD_PID" 2>/dev/null; }
[ -f "$OUT/.timeout-$RUN_ID" ] && TIMED_OUT=1

END_TS="$(date '+%Y-%m-%d %H:%M:%S %z')"
DUR=$(( $(date +%s) - START_EPOCH ))

# ---------- 分类：PASS / FAIL / NOTRUN ----------
STATUS="PASS"; EXIT_CODE=0; REASON=""
if [ $RC -ne 0 ]; then
  STATUS="FAIL"; EXIT_CODE=1
  [ "$TIMED_OUT" = 1 ] && { EXIT_CODE=124; REASON="timeout after ${TIMEOUT}s (SIGTERM sent)"; }
fi
printf '# finished: %s duration=%ss xcodebuild_rc=%s\n' "$END_TS" "$DUR" "$RC" >> "$LOG"

PSEUDO=0
if grep -qiE "Pseudo Terminal Setup Error|pseudo[- ]terminal" "$LOG" 2>/dev/null; then
  PSEUDO=1
fi
if [ "$PSEUDO" = 1 ] && [ "$TIMED_OUT" = 0 ]; then
  STATUS="NOTRUN"; EXIT_CODE=3
  REASON="Pseudo Terminal Setup Error — 当前会话被沙箱限制，拿不到伪终端；不绕过、不伪报"
fi
if [ "$PSEUDO" = 1 ] && [ "$TIMED_OUT" = 1 ]; then
  REASON="timeout after ${TIMEOUT}s；日志中同时有 Pseudo Terminal 迹象（可能被沙箱卡住）"
fi
if [ "$STATUS" = "FAIL" ] && [ -z "$REASON" ]; then
  REASON="$(grep -E '(^| )error:|\*\* TEST (FAILED|INTERRUPTED)' "$LOG" 2>/dev/null | tail -1 | cut -c1-300)"
fi

# 其他沙箱迹象：只写进证据，不改分类（除非伪终端）
SANDBOX_HINT=0
grep -qiE "not allowed to open documents in Terminal|Operation not permitted|LSOpenURLsWithRole|kLSNotPermittedErr" "$LOG" 2>/dev/null && SANDBOX_HINT=1

# ---------- 摘要 ----------
SUMM="$BASE.summary.txt"
{
  printf 'label=%s\n' "$LABEL"
  printf 'run_id=%s\n' "$RUN_ID"
  printf 'status=%s\n' "$STATUS"
  printf 'exit=%s\n' "$EXIT_CODE"
  printf 'reason=%s\n' "$REASON"
  printf 'mode=%s\n' "$MODE"
  printf 'tested_sha=%s\n' "$QIN_SHA"
  printf 'dirty_files=%s\n' "$QIN_DIRTY"
  printf 'device=%s\n' "$NAME"
  printf 'udid=%s\n' "$UDID"
  printf 'runtime=%s\n' "$SIRUNTIME"
  printf 'host=macOS %s / %s\n' "$MACOS_VER" "$XCODE_VER"
  printf 'started=%s\n' "$START_TS"
  printf 'finished=%s\n' "$END_TS"
  printf 'duration_s=%s\n' "$DUR"
  printf 'xcodebuild_rc=%s\n' "$RC"
  printf 'pseudo_terminal=%s\n' "$PSEUDO"
  printf 'sandbox_hint=%s\n' "$SANDBOX_HINT"
  printf 'xcresult=%s\n' "$RESULT"
  printf 'log=%s\n' "$LOG"
} > "$SUMM"

if [ -e "$RESULT" ]; then
  xcrun xcresulttool get test-results summary --path "$RESULT" > "$BASE.summary.json" 2>/dev/null || true
  if [ -s "$BASE.summary.json" ]; then
    RUN_COUNTS="$(/usr/bin/python3 - "$BASE.summary.json" <<'PY' 2>/dev/null || true
import json,sys
try: s=json.load(open(sys.argv[1]))
except Exception: sys.exit(0)
print(f"{s.get('passedTests',0)} pass / {s.get('skippedTests',0)} skipped / {s.get('failedTests',0)} fail"
      f"  (total {s.get('totalTestCount')}, result {s.get('result')})")
PY
)"
    [ -n "$RUN_COUNTS" ] && printf 'counts=%s\n' "$RUN_COUNTS" >> "$SUMM"
  fi
fi

# ---------- 失败/未跑：保留现场 ----------
if [ "$STATUS" != "PASS" ]; then
  mkdir -p "$EVID"
  cp -p "$LOG" "$EVID/xcodebuild.log" 2>/dev/null || true
  cp -p "$SUMM" "$EVID/RUN-STATUS.txt" 2>/dev/null || true
  [ -e "$RESULT" ] && printf '%s\n' "$RESULT" > "$EVID/xcresult-path.txt"
  [ -s "$BASE.summary.json" ] && cp -p "$BASE.summary.json" "$EVID/summary.json" 2>/dev/null || true
  printf '%s\n' "$JSON" > "$EVID/simctl-devices.json"
  xcrun simctl list runtimes > "$EVID/simctl-runtimes.txt" 2>&1 || true
  xcrun simctl list devices > "$EVID/simctl-devices.txt" 2>&1 || true

  # 截图：失败现场（booted 时可用，不需要 Simulator.app UI）
  xcrun simctl io "$UDID" screenshot "$EVID/screenshot-fail.png" >/dev/null 2>&1 \
    || warn "截图失败（设备可能未 booted）：$EVID/screenshot-fail.png"

  # 设备日志最后 3 分钟
  xcrun simctl spawn "$UDID" log show --last 3m --style compact > "$EVID/device-log-3m.raw" 2>/dev/null || true
  [ -f "$EVID/device-log-3m.raw" ] && tail -n 20000 "$EVID/device-log-3m.raw" > "$EVID/device-log-3m.log" && rm -f "$EVID/device-log-3m.raw"

  # app 数据容器（含沙盒内日志/db，便于查现场）
  if CONT="$(xcrun simctl get_app_container "$UDID" "$BUNDLE_ID" data 2>/dev/null)" && [ -d "$CONT" ]; then
    /usr/bin/ditto "$CONT" "$EVID/app-data" 2>/dev/null || warn "复制 app 容器失败: $CONT"
  fi

  # 测试结果明细
  if [ -e "$RESULT" ]; then
    xcrun xcresulttool get test-results tests --path "$RESULT" > "$EVID/xcresult-tests.json" 2>/dev/null || true
  fi

  {
    printf 'status=%s exit=%s rc=%s\n' "$STATUS" "$EXIT_CODE" "$RC"
    printf 'reason=%s\n' "$REASON"
    printf 'pseudo_terminal=%s sandbox_hint=%s timeout=%s\n' "$PSEUDO" "$SANDBOX_HINT" "$TIMED_OUT"
    printf 'device=%s udid=%s runtime=%s\n' "$NAME" "$UDID" "$SIRUNTIME"
    printf '--- files ---\n'
    ls -la "$EVID"
  } > "$EVID/MANIFEST.txt"
  warn "已保留现场: $EVID"
fi

# ---------- 收尾输出 ----------
note ""
note "RESULT: $STATUS  ${REASON}"
note "   device   : $NAME ($UDID) / $SIRUNTIME"
[ -n "${RUN_COUNTS:-}" ] && note "   counts   : $RUN_COUNTS"
note "   xcresult : $RESULT"
note "   log      : $LOG"
[ "$STATUS" != "PASS" ] && note "   evidence : $EVID"
note "   duration : ${DUR}s"
exit "$EXIT_CODE"
