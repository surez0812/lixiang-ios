#!/usr/bin/env bash
# Build/install/launch Lixiang on an iOS simulator, optionally screenshot.
# Usage: scripts/r14-build-sim.sh <UDID> [screenshot.png]
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
UDID="${1:?simulator UDID required}"
SHOT="${2:-}"
XCODEGEN="${XCODEGEN:-/Users/surezhang/work/ZhaoYao/.tools/xcodegen/2.46.0/bin/xcodegen}"
DD="${DD:-/tmp/lx-r14-dd}"
cd "$ROOT"
"$XCODEGEN" generate --spec project.yml >/dev/null
xcodebuild -project Lixiang.xcodeproj -scheme Lixiang -sdk iphonesimulator \
  -destination "platform=iOS Simulator,id=$UDID" -derivedDataPath "$DD" \
  CODE_SIGNING_ALLOWED=NO build >/tmp/lx-r14-build.log 2>&1
APP="$DD/Build/Products/Debug-iphonesimulator/Lixiang.app"
xcrun simctl boot "$UDID" 2>/dev/null || true
xcrun simctl install "$UDID" "$APP"
BUNDLE=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "$APP/Info.plist")
xcrun simctl terminate "$UDID" "$BUNDLE" 2>/dev/null || true
xcrun simctl launch "$UDID" "$BUNDLE"
if [ -n "$SHOT" ]; then sleep 2; xcrun simctl io "$UDID" screenshot "$SHOT"; fi
echo "BUILD_OK app=$APP bundle=$BUNDLE"
