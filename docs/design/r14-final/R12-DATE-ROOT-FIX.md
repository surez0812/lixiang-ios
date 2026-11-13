# R12 日期入口根节点覆盖修复

独立浏览器验收报告发现：黄历带 date 参数时，旧脚本先给 `.device` 设置 `data-selected-date` 作为状态；日期标签更新又用 `[data-selected-date]` 查找节点，并写入 textContent，导致根节点整个子树被删除。

最小修复：罗盘日期叶子标记改为 `data-date-label="selected"`；日期更新限定为 `p[data-almanac-date], p[data-date-label="selected"]`，并验证 childElementCount 为0后才更新。根节点上的 selectedDate 状态继续保留，不参与文本写入。所有黄历/罗盘设备和主题已重新生成；没有调整设计、动画或build12。

真实DOM回归：用jsdom26执行实际完整HTML和所有内联脚本，不使用此前的选择器字典桩。覆盖14种模式的月历→黄历→罗盘→返回、前后日，及跨年/平闰年，共93次正向完整文档执行。每步检查workspace、左右内容区、导航链接和正确日期标签均保留。同时还原旧选择器作负向对照，确认会触发“lost workspace”，测试能拦截原始缺陷。

报告：R12-DATE-DOM-REGRESSION.json；脚本：test_r12_date_dom.cjs。这是实际DOM实现上的脚本回归，不是Chrome绘制或点击验收；修复后仍待独立浏览器复核。此前独立验收通过的布局/罗盘结果只按协作方报告留存，不冒充本chat实测。

运行依赖：Node20，jsdom26。可在本目录安装jsdom，或使用本轮临时路径：

```
npm install --prefix /tmp/lixiang-r12-dom-regression jsdom@26 --no-audit --no-fund
node test_r12_date_dom.cjs
```

同步：62张黄历/罗盘PNG重新导出，清单、SHA和ZIP更新。PNG仍为离线设计合成，静态视觉未因本修复改变。
