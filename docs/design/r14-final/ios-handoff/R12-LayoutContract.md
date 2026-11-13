# R12 接入补充

- 当前规范见../R12-DESIGN-SPEC.md。罗盘入口采用系统Liquid Glass bar button，与返回同组；内容装饰allowsHitTesting(false)。
- 不为导航标题创建额外空行。safe area以真实系统为准，不把原型36pt/12pt常量复制进生产。
- 底部Tab覆盖内容，末尾滚动避让保证可达。Open Landscape仅右侧系统状态/Tab/按钮组；Open Portrait顶/底覆盖。
- 罗盘页原型已自包含重写，初始内容不依赖JS。App应直接由SwiftUI数据渲染，不能复制浏览器示意布局当原生系统栏。
- Tent工具108pt，入口同排，摘要与Hero顶对齐，压缩月历展示整月。
- Splitview退出本轮；iPhone横屏只是补充参考，未改App旋转策略。
- 冻结抽签与build12不变；未编译App，运行验证仍待接入。
