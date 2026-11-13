#!/usr/bin/env bash
# Install + launch + screenshot one R14 state. No GUI, no AppleScript.
# Usage: r14-sim-qa.sh --app <Lixiang.app> --device <name-or-udid> --label <label> [--launch-args ...]
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
APP=""; DEVICE="Lixiang-iPhone17Pro"; LABEL="r14-state"; ARGS=()
while [ $# -gt 0 ]; do
  case "$1" in
    --app) APP="${2:-}"; shift 2;;
    --device) DEVICE="${2:-}"; shift 2;;
    --label) LABEL="${2:-}"; shift 2;;
    --launch-args) shift; while [ $# -gt 0 ] && [ "${1#--}" = "$1" ]; do ARGS+=("$1"); shift; done;;
    --) shift; ARGS+=("$@"); break;;
    -h|--help) sed -n '2,10p' "$0"; exit 0;;
    *) ARGS+=("$1"); shift;;
  esac
done
BUNDLE="xin.zhaoyao.lixiang"
EVID="$ROOT/qa/evidence"; mkdir -p "$EVID"
[ -n "$APP" ] || { echo "ERROR: --app required" >&2; exit 2; }
[ -d "$APP" ] || { echo "ERROR: app not found: $APP" >&2; exit 2; }
# Resolve name/UDID from available devices
python3 - "$DEVICE" >/tmp/r14-device.$$.txt <<'PY'
import json,subprocess,sys
want=sys.argv[1]
data=json.loads(subprocess.check_output(['xcrun','simctl','list','-j','devices','available']))
for runtime,devs in data.get('devices',{}).items():
    for d in devs:
        if d.get('udid')==want or d.get('name')==want:
            print(d['udid']+'\t'+d['name']+'\t'+runtime); raise SystemExit
raise SystemExit('device not found: '+want)
PY
IFS=$'\t' read -r UDID NAME RUNTIME < /tmp/r14-device.$$.txt; rm -f /tmp/r14-device.$$.txt
[ -n "$UDID" ] || { echo "ERROR: device not found" >&2; exit 2; }
echo "[r14-qa] device=$NAME udid=$UDID runtime=$RUNTIME"
xcrun simctl boot "$UDID" >/dev/null 2>&1 || true
xcrun simctl bootstatus "$UDID" -b >/dev/null 2>&1 || true
xcrun simctl terminate "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
xcrun simctl uninstall "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
xcrun simctl install "$UDID" "$APP"
xcrun simctl status_bar "$UDID" override --time "9:41" --batteryState charged --batteryLevel 100 --wifiBars 3 --cellularBars 4 >/dev/null 2>&1 || true
xcrun simctl launch --terminate-running-process "$UDID" "$BUNDLE" "${ARGS[@]}" >/dev/null 2>&1 || true
sleep "${R14_LAUNCH_WAIT:-8}"
SHOT="$EVID/${LABEL}.png"
DISPLAY_ARG=()
DISP=$(python3 - "$UDID" <<'PY2' 2>/dev/null || true
import json,subprocess,sys
out=subprocess.run(['xcrun','simctl','io',sys.argv[1],'enumerate'],capture_output=True,text=True).stdout
cur={}; ports=[]
for line in out.splitlines():
    st=line.strip()
    if st=='Port:':
        if cur.get('uuid'): ports.append(cur)
        cur={}
    elif st.startswith('UUID:'): cur['uuid']=st.split(':',1)[1].strip()
    elif st.startswith('Default width:'): cur['w']=int(st.split(':')[1])
    elif st.startswith('Default height:'): cur['h']=int(st.split(':')[1])
if cur.get('uuid'): ports.append(cur)
ports=[p for p in ports if p.get('w') and p.get('h')]
if len(ports)>1:
    best=max(ports,key=lambda p:p['w']*p['h'])
    print(best['uuid'])
PY2
)
[ -n "$DISP" ] && DISPLAY_ARG=(--display="$DISP")
xcrun simctl io "$UDID" screenshot --type=png "${DISPLAY_ARG[@]}" "$SHOT" >/dev/null 2>&1
{
  echo "label=$LABEL"; echo "device=$NAME"; echo "udid=$UDID"; echo "runtime=$RUNTIME";
  echo "app=$APP"; echo "app_binary_sha256=$(shasum -a 256 "$APP/Lixiang" 2>/dev/null | awk '{print $1}')";
  echo "screenshot=$SHOT"; echo "screenshot_sha256=$(shasum -a 256 "$SHOT" | awk '{print $1}')";
  echo "launch_args=${ARGS[*]:-}";
  echo "captured_at=$(date -Iseconds)";
} > "$EVID/${LABEL}.txt"
echo "[r14-qa] screenshot=$SHOT"
echo "[r14-qa] manifest=$EVID/${LABEL}.txt"
