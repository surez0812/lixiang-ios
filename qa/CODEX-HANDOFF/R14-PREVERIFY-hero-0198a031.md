# 12 hero 集成 pre-verify（0198a031）

- 包：`P1/Lixiang-R14-1.0-13-hero-0198a031-debug-simulator.tar.gz`
  - tar `7330647b…`；binary `c07fca6d…`；commit `0198a031…`；1.0(13)；events `79b80283…` 未改。
- 设备：R14-QA-iPhone `0B71AEF4`（仅详情截图，无代码改动）；证据 `qa/evidence/hero-0198a031/`。

## 1. 包/资源映射（PASS）
- bundle 根 12 个 `<id>.webp`；内容与 candidates/SHA 一一匹配（dongzhi 18756、qingming 35800、chunjie 10048、zhongqiu 23820、xiayuan 23882、zhongyuan 21292、laba 18666、yulanpen 90836、xiezao 18200、jizu 32624、shangsi 61096、chongyang 43112）。
- bundle 内另有旧 assets（fest-*/term-*），非本次 12 映射，不影响 id 加载；events 未改。
- `ContentHeroTests` 4/4（dev 报告）：12 decode/1024×576/16:9、alt、fallback、cache；QA 未重跑。

## 2. 12 详情 hero 实拍（PASS）
- QA iPhone 用 `-LixiangDebugDate` 解锁 12 条，逐条截图：`qa/evidence/hero-0198a031/<id>.png`（dongzhi 重试 `dongzhi-retry2.png`）。
- 视觉：12/12 hero 显示，id→画面匹配（dongzhi 黄陶罐、qingming 垂柳、chunjie 红灯笼、zhongqiu 月饼、xiayuan 水岸、zhongyuan 河灯、laba 粥、yulanpen 荷塘白莲、xiezao 灶壶、jizu 花束、shangsi 春水柳、chongyang 菊花）；alt 与画面一致；16:9 cover 未见拉伸/异常裁切。
- 团队截图 `r14-hero-qingming-detail.png` 实际是“谢灶锁定”页、无 hero，已不作为 qingming 证据；QA 重拍 `qingming.png` 为真实清明 hero。

## 3. 缺失回退（PASS，静态/单测）
- `ContentHeroTests` 断言 missing id → nil + `accessibilityLabel=岁时插画`；`image(for:)` 回退 `winter`；未独立做缺失 fixture 设备截图，仅代码/单测。
- content JSON/12 approved 未改；内容行 85-90/163/174 仍 NOT RUN。

## 4. 结论
- 资源/测试/12 hero 实拍 PASS；fallback 为静态/单测 PASS（无设备 fixture 截图）。
- 任务 `TASK-20261114-1245-hero-0198a031.md` 移出 HOLD；Codex 可独立复核。
- 矩阵 100/33/55 不变；12 hero 转正前仍 pending/接入证据已补，但内容行不自动 PASS。
