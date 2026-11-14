# Compass 选择时辰 light/dark 对照

- 设计稿 `compass-phone-light-hour.png` / `compass-phone-dark-hour.png` 均含「时方位 + 选择时辰下拉 + 时间范围」；新图符合该结构。
- 证据：`qa/evidence/compass-selector/`。

## Light（行175）PASS
- 时方位；选择时辰「午时·甲午」；时间范围 11:00—12:59。
- dial 五神标签（喜/财/福/阳贵/阴贵）可见；煞方 正北。

## Dark（行176）PASS（已修）
- 时方位；选择时辰「午时·甲午」；时间范围 11:00—12:59。
- **dial 五神 pill 可见**（喜/福/财/阳贵/阴贵，深墨文字）；煞方正北。
- 证据：`qa/evidence/compass-selector/r14-compass-selector-dark-v2.png` `4a1cb98c…`。
- 五神位置固定、煞方随时辰变：待设计确认。

- 不 merge/发布/提审。
