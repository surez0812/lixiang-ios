# R8 验证范围

- 601项结构、链接、脚本语法、模板、坐标、像素与定稿资产哈希检查：通过。
- 14条权限／提醒状态流程：通过。执行的是实际页面里的R8脚本，使用Node DOM/storage/timer stub，不是浏览器。
- 4条定稿动画真实时钟逻辑：通过。同日固化、跳过、显式／系统减少动态状态保持。
- SwiftUI自适应host及通知权限参考：syntax parse通过；没有App构建或原生运行。
- 用户6张截图像素尺寸及本地副本SHA-256已记录；所有Duo导出画布与本轮尺寸表一致。

PNG来源：离线HTML片段排版＋原始生图素材／矢量合成。不是浏览器截图，也不是历象的Device Hub运行截图。

尚未验证：浏览器视觉与ResizeObserver运行、真实Core Location、UNUserNotificationCenter排期／到达、WKWebView、VoiceOver、原生TabView、自适应safe area和铰链区域。网页模板只在本地生成，未发布／未接入主站admin。原型通知字段nativeScheduled=false，不能当作系统已注册成功。

R7动画原件保持冻结。历史失败／未验证状态继续保留在R7和更早证据，不在本轮改写为PASS。
