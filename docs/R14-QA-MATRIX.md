# 历象 R14 · 188 状态 QA 矩阵

- 生成器：`scripts/r14-matrix-gen.py`；权威源：`screens.json` SHA256 `ea505be157c6ceb3bc57eabe0fb00feef3eaf7d990fa6d2b8ad22264224e7409`；设计条目 188 条；**设计稿 ≠ 实现/验收通过**。
- 每行先按对应设计 PNG 自查，再在模拟器/真机跑同状态；结果只允许 PASS/FAIL/NOT RUN；证据列写截图/日志/设备。
- 当前阶段：**全部 NOT RUN**（开发自测未交；未测未就绪页面，不用设计图代替原生结果）。
- 12 画布：phone light/dark 375×930；iPad 834×1194、1194×834 ×亮暗；Duo 六姿态；Tabletop=OpenPortrait 669×951。
- page 分组不合并：home/almanac/compass/daily/fortune/folklore/folklore-detail/selection/countdown/countdown-detail/settings。

| # | 页面 | 模式/画布 | 尺寸 | 状态 | 入口 | 期望 | PASS | FAIL | NOT RUN | 证据 |
|---:|---|---|---|---|---|---|---|---|---|---|
| 1 | home 首页/日历 | phone-light·浅色 | 375×930 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPhone16Pro-tab0.png (53c2dde6…); new build 21:41; iPhone 16 Pro dark/light? light tokens |
| 2 | home 首页/日历 | phone-dark·深色 | 375×930 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/visual-v2/dark-home.png (654d07d3…); new build; dark tokens |
| 3 | home 首页/日历 | ipad-portrait·浅色 | 834×1194 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/ipad-portrait/r14-ipad-portrait-tab0.png; iPad portrait 2064×2752 |
| 4 | home 首页/日历 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | — | — | **NOT RUN** | 待证；`r14-final/home-ipad-portrait-dark.png` |
| 5 | home 首页/日历 | ipad-landscape·浅色 | 1194×834 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPadPro13-tab0.png (a465f368…); new build; iPad landscape |
| 6 | home 首页/日历 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | — | — | **NOT RUN** | 待证；`r14-final/home-ipad-landscape-dark.png` |
| 7 | home 首页/日历 | duo-closed-portrait·浅色 | 466×678 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/firstbatch-v2/DuoClosed-tab0.png (b495042b…); R14-Duo closed portrait; new build |
| 8 | home 首页/日历 | duo-closed-landscape·浅色 | 678×466 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | — | — | **NOT RUN** | 待证；`r14-final/home-duo-closed-landscape.png` |
| 9 | home 首页/日历 | duo-tent·浅色 | 678×466 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | — | — | **NOT RUN** | 待证；`r14-final/home-duo-tent.png` |
| 10 | home 首页/日历 | duo-open-portrait·浅色 | 669×951 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | — | — | **NOT RUN** | qa/evidence/firstbatch/DuoInner-tab0.png (fcff7a2e…); inner display 2007×2853 black; simulator posture/display unsupported |
| 11 | home 首页/日历 | duo-open-landscape·浅色 | 951×669 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | — | — | **NOT RUN** | 待证；`r14-final/home-duo-open-landscape.png` |
| 12 | home 首页/日历 | duo-tabletop·浅色 | 669×951 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | — | — | **NOT RUN** | 待证；`r14-final/home-duo-tabletop.png` |
| 13 | almanac 黄历 | phone-light·浅色 | 375×930 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-phone-light.png` |
| 14 | almanac 黄历 | phone-dark·深色 | 375×930 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/visual-v2/dark-almanac.png (1ef6793a…); new build dark |
| 15 | almanac 黄历 | ipad-portrait·浅色 | 834×1194 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-ipad-portrait.png` |
| 16 | almanac 黄历 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-ipad-portrait-dark.png` |
| 17 | almanac 黄历 | ipad-landscape·浅色 | 1194×834 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | **FAIL** | — | qa/evidence/ipad-landscape/r14-ipad-landscape-almanac.png；设计左Hero+宜忌/右十二时辰；实现左Hero空、右宜忌+时辰 |
| 18 | almanac 黄历 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-ipad-landscape-dark.png` |
| 19 | almanac 黄历 | duo-closed-portrait·浅色 | 466×678 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-duo-closed-portrait.png` |
| 20 | almanac 黄历 | duo-closed-landscape·浅色 | 678×466 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-duo-closed-landscape.png` |
| 21 | almanac 黄历 | duo-tent·浅色 | 678×466 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-duo-tent.png` |
| 22 | almanac 黄历 | duo-open-portrait·浅色 | 669×951 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-duo-open-portrait.png` |
| 23 | almanac 黄历 | duo-open-landscape·浅色 | 951×669 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-duo-open-landscape.png` |
| 24 | almanac 黄历 | duo-tabletop·浅色 | 669×951 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-duo-tabletop.png` |
| 25 | folklore 岁时列表 | phone-light·浅色 | 375×930 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPhone16Pro-tab1.png (69cfe43f…); new build |
| 26 | folklore 岁时列表 | phone-dark·深色 | 375×930 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | **PASS** | — | — | qa/evidence/visual-v2/dark-folklore-v2.png (53d5b2a2…); HEAD 4d84b2e dark brand card |
| 27 | folklore 岁时列表 | ipad-portrait·浅色 | 834×1194 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | **PASS** | — | — | qa/evidence/ipad-portrait/r14-ipad-portrait-tab1.png; iPad portrait 2064×2752 |
| 28 | folklore 岁时列表 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | — | — | **NOT RUN** | 待证；`r14-final/folklore-ipad-portrait-dark.png` |
| 29 | folklore 岁时列表 | ipad-landscape·浅色 | 1194×834 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPadPro13-tab1.png (c73b0b36…); new build |
| 30 | folklore 岁时列表 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | — | — | **NOT RUN** | 待证；`r14-final/folklore-ipad-landscape-dark.png` |
| 31 | folklore 岁时列表 | duo-closed-portrait·浅色 | 466×678 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | **PASS** | — | — | qa/evidence/firstbatch-v2/DuoClosed-tab1.png (b351c337…); new build |
| 32 | folklore 岁时列表 | duo-closed-landscape·浅色 | 678×466 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | — | — | **NOT RUN** | 待证；`r14-final/folklore-duo-closed-landscape.png` |
| 33 | folklore 岁时列表 | duo-tent·浅色 | 678×466 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | — | — | **NOT RUN** | 待证；`r14-final/folklore-duo-tent.png` |
| 34 | folklore 岁时列表 | duo-open-portrait·浅色 | 669×951 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | — | — | **NOT RUN** | qa/evidence/firstbatch/DuoInner-tab1.png (fcff7a2e…); black inner display |
| 35 | folklore 岁时列表 | duo-open-landscape·浅色 | 951×669 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | — | — | **NOT RUN** | 待证；`r14-final/folklore-duo-open-landscape.png` |
| 36 | folklore 岁时列表 | duo-tabletop·浅色 | 669×951 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | — | — | **NOT RUN** | 待证；`r14-final/folklore-duo-tabletop.png` |
| 37 | countdown 倒计日 | phone-light·浅色 | 375×930 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | **PASS** | — | — | qa/evidence/portrait-states/r14-countdown-empty.png (51c0cdf9…); 卸载重装空态 |
| 38 | countdown 倒计日 | phone-dark·深色 | 375×930 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | **PASS** | — | — | qa/evidence/visual-v2/dark-countdown-v2.png (b2f9cff3…); HEAD 4d84b2e dark brand card |
| 39 | countdown 倒计日 | ipad-portrait·浅色 | 834×1194 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | **PASS** | — | — | qa/evidence/ipad-portrait/r14-ipad-portrait-tab3.png; iPad portrait 2064×2752 |
| 40 | countdown 倒计日 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | — | — | **NOT RUN** | 待证；`r14-final/countdown-ipad-portrait-dark.png` |
| 41 | countdown 倒计日 | ipad-landscape·浅色 | 1194×834 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPadPro13-tab3.png (d939a5b9…); new build |
| 42 | countdown 倒计日 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | — | — | **NOT RUN** | 待证；`r14-final/countdown-ipad-landscape-dark.png` |
| 43 | countdown 倒计日 | duo-closed-portrait·浅色 | 466×678 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | **PASS** | — | — | qa/evidence/firstbatch-v2/DuoClosed-tab3.png (ade6de60…); new build |
| 44 | countdown 倒计日 | duo-closed-landscape·浅色 | 678×466 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | — | — | **NOT RUN** | 待证；`r14-final/countdown-duo-closed-landscape.png` |
| 45 | countdown 倒计日 | duo-tent·浅色 | 678×466 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | — | — | **NOT RUN** | 待证；`r14-final/countdown-duo-tent.png` |
| 46 | countdown 倒计日 | duo-open-portrait·浅色 | 669×951 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | — | — | **NOT RUN** | qa/evidence/firstbatch/DuoInner-tab3.png (fcff7a2e…); black inner display |
| 47 | countdown 倒计日 | duo-open-landscape·浅色 | 951×669 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | — | — | **NOT RUN** | 待证；`r14-final/countdown-duo-open-landscape.png` |
| 48 | countdown 倒计日 | duo-tabletop·浅色 | 669×951 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | — | — | **NOT RUN** | 待证；`r14-final/countdown-duo-tabletop.png` |
| 49 | settings 设置 | phone-light·浅色 | 375×930 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPhone16Pro-tab4.png (1a925a01…); new build |
| 50 | settings 设置 | phone-dark·深色 | 375×930 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | **PASS** | — | — | qa/evidence/visual-v2/dark-settings-v2.png (9042b7f9…); HEAD 4d84b2e dark brand card |
| 51 | settings 设置 | ipad-portrait·浅色 | 834×1194 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | **PASS** | — | — | qa/evidence/ipad-portrait/r14-ipad-portrait-tab4.png; iPad portrait 2064×2752 |
| 52 | settings 设置 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | — | — | **NOT RUN** | 待证；`r14-final/settings-ipad-portrait-dark.png` |
| 53 | settings 设置 | ipad-landscape·浅色 | 1194×834 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPadPro13-tab4.png (0b424bff…); new build |
| 54 | settings 设置 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | — | — | **NOT RUN** | 待证；`r14-final/settings-ipad-landscape-dark.png` |
| 55 | settings 设置 | duo-closed-portrait·浅色 | 466×678 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | **PASS** | — | — | qa/evidence/firstbatch-v2/DuoClosed-tab4.png (b2c48e0e…); new build |
| 56 | settings 设置 | duo-closed-landscape·浅色 | 678×466 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | — | — | **NOT RUN** | 待证；`r14-final/settings-duo-closed-landscape.png` |
| 57 | settings 设置 | duo-tent·浅色 | 678×466 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | — | — | **NOT RUN** | 待证；`r14-final/settings-duo-tent.png` |
| 58 | settings 设置 | duo-open-portrait·浅色 | 669×951 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | — | — | **NOT RUN** | qa/evidence/firstbatch/DuoInner-tab4.png (fcff7a2e…); black inner display |
| 59 | settings 设置 | duo-open-landscape·浅色 | 951×669 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | — | — | **NOT RUN** | 待证；`r14-final/settings-duo-open-landscape.png` |
| 60 | settings 设置 | duo-tabletop·浅色 | 669×951 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | — | — | **NOT RUN** | 待证；`r14-final/settings-duo-tabletop.png` |
| 61 | selection 择日 | phone-light·浅色 | 375×930 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPhone16Pro-tab2.png (8a2eb101…); new build selection |
| 62 | selection 择日 | phone-dark·深色 | 375×930 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | — | — | **NOT RUN** | 待证；`r14-final/selection-phone-dark.png` |
| 63 | selection 择日 | ipad-portrait·浅色 | 834×1194 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | **PASS** | — | — | qa/evidence/ipad-portrait/r14-ipad-portrait-tab2.png; iPad portrait 2064×2752 |
| 64 | selection 择日 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | — | — | **NOT RUN** | 待证；`r14-final/selection-ipad-portrait-dark.png` |
| 65 | selection 择日 | ipad-landscape·浅色 | 1194×834 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | — | **FAIL** | — | qa/evidence/ipad-landscape/r14-ipad-landscape-selection.png；设计左表单/右结果两列；实现单列，无结果列 |
| 66 | selection 择日 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | — | — | **NOT RUN** | 待证；`r14-final/selection-ipad-landscape-dark.png` |
| 67 | selection 择日 | duo-closed-portrait·浅色 | 466×678 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | **PASS** | — | — | qa/evidence/firstbatch-v2/DuoClosed-tab2.png (835794a6…); new build selection |
| 68 | selection 择日 | duo-closed-landscape·浅色 | 678×466 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | — | — | **NOT RUN** | 待证；`r14-final/selection-duo-closed-landscape.png` |
| 69 | selection 择日 | duo-tent·浅色 | 678×466 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | — | — | **NOT RUN** | 待证；`r14-final/selection-duo-tent.png` |
| 70 | selection 择日 | duo-open-portrait·浅色 | 669×951 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | — | — | **NOT RUN** | qa/evidence/firstbatch/DuoInner-tab2.png (fcff7a2e…); black inner display |
| 71 | selection 择日 | duo-open-landscape·浅色 | 951×669 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | — | — | **NOT RUN** | 待证；`r14-final/selection-duo-open-landscape.png` |
| 72 | selection 择日 | duo-tabletop·浅色 | 669×951 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | — | — | **NOT RUN** | 待证；`r14-final/selection-duo-tabletop.png` |
| 73 | daily 每日一句 | phone-light·浅色 | 375×930 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | 待证；`r14-final/daily-phone-light.png` |
| 74 | daily 每日一句 | phone-dark·深色 | 375×930 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | 待证；`r14-final/daily-phone-dark.png` |
| 75 | daily 每日一句 | ipad-portrait·浅色 | 834×1194 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | 待证；`r14-final/daily-ipad-portrait.png` |
| 76 | daily 每日一句 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | 待证；`r14-final/daily-ipad-portrait-dark.png` |
| 77 | daily 每日一句 | ipad-landscape·浅色 | 1194×834 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | **FAIL** | — | qa/evidence/ipad-landscape/r14-ipad-landscape-daily.png；设计左解释/右分享两列；实现单列 |
| 78 | daily 每日一句 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | 待证；`r14-final/daily-ipad-landscape-dark.png` |
| 79 | daily 每日一句 | duo-closed-portrait·浅色 | 466×678 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | 待证；`r14-final/daily-duo-closed-portrait.png` |
| 80 | daily 每日一句 | duo-closed-landscape·浅色 | 678×466 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | 待证；`r14-final/daily-duo-closed-landscape.png` |
| 81 | daily 每日一句 | duo-tent·浅色 | 678×466 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | 待证；`r14-final/daily-duo-tent.png` |
| 82 | daily 每日一句 | duo-open-portrait·浅色 | 669×951 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | 待证；`r14-final/daily-duo-open-portrait.png` |
| 83 | daily 每日一句 | duo-open-landscape·浅色 | 951×669 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | 待证；`r14-final/daily-duo-open-landscape.png` |
| 84 | daily 每日一句 | duo-tabletop·浅色 | 669×951 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | 待证；`r14-final/daily-duo-tabletop.png` |
| 85 | folklore-detail 岁时详情 | phone-light·浅色 | 375×930 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-phone-light.png` |
| 86 | folklore-detail 岁时详情 | phone-dark·深色 | 375×930 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-phone-dark.png` |
| 87 | folklore-detail 岁时详情 | ipad-portrait·浅色 | 834×1194 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-ipad-portrait.png` |
| 88 | folklore-detail 岁时详情 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-ipad-portrait-dark.png` |
| 89 | folklore-detail 岁时详情 | ipad-landscape·浅色 | 1194×834 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-ipad-landscape.png` |
| 90 | folklore-detail 岁时详情 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-ipad-landscape-dark.png` |
| 91 | folklore-detail 岁时详情 | duo-closed-portrait·浅色 | 466×678 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-duo-closed-portrait.png` |
| 92 | folklore-detail 岁时详情 | duo-closed-landscape·浅色 | 678×466 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-duo-closed-landscape.png` |
| 93 | folklore-detail 岁时详情 | duo-tent·浅色 | 678×466 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-duo-tent.png` |
| 94 | folklore-detail 岁时详情 | duo-open-portrait·浅色 | 669×951 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-duo-open-portrait.png` |
| 95 | folklore-detail 岁时详情 | duo-open-landscape·浅色 | 951×669 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-duo-open-landscape.png` |
| 96 | folklore-detail 岁时详情 | duo-tabletop·浅色 | 669×951 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-duo-tabletop.png` |
| 97 | countdown-detail 倒计日详情 | phone-light·浅色 | 375×930 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | **PASS** | — | — | qa/evidence/portrait-states/r14-iphone-countdown-detail.png (9334afc4…); 生日/2027-02-06/85天/农历每年/提醒09:00 |
| 98 | countdown-detail 倒计日详情 | phone-dark·深色 | 375×930 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-phone-dark.png` |
| 99 | countdown-detail 倒计日详情 | ipad-portrait·浅色 | 834×1194 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-ipad-portrait.png` |
| 100 | countdown-detail 倒计日详情 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-ipad-portrait-dark.png` |
| 101 | countdown-detail 倒计日详情 | ipad-landscape·浅色 | 1194×834 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-ipad-landscape.png` |
| 102 | countdown-detail 倒计日详情 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-ipad-landscape-dark.png` |
| 103 | countdown-detail 倒计日详情 | duo-closed-portrait·浅色 | 466×678 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-duo-closed-portrait.png` |
| 104 | countdown-detail 倒计日详情 | duo-closed-landscape·浅色 | 678×466 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-duo-closed-landscape.png` |
| 105 | countdown-detail 倒计日详情 | duo-tent·浅色 | 678×466 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-duo-tent.png` |
| 106 | countdown-detail 倒计日详情 | duo-open-portrait·浅色 | 669×951 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-duo-open-portrait.png` |
| 107 | countdown-detail 倒计日详情 | duo-open-landscape·浅色 | 951×669 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-duo-open-landscape.png` |
| 108 | countdown-detail 倒计日详情 | duo-tabletop·浅色 | 669×951 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-duo-tabletop.png` |
| 109 | fortune 每日一签 | phone-light·浅色 | 375×930 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/weather-fortune/r14-fortune-frame0.png (aaf6270f…); 每日一签 idle/待机 |
| 110 | fortune 每日一签 | phone-dark·深色 | 375×930 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-phone-dark.png` |
| 111 | fortune 每日一签 | ipad-portrait·浅色 | 834×1194 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-ipad-portrait.png` |
| 112 | fortune 每日一签 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-ipad-portrait-dark.png` |
| 113 | fortune 每日一签 | ipad-landscape·浅色 | 1194×834 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | **FAIL** | — | qa/evidence/ipad-landscape/r14-ipad-landscape-fortune.png；设计左标题/右签筒/底部全宽按钮+跳过；实现按钮偏小/跳过缺失 |
| 114 | fortune 每日一签 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-ipad-landscape-dark.png` |
| 115 | fortune 每日一签 | duo-closed-portrait·浅色 | 466×678 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-duo-closed-portrait.png` |
| 116 | fortune 每日一签 | duo-closed-landscape·浅色 | 678×466 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-duo-closed-landscape.png` |
| 117 | fortune 每日一签 | duo-tent·浅色 | 678×466 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-duo-tent.png` |
| 118 | fortune 每日一签 | duo-open-portrait·浅色 | 669×951 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-duo-open-portrait.png` |
| 119 | fortune 每日一签 | duo-open-landscape·浅色 | 951×669 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-duo-open-landscape.png` |
| 120 | fortune 每日一签 | duo-tabletop·浅色 | 669×951 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-duo-tabletop.png` |
| 121 | compass 罗盘 | phone-light·浅色 | 375×930 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-phone-light.png` |
| 122 | compass 罗盘 | phone-dark·深色 | 375×930 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/visual-v2/dark-compass.png (f5222991…); new build dark |
| 123 | compass 罗盘 | ipad-portrait·浅色 | 834×1194 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-ipad-portrait.png` |
| 124 | compass 罗盘 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-ipad-portrait-dark.png` |
| 125 | compass 罗盘 | ipad-landscape·浅色 | 1194×834 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | **FAIL** | — | qa/evidence/ipad-landscape/r14-ipad-landscape-compass.png；设计左控件/右罗盘+图例；实现全宽居中单列 |
| 126 | compass 罗盘 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-ipad-landscape-dark.png` |
| 127 | compass 罗盘 | duo-closed-portrait·浅色 | 466×678 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-duo-closed-portrait.png` |
| 128 | compass 罗盘 | duo-closed-landscape·浅色 | 678×466 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-duo-closed-landscape.png` |
| 129 | compass 罗盘 | duo-tent·浅色 | 678×466 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-duo-tent.png` |
| 130 | compass 罗盘 | duo-open-portrait·浅色 | 669×951 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-duo-open-portrait.png` |
| 131 | compass 罗盘 | duo-open-landscape·浅色 | 951×669 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-duo-open-landscape.png` |
| 132 | compass 罗盘 | duo-tabletop·浅色 | 669×951 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-duo-tabletop.png` |
| 133 | fortune 每日一签 | phone-light·浅色 | 375×930 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/weather-fortune/r14-fortune-frame1450.png (731ff0aa…); result full, title visible |
| 134 | almanac 黄历 | phone-light·浅色 | 375×930 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-phone-light-plain-off.png` |
| 135 | fortune 每日一签 | phone-dark·深色 | 375×930 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-phone-dark-result.png` |
| 136 | almanac 黄历 | phone-dark·深色 | 375×930 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-phone-dark-plain-off.png` |
| 137 | fortune 每日一签 | ipad-portrait·浅色 | 834×1194 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-ipad-portrait-result.png` |
| 138 | almanac 黄历 | ipad-portrait·浅色 | 834×1194 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-ipad-portrait-plain-off.png` |
| 139 | fortune 每日一签 | ipad-portrait-dark·深色 | 834×1194 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-ipad-portrait-dark-result.png` |
| 140 | almanac 黄历 | ipad-portrait-dark·深色 | 834×1194 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-ipad-portrait-dark-plain-off.png` |
| 141 | fortune 每日一签 | ipad-landscape·浅色 | 1194×834 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-ipad-landscape-result.png` |
| 142 | almanac 黄历 | ipad-landscape·浅色 | 1194×834 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-ipad-landscape-plain-off.png` |
| 143 | fortune 每日一签 | ipad-landscape-dark·深色 | 1194×834 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-ipad-landscape-dark-result.png` |
| 144 | almanac 黄历 | ipad-landscape-dark·深色 | 1194×834 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-ipad-landscape-dark-plain-off.png` |
| 145 | fortune 每日一签 | duo-closed-portrait·浅色 | 466×678 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-duo-closed-portrait-result.png` |
| 146 | almanac 黄历 | duo-closed-portrait·浅色 | 466×678 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-duo-closed-portrait-plain-off.png` |
| 147 | fortune 每日一签 | duo-closed-landscape·浅色 | 678×466 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-duo-closed-landscape-result.png` |
| 148 | almanac 黄历 | duo-closed-landscape·浅色 | 678×466 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-duo-closed-landscape-plain-off.png` |
| 149 | fortune 每日一签 | duo-tent·浅色 | 678×466 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-duo-tent-result.png` |
| 150 | almanac 黄历 | duo-tent·浅色 | 678×466 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-duo-tent-plain-off.png` |
| 151 | fortune 每日一签 | duo-open-portrait·浅色 | 669×951 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-duo-open-portrait-result.png` |
| 152 | almanac 黄历 | duo-open-portrait·浅色 | 669×951 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-duo-open-portrait-plain-off.png` |
| 153 | fortune 每日一签 | duo-open-landscape·浅色 | 951×669 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-duo-open-landscape-result.png` |
| 154 | almanac 黄历 | duo-open-landscape·浅色 | 951×669 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-duo-open-landscape-plain-off.png` |
| 155 | fortune 每日一签 | duo-tabletop·浅色 | 669×951 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | 待证；`r14-final/fortune-duo-tabletop-result.png` |
| 156 | almanac 黄历 | duo-tabletop·浅色 | 669×951 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-duo-tabletop-plain-off.png` |
| 157 | home 首页/日历 | phone-light·浅色 | 375×930 | 无匹配岁时/纪念，无空占位 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/portrait-states/r14-home-no-matches.png (b5965414…); 2026-06-15 no matches |
| 158 | home 首页/日历 | phone-light·浅色 | 375×930 | 定位允许/天气就绪 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/weather-fortune/r14-home-weather-loaded.png (31de88b6…); weather loaded |
| 159 | home 首页/日历 | phone-light·浅色 | 375×930 | 定位拒绝，核心不阻断 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/weather-fortune/r14-home-weather-denied.png (42030862…); weather denied |
| 160 | home 首页/日历 | phone-light·浅色 | 375×930 | 定位中/加载 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/weather-fortune/r14-home-weather-locating.png (326c049c…); weather locating |
| 161 | almanac 黄历 | phone-light·浅色 | 375×930 | 无岁时/节日时隐藏入口 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/portrait-states/r14-almanac-no-festival.png (dad4eb3e…); 2026-06-15 |
| 162 | almanac 黄历 | phone-light·浅色 | 375×930 | 节气/冬季边界 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/portrait-states/r14-almanac-winter.png (33365e06…); 2026-12-22 冬至/almanac winter |
| 163 | folklore-detail 岁时详情 | phone-light·浅色 | 375×930 | 今日解锁/已读边界 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-phone-light-today.png` |
| 164 | folklore-detail 岁时详情 | phone-light·浅色 | 375×930 | 离线/加载失败可重试 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-phone-light-offline.png` |
| 165 | countdown-detail 倒计日详情 | phone-light·浅色 | 375×930 | 新建入口/校验 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-phone-light-new.png` |
| 166 | countdown-detail 倒计日详情 | phone-light·浅色 | 375×930 | 请求前说明，不擅自弹权限 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-phone-light-preprompt.png` |
| 167 | countdown-detail 倒计日详情 | phone-light·浅色 | 375×930 | 系统权限弹窗 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-phone-light-system-prompt.png` |
| 168 | countdown-detail 倒计日详情 | phone-light·浅色 | 375×930 | 允许后安排提醒 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-phone-light-allowed.png` |
| 169 | countdown-detail 倒计日详情 | phone-light·浅色 | 375×930 | 拒绝不阻断；设置返回重读 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 待证；`r14-final/countdown-detail-phone-light-denied.png` |
| 170 | home 首页/日历 | phone-light·浅色 | 375×2500 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | — | — | **NOT RUN** | 待证；`r14-final/home-phone-light-full.png` |
| 171 | almanac 黄历 | phone-light·浅色 | 375×12000 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-phone-light-full.png` |
| 172 | almanac 黄历 | phone-light·浅色 | 375×6500 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 待证；`r14-final/almanac-phone-light-plain-off-full.png` |
| 173 | daily 每日一句 | phone-light·浅色 | 375×1650 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | 待证；`r14-final/daily-phone-light-full.png` |
| 174 | folklore-detail 岁时详情 | phone-light·浅色 | 375×2400 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 待证；`r14-final/folklore-detail-phone-light-full.png` |
| 175 | compass 罗盘 | phone-light·浅色 | 375×930 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/portrait-states/r14-compass-hour{3,9,15,21}.png（4e/47/67/86…）；时方位 03/09/15/21，煞方变化 |
| 176 | compass 罗盘 | phone-dark·深色 | 375×930 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-phone-dark-hour.png` |
| 177 | compass 罗盘 | ipad-portrait·浅色 | 834×1194 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-ipad-portrait-hour.png` |
| 178 | compass 罗盘 | ipad-portrait-dark·深色 | 834×1194 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-ipad-portrait-dark-hour.png` |
| 179 | compass 罗盘 | ipad-landscape·浅色 | 1194×834 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-ipad-landscape-hour.png` |
| 180 | compass 罗盘 | ipad-landscape-dark·深色 | 1194×834 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-ipad-landscape-dark-hour.png` |
| 181 | compass 罗盘 | duo-closed-portrait·浅色 | 466×678 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-duo-closed-portrait-hour.png` |
| 182 | compass 罗盘 | duo-closed-landscape·浅色 | 678×466 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-duo-closed-landscape-hour.png` |
| 183 | compass 罗盘 | duo-tent·浅色 | 678×466 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-duo-tent-hour.png` |
| 184 | compass 罗盘 | duo-open-portrait·浅色 | 669×951 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-duo-open-portrait-hour.png` |
| 185 | compass 罗盘 | duo-open-landscape·浅色 | 951×669 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-duo-open-landscape-hour.png` |
| 186 | compass 罗盘 | duo-tabletop·浅色 | 669×951 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | 待证；`r14-final/compass-duo-tabletop-hour.png` |
| 187 | almanac 黄历 | phone-light·浅色 | 375×930 | 前一日整组重算 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/portrait-states/r14-almanac-previous.png (09f36b4e…); 11-12 |
| 188 | almanac 黄历 | phone-light·浅色 | 375×930 | 后一日整组重算 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/portrait-states/r14-almanac-next.png (70931d8b…); 11-14 |

## 补充 · 动态字体 xLarge（不计入 188）

| ID | 页面 | 启动 | 结果 | 证据 |
|---|---|---|---|---|
| X-01 | Home | `-LixiangTypeScale xl` | **PASS** | `qa/evidence/dynamic-v2/xl-home.png` |
| X-02 | Almanac | `-LixiangTypeScale xl` | **PASS** | `qa/evidence/dynamic-v2/xl-almanac.png` |
| X-03 | Compass | `-LixiangTypeScale xl` | **PASS** | `qa/evidence/dynamic-v2/xl-compass.png` |
| X-04 | Daily | `-LixiangTypeScale xl` | **PASS** | `qa/evidence/dynamic-v2/xl-daily.png` |
| X-05 | Folklore detail | `-LixiangTypeScale xl` | **PASS** | `qa/evidence/dynamic-v2/xl-folklore-detail.png` |

- 说明：只验字体放大布局；VoiceOver/a1/旋转组合 NOT RUN；详见 `qa/DYNAMIC-TYPE.md`。
- 字体未找到 Songti/Kaiti，回退系统 serif；设计字体差异记为已知偏差，不标 PASS。

## 补充 · Home 天气六态

| ID | 状态 | 结果 | 证据 |
|---|---|---|---|
| W-01 | initial | **PASS** | `qa/evidence/firstbatch-v2/iPhone16Pro-tab0.png` |
| W-02 | locating | **PASS** | `qa/evidence/weather-fortune/r14-home-weather-locating.png` |
| W-03 | denied | **PASS** | `qa/evidence/weather-fortune/r14-home-weather-denied.png` |
| W-04 | failed | **PASS** | `qa/evidence/weather-fortune/r14-home-weather-failed.png` |
| W-05 | loaded | **PASS** | `qa/evidence/weather-fortune/r14-home-weather-loaded.png` |
| W-06 | denied→系统设置返回 | **NOT RUN** | 需系统设置返回重读权限；未测 |

## 补充 · Fortune 1450ms 关键帧

| ID | 时间 | 结果 | 证据/判断 |
|---|---|---|---|
| F-01 | 0ms | **PASS** | `qa/evidence/weather-fortune/r14-fortune-frame0.png`；待机/标题常驻 |
| F-02 | 180ms | **NOTE** | 数学零交叉；与 0ms 同 SHA `aaf6270f…`，非缺陷 |
| F-03 | 600ms | **NOTE** | 数学零交叉；与 0ms 同 SHA `aaf6270f…`，非缺陷 |
| F-04 | 1050ms | **PASS** | `r14-fortune-frame1050.png`；签筒升起动作 |
| F-05 | 1450ms | **PASS** | `r14-fortune-frame1450.png`；结果全显、标题常驻 |

- 说明：180/600 为 ApprovedFortuneCore 零交叉边界，与 0ms 同图属正确数学；不标 FAIL。

### 运动关键帧（补充）

| ID | 时间 | 结果 | 证据 |
|---|---|---|---|
| M-01 | 300ms | **PASS** | `qa/evidence/weather-fortune/r14-fortune-frame300.png` |
| M-02 | 450ms | **PASS** | `qa/evidence/weather-fortune/r14-fortune-frame450.png` |
| M-03 | 800ms | **PASS** | `qa/evidence/weather-fortune/r14-fortune-frame800.png` |
| M-04 | 900ms | **PASS** | `qa/evidence/weather-fortune/r14-fortune-frame900.png` |

## 补充 · 交互状态

| ID | 状态 | 结果 | 证据 |
|---|---|---|---|
| S-01 | Selection 结果列表 | **PASS** | `qa/evidence/portrait-states/r14-iphone-selection-results.png`；2026 年份无千分位、含日期/宜/忌/看当日 |
| D-01 | Daily 分享页 | **PASS** | `qa/evidence/portrait-states/r14-iphone-daily-share.png`；全屏分享卡（经文/标题/白话/出处/二维码）+系统分享，不再空白 |

- Countdown 详情已对应设计行 97；Selection 结果无独立设计行，单列 S-01。
- Folklore 详情正文暂为「内容准备中」，不标读；正式 12 条内容接入前按内容缺口处理，不作 PASS。

## 汇总
- 总行数：188（screens.json 校验）。
- 结果：PASS 37 / FAIL 5 / NOT RUN 146；另 X-01..X-05 动态字体 PASS、F 3 PASS/2 NOTE、M-01..M-04 PASS、W 5 PASS/1 NOT RUN、S-01 PASS、D-01 PASS。
- 出口：每行至少 1 张原生截图；失败保留日志/设备/commit；未实现或真机不可得写 NOT RUN。
