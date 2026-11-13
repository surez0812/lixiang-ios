# iPhone portrait 状态证据（新 debug，HEAD 含 weather/fortune）

- 证据目录：`qa/evidence/portrait-states/`；全部 iPhone 16 Pro portrait 1206×2622。
- `-LixiangDebugDate` 冷启动 6–8s 后截图；已按证据评估。

| 状态 | 结果 | 证据/判断 |
|---|---|---|
| home no-matches（2026-06-15） | **PASS** | `r14-home-no-matches.png` `b5965414…`；无岁时/纪念入口、无空占位 |
| almanac previous（11-12） | **PASS** | `r14-almanac-previous.png` `09f36b4e…`；日期/农历/宜忌整组刷新 |
| almanac next（11-14） | **PASS** | `r14-almanac-next.png` `70931d8b…`；日期/农历/宜忌整组刷新 |
| almanac no-festival（06-15） | **PASS** | `r14-almanac-no-festival.png` `dad4eb3e…`；无岁时 panel |
| compass hour 03/09/15/21 | **PASS** | `r14-compass-hour{3,9,15,21}.png`（`4acfbf8b…`/`4731af4a…`/`673fac58…`/`866021e8…`）；时方位/煞方随 4 个时辰变化 |

- 仅 iPhone portrait 行；iPad/其他画布仍 NOT RUN。
- 矩阵：home 157、almanac 161/187/188、compass 175 已 PASS。
- 不 merge/发布/提审。
