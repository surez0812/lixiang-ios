#!/usr/bin/env bash
# R14 simulator build. No GUI. All QA artifacts stay under repo/.qa.
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="${R14_DERIVED:-$ROOT/.qa/DerivedData}"
PKG="${R14_PKG:-$ROOT/.qa/SourcePackages}"
LOG="${R14_BUILD_LOG:-$ROOT/.qa/r14-build.log}"
mkdir -p "$OUT" "$PKG" "$(dirname "$LOG")"
echo "[r14-build] root=$ROOT" | tee "$LOG"
echo "[r14-build] derived=$OUT pkg=$PKG" | tee -a "$LOG"
xcodebuild \
  -project "$ROOT/Lixiang.xcodeproj" \
  -scheme Lixiang \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath "$OUT" \
  -clonedSourcePackagesDirPath "$PKG" \
  CODE_SIGNING_ALLOWED=NO \
  build 2>&1 | tee -a "$LOG"
APP="$OUT/Build/Products/Debug-iphonesimulator/Lixiang.app"
echo "[r14-build] app=$APP" | tee -a "$LOG"
test -d "$APP" || { echo "ERROR: app not found" >&2; exit 1; }
shasum -a 256 "$APP/Lixiang" 2>/dev/null | tee -a "$LOG" || true
