# iPad portrait 5 Tab

- 证据：`qa/evidence/ipad-portrait/r14-ipad-portrait-tab0..4.png`；2064×2752 portrait。
- 结果：**PASS**（5/5）
  - home 行 3：`ce30aff7…`
  - folklore 行 27：`507258fc…`
  - selection 行 63：`55c2265d…`
  - countdown 行 39：`c5911ddc…`
  - settings 行 51：`f0df85ad…`
- 非空、Tab 正常、两列/留白布局可见；portrait 其余状态/横屏 revert 不做额外推断。
- 不 merge/发布/提审。


## Dark 5 Tab（补充）
- home/folklore/selection/countdown/settings dark 全部 **PASS**（行 4/28/64/40/52）；2064×2752；证据 `qa/evidence/ipad-portrait-dark/`。
