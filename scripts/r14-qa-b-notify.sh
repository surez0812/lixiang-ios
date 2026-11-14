#!/usr/bin/env bash
# B 166-169 injected notification states. Only R14-QA-iPhone.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="${PKG:-/Users/surezhang/work/ZhaoYao/handover/calendar-20261111/dev-evidence/P1/Lixiang-R14-1.0-13-notify-904fa930-debug-simulator.tar.gz}"
UDID="${UDID:-0B71AEF4-1E34-47A3-937A-3A097A0D0362}"
BUNDLE=xin.zhaoyao.lixiang
OUT="$ROOT/qa/evidence/qa-b-notify"; mkdir -p "$OUT"
rm -rf /tmp/r14-qa-b; mkdir -p /tmp/r14-qa-b
tar -xzf "$PKG" -C /tmp/r14-qa-b
APP=$(find /tmp/r14-qa-b -maxdepth 2 -name Lixiang.app | head -1)
[ -n "$APP" ] || { echo missing app; exit 2; }
[ "$(shasum -a 256 "$PKG" | awk '{print $1}')" = "fc9068b724a494638289e99d9b557582d707eb52d190d5472b10c5727072aede" ] || { echo tar sha mismatch; exit 3; }
xcrun simctl boot "$UDID" >/dev/null 2>&1 || true
xcrun simctl bootstatus "$UDID" -b >/dev/null 2>&1 || true
xcrun simctl status_bar "$UDID" override --time 9:41 --batteryState charged --batteryLevel 100 --wifiBars 3 --cellularBars 4 >/dev/null 2>&1 || true
shot() {
  local label=$1; shift
  xcrun simctl terminate "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
  xcrun simctl uninstall "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
  xcrun simctl install "$UDID" "$APP"
  xcrun simctl launch --terminate-running-process "$UDID" "$BUNDLE" -LixiangSeedCountdown 1 "$@" >/dev/null 2>&1 || true
  sleep "${WAIT:-25}"
  xcrun simctl io "$UDID" screenshot --type=png "$OUT/$label.png" >/dev/null 2>&1 || true
  { echo "label=$label"; echo "udid=$UDID"; echo "tar_sha256=$(shasum -a 256 "$PKG"|awk '{print $1}')"; echo "binary_sha256=$(shasum -a 256 "$APP/Lixiang"|awk '{print $1}')"; echo "args=$*"; echo "captured=$(date -Iseconds)"; echo "note=injected simulation; not native system permission proof"; } > "$OUT/$label.txt"
  echo "shot $label"
}
shot preprompt -LixiangNotifyPreprompt -LixiangR14Route countdownDetail
shot preprompt-detail -LixiangNotifyPrepromptDetail -LixiangR14Route countdownDetail
shot denied -LixiangNotifyDenied -LixiangR14Route countdownDetail
shot authorized -LixiangNotifyAuthorized -LixiangR14Route countdownDetail
shot settings-return -LixiangNotifySettingsReturn -LixiangR14Route countdownDetail
shot preprompt-list -LixiangNotifyPreprompt -LixiangTab 3
echo OUT=$OUT
