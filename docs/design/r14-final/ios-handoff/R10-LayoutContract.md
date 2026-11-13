# R10 iOS 布局接入补充

当前规范见 ../R10-DESIGN-SPEC.md。

- 岁时筛选：ScrollView(.horizontal) 内 HStack，不换行，44pt 高点击区。
- 横屏首页：按可用高度布局，底部工具 HStack 固定156pt，Hero 使用剩余空间；间距16pt。不要用固定大 Hero 挤压工具卡。
- 今日分享页：iPad 横屏为解释/分享卡左右两列。
- 黄历主卡：纪年与当日岁时属于主卡内部的内容，自然增长；不额外包出两张卡。
- 今日罗盘：主卡右上角入口，push compass(selectedDate)，仅日方位；返回 almanac(selectedDate)。不保留时方位切换。
- 横屏黄历：HStack 中两个等高 ScrollView，父视口不滚动。每个列视图占满 GeometryReader 提供的可用高度，内部内容增长时只滚本列；十二时辰无需第二层滚动容器。
- 纪念日按钮到列表间隔20pt，按钮48pt高。

以上为未编译的接入约定；未修改或运行 App。R9NavigationReference.swift 等前轮参考继续保留，其冲突布局按 R10 替换。
