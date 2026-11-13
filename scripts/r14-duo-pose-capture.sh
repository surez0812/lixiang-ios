#!/usr/bin/env bash
# 在 Codex Device Hub 已把 Duo 切到目标姿态、设备空闲后运行。
# 用法: r14-duo-pose-capture.sh <UDID> <pose-name>
# 产物: handover/calendar-20261111/dev-evidence/P1/shots/r14-duo-<pose>-display-<WxH>-tab<N>.png
set -euo pipefail
UDID="${1:?UDID required}"
POSE="${2:?pose name required}"
OUT="${OUT_DIR:-/Users/surezhang/work/ZhaoYao/handover/calendar-20261111/dev-evidence/P1/shots}"
mkdir -p "$OUT"
BUNDLE="xin.zhaoyao.lixiang"

displays=$(xcrun simctl io "$UDID" enumerate 2>/dev/null | python3 - <<'PY'
import sys, json
cur={}; ports=[]
for line in sys.stdin:
    st=line.strip()
    if st=="Port:":
        if cur.get("uuid"): ports.append(cur)
        cur={}
    elif st.startswith("UUID:"): cur["uuid"]=st.split(":",1)[1].strip()
    elif st.startswith("Default width:"): cur["w"]=int(st.split(":")[1])
    elif st.startswith("Default height:"): cur["h"]=int(st.split(":")[1])
if cur.get("uuid"): ports.append(cur)
print(" ".join(f'{p["uuid"]}:{p["w"]}x{p["h"]}' for p in ports))
PY
)
echo "displays: $displays"
capture_all() {
  local tag="$1"
  for d in $displays; do
    uuid=${d%%:*}; wh=${d##*:}
    xcrun simctl io "$UDID" screenshot --display="$uuid" --type=png \
      "$OUT/r14-duo-${POSE}-display-${wh}-${tag}.png" >/dev/null 2>&1 || echo "capture failed $uuid"
  done
}
capture_all "current"
for n in 0 1 2 3 4; do
  xcrun simctl terminate "$UDID" "$BUNDLE" 2>/dev/null || true
  sleep 1
  xcrun simctl launch --terminate-running-process "$UDID" "$BUNDLE" -LixiangTab "$n" >/dev/null 2>&1
  sleep 7
  capture_all "tab$n"
done
ls -lh "$OUT"/r14-duo-"${POSE}"-display-* | tail -20
