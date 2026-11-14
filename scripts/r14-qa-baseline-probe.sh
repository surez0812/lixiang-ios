#!/usr/bin/env bash
# Non-Duo QA baseline probe (no injection). Safe: only R14-QA-* simulators.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PKG="${PKG:-/Users/surezhang/work/ZhaoYao/handover/calendar-20261111/dev-evidence/P1/Lixiang-R14-1.0-13-bilingual-8c4119b1-debug-simulator.tar.gz}"
UDID="${UDID:-0B71AEF4-1E34-47A3-937A-3A097A0D0362}"
BUNDLE="xin.zhaoyao.lixiang"
OUT="$ROOT/qa/evidence/qa-baseline-probe"; mkdir -p "$OUT"
rm -rf /tmp/r14-qa-baseline; mkdir -p /tmp/r14-qa-baseline
tar -xzf "$PKG" -C /tmp/r14-qa-baseline
APP="$(find /tmp/r14-qa-baseline -maxdepth 2 -name Lixiang.app | head -1)"
[ -n "$APP" ] || { echo "missing app" >&2; exit 2; }
EXPECT_TAR=7b5b6dbb35c9d5a29cc1d87936176f62efeccec569a8507c399ba051b2486ad8
GOT_TAR=$(shasum -a 256 "$PKG" | awk '{print $1}')
[ "$GOT_TAR" = "$EXPECT_TAR" ] || { echo "tar sha mismatch: $GOT_TAR" >&2; exit 3; }
xcrun simctl boot "$UDID" >/dev/null 2>&1 || true
xcrun simctl bootstatus "$UDID" -b >/dev/null 2>&1 || true
xcrun simctl terminate "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
xcrun simctl uninstall "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
xcrun simctl install "$UDID" "$APP"
xcrun simctl status_bar "$UDID" override --time 9:41 --batteryState charged --batteryLevel 100 --wifiBars 3 --cellularBars 4 >/dev/null 2>&1 || true
probe() {
  local label="$1"; shift
  xcrun simctl terminate "$UDID" "$BUNDLE" >/dev/null 2>&1 || true
  xcrun simctl launch --terminate-running-process "$UDID" "$BUNDLE" "$@" >/dev/null 2>&1 || true
  sleep "${WAIT:-8}"
  xcrun simctl io "$UDID" screenshot --type=png "$OUT/$label.png" >/dev/null 2>&1 || true
  { echo "label=$label"; echo "udid=$UDID"; echo "tar_sha256=$GOT_TAR"; echo "binary_sha256=$(shasum -a 256 "$APP/Lixiang" | awk '{print $1}')"; echo "launch_args=$*"; echo "captured_at=$(date -Iseconds)"; echo "note=no injection baseline probe"; } > "$OUT/$label.txt"
  echo "probe $label"
}
# current behavior, no injection
probe countdown-detail-seeded -LixiangSeedCountdown 1 -LixiangR14Route countdownDetail -AppleLanguages '(zh-Hans)' -AppleLocale zh_CN
probe countdown-list-seeded -LixiangSeedCountdown 1 -LixiangTab 3 -AppleLanguages '(zh-Hans)' -AppleLocale zh_CN
probe folklore-detail -LixiangR14Route folkloreDetail -AppleLanguages '(zh-Hans)' -AppleLocale zh_CN
echo "OUT=$OUT"
