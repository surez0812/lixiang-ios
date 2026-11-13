# 历象 R14 · iPhone仅竖屏，Tabletop共享Open Portrait

本轮只调整设备范围与布局映射，不重做其他已确认设计。

1. 普通iPhone仅phone-light/phone-dark两个portrait模式，不输出phone-landscape或phone-landscape-dark页面、PNG或审核索引。
2. Duo Tabletop统一使用Open Portrait布局及尺寸：669×951pt，设计PNG2007×2853px。直接共享同一页面布局，保留Tabletop文件名与日期导航路由；所有内容结构、字号、间距、顶部浮动状态/按钮及底部玻璃Tab一致。
3. Tabletop每日一签也使用Open Portrait的上/下布局、常驻居中标题和完整结果，不再保留原951×669横屏构图。
4. iPad横竖、其他Duo模式和普通iPhone竖屏的R13设计保持不变。Splitview仍排除。

共12模式：phone-light、phone-dark；iPad portrait/landscape各浅深；Duo Closed Portrait、Closed Landscape、Tent、Open Portrait、Open Landscape、Tabletop。11类页面加专项状态/长图合计188个PNG/HTML。

一致性检查：Tabletop全部14个页面/状态与Open Portrait规范化HTML一致，14张PNG逐字节相同；新目录无普通iPhone横屏HTML/PNG。日期链路与标题常驻继续实际DOM回归。

图片来源：其他模式沿用未改动的R13图；Tabletop复用对应Open Portrait图，来源记录在R14-RENDER-PROVENANCE.json。均为离线设计合成，不是浏览器或iOS截图。App、build12、动画核心/素材/视频不改，未构建或提审。真实设备safe area仍由接入验证。


## 首页双卡补充

首页双卡使用内容自适应等高布局，取消固定112/156pt高度；标题行与说明／操作行水平对齐。详见 HOME-TOOLS-UPDATE.md。
