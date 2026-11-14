# Countdown detail phone / Daily phone / Compass phone

## Countdown detail
- **行97 phone-light PASS**：生日 / 2027-02-06 / 还有85天 / 农历每年 / 本地通知开 / 09:00。
- **行98 phone-dark PASS**：同字段，深色可读。
- 证据：`qa/evidence/countdown-detail-phone/`。
- iPad 行99-102 按 Lead 要求保持 **NOT RUN**（CLI 空白，待 XCUITest）。

## Daily
- **行73 phone-light PASS**：新卡片结构，经文/出处/含义/应用/今日分享卡（含二维码）可见。
- 证据：`qa/evidence/daily-redesign/r14-daily-redesign-light.png` `5cd55ffe…`。

## Compass
- **行121 未评 PASS**：`r14-compass-selector-light.png` 实际是**时方位**（已选「时方位」+「午时·甲午 11:00—12:59」），不是行121要求的默认日方位；该图已用于行175。默认日方位仍缺证 → NOT RUN。

## Compass 日方位复评（第二次）
- `r14-compass-day-light.png`（`b2c8eeb8…`）实际为 **Home 首屏**（日期/经文/每日一签/黄历），不是罗盘日方位页 → 行121 仍 **NOT RUN**。
- 需真正罗盘页、默认「日方位」、无选择时辰下拉的截图。
- 矩阵计数不变：90 PASS / 0 FAIL / 98 NOT RUN。

## 复评（XCUITest 重拍）
- **Compass 行121 light PASS**：默认「日方位」选中、无选择时辰下拉、盘面五神+煞方+十二时辰；`67df00b8…`。行122 dark 同结构 PASS（`62f45f2f…`）。
- **iPad countdown-detail 行99-102 PASS**：portrait/landscape light/dark 均 生日/2027-02-06/85天/农历每年/提醒09:00；无空白。
- 之前 `r14-compass-day-light.png` 的 Home 假图作废。
- 矩阵：95 PASS / 0 FAIL / 93 NOT RUN。
