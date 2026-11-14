#!/usr/bin/env bash
# A 164 offline/failure/retry probe. Only R14-QA-iPhone.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="${PKG:-/Users/surezhang/work/ZhaoYao/handover/calendar-20261111/dev-evidence/P1/Lixiang-R14-1.0-13-offline-9804c16e-debug-simulator.tar.gz}"
UDID="${UDID:-0B71AEF4-1E34-47A3-937A-3A097A0D0362}"
BUNDLE=xin.zhaoyao.lixiang
OUT="$ROOT/qa/evidence/qa-a-offline"; mkdir -p "$OUT"
rm -rf /tmp/r14-qa-a; mkdir -p /tmp/r14-qa-a
tar -xzf "$PKG" -C /tmp/r14-qa-a
APP=$(find /tmp/r14-qa-a -maxdepth 2 -name Lixiang.app | head -1)
[ -n "$APP" ] || { echo missing app; exit 2; }
[ "$(shasum -a 256 "$PKG" | awk '{print $1}')" = "1645f8349f06a4c57f1688ac449791ff7ad60102ac34ab2a04c93d607a733818" ] || { echo tar sha mismatch; exit 3; }
xcrun simctl boot "$UDID" >/dev/null 2>&1 || true
xcrun simctl bootstatus "$UDID" -b >/dev/null 2>&1 || true
xcrun simctl terminate "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
xcrun simctl uninstall "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
xcrun simctl install "$UDID" "$APP"
xcrun simctl status_bar "$UDID" override --time 9:41 --batteryState charged --batteryLevel 100 --wifiBars 3 --cellularBars 4 >/dev/null 2>&1 || true
shot() {
  local label=$1; shift
  xcrun simctl terminate "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
  xcrun simctl launch --terminate-running-process "$UDID" "$BUNDLE" "$@" >/dev/null 2>&1 || true
  sleep "${WAIT:-25}"
  xcrun simctl io "$UDID" screenshot --type=png "$OUT/$label.png" >/dev/null 2>&1 || true
  { echo "label=$label"; echo "udid=$UDID"; echo "tar_sha256=$(shasum -a 256 "$PKG"|awk '{print $1}')"; echo "binary_sha256=$(shasum -a 256 "$APP/Lixiang"|awk '{print $1}')"; echo "args=$*"; echo "captured=$(date -Iseconds)"; } > "$OUT/$label.txt"
  echo "shot $label"
}
# fresh install: no cache + offline
shot offline-uncached -LixiangR14Route folkloreDetail -LixiangForceOffline
# load normal once, then offline cached
shot cached-load -LixiangR14Route folkloreDetail
shot offline-cached -LixiangR14Route folkloreDetail -LixiangForceOffline
# forced load failure
shot load-failed -LixiangR14Route folkloreDetail -LixiangForceLoadFail
# offline -> auto retry -> loaded
shot retry-success -LixiangR14Route folkloreDetail -LixiangOfflineRetry
echo OUT=$OUT
