# R12 最新意见覆盖

| 意见 | 本轮处理 | 审核入口 |
|---|---|---|
| 删除黄历大号“十二” | 移除 rounddate 节点，保留公历、农历和干支 | almanac-phone-light.html |
| 罗盘按钮重做、与返回按钮相邻 | 采用用户明确允许的 Liquid Glass bar button 方案；移出主卡，和返回组成浮动44pt按钮组；Duo侧栏模式两按钮在右栏相邻 | almanac-phone-light.html / almanac-duo-open-landscape.html |
| 罗盘页空白 | 罗盘改为自包含HTML/CSS/脚本，不再继承多轮页面布局脚本；初始完整罗盘DOM和图例无需JS即可显示，保留日/时及十二时辰 | compass-phone-light.html / -hour.html |
| iPhone/iPad 顶部无额外间距 | 内容从36pt状态区之后开始，无额外12pt间隔；返回按钮浮于内容 | 所有普通iPhone/iPad页面 |
| 底部Tab浮动Liquid Glass | 内容视口延伸到Tab后方，材质半透明；末尾留滚动避让，Tab不是独立占位条 | home-phone-light.html |
| Tent入口同一行、工具矮、Hero高 | 两个命中入口强制同排；工具156→108pt；Hero拿回48pt，并压缩正文间距 | home-duo-tent.html |
| Tent黄历顶对齐、压缩并露全月历 | 黄历摘要上边距清零、字号间距压缩；月历日期格35pt，整月在右列展示 | home-duo-tent.html |
| Open Landscape右侧状态与导航 | 明确side-duo，只有右侧floating-tabs，没有底部tabs；内容距栏8pt | home-duo-open-landscape.html |
| Open Portrait默认顶距、按钮浮动 | 内容顶部12pt；状态/返回覆盖页面，底部玻璃Tab覆盖内容 | home-duo-open-portrait.html |
| 不再设计splitview | 新输出中没有splitview页面、PNG和索引项；历史原始参考不删除 | screens.json |

共216张PNG/HTML，14种画布：移除2个splitview，同时补充本轮提及的普通iPhone横屏浅/深设计参考。此补充不修改App原先旋转策略。罗盘每种画布均有日/时两态（28张）。

选择的是“Liquid Glass bar button”替代方案，没有调用或虚构app icon生成skill。当前图标为玻璃控制内的导航符号，不新增App图标资产。按钮图层、日期跳转、罗盘状态和导出检查有记录；本chat未运行浏览器，因此不把离线可见性检查等同用户设备上的空白问题已实测验收。

最终离线检查：Tent右列436pt≤438pt；14种模式完整罗盘HTML初始布局均有正尺寸内容框。日期/十二时辰切换、286项结构/语法及216张导出检查通过。

## 日期参数阻断修复

专用日期叶子选择器替代通用data-selected-date，禁止覆盖页面根节点。14模式完整日期链路、跨年/平闰年共93次真实DOM正向执行通过；旧选择器负向对照可重现并拦截页面丢失。详情见R12-DATE-ROOT-FIX.md。日期修复后的Chrome运行仍待协作方复核，尚不宣布整轮验收通过。
