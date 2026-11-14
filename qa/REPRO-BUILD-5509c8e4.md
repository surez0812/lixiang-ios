# 干净重建核对 · commit 5509c8e4（2026-11-14 09:25）

目的：回应 Codex 交付审查“二进制由 commit 构建/干净构建可复现 = NOT RUN”。

## 方法
```bash
git worktree add --detach /tmp/lx-repro-5509 5509c8e42f8d8caa163f476c8545bd2b7c293c27
cd /tmp/lx-repro-5509
xcodegen generate --spec project.yml
xcodebuild -project Lixiang.xcodeproj -scheme Lixiang -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,id=CFF55DB9-F228-4205-B307-FB4A074D6753' \
  -derivedDataPath /tmp/lx-repro-dd CODE_SIGNING_ALLOWED=NO build
```

## 结果
- BUILD SUCCEEDED（固定 commit，独立 worktree + 全新 DerivedData）
- 重建 App 与审查包对比：
  - `events.json` SHA 相同 `79b80283…`；字体 NotoSerifSC Regular/Bold 均在；bundle 文件数 89
  - 主可执行文件大小相同 40,136B；**SHA 不同**（重建 `d49cbefe…` vs 包内 `b4b887ee…`）
  - 差异仅 `Lixiang`/`Lixiang.debug.dylib`（debug 构建非确定性：UUID/路径），资源一致
- **结论**：
  - 固定 commit 可干净构建成功；资源/内容可复现
  - **byte-identical 二进制不可复现**（debug 构建），不能声称 reproducible-build PASS
  - 审查包 `5509c8e4` 因先跑测试，App 内含 `PlugIns/LixiangTests.xctest`；仅为测试插件，最终发布包应 build-only 并移除该目录（未改现有 immutable 包）

## 边界
- 未运行 UI/业务测试；不代表 188 验收；未发布/提审/合并。

## 发布包前置检查（build-only，新增）
- 脚本：`scripts/r14-package-check.sh [derivedDataPath]`
- 流程：xcodegen → `xcodebuild build`（generic simulator，**不跑 test**）→ 断言 App 无 `PlugIns/`/`*xctest*` → 版本 1.0(13) → 源/包内 `Content/events.json` SHA 一致
- 本 HEAD 实测（clean DerivedData `/tmp/lixiang-r14-release-dd`）：
  - `PASS: build-only package check (no PlugIns/xctest, version/resource OK)`
  - version=1.0(13)
  - binary_sha256=`c0e87ac1ec1cf8880e704790f801650bd482da6d627a6bc897a2f9147a330ea0`
  - events_sha256=`79b80283d81651c9a889f9328b19c9487dde3e1bf49306a4b883a5c60b828d5b`
  - app=64488KB
- 说明：debug 二进制 SHA 受构建 UUID/路径影响，不要求 byte-identical；资源/内容 SHA 必须一致。
- 旧包 `…staticcloseout-5509c8e4…tar.gz` 保持不动（Codex 已引用）；其中 `PlugIns/LixiangTests.xctest` 为“先 test 后打包”产物，**不得用于最终发布**。
