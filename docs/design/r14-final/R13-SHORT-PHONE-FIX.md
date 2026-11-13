# R13 两款iPhone短横屏结果裁切修复

独立Chrome复核发现：其他12款120次样签检查通过，但普通iPhone横屏浅/深两款20次失败。实际浏览器的`.fortune-host .result-copy`继承了500px最小高度，远超144px的结果视口；先前离线intrinsic检查没有包含这个祖先条件，不能代表Chrome结果。

本补丁仅针对`phone-landscape`、`phone-landscape-dark`的一签结果容器：

- 在组件样式末尾显式覆盖`min-height:0!important`，高度和最大高度都绑定实际结果视口`--ft-vh`。
- 清除内部copy的top/right/bottom/left和transform遗留约束，居中发生在144px视口内；不改外层揭签动画transform。
- 只在这两款将内边距设为4px、行间隙2px，给完整签题、四句签诗、签意和建议留出明确余量。
- 不添加内部滚动，不通过隐藏段落、删文案或裁切掩盖问题。标题、动作内核、素材、build12不变。

验证：完整生成HTML+真实祖先CSS在jsdom中执行，20组样签/主题核对最小高度、视口绑定、位置、内边距、无内部滚动和标题保留；移除补丁的负向对照可恢复500px。报告为R13-SHORT-PHONE-CSS-REGRESSION.json。此为DOM/CSS约束回归，不是Chrome几何。

短横屏20组离线排版也改为包含真实`.fortune-host`祖先，避免重复遗漏；4张待机/结果PNG重新导出，清单、SHA和ZIP同步。前轮完整日期链路及标题回归继续保留。

修复后的20组Chrome真实几何仍待独立复核，尚不宣称整轮验收通过。修复前的独立Chrome JSON/截图留存在evidence/R13-INDEPENDENT-CHROME-BEFORE-SHORT-FIX.*。旧140组离线容纳记录属于设计候选证据，不覆盖此次浏览器暴露的问题。
