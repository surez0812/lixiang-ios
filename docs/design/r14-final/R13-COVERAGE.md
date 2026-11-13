# R13 最新意见覆盖（重复项已合并）

| 意见 | 本轮处理 | 审核入口 |
|---|---|---|
| 仅iPhone/iPad罗盘按钮移右上、写“值神罗盘” | 普通设备黄历左右分置返回/文字玻璃按钮；Duo继续原侧栏相邻图形按钮 | almanac-phone-light.html / almanac-ipad-portrait.html |
| iPhone Portrait首页工具卡过高、图标粗体一行、与黄历贴住 | 156→112pt；签筒图和标题同排；天气图标和标题同排；工具组与下方黄历16pt间距 | home-phone-light.html |
| Duo Close Portrait同样压缩工具卡 | 112pt同高、图标标题同排、16pt间距 | home-duo-closed-portrait.html |
| Duo Close Landscape工具卡和Hero命中入口 | 工具112pt；岁时/纪念同排，Hero拿回44pt高度 | home-duo-closed-landscape.html |
| Duo Close Landscape岁时filters可换行 | flex-wrap:wrap，无水平滚动条 | folklore-duo-closed-landscape.html |
| Duo Close Portrait/Close Landscape岁时详情上下结构、短头、正文满宽 | 紧凑网格标题头，正文iframe占满可用内容宽度；上下布局不再左右分栏 | folklore-detail-duo-closed-portrait.html / folklore-detail-duo-closed-landscape.html |
| 一签在iPhone、iPad竖屏、Duo Close/Open Portrait、Tabletop标题居中 | 标题和签筒中心线对齐；Tabletop明确上/下结构 | 对应fortune页面 |
| 一签在iPad横屏、Duo Close/Open Landscape标题左侧且垂直居中 | 标题中心对齐签筒/结果区域中心，而非含操作区的整列中心 | fortune-ipad-landscape.html / fortune-duo-closed-landscape.html / fortune-duo-open-landscape.html |
| 结束后标题保留，签文不能上下滚 | 独立常驻页面标题，结果纸全量排版；短高度采用签诗/解释两列，不放内部ScrollView | 所有fortune-*-result.html |

验证：当前10条签文×14种画布共140组完整排版可容纳；完整HTML离线布局检查14种标题中心线和正文末尾边界；28个待机/结果页在实际DOM中运行冻结动画到0/180/600/1050/1450ms，标题均保留。日期根节点修复链路继续回归。以上不等同Chrome绘制或原生iOS验收。

保留：冻结签筒素材、1450ms动画核心、视频/每日固化逻辑；build12不改、不提审。标题的展示属于本轮页面层调整，不再跟随旧标题淡出。

## 两款短横屏最小补丁

独立Chrome验收发现浅/深iPhone横屏的20组签文受500px遗留最小高度影响；其余120组报告通过。已仅对这两款重置min-height/viewport高度/定位，缩小内边距和行隙，重新导出4张PNG并更新包。真实祖先CSS的20组DOM约束回归通过，去掉补丁的负向对照能恢复500px。修复后Chrome几何仍待复核，见R13-SHORT-PHONE-FIX.md。
