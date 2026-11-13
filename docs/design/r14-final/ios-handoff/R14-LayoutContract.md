# R14 设备布局约定

- 普通iPhone仅portrait，不接入phone-landscape/phone-landscape-dark设计参考。
- Tabletop复用Open Portrait同一布局组件，设计画布669×951pt；顶部状态/返回等浮动，底部Tab为浮动玻璃。不要继续使用951×669横向布局。
- Tabletop各页和每日一签均保持Open Portrait一致，日期路由保留当前模式文件名；布局组件共享。
- 其余R13规则不变。动画核心/素材、App/build12/发布状态不改。

真实safe area由系统提供，原型逻辑尺寸不直接硬编码到App。


## 首页双卡补充

首页双卡使用内容自适应等高布局，取消固定112/156pt高度；标题行与说明／操作行水平对齐。详见 ../HOME-TOOLS-UPDATE.md。
