# R14 屏幕矩阵摘要

来源：`r14-final/screens.json`（188 条，12 画布、11 页面类）；PNG 均存在（188/188）。

## 模式
| 模式 | 数量 |
|---|---|
| phone-light | 34 |
| phone-dark | 14 |
| ipad-portrait / dark | 14 / 14 |
| ipad-landscape / dark | 14 / 14 |
| duo-closed-portrait | 14 |
| duo-closed-landscape | 14 |
| duo-tent | 14 |
| duo-open-portrait | 14 |
| duo-open-landscape | 14 |
| duo-tabletop | 14 |

## 页面
almanac 30、fortune 24、compass 24、home 17、countdown-detail 17、folklore-detail 15、daily 13、folklore 12、countdown 12、settings 12、selection 12。

## 高风险（视觉验收重点）
- home 17 状态：双卡等高/标题对齐/长城市/权限/天气五态；普通 iPhone 仅 portrait。
- fortune 24：1450ms 五关键点/标题常驻/结果不内部滚动/减少动态；Duo Tabletop 与 Open Portrait 同构。
- almanac 30：白话 compact/expanded、日期整组刷新、宽屏双列独立滚动。
- daily 13：长文/动态字体/poster 二维码；分享只亮色。
- Duo：六姿态；tabletop 与 open portrait 共享 669×951 竖屏布局。
- 普通 iPhone 无 landscape；Split View 不在范围。
