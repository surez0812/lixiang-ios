# R10 本轮意见覆盖

| 修改意见 | 处理结果 | 审核文件 |
|---|---|---|
| iPhone 岁时 filter 占三行 | 单行、44pt 点击高度，横向滑动，不换行 | folklore-phone-light.html |
| 岁时详情顶部大标题空 | 紧凑标题区：分类、标题、短引导、日期/解锁状态和分享；正文紧接 | folklore-detail-phone-light.html |
| iPad 横屏首页工具卡底部切 | 左列给工具组固定 156pt，加 16pt 间距；Hero 使用剩余高度 | home-ipad-landscape.html |
| 每日一签/天气左对齐不舒服 | 图、标题、辅助文案与按钮居中，同高双卡 | home-phone-light.html |
| 分享卡 iPad 横屏左右结构 | 左列经文解释，右列分享卡和二维码/分享操作 | daily-ipad-landscape.html |
| 历法纪年合入黄历主卡 | 主卡日期下显示合并纪元，不再独立纪年卡 | almanac-phone-light.html |
| 当日岁时合入主卡底部 | 精确日期匹配列表在主卡内；无匹配无区块，主卡自然增高 | almanac-phone-light.html / -no-festival.html |
| 主卡右上角日罗盘，舍弃时罗盘 | “今日罗盘”入口跳独立日方位页；无时方位切换；返回黄历 | compass-phone-light.html |
| 横屏黄历左右满高、独立滚 | 固定外视口，左右 100% 高度，独立 overflow-y:auto；十二时辰不再内嵌第二层滚动 | almanac-ipad-landscape.html / almanac-duo-open-landscape.html |
| Duo Close Portrait 纪念日按钮与卡片贴住 | 按钮 48pt，下面明确 20pt 间距 | countdown-duo-closed-portrait.html |

继承 R9 的统一首页、五 Tab、无导航标题、Hero 渐隐、原始反馈留存与动画冻结。原生 App、浏览器绘制与真实 Duo safe area 未运行验收；PNG 均为离线设计合成。

## 岁时详情运行修正

根据协作验收反馈修复日期覆盖短引导的问题：日期段落使用唯一 `data-event-date`，运行脚本只更新此节点，不再选择第一个 `p`。日期统一为“2026年11月22日”格式；“今日”专项状态默认匹配当日活动，不再被默认小雪覆盖。14 种设备/主题及 3 个专项/完整状态均更新，直接入口、event 参数及 date 参数组合共 85 项生成脚本执行检查通过。17 张相关 PNG 和交付包同步更新。此修正未由本 chat 重跑浏览器绘制验证。
