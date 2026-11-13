# 当前 R14 接入

本轮变更以 R14-LayoutContract.md 和 ../R14-DESIGN-SPEC.md 为准，下方为 R9 留存参考。

# 当前 R13 接入

本轮变更以 R13-LayoutContract.md 和 ../R13-DESIGN-SPEC.md 为准，下方为 R9 留存参考。

# 当前 R12 接入

本轮变更以 R12-LayoutContract.md 和 ../R12-DESIGN-SPEC.md 为准，下方为 R9 留存参考。

# 当前 R11 接入

本轮变更以 R11-LayoutContract.md 和 ../R11-DESIGN-SPEC.md 为准，下方为 R9 留存参考。

# 当前 R10 接入

本轮变更以 R10-LayoutContract.md 和 ../R10-DESIGN-SPEC.md 为准，下方为 R9 留存参考。

# R9 iOS 设计接入

当前规范以 `../R9-DESIGN-SPEC.md`、`../R9-COPY.md`、`../R9-COVERAGE.md` 为准。文件夹中 R8 命名文档/验证是历史证据，涉及布局冲突时不得作为当前要求；原有动画文件仍为冻结依据。

1. 首页统一合并；删除独立 day 页面与滑动选日处理。月历仅 push almanac(date)。首页竖屏顺序见最新规格。
2. 五个原生 tab：calendar、folklore、selection、countdown、settings。新增 TabSelection.imageset 为保留矢量 PDF；已有四个图标继续使用。
3. 没有 navigation title，也没有空标题行。隐藏旧 navigation bar；返回等按钮叠在内容上，保留正文避让及系统 safe area。不要绘制模拟状态栏。
4. `R9NavigationReference.swift` 给出五 tab、可选字符串 badge（含今天 0）、浮动返回的接入意图；是未编译的参考片段，不是可安装 App。placeholder 内容由真实页面替换。
5. 当日岁时按黄历所选日期过滤；无结果无 panel。白话关闭仅宜/忌两个文本项目，开启逐项解释。纪元同值合并、异值分开。
6. 使用现有 approved 素材、`ApprovedMotionManifest.json` 及 1450ms timeline。调整容器不改变签筒遮挡/木签轴心/每日持久化。
7. 定位/通知采用真实系统授权：用户主动点击后请求；通知拒绝时仍有 App 内提醒。网页示意按钮不能替代真实通知注册。
8. Duo 顶底/侧栏形态按最新规格，safe area 及系统容器的实际适配需要在目标 Device Hub / simulator 验证。设计 PNG 为离线合成，无原生运行结论。

`DailyDrawStore.swift`、FortuneAnimationView/AdaptiveDemoView、ReminderPermissionReference 等沿用前轮参考。此次没有编译、安装、修改 build12 或提审。
