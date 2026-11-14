# hero v2 pre-verify（de01327c）

- 包：`P1/Lixiang-R14-1.0-13-hero2-de01327c-debug-simulator.tar.gz`
  - tar `16e72ee5…`；binary `dee094c4…`；commit `de01327c…`；1.0(13)；events `79b80283…` 未改。
- QA 未操作设备；源码/测试/团队截图复核。

## 1. 包/资源/测试（PASS）
- bundle root 12 `<id>.webp` 仍在；events 未改；`ContentHeroTests` 5/5（新增 forceMissing）为 dev 报告。
- 12 ids 映射未回退；内容 JSON/reviewStatus 未改。

## 2. 16:9 容器（PASS，代码/截图）
- 详情 hero 改 `Color.clear.aspectRatio(16/9).overlay{ Image.resizable().scaledToFill() }.clipped()`，删除固定 height220；宽度派生比例、fill 只裁边不拉伸。
- 截图：`r14-hero169-phone-xl.png`（1206×2622）、`r14-hero169-ipad.png`（2064×2752）显示宽幅 hero、无可见压扁/异常拉伸；iPhone/iPad 各一态，未覆盖全部宽度/动态字号。

## 3. fallback（PASS，运行截图）
- DEBUG `-LixiangForceMissingHero` → `uiImage` nil → `Image("winter")`；截图 `r14-hero169-fallback.png` 显示冬季插画，非空白/破图。
- `ContentHeroTests` forceMissing nil 断言；fallback 运行时截图团队提供，QA 未独立运行。

## 4. EN accessibility（NOT RUN）
- 产品无英文 locale/UI；EN alt 元数据存在，但运行时 locale/VoiceOver 未验，**NOT RUN**，不伪造。
- 内容行 85-90/163/174 仍 NOT RUN；12 hero 转正前仍 pending；矩阵 100/33/55 不变。

## 结论
- 16:9 容器代码/phone+iPad 截图、fallback 运行截图、12资源未回退 PASS；EN NOT RUN；可交 Codex 复核。
- 任务 `TASK-20261114-1320-hero2-de01327c.md` 移出 HOLD。
