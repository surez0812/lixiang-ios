# 历象 R9 设计规格

2026-11-13。本轮最新反馈为准，覆盖前轮“仅 iPad 合并”“Hero 去掉岁时”“Duo 全部右侧导航”等冲突方案。设计审核版，不修改 App、不构建、不提审；build12 继续内测。

## 页面与信息架构

全局导航顺序：日历、岁时、择日、倒计日、设置。择日是一级 tab，不再出现在首页独立 panel。原独立“今日详情”页面及 day 路由全部删除；首页在所有设备合并原今日详情功能。

竖屏首页按一个连续纵向滚动顺序：今日 Hero → 每日一签 / 今日天气同排 → 今日黄历摘要 → 月历。首页不显示独立岁时/择日 panel。Hero 中当日命中的岁时/纪念日属于卡内快捷入口，保留。iPad 和宽屏 Duo 首页使用两列：左侧 Hero、同排工具，右侧黄历摘要与月历，各列可滚动；没有左右滑动切换日期的交互。

点击任何设备的月历日期，直接进入 `almanac-{mode}.html?date=YYYY-MM-DD`。黄历详情返回首页；岁时详情返回岁时 tab，纪念日详情返回倒计日 tab。经文入口直接进入解释与二维码分享页。原型的日期参数和匹配岁时随日期变，完整黄历和天气数值仍是固定示例，不能当作其他日期的真实黄历。

## 浮动控制与 Liquid Glass

所有 10 类页面均无 navigation title，也不预留标题行高度。根 tab 页无返回按钮；子页在内容前景叠加 44×44pt 返回按钮。内容卡内保留“今日黄历”“每日一句”等信息标题。首卡为浮动返回按钮留出内部避让，禁止重新建一整条空白导航栏。

玻璃仅用于全局导航、浮动控制、弹层操作，不覆盖纸色内容卡。原型用透明材质、细亮边、模糊近似；PNG 中的材质是离线设计合成示意，不是真实系统玻璃。App 应优先使用系统 TabView 和按钮材质，不手工复刻系统状态栏。动态字体、减少透明度、VoiceOver 和真实材质表现留待 iOS 接入验证。

官方依据：
- [Apple：Applying Liquid Glass to custom views](https://developer.apple.com/documentation/SwiftUI/Applying-Liquid-Glass-to-custom-views)
- [Apple：TabView](https://developer.apple.com/documentation/swiftui/tabview)
- [Apple：Tab bars](https://developer.apple.com/design/human-interface-guidelines/tab-bars)
- [Apple：数字 badge](https://developer.apple.com/documentation/swiftui/view/badge(_:)-8adyq)
- [Apple：可选字符串 badge](https://developer.apple.com/documentation/swiftui/view/badge(_:)-6x46k)

## Hero 与提醒

Hero 保留完整年/月/日干支以及当前时干支。节气插画底部以透明度渐变叠加纸色，light/dark 各有独立 alpha 遮罩，所有 Duo 形态也使用同一层次。新遮罩是 UI 图层，不改变原插画。

今日岁时、今日纪念日显示为无分割线的柔色短入口，右侧箭头表达可点击，最小高度 44pt。不使用下划线，不把整块 Hero 设成旧“今日详情”入口。两种命中独立判断，无命中隐藏对应项；经文入口保持“读解释与分享 ›”。

岁时 tab：有新解锁未读内容时标准红点。倒计日 tab：标准红底白字数字 badge，不再组合描边气泡与红点。数字沿用已约定的最近纪念日剩余天数，0 表示今天，1–10 表示临近，超过 10 天隐藏；不是事件条数。多条取最近未来日期。无通知权限仍展示 App 内提醒。

iOS 数字 Int 0 会隐藏 badge，因此今天的 0 使用可选字符串 `.badge("0")`；无提醒传 `nil`。其它天数也统一转字符串。红色及字体由原生系统 badge 管理。

## 黄历详情

黄帝纪元和道历纪元相同：一行“黄帝纪元 · 道历纪元”，一个年份；佛历独立。若不相同，则三个纪元分别显示。本轮示例 4723/4723/2570。

“白话全解”开启：15 项宜、6 项忌逐项解释，并保留值神、冲煞、纳音、建除等解释。关闭：宜忌区域仅两个换行内容项，宜一项、忌一项，全部原始活动仍保留；同时隐藏白话解释。开关可重新打开，不通过另一个父容器永久遮住内容。

当日岁时：仅按当前所选日期精确匹配，按时间/稳定 ID 排序为可点击列表；无匹配不出现 panel；多项逐条显示，绝不拿未来临近项填充。列表目的地是相应的岁时详情。提供 11/12 有匹配、11/13 无匹配、11/22 小雪匹配三个审核状态。

完整黄历继续保留：彭祖百忌、建除十二神、胎神、星宿、吉神宜趋、凶神宜忌、十二时辰的干支/宜忌/冲属相，以及同页罗盘。十二时辰统一列表，不恢复重复快捷按钮。

## 设备

普通 iPhone 仅 portrait；本轮不交付普通 phone-landscape。

- Duo open-portrait：采用用户最新 News 原图 2007×2853，逻辑画布 669×951，顶部横向状态、底部横向五 tab；旧 2853×2007 错误竖屏参考不再使用。
- Duo tabletop：按本轮明确要求，使用 951×669 的宽屏内容、顶部状态、底部横向五 tab。原始 tabletop 附图是桌面而非 App；此处是设计推导，不声称硬件或模拟器已验证。
- Duo close landscape / open landscape / tent：侧栏与内容净距统一 8pt，侧栏宽 50pt，点击目标至少 44pt；不再为标题留整行高度。
- Duo closed portrait、splitview 保留对应侧栏形态。分屏左右画布仅一半属于本 App，另一半为示意占位。
- iPad portrait/landscape 含浅深色；横向多列可以独立滚动，内容不会因固定高度丢失。

14 种画布、10 类页面、14 个抽签结果态、14 个白话关闭态、13 个专项状态、5 个完整内容长图，共 186 张 PNG。具体尺寸见 `screens.json`，几何及来源见 `R9-RENDER-PROVENANCE.json`。

## 动画与素材

已批准 R7 的素材、1450ms 动画核心及定稿 MP4/GIF 保持 SHA-256 不变；仅调整外部容器和导航。全部 14 种画布提供待机及结果态；本地按北京时间固化每日一签，不请求 AI。真实时钟 Node 测试覆盖正常结束、跳过、系统/手动减少动态四种状态，但不等同浏览器或 SwiftUI 视觉验证。

新增择日图标采用现有图标家族的 28pt / 1.8pt 线宽，交付 SVG、1×/2×/3× PNG、保留矢量 PDF imageset。没有调用 Sketch 或把矢量导出声称为 Sketch 产物。

## 验证边界

272 项源代码结构/脚本语法/固定素材检查已通过；完整文件链接、导出图片尺寸与几何另有交付校验。PNG 为 WeasyPrint 局部排版加 Pillow/CairoSVG 离线合成，浏览器截图标志固定为 false。没有打开本地浏览器，没有运行 iOS App、模拟器或真实系统权限接口；原型权限对话框仅演示状态。后续 iOS 应验证 native TabView、Duo 系统栏真实 safe area、动态字体、VoiceOver、通知注册和定位权限。
