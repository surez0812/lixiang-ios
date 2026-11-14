# 历象 R14 节气/节日插画补产计划（Aliyun DashScope / wanx）

- 授权：Sure 2026-11-14；预算 **≤ ¥50**；由 PM 执行/验收，designer 可协助精修
- 目标：补 24 节气 + 重要传统节日 hero/插画，替换当前仅冬季 1 套与 12 条 `pending-design`
- 原则：复用此前 demo 的 prompt 风格/negative/seed 策略；不贴 key、不入库；先生成后人工选片；不直接当最终成品上线

## 1. 历史记录（已找到）
- Ops 放行与实测：`handover/calendar-20261111/ops/DASHSCOPE-REQUEST.md`
  - 模型：`wanx2.1-t2i-plus`；实测 ¥0.2/张、RPM 120；尺寸上限 1440 → 用 **1024×1365** 或 **960×1440**
  - env：`/Users/surezhang/.dashscope/image.env`（首选）或 `/Users/surezhang/work/ZhaoYao/.secrets/dashscope-image.env`（回退）；只 source，不打印/不入库
  - **key 分离（Sure 2026-11-14）**：图片只用**普通 API key**；**token plan/top plan 只用于文案/经典语录**，禁止用于 wanx 图片；混用需立即停并报额度
  - 历史测试图：`ops/dashscope-image-test-20261111T1345/`
- 旧生成脚本/参数：`proposals/lixiang-1.0-20261111/rich/run_wanx.py`、`prompts.json`、`wanx/`、`params.json`
  - 旧 prompt 风格：`warm rich Chinese seasonal editorial illustration`，cream paper `#F7EBDC`，flat color blocks，paper grain，2–4 colors，generous negative space
  - 旧 negative：`text, watermark, signature, calligraphy, Chinese characters, logo, person, face, hands, religious statue, temple, talisman, coins, neon, glass, 3d render, plastic, oversaturated, cold blue, navy, dark background, busy composition, cluttered, minimal empty`
  - 旧 seed：`20261111`（同模型固定，便于对比）
- 设计侧素材 prompt（对象资产）：`lixiang-design-handoff-20261113/docs/design/r14-final/ASSET-PROMPTS.md`

## 2. 建议范围（PM 可决定最终数量，但不得低于）
- **24 节气**：各 1 张（优先立春/夏至/秋分/冬至先出样，其余批量）
- **重要传统节日**：至少 12 个（春节、元宵、清明、端午、七夕、中元、中秋、重阳、腊八、小年/谢灶、除夕、上巳/下元/祭祖按 PM 取舍）
- 建议首批 **36 张**（24+12）；预算按 ¥0.2/张 ≈ ¥7.2，留足重跑/精修余量；如出 2 候选/关键节日，≤60 张也远低于 ¥50
- 最终 hero 需 **16:9 webp ≤120KB**；生成可用 1024×1365/1024×576，按构图裁切；不得拉伸变形

## 3. 执行步骤（PM）
1. `source /Users/surezhang/.dashscope/image.env`（失败再回退另一个）；**先 1 张测试**，打印只含 model/size/耗时/成本，不打印 key
2. 复用旧 `prompts.json` 的风格/negative/seed 模板；为 24 节气 + 节日补 subject prompt（同一句式，不引入 text/人物/宗教场所）
3. 生成到 `handover/calendar-20261111/assets/seasonal-aliyun/`：
   - `raw/<id>-<variant>.png`
   - `params.json`（model/size/prompt/negative/seed/成本/耗时）
   - `usage-log.csv`（日期/模型/尺寸/张数/费用）
   - `selection.md`（每张入选/弃用理由）
4. PM 逐张审：季节/节气准确、无伪文字/水印/人物、R14 暖纸/留白/2–4 色、可裁 16:9；不过关重跑
5. 输出 `webp`（≤120KB）到 `App/Resources/SeasonalArt/` 的候选目录，先不覆盖现有 winter；给 SHA/尺寸/alt
6. 报预算实际花费（目标 ≤¥50，超出前先停）

## 4. 验收
- 24/24 节气有图；重要节日 ≥12 有图
- 每张有 prompt/seed/成本/候选记录；无 key 泄露
- 亮/暗、375/iPad 裁切不崩；webp ≤120KB；无文字/水印
- PM 选出首版；designer/QA 视觉复核；dev 再接入 content hero，不直接声称页面 PASS

## 5. 与当前交付包关系
- 本批素材不阻塞 Codex 测试当前 clean 包；生成后单独打 asset followup/新包
- 12 条 `pending-design` hero 在本批素材验收前仍保持内容行 NOT RUN

## 6. 执行结果（2026-11-14，PM 已执行）
- **状态：首批完成**（测试 1 + 24 节气 + 12 节日 = 37 个唯一资产；48 次调用含重跑；**实际花费 ¥9.6**，预算余 ¥40.4）
- 首张测试：`wanx2.1-t2i-plus`、1024×1365、seed 20261111、17.6s、¥0.2 → 风格通过后批量
- **覆盖**：
  - 24/24 节气全齐：lichun/yushui/jingzhe/chunfen/qingming/guyu/lixia/xiaoman/mangzhong/xiazhi/xiaoshu/dashu/liqiu/chushu/bailu/hanlu/shuangjiang/lidong/xiaoxue/daxue/dongzhi/xiaohan/dahan
  - 12/12 节日：chunjie/yuanxiao/qingming-festival/duanwu/qixi/zhongyuan/zhongqiu/chongyang/laba/xiezao/chuxi/shangsi
  - 未生成：下元/祭祖（非最低要求；如需补 2 张约 ¥0.4，先经 PM/Lead 确认，不无目的加量）
- 重跑：jingzhe/guyu/xiaohan（去文字）、fest-* 10 条（去春联/英文标题/荧光粉），成本已计入
- **产物**：
  - raw：`handover/calendar-20261111/assets/seasonal-aliyun/raw/`（37 png）
  - 参数：`params.json` SHA `a7faa6fe…`（model/size/seed/prompt/negative/elapsed/cost）
  - 用量：`usage-log.csv` SHA `0ad3f26a…`（48 张 ¥9.6）
  - 转换：`converted.json` SHA `7b4167a8…`
  - **选片：`selection.md` SHA `cbbf5132…`**（每张入选/弃用/待优化理由；首选 8 张）
  - 候选 webp：`App/Resources/SeasonalArt/candidates/`（37 张，16:9 1024×576，**≤72.1KB**；未覆盖 winter）
- 视觉初审：无伪文字/水印/人物/宗教场所；暖纸/留白/2–4 色；`chushu` 偏空、`daxue` 窗格、`qixi` 抽象、`chuxi` 顶部裁切 → 可备份重跑，不阻塞
- 边界：需 PM/QA 视觉复核后才交 dev 接入；12 条 hero 在验收前仍 pending-design，内容行不因素材自动 PASS

## 7. 最终执行口径（2026-11-14，QA 复核后）
- **候选目录 39 文件 = 38 可用（24 节气 + 14 节日）+ 1 张 test-lichun**；产品资产 38
- **55 次调用、实际 ¥11.0**（含 3 张 QA 待修重跑 + 2 张下元/祭祖补充）；预算余 ¥39
- `fest-laba`/`fest-xiezao`/`term-dashu` 已重跑 PASS；`fest-xiayuan`/`fest-jizu` 已补
- **root `term-daxue-light.webp` 已压至 115,952B（1500×1880）**，原文件备份 `.orig.webp`
- 新 SHA：`params.json 44457f42…`、`converted.json 30b0f0bd…`、`usage-log.csv 7a0864ee…`、`selection.md 0a828f44…`、`inventory daa4e0bc…`
- 不直接接 App；12 条 hero 仍 pending-design；先交 QA 复检 3+2+压图

## 8. yulanpen 补充 + 12 条 hero 映射
- 新增 `fest-yulanpen.webp`（12.9KB）；candidates 40 文件 = **39 可用**（24+15）+1 test
- 总调用 **56 次、¥11.2**；`params.json/converted.json/usage-log.csv` 已更新
- 12 条内容→hero 映射：`qa/CONTENT-HERO-MAP.md`；仍待 QA 复核，不直接接 App

## 9. QA 复审修正（2026-11-14）
- alt 5 条修正；`fest-yulanpen` 重跑为荷塘白莲（90.8KB，SHA 见 map）
- 57 次调用、¥11.4；映射见 `qa/CONTENT-HERO-MAP.md`
