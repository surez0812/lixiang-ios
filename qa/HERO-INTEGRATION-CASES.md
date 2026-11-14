# 12 hero 集成验收用例（dev 接入后执行）

- 资产复核：`qa/CONTENT-HERO-QA.md`/`CONTENT-HERO-RECHECK.md`；映射 `qa/CONTENT-HERO-MAP.md` SHA `53c79f16…`；**39 可用+1 test，¥11.4**。
- 当前 12 hero 仅“资产复核 PASS”，未接 App；**仍 pending-design**；内容行 NOT RUN；矩阵 100/33/55 不改。
- 接入约定（dev）：
  - 12 webp 放 `App/Resources/Content/Heroes/<content-id>.webp`（如 `dongzhi.webp`）。
  - UI 按 content id 加载；缺失回退现有 `winter`。
  - **不改** `events-12.json` 文案/reviewStatus；不把 hero 元数据改成已交付。
  - 新 immutable 包 + tar/binary/events SHA + 新任务 ID。

## A. 12/12 详情 hero
1. 逐条打开详情（日期/解锁条件满足），确认 hero 显示对应资产，不是 winter/占位/空白。
2. 对照 mapping：content id→文件；无错配（dongzhi 罐、qingming 垂柳、chunjie 红灯笼、zhongqiu 月饼、xiayuan 水岸、zhongyuan 河灯、laba 粥、yulanpen 荷塘白莲、xiezao 灶壶、jizu 花束、shangsi 春水柳、chongyang 菊花）。
3. alt：zh/en 与实际画面一致；不得沿用旧错误 alt（尤其 dongzhi/yulanpen）。
4. 视觉：16:9/cover 无拉伸；桌面/手机/详情裁切可接受；无伪文字/水印/人物/宗教场所。

## B. 缺失/回退
5. 用一个不存在 hero 的 content id（测试 fixture 或临时只读）确认回退 `winter`，不 crash/不空白。
6. 缺失资源不得显示破图/错误 alt；日志/调试可查。
7. 不清除其它 id 的 hero。

## C. 门禁/非目标
8. `events-12.json` 仍 12 approved，文案/reviewStatus 未变；hero 元数据仍 pending-design 或另行说明，不得宣称图片已验收。
9. 内容行 85-90/163/174 仍需逐行 UI 证据；hero 显示不等于行 PASS。
10. 矩阵不改；不发布/提审/合并。

## 证据
- 每 id：详情截图 + 资源 SHA；回退 fixture 截图；新包 tar/binary/events SHA。
- 12 hero 转正前仍 pending；内容行 NOT RUN。
