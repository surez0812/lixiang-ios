# R9 最新反馈逐条覆盖

| 用户意见 | 本轮处理 | 审核入口 |
|---|---|---|
| 所有页取消 navigation title，按钮浮动 | 10 类页面移除标题容器与预留行；子页独立返回按钮 | 任一 HTML、黄历/每日一句 |
| iPad 首页无岁时/择日 panel，择日进全局 bar | 首页只保留 Hero、签/天气、黄历、月历；五 tab | home-ipad-landscape |
| iPad 禁止左右滑切今日详情 | 无滑动日期切换；月历直接跳黄历 | home-ipad-portrait |
| iPhone/Duo 合并首页与今日详情，删除旧页 | 所有设备统一首页，无 day 页面文件 | home-phone-light-full |
| 月历点击日期进黄历 | 所有模式均 almanac?date，保留所选日期 | home 任一模式 |
| 竖屏首页规定顺序 | Hero→签/天气同排→黄历→月历 | home-phone-light-full |
| 倒计日标准数字 badge | 红底白字、无描边/额外红点，原生字符串 0 方案 | 所有五项导航 |
| Hero 岁时和纪念日不用划线但可点击 | 无分割线柔色入口、箭头、独立详情 URL | home-phone-light |
| Duo Hero 透明过渡 | 浅/深色 alpha 层，Duo 也覆盖图底部 | home-duo-open-portrait |
| 黄帝/道历相同时合并 | 同年一行双名称；异年三行分开 | almanac-phone-light-plain-off |
| 黄历仅当天 match 岁时，list 可进入详情 | 精确日期过滤，无匹配隐藏，多个支持列表 | almanac-phone-light / -no-festival / -winter |
| 白话关闭将宜忌收拢两项 | 完整保留 15 宜/6 忌，恰好两项换行；可重开 | almanac-phone-light-plain-off-full |
| Duo open portrait 使用新正确截图，顶状态/底 tab | 新参考 2007×2853 已校验；669×951pt | home-duo-open-portrait |
| Duo tabletop 顶状态/底 tab | 按最新要求横向内容、顶状态/底五 tab | home-duo-tabletop |
| close landscape/open landscape/tent 减少侧栏空隙 | 8pt 内容净距、无标题占位 | 对应 home 模式 |

继承项保留：无印章；D1 纸色/深墨/朱色风格；经文解释与二维码分享；定位/通知拒绝后 App 内状态；岁时远程正文模板和原生外壳；完整黄历、十二时辰与罗盘；四类经文；已批准动画核心与素材冻结；每日一签本地确定性；build12 只内测。

交付为设计审核状态。272 项源代码检查和 Node 动画四项逻辑测试通过，不包含浏览器/模拟器实测，详见规格中的验证边界。

原始 A1–F3 意见与上一轮覆盖记录留存于 `history/`；冲突时本轮用户意见优先。
