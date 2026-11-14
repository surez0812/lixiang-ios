#!/usr/bin/env bash
# R14 发布包前置检查：build-only（不跑 test），并断言 App 内无 PlugIns/测试 bundle。
# 用法：scripts/r14-package-check.sh [derivedDataPath]
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DD="${1:-/tmp/lixiang-r14-release-dd}"
cd "$ROOT"

echo "[1/5] xcodegen"
/Users/surezhang/work/ZhaoYao/.tools/xcodegen/2.46.0/bin/xcodegen generate --spec project.yml >/dev/null

echo "[2/5] clean build-only (no test)"
rm -rf "$DD"
xcodebuild build \
  -project Lixiang.xcodeproj -scheme Lixiang -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  -derivedDataPath "$DD" CODE_SIGNING_ALLOWED=NO >/tmp/r14-package-build.log 2>&1
APP="$DD/Build/Products/Debug-iphonesimulator/Lixiang.app"
test -d "$APP" || { echo "FAIL: app not found"; exit 1; }

echo "[3/5] assert no PlugIns / test bundles"
if [ -d "$APP/PlugIns" ]; then echo "FAIL: App contains PlugIns (test bundles)"; exit 1; fi
if find "$APP" -iname "*.xctest" -o -iname "*XCTest*" | grep -q .; then echo "FAIL: App contains XCTest artifacts"; exit 1; fi

echo "[4/5] version + resource checks"
VER=$(/usr/libexec/PlistBuddy -c "Print :CFBundleShortVersionString" "$APP/Info.plist")
BUILD=$(/usr/libexec/PlistBuddy -c "Print :CFBundleVersion" "$APP/Info.plist")
[ "$VER" = "1.0" ] && [ "$BUILD" = "13" ] || { echo "FAIL: version $VER($BUILD) != 1.0(13)"; exit 1; }
SRC_SHA=$(shasum -a 256 App/Resources/Content/events.json | awk '{print $1}')
BUNDLED=$(find "$APP" -name events.json | head -1)
[ -n "$BUNDLED" ] || { echo "FAIL: bundled events.json missing"; exit 1; }
B_SHA=$(shasum -a 256 "$BUNDLED" | awk '{print $1}')
[ "$SRC_SHA" = "$B_SHA" ] || { echo "FAIL: events.json SHA mismatch src=$SRC_SHA bundled=$B_SHA"; exit 1; }

echo "[5/5] result"
echo "APP=$APP"
echo "version=$VER($BUILD)"
echo "binary_sha256=$(shasum -a 256 "$APP/Lixiang" | awk '{print $1}')"
echo "events_sha256=$SRC_SHA"
echo "app_bytes=$(du -sk "$APP" | awk '{print $1}')KB"
echo "PASS: build-only package check (no PlugIns/xctest, version/resource OK)"
