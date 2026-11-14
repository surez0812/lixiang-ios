# 内容详情行 85-90/163/174 验收（hero 已接入）

- 用例：`qa/CONTENT-DETAIL-ROWS-CASES.md` SHA `db027641…`；包 `38b34c5a`（hero3；events `79b80283`）。
- 设备：R14-QA-iPhone `0B71AEF4`、R14-QA-iPad `415BFB3F`；未碰锁定机。
- 证据：`qa/evidence/content-detail-rows/`。
- **矩阵不改；以下逐行按证据标 NOT RUN，不整批、不以首屏/hero 接入冒充 PASS。**

## 逐行
| 行 | 当前证据 | 判定 | 缺什么 |
|---:|---|---|---|
| 85 phone-light | `row85-phone-light.png`：真实 chongyang 已过去/今天、hero/正文/来源可见；`force-loading/fail/offline` 三态各一张，failed 有「岁时内容加载失败+重试」 | **NOT RUN** | 未验证 eventID+版本展示、成功才已读/重复读、失败重试成功链路；alt/VoiceOver 未验 |
| 86 phone-dark | `row86-phone-dark.png`：dark 详情 hero/正文/来源可见 | **NOT RUN** | 同 85 的 eventID/version/read/retry/alt 未验；仅 dark 默认态 |
| 87 iPad portrait-light | `row87-ipad-portrait-light.png`（2064×2752）：iPad 详情、hero/正文/2 sources 可见 | **NOT RUN** | 未验证 loading/offline/failure、eventID+版本、read；alt 未验 |
| 88 iPad portrait-dark | `row88-ipad-portrait-dark.png`：dark 同上 | **NOT RUN** | 同 87 缺状态/边界/alt |
| 89 iPad landscape-light | **无有效 landscape 证据**：`screenConfig geometry 2752x2064/1194x834` 均报 no mode；未生成有效 landscape 图（仅 `row89-invalid-portrait-not-landscape.png` 误拍，已改名） | **NOT RUN** | 缺 iPad landscape 姿态/模式；不能把 portrait 图当 landscape |
| 90 iPad landscape-dark | 无 landscape 证据（同上） | **NOT RUN** | 缺 landscape 姿态 + dark 状态 |
| 163 今日解锁/已读 | `row85-phone-light.png` 日期=event 今天，详情可读；未做已读/跨日 | **NOT RUN** | 缺成功 markRead、未读→已读、跨日/重启持久化、失败不标读 |
| 174 375×2400 长图 | 仅首屏 1206×2622；未生成长图 | **NOT RUN** | 缺 375×2400/2500 全量滚动；不得首屏冒充；当前内容高度/资产是否足够未证 |

## 说明
- 85/86/87/88 的默认详情 hero/正文/sources 视觉可作为补充证据，但验收项未齐，故不 PASS。
- 89/90 设备窗口无法旋转到 landscape（simctl screenConfig 无有效 landscape mode）；需真实 landscape 窗口。
- 174 需长图采集/long screenshot 工具；当前未执行。
- 内容行仍 NOT RUN；hero 已接入不等于内容/PAGE-CONTRACTS PASS；矩阵 100/33/55 不变。
