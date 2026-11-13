#!/usr/bin/env bash
# Print available simulators used by R14; no screenshots/fake posture results.
set -euo pipefail
xcrun simctl list devices available | sed -n '1,120p'
echo
echo "R14 canvas mapping: phone=iPhone 17 Pro; iPad=iPad Pro 13; Duo=Lixiang-iPhoneDuo."
echo "Duo close/tent/tabletop are postures, not separate simctl devices; use XCUITest/device controls when available, otherwise NOT RUN."
