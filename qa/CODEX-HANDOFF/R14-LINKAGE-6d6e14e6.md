# R14 同次 log→截图 linkage 取证（6d6e14e6）

- 目的：Codex closeout v4 证据缺口（log/截图 linkage），仅证据，不改代码
- commit：`6d6e14e6e776e9c644063c4263ffa0634fb2abd6`
- build：**build-only**（`scripts/r14-package-check.sh`，无 PlugIns/xctest）
- 版本：1.0(13)
- App binary SHA256：`29a69a6fa131912519cf2d74dbead3f845aaede1be7ab499fe268c01c3db6db7`
- evidence tar：`P1/linkage-6d6e14e6/Lixiang-R14-1.0-13-linkage-6d6e14e6-debug-simulator.tar.gz`
  SHA256：`53cd8114ebcd9d6d452f4063e12a523d16867e7fbe2917012698d941fa9ab6b3`
- 设备：R14-Build-iPhone `CFF55DB9-F228-4205-B307-FB4A074D6753`（仅此设备）
- 证据根目录：`dev-evidence/P1/linkage-6d6e14e6/`；manifest：`manifest.json` SHA256 `5dcc866e0b5f18773b31b574f0b924919e672b68c0fde8d8695a9ae139169846`

## 同次运行
| run | runUTC | flags | LXFONT | screenshot SHA256 | log SHA256 |
|---|---|---|---|---|---|
| actual-xl | 2026-11-14T01:57:23Z | `-LixiangTypeScale xl` | `NotoSerifCJKsc-fixedSize forceFallback=false` | `530a22a6…` | `2c52df01…` |
| forced-xl | 2026-11-14T01:57:43Z | `-LixiangTypeScale xl -LixiangForceSerifFallback` | `system-serif-forced forceFallback=true` | `67670f40…` | `ce26f547…` |
| forced-a2 | 2026-11-14T01:58:03Z | `-LixiangTypeScale a2 -LixiangForceSerifFallback` | `system-serif-forced forceFallback=true` | `3f7929cf…` | `e0bc640d…` |

- 每次 launch 的 raw 参数见各 log 内 `LXLAUNCH args=[…]`；`LXFONT` 行在同 log；截图 1206×2622
- manifest 记录 log/截图路径+SHA、package/binary/commit、设备、flags、runUTC

## 复现命令
```bash
cd work/lixiang-r14
./scripts/r14-package-check.sh /tmp/lixiang-r14-linkage-dd
APP=/tmp/lixiang-r14-linkage-dd/Build/Products/Debug-iphonesimulator/Lixiang.app
PHONE=CFF55DB9-F228-4205-B307-FB4A074D6753
xcrun simctl install $PHONE "$APP"
xcrun simctl launch --terminate-running-process --console-pty $PHONE xin.zhaoyao.lixiang \
  -LixiangTypeScale xl > /tmp/actual-xl.log 2>&1
sleep 18; xcrun simctl io $PHONE screenshot /tmp/actual-xl.png
# forced：追加 -LixiangForceSerifFallback；a2：-LixiangTypeScale a2
```
