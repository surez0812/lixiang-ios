# R14 非作者 QA · 首批（更新 2026-11-13）

## 构建/安装
- `scripts/r14-build.sh` 仍 **exit 74**：xcodebuild 无法写 `~/Library/Caches/org.swift.swiftpm/...`（Operation not permitted）；加 `HOME/.qa` 后仍被本机环境拦，非产品编译错误。
- 使用新 dev build：`/private/tmp/lx-r14-dd/.../Lixiang.app`，1.0(13)，`Lixiang` SHA `f62b1ec3…`（21:41 构建，HEAD 284ebd0 颜色/字体修复后）；`r14-sim-qa.sh` 安装/启动流程已跑通。
- 新 HEAD `b95ee61` 的修复（SelectionScreen）通过 dev 证据 `r14-iphone-tab2.png` / `r14-ipad-landscape-tab2.png` 复核；本机未重打新 app。

## 五 Tab 首屏
| Tab | iPhone 16 Pro | iPad Pro 13 横屏 | Duo 内屏 |
|---|---|---|---|
| 日历/home | **PASS** | **PASS** | **PASS**（Closed Portrait） |
| 岁时/folklore | **PASS** | **PASS** | **PASS**（Closed Portrait） |
| 择日/selection | **PASS**（dev b95ee61 证据） | **PASS**（dev XCUITest 证据） | **PASS**（Closed Portrait） |
| 倒计日/countdown | **PASS**（空态） | **PASS** | **PASS**（Closed Portrait） |
| 设置/settings | **PASS** | **PASS** | **PASS**（Closed Portrait） |

- iPad 横屏 5 Tab 为真实 2752×2064；portrait 未覆盖，矩阵 portrait 仍 NOT RUN。
- 择日证据：`qa/evidence/firstbatch-v2/iPhone16Pro-tab2.png`（`8a2eb101…`）、`iPadPro13-tab2.png`（`84368cf9…`）。
- Duo：新建设备 `R14-Duo`（B77A…）Closed Portrait 5 Tab **PASS**，外屏 1398×2034；证据 `DuoNew-tab0..4.png`（`184a2620…`/`6b41fc49…`/`251debbd…`/`5e30cf78…`/`7daa02ea…`）。
- 其余 Duo 姿态 Closed Landscape/Tent/Tabletop/Open 仍需 DeviceHub，保持 **NOT RUN**。旧 668C inner 黑为姿态/显示问题，已弃用。
- 首次 12s iPhone 截图 Home 为冷启动未完成，20s 重拍正常，不计产品 FAIL。

## 动态字体
- `-LixiangTypeScale xl` 的 Home/Almanac/Compass/Daily/Folklore-detail **PASS（补充项）**；证据 `qa/evidence/dynamic-v2/`；详见 `qa/DYNAMIC-TYPE.md`。
- 不纳入 188 设计状态计数；VoiceOver/a1/组合姿态 NOT RUN。

## 矩阵
- `docs/R14-QA-MATRIX.md`：**37 PASS / 5 FAIL / 146 NOT RUN**（另 X-01..X-05 动态字体 PASS），SHA `a1cf7da0…`；计数检查 `docs/R14-QA-COUNT-CHECK.md` 一致。

## 未测
- 天气六态（仅 initial）、VoiceOver、E2E 16 场景、Duo 其余姿态：NOT RUN。
- 不 merge/发布/提审；未改产品代码。

## Duo 旧 UDID 重试记录（已由新设备解决）
- 按 Lead 指定 UDID `668C5E37-CCD6-474C-B9B3-7D985287F0CE`：boot OK；`simctl install` OK；launch **失败**：`FBSOpenApplicationServiceErrorDomain code=5`，SpringBoard crash；重新 enumerate 后 display UUID 变化，tab1 起截图报 `Device does not have a '<old-uuid>' display port`。
- tab0 抓到 2007×2853 黑屏+加载星（SHA `9d74f3bb…` 转 RGB），无 UI。
- **仍 NOT RUN**；矩阵不引用 Lead 证据冒充非作者 PASS；Duo 其余五姿态仍待 DeviceHub。


## 颜色/字体基线（HEAD 284ebd0）
- 新 build 已重截首批与暗色：`firstbatch-v2/`、`visual-v2/dark-*`；旧截图颜色作废。
- 模拟器无 Songti/Kaiti，回退系统 serif；设计字体差异记为已知偏差，不标 PASS。


## 暗色品牌卡（HEAD 4d84b2e）
- Settings/Countdown/Folklore dark 已重截并 PASS：`qa/evidence/visual-v2/dark-{settings,countdown,folklore}-v2.png`（`9042b7f9…`/`b2f9cff3…`/`53d5b2a2…`）。
- 品牌卡恢复深红；Home/Almanac/Compass dark 仍用 `visual-v2/dark-*`。
- 字体偏差保持已知缺陷，不标 PASS。


## 天气 / Fortune（新 debug）
- 天气 initial/locating/denied/failed/loaded **5 PASS**；denied→系统设置返回 **NOT RUN**。
- Fortune 0ms/1050ms/1450ms 与结果态 **PASS**；180/600 为数学零交叉 NOTE；300/450/800/900 运动帧 PASS。
- 证据 `qa/evidence/weather-fortune/`；详见 `qa/WEATHER-FORTUNE.md`。
- 矩阵：37 PASS / 5 FAIL / 146 NOT RUN + X5 + W5/W1 + F3 PASS/2 NOTE + M4 PASS。


## iPhone portrait 新状态
- home no-matches / almanac previous+next+no-festival / compass hour 03·09·15·21 共 5 项 **PASS**。
- 证据 `qa/evidence/portrait-states/`；详见 `qa/PORTRAIT-STATES.md`。


## 交互状态
- Selection 结果列表 PASS（S-01；年份无千分位、含日期/宜/忌/看当日）。
- Countdown 详情 PASS（行 97；生日/2027-02-06/85天/农历每年/提醒09:00）。
- 证据 `qa/evidence/portrait-states/`；详见 `qa/INTERACTION-STATES.md`。


## Almanac 冬景 / Countdown 空态 / Daily 分享
- almanac winter（12-22）**PASS**（行 162）。
- countdown empty（重装）**PASS**（行 37）。
- Daily 分享页 **PASS（D-01 已修）**：全屏卡片+二维码+系统分享。
- Folklore 正文「内容准备中」，不标读，按内容缺口。
- 证据 `qa/evidence/portrait-states/`；详见 `qa/ALMANAC-COUNTDOWN-SHARE.md`。


## iPad portrait 5 Tab
- home/岁时/择日/倒计日/设置 **PASS**（XCUITest portrait，2064×2752）；矩阵行 3/27/39/51/63。
- 证据 `qa/evidence/ipad-portrait/`；portrait 其余状态仍 NOT RUN。


## iPad landscape 路由视觉对照
- almanac/compass/daily/fortune/selection 5 页均与设计两列布局不符，矩阵标 **FAIL/偏差**（详见 `qa/IPAD-LANDSCAPE.md`）。
