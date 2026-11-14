# build-only clean 候选包 preverify（474b12c8）

- 包：`P1/Lixiang-R14-1.0-13-clean-474b12c8-debug-simulator.tar.gz`
- tar `7547f91c…`；binary `c382c07b…`；commit `474b12c8`；1.0(13)；1.0(13) bundle `xin.zhaoyao.lixiang`。
- events.json `79b80283…`（12 approved）。
- QA 仅做包身份/结构检查；未装设备、未重跑 12 页。

## 检查
- tar/binary/commit/版本/events 匹配。
- App 内 **无 `PlugIns` 目录、无 `*.xctest`**；仅 debug 构建的 `Lixiang.debug.dylib` / `__preview.dylib`（非测试插件）。
- `scripts/r14-package-check.sh` 存在；dev 报告 PASS。QA 本机直接执行该脚本时 `xcodebuild` 因 SwiftPM manifests 缓存权限失败，**环境限制**，不据此判包失败；未产生新包/未改产品代码。
- 旧包/基线未改。

## 结论
- **包身份 preverify PASS（build-only 结构，无测试插件）**。
- 矩阵不变 100/33/55；仅包检查，不代表 UI/188 PASS。
