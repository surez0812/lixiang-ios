# R14 设备范围修正

| 用户意见 | 处理 | 证据 |
|---|---|---|
| iPhone只做portrait，不需要两款phone-landscape | 从模式列表、全部页面/PNG、索引与当前交付包移除浅/深普通iPhone横屏；保留iPhone竖屏浅/深 | screens.json、R14-MODE-VALIDATION.json |
| duo-tabletop其实是竖屏，用duo-open-portrait布局保持一致 | Tabletop改669×951pt（2007×2853px），直接共享Open Portrait页面布局；顶部浮动状态/按钮、底部浮动玻璃Tab、各页竖屏结构一致 | Tabletop全部14个页面/状态与Open Portrait规范化HTML一致，PNG逐字节相同 |

当前12种画布，共188张PNG/HTML。Splitview继续不设计。前轮普通iPhone横屏裁切补丁属于已移除设备的历史记录，不再列为本轮验收项；原R13目录保留历史。

日期链路、标题常驻、冻结动画与build12均不改。静态图复用关系见R14-RENDER-PROVENANCE.json，未将复用图宣称为新浏览器截图。


## 首页双卡补充

首页双卡使用内容自适应等高布局，取消固定112/156pt高度；标题行与说明／操作行水平对齐。详见 HOME-TOOLS-UPDATE.md。
