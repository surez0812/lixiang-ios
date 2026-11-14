# 12 hero delta 复检清单（待 PM 修正后执行）

- 基线：`qa/CONTENT-HERO-QA.md`（6 PASS / 5 alt 不符 / yulanpen 待修）。
- 预算/计数：candidates **40 = 39 可用（24节气+15节日）+1 test**；56 次/¥11.2；未接 App。
- 12 hero 仍 **pending-design**；复检通过前不接 App；内容行 NOT RUN；矩阵不改。
- 只复检 delta，不重审全部 12。

## A. 5 张 alt 修正（图已可用）
| id | 现 alt 问题 | 复检 acceptance |
|---|---|---|
| dongzhi | “柳枝薄冰与暖灯”与黄坛/罐画面不符 | alt 改为画面实际（黄坛/冬日静物）或补图；文字不得虚构 |
| chunjie | “红灯笼与团圆桌”无桌 | alt 删“团圆桌”，保留灯笼/节庆 |
| qingming | “柳枝青山与细雨”无山/雨 | alt 只写柳枝/清明语境，或补山雨图；选择需 PM 确认 |
| xiezao | “灶台茶壶与糖瓜”无糖瓜 | alt 改为灶壶/果品等实际元素 |
| jizu | “家庭供桌与庭院”无供桌/庭院 | alt 改为窗前花束/追思语境，避免错误叙事 |

## B. yulanpen 新图/复用理由
- 现图 `fest-yulanpen.webp` 12,888B，浅绿水面+3小灯，非暮色，与中元近似。
- 通过条件（二选一）：
  1. 新图：暮色/静水/河灯，与中元图有可辨识差异；16:9 1024×576，≤120KB，无伪文字/人物/宗教场所；新 SHA/bytes。
  2. 复用理由：PM/设计书面说明为何该图可代表盂兰盆且不改 alt；QA 仅记录，不自行接受。
- 仍须 alt 与画面一致。

## C. 记录
- 每个修正项给新 alt/新文件 SHA/bytes；只复检 delta；不重审全部 12。
- 通过前不接 App；hero pending；内容行 NOT RUN；矩阵 100/33/55 不变。

## 复检结果（2026-11-14 PM 修正后）
- 映射 `CONTENT-HERO-MAP` SHA `256135dd…`：12 行 path/bytes/SHA/16:9 全部匹配；39 可用+1 test；57次/¥11.4。
- **5 条 alt**：
  - chunjie（三盏红灯笼）PASS
  - qingming（垂柳）PASS
  - xiezao（灶台茶壶与橘子）PASS
  - jizu（窗下花束）基本 PASS（画面含红/白菊，alt“白菊”略窄但不虚构）
  - **dongzhi FAIL**：alt 仍写“暖黄灯笼”，画面实际为黄色坛/罐，无灯笼；需再改 alt 或补图。
- **yulanpen 新图**：90,836B/SHA `5c60aa8b…`/1024×576；已是荷塘白莲、无灯/文字/人物/宗教场所，**与中元河灯区分**；但画面为浅色白天荷塘，**并不“暮色”**，alt“暮色荷塘白莲”与画面不符 → **待修 alt/暮色**，资产本身无红线。
- 结论：delta 未全通过（dongzhi alt + yulanpen alt/暮色），**不接 App**；其余 4 条 alt 与映射通过；hero 仍 pending；内容行 NOT RUN。

## 最后一轮 delta（仅 2 项）
- 前置：`qa/CONTENT-HERO-RECHECK.md` 当前结论；12 hero 仍 pending、不接 App。
- 只核这两项，不重审其余 10 条。
1. **dongzhi**：当前 alt“暖黄灯笼”与画面黄色坛/罐不符。通过条件：改 alt 为画面实际（坛/罐/冬日静物）或重跑为灯笼图；新 mapping bytes/SHA。
2. **yulanpen**：当前图荷塘白莲已脱离中元、无红线，但画面偏浅白天，alt“暮色荷塘白莲”不符。通过条件：改 alt 去掉“暮色”（如“荷塘白莲”）或重跑暮色版；新 mapping bytes/SHA。
- 映射：`CONTENT-HERO-MAP` 当前 SHA `256135dd…`；修正后需新 SHA；12 行 path/bytes/SHA/16:9 仍匹配。
- 通过后交 dev 集成；12 hero 转正前仍 pending；内容行不自动 PASS；矩阵不改。

## 最终 delta 结果（PASS）
- `CONTENT-HERO-MAP` SHA **`53c79f164d832e691bef2c80d796b20643981116218187c9c3e909981b623d6b`**。
- **dongzhi alt**：「冬至，暖黄陶罐（温酒器）」与画面黄陶罐一致 → PASS。
- **yulanpen alt**：「盂兰盆，荷塘白莲」与画面白莲/荷塘一致，已去掉“暮色” → PASS。
- 12 行 mapping path/bytes/SHA/16:9 全部匹配；bytes/SHA 未变。
- **最终 PASS（hero 映射/视觉）**；12 hero 仍 pending-design 直到 dev 集成；内容行不自动 PASS；矩阵不改。
