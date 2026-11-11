#!/bin/bash
# QA 前置：预热 SwiftPM manifest cache，规避 xcodebuild rc74（manifest cache 阻断）
set -euo pipefail
cd "$(dirname "$0")/../.."
PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin
rm -rf ~/Library/Caches/org.swift.swiftpm/manifests 2>/dev/null || true
swift package resolve --package-path packages/LixiangCalendarCore
xcodebuild -resolvePackageDependencies -project Lixiang.xcodeproj -scheme Lixiang
echo "OK: manifest cache warmed; now run xcodebuild test -only-testing:LixiangTests -only-testing:LixiangUITests/CountdownUITests"
