# 12 条 hero 映射/视觉复核（candidates 40）

- 映射：`qa/CONTENT-HERO-MAP.md` SHA `eca2ff54…`；路径前缀 `App/Resources/SeasonalArt/candidates/`。
- candidates 实际 **40 = 39 可用（24 节气+15 节日）+1 test**；花费 ¥11.2/56 次；未接 App。
- **映射完整性 PASS**：12 content ids 一一对应，无缺失/多余；路径存在；bytes/SHA 全部匹配；全部 16:9 1024×576、RGB、≤120KB。
- 12 hero 仍 **pending-design**；通过前不接 App；内容行 NOT RUN；矩阵不改。

## 结论
- **映射 PASS；视觉 6 张 PASS、5 张 alt 文案需修（图可用）、1 张待修/待确认**（yulanpen）。
- 红线：未见伪文字/水印/签名/人物/脸/手/宗教场所/符咒。
- 12 张均无透明/拉伸；1024×576。

## 特别核对
### yulanpen（待修/确认）
- 文件 `fest-yulanpen.webp` 12,888B；SHA `55b83202…`；1024×576。
- 画面：浅绿水面 + 3 盏小橙色河灯，**不是“暮色”**，且与 `fest-zhongyuan`（河面密集河灯/暮色）**主题近似**，区分度弱；alt 写“暮色河灯与静水”与画面不符。
- 不能判“过暗”；问题是**偏浅/与中元近似**。建议：增加暮色/盂兰盆独立元素（供僧/目连文化意象需克制），或改 alt 并确认可否复用；当前不接。

### qingming（图可用，alt/选择待确认）
- `fest-qingming-festival.webp` 35,800B；画面仅柳枝，无“青山/细雨”；alt 写“柳枝青山与细雨”不符。
- 选择节日语境图（非纯节气）方向可接受，但需 **改 alt** 或补充清明元素；不把通用柳枝当完整清明叙事。

## 逐张
| content id | asset | bytes | SHA256 | 视觉 |
|---|---|---:|---|---|
| dongzhi | term-dongzhi | 18,756 | `99e90d61…` | PASS（图）；alt“柳枝薄冰与暖灯”与画面（黄色坛/罐）不符→改 alt |
| qingming | fest-qingming-festival | 35,800 | `dab4932b…` | 图可用；alt“青山/细雨”不符→改 alt；选择待确认 |
| chunjie | fest-chunjie | 10,048 | `75c4cfa3…` | PASS（灯笼）；alt“团圆桌”不符→改 alt |
| zhongqiu | fest-zhongqiu | 23,820 | `15ebe2a3…` | PASS（满月/月饼） |
| xiayuan | fest-xiayuan | 23,882 | `b3e0bb7f…` | PASS（水岸/暖灯） |
| zhongyuan | fest-zhongyuan | 21,292 | `b78fb1be…` | PASS（河灯/暮色） |
| laba | fest-laba | 18,666 | `c1ae3793…` | PASS（腊八粥） |
| yulanpen | fest-yulanpen | 12,888 | `55b83202…` | **待修/确认**：偏浅、与中元近似、alt 不符 |
| xiezao | fest-xiezao | 18,200 | `71c14231…` | PASS（灶壶/果品）；alt“糖瓜”不符→改 alt |
| jizu | fest-jizu | 32,624 | `3f733ceb…` | 图可用（窗前花束）；alt“供桌/庭院”不符→改 alt |
| shangsi | fest-shangsi | 61,096 | `5cac3a40…` | PASS（春水柳枝） |
| chongyang | fest-chongyang | 43,112 | `82824d83…` | PASS（菊花） |

## 后续
- 通过前不接 App；yulanpen/alt 修正后需新 SHA；12 hero 仍 pending-design；内容行 NOT RUN；矩阵 100/33/55 不变。

## Delta 复检（PM 修正后）
- 映射 SHA `256135dd…`；dongzhi alt 仍与黄坛画面不符；yulanpen 新图已脱离中元但偏浅、alt“暮色”不符；chunjie/qingming/xiezao/jizu alt 通过（jizu 白菊措辞略窄）。详见 `qa/CONTENT-HERO-RECHECK.md`。

## 最终 delta 结论（PASS）
- `CONTENT-HERO-MAP` SHA `53c79f16…`；dongzhi/yulanpen alt 与画面一致；12 行 path/bytes/SHA/16:9 全匹配。
- **hero 映射/视觉 PASS**；12 hero 仍 pending-design，待 dev 集成；内容行不自动 PASS；矩阵不变。
