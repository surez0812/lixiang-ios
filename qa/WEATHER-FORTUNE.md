# Home 天气六态 / Fortune 关键帧证据

## 天气（新 debug `-LixiangWeatherState`）
| 状态 | 结果 | 证据 |
|---|---|---|
| initial | **PASS** | `qa/evidence/firstbatch-v2/iPhone16Pro-tab0.png` |
| locating | **PASS** | `qa/evidence/weather-fortune/r14-home-weather-locating.png`（`326c049c…`） |
| denied | **PASS** | `qa/evidence/weather-fortune/r14-home-weather-denied.png`（`42030862…`） |
| failed | **PASS** | `qa/evidence/weather-fortune/r14-home-weather-failed.png`（`e565f432…`） |
| loaded | **PASS** | `qa/evidence/weather-fortune/r14-home-weather-loaded.png`（`31de88b6…`） |
| denied→系统设置返回 | **NOT RUN** | 需系统设置返回重读；未测 |

## Fortune 1450ms
| 时间 | 结果 | 判断 |
|---|---|---|
| 0ms | **PASS** | `r14-fortune-frame0.png` `aaf6270f…`；待机/标题常驻 |
| 180ms | **NOTE** | ApprovedFortuneCore 零交叉（angle=0/press≈1）；与 0ms 同 SHA 属数学正确，不标 FAIL |
| 600ms | **NOTE** | s=1、sin(4π)=0、lift=0；与 0ms 同 SHA 属数学正确，不标 FAIL |
| 1050ms | **PASS** | `r14-fortune-frame1050.png` `e7d82c93…`；签筒升起 |
| 1450ms | **PASS** | `r14-fortune-frame1450.png` `731ff0aa…`；结果全显、标题常驻 |

- 结论：0/180/600 同图是冻结数学零交叉，180/600 记 NOTE，不计 FAIL。补充运动帧 300/450/800/900 均不同且 PASS；1050/1450/结果态 PASS。
- 矩阵 fortune 默认/结果行已按 0/1450 证据 PASS；关键帧补充 F-02/F-03 FAIL。


## 运动关键帧补充
- 300ms `d0dd17ab…` 轻摇正向
- 450ms `5c531865…` 反向
- 800ms `580a4ede…` 升签中段
- 900ms `0c728f64…` 接近升起
- 证据均在 `qa/evidence/weather-fortune/`。
