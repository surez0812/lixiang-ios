# hero3 fallback label pre-verify（38b34c5a）

- 包：`P1/Lixiang-R14-1.0-13-hero3-38b34c5a-debug-simulator.tar.gz`
  - tar `18868dd6…`；binary `65ff66de…`；commit `38b34c5a…`；1.0(13)；events `79b80283…` 未改。
- QA 未操作设备；源码/测试/团队截图复核。

## 1. resolve image+label（PASS）
- `R14ContentHero.resolve(for:)` 单次解析：成功→原图+原 alt（`isFallback=false`）；缺失/失败/forceMissing/unknown→winter+`fallbackLabel="岁时插画"`（`isFallback=true`）。
- 详情页改用 `let hero = resolve(...)`，图片与 `.accessibilityLabel(hero.label)` 同源；不再分别调用 alt。
- **known ID + forceMissing**：图片 winter、label 中性、查不到原 alt；正常 known ID label 原 alt；unknown 中性。

## 2. 测试（dev 报告）
- `ContentHeroTests` 6/6（新增 resolve label matches image：正常原 alt、forced missing 中性、unknown 中性）。
- `R14HeroAccessibilityUITests` PASS（dev 报告）：正常重阳原 alt；forced missing 中性且查不到原 alt；截图 `r14-hero-fallback-label.png`（1206×2622，显示 winter）。
- QA 未重跑；无 pty 可用。

## 3. 未回退
- 12 webp 仍在 bundle；events 未改；16:9 容器代码未回退；content JSON/reviewStatus 未改。
- EN runtime/locale 仍 **NOT RUN**（产品无英文 UI）；内容行 85-90/163/174 仍 NOT RUN；12 hero 转正前 pending；矩阵 100/33/55 不变。

## 结论
- a11y label 同步修复 PASS（代码/单测/团队 UI 测试）；可交 Codex 复核。
- 任务 `TASK-20261114-1330-hero3-38b34c5a.md` 移出 HOLD。
