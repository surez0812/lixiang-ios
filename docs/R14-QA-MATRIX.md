# 历象 R14 · 188 状态 QA 矩阵

- 生成器：`scripts/r14-matrix-gen.py`；权威源：`screens.json` SHA256 `ea505be157c6ceb3bc57eabe0fb00feef3eaf7d990fa6d2b8ad22264224e7409`；设计条目 188 条；**设计稿 ≠ 实现/验收通过**。
- 每行先按对应设计 PNG 自查，再在模拟器/真机跑同状态；结果只允许 PASS/FAIL/NOT RUN；证据列写截图/日志/设备。
- 当前阶段：**全部 NOT RUN**（开发自测未交；未测未就绪页面，不用设计图代替原生结果）。
- 12 画布：phone light/dark 375×930；iPad 834×1194、1194×834 ×亮暗；Duo 六姿态；Tabletop=OpenPortrait 669×951。
- page 分组不合并：home/almanac/compass/daily/fortune/folklore/folklore-detail/selection/countdown/countdown-detail/settings。

| # | 页面 | 模式/画布 | 尺寸 | 状态 | 入口 | 期望 | PASS | FAIL | NOT RUN | 证据 |
|---:|---|---|---|---|---|---|---|---|---|---|
| 1 | home 首页/日历 | phone-light·浅色 | 375×930 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPhone16Pro-tab0.png (53c2dde6…); new build 21:41; iPhone 16 Pro dark/light? light tokens |
| 2 | home 首页/日历 | phone-dark·深色 | 375×930 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/home-full/r14-home-full-dark.png (a7b676c6…); 冬至/纪念/经文/双卡/黄历/倒计日1 |
| 3 | home 首页/日历 | ipad-portrait·浅色 | 834×1194 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/ipad-portrait/r14-ipad-portrait-tab0.png; iPad portrait 2064×2752 |
| 4 | home 首页/日历 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/ipad-portrait-dark/r14-ipad-portrait-dark-tab0.png; iPad portrait dark 2064×2752 |
| 5 | home 首页/日历 | ipad-landscape·浅色 | 1194×834 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPadPro13-tab0.png (a465f368…); new build; iPad landscape |
| 6 | home 首页/日历 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/ipad-landscape-dark/r14-ipad-landscape-dark-tab0.png; iPad landscape dark 2752×2064 |
| 7 | home 首页/日历 | duo-closed-portrait·浅色 | 466×678 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/firstbatch-v2/DuoClosed-tab0.png (b495042b…); R14-Duo closed portrait; new build |
| 8 | home 首页/日历 | duo-closed-landscape·浅色 | 678×466 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | — | **FAIL** | — | Codex cases.csv duo-closed-landscape/home: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 9 | home 首页/日历 | duo-tent·浅色 | 678×466 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 10 | home 首页/日历 | duo-open-portrait·浅色 | 669×951 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | — | **FAIL** | — | Codex cases.csv duo-open-portrait/home: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 11 | home 首页/日历 | duo-open-landscape·浅色 | 951×669 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | — | **FAIL** | — | Codex cases.csv duo-open-landscape/home: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 12 | home 首页/日历 | duo-tabletop·浅色 | 669×951 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 13 | almanac 黄历 | phone-light·浅色 | 375×930 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/almanac-plain-off/r14-tokens-almanac-light.png (eaf1cc78…); 黄历主态，底色/字段完整 |
| 14 | almanac 黄历 | phone-dark·深色 | 375×930 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/visual-v2/dark-almanac.png (1ef6793a…); new build dark |
| 15 | almanac 黄历 | ipad-portrait·浅色 | 834×1194 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/ipad-portrait-routes/r14-ipad-portrait-almanac-light.png; iPad portrait 834×1194 |
| 16 | almanac 黄历 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/ipad-portrait-routes/r14-ipad-portrait-almanac-dark.png; iPad portrait 834×1194 |
| 17 | almanac 黄历 | ipad-landscape·浅色 | 1194×834 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/ipad-landscape/r14-ipad-landscape-almanac-real.png (fb8ec289…); XCUITest 2752×2064 双列 |
| 18 | almanac 黄历 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/ipad-landscape-dark/r14-ipad-landscape-dark-almanac.png; 双列 |
| 19 | almanac 黄历 | duo-closed-portrait·浅色 | 466×678 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/duo-closed-routes/r14-duo-closed-almanac.png (a99b1734…); 单列 Hero→宜忌，符合设计 |
| 20 | almanac 黄历 | duo-closed-landscape·浅色 | 678×466 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | **FAIL** | — | Codex cases.csv duo-closed-landscape/almanac: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 21 | almanac 黄历 | duo-tent·浅色 | 678×466 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 22 | almanac 黄历 | duo-open-portrait·浅色 | 669×951 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | **FAIL** | — | Codex cases.csv duo-open-portrait/almanac: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 23 | almanac 黄历 | duo-open-landscape·浅色 | 951×669 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | **FAIL** | — | Codex cases.csv duo-open-landscape/almanac: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 24 | almanac 黄历 | duo-tabletop·浅色 | 669×951 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 25 | folklore 岁时列表 | phone-light·浅色 | 375×930 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPhone16Pro-tab1.png (69cfe43f…); new build |
| 26 | folklore 岁时列表 | phone-dark·深色 | 375×930 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | **PASS** | — | — | qa/evidence/visual-v2/dark-folklore-v2.png (53d5b2a2…); HEAD 4d84b2e dark brand card |
| 27 | folklore 岁时列表 | ipad-portrait·浅色 | 834×1194 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | **PASS** | — | — | qa/evidence/ipad-portrait/r14-ipad-portrait-tab1.png; iPad portrait 2064×2752 |
| 28 | folklore 岁时列表 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | **PASS** | — | — | qa/evidence/ipad-portrait-dark/r14-ipad-portrait-dark-tab1.png; iPad portrait dark 2064×2752 |
| 29 | folklore 岁时列表 | ipad-landscape·浅色 | 1194×834 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPadPro13-tab1.png (c73b0b36…); new build |
| 30 | folklore 岁时列表 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | **PASS** | — | — | qa/evidence/ipad-landscape-dark/r14-ipad-landscape-dark-tab1.png; iPad landscape dark 2752×2064 |
| 31 | folklore 岁时列表 | duo-closed-portrait·浅色 | 466×678 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | **PASS** | — | — | qa/evidence/firstbatch-v2/DuoClosed-tab1.png (b351c337…); new build |
| 32 | folklore 岁时列表 | duo-closed-landscape·浅色 | 678×466 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | — | **FAIL** | — | Codex cases.csv duo-closed-landscape/folklore: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 33 | folklore 岁时列表 | duo-tent·浅色 | 678×466 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 34 | folklore 岁时列表 | duo-open-portrait·浅色 | 669×951 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | — | **FAIL** | — | Codex cases.csv duo-open-portrait/folklore: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 35 | folklore 岁时列表 | duo-open-landscape·浅色 | 951×669 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | — | **FAIL** | — | Codex cases.csv duo-open-landscape/folklore: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 36 | folklore 岁时列表 | duo-tabletop·浅色 | 669×951 | 默认 | 岁时根 Tab；列表活动 | 列表类别/日期/剩余/解锁/未读；未解锁不泄正文 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 37 | countdown 倒计日 | phone-light·浅色 | 375×930 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | **PASS** | — | — | qa/evidence/portrait-states/r14-countdown-empty.png (51c0cdf9…); 卸载重装空态 |
| 38 | countdown 倒计日 | phone-dark·深色 | 375×930 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | **PASS** | — | — | qa/evidence/visual-v2/dark-countdown-v2.png (b2f9cff3…); HEAD 4d84b2e dark brand card |
| 39 | countdown 倒计日 | ipad-portrait·浅色 | 834×1194 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | **PASS** | — | — | qa/evidence/ipad-portrait/r14-ipad-portrait-tab3.png; iPad portrait 2064×2752 |
| 40 | countdown 倒计日 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | **PASS** | — | — | qa/evidence/ipad-portrait-dark/r14-ipad-portrait-dark-tab3.png; iPad portrait dark 2064×2752 |
| 41 | countdown 倒计日 | ipad-landscape·浅色 | 1194×834 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPadPro13-tab3.png (d939a5b9…); new build |
| 42 | countdown 倒计日 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | **PASS** | — | — | qa/evidence/ipad-landscape-dark/r14-ipad-landscape-dark-tab3.png; iPad landscape dark 2752×2064 |
| 43 | countdown 倒计日 | duo-closed-portrait·浅色 | 466×678 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | **PASS** | — | — | qa/evidence/firstbatch-v2/DuoClosed-tab3.png (ade6de60…); new build |
| 44 | countdown 倒计日 | duo-closed-landscape·浅色 | 678×466 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | — | **FAIL** | — | Codex cases.csv duo-closed-landscape/countdown: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 45 | countdown 倒计日 | duo-tent·浅色 | 678×466 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 46 | countdown 倒计日 | duo-open-portrait·浅色 | 669×951 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | — | **FAIL** | — | Codex cases.csv duo-open-portrait/countdown: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 47 | countdown 倒计日 | duo-open-landscape·浅色 | 951×669 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | — | **FAIL** | — | Codex cases.csv duo-open-landscape/countdown: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 48 | countdown 倒计日 | duo-tabletop·浅色 | 669×951 | 默认 | 倒计日根 Tab；新增/已有条目 | 多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 49 | settings 设置 | phone-light·浅色 | 375×930 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPhone16Pro-tab4.png (1a925a01…); new build |
| 50 | settings 设置 | phone-dark·深色 | 375×930 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | **PASS** | — | — | qa/evidence/visual-v2/dark-settings-v2.png (9042b7f9…); HEAD 4d84b2e dark brand card |
| 51 | settings 设置 | ipad-portrait·浅色 | 834×1194 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | **PASS** | — | — | qa/evidence/ipad-portrait/r14-ipad-portrait-tab4.png; iPad portrait 2064×2752 |
| 52 | settings 设置 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | **PASS** | — | — | qa/evidence/ipad-portrait-dark/r14-ipad-portrait-dark-tab4.png; iPad portrait dark 2064×2752 |
| 53 | settings 设置 | ipad-landscape·浅色 | 1194×834 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPadPro13-tab4.png (0b424bff…); new build |
| 54 | settings 设置 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | **PASS** | — | — | qa/evidence/ipad-landscape-dark/r14-ipad-landscape-dark-tab4.png; iPad landscape dark 2752×2064 |
| 55 | settings 设置 | duo-closed-portrait·浅色 | 466×678 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | **PASS** | — | — | qa/evidence/firstbatch-v2/DuoClosed-tab4.png (b2c48e0e…); new build |
| 56 | settings 设置 | duo-closed-landscape·浅色 | 678×466 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | — | **FAIL** | — | Codex cases.csv duo-closed-landscape/settings: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 57 | settings 设置 | duo-tent·浅色 | 678×466 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 58 | settings 设置 | duo-open-portrait·浅色 | 669×951 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | — | **FAIL** | — | Codex cases.csv duo-open-portrait/settings: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 59 | settings 设置 | duo-open-landscape·浅色 | 951×669 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | — | **FAIL** | — | Codex cases.csv duo-open-landscape/settings: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 60 | settings 设置 | duo-tabletop·浅色 | 669×951 | 默认 | 设置根 Tab；子流程返回 | 外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 61 | selection 择日 | phone-light·浅色 | 375×930 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | **PASS** | — | — | qa/evidence/firstbatch-v2/iPhone16Pro-tab2.png (8a2eb101…); new build selection |
| 62 | selection 择日 | phone-dark·深色 | 375×930 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | **PASS** | — | — | qa/evidence/dark-pages/r14-selection-redesign-dark.png (33f40991…); 品牌 Hero 已加；表单 chip/独立卡为单独偏差 |
| 63 | selection 择日 | ipad-portrait·浅色 | 834×1194 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | **PASS** | — | — | qa/evidence/ipad-portrait-routes/r14-ipad-portrait-selection-light.png; iPad portrait 834×1194 |
| 64 | selection 择日 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | **PASS** | — | — | qa/evidence/ipad-portrait-routes/r14-ipad-portrait-selection-dark.png; iPad portrait 834×1194 |
| 65 | selection 择日 | ipad-landscape·浅色 | 1194×834 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | **PASS** | — | — | qa/evidence/ipad-landscape/r14-ipad-landscape-selection-real.png (c73e1afe…); 左表单/右结果双列，结果空态正常 |
| 66 | selection 择日 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | **PASS** | — | — | qa/evidence/ipad-landscape-dark/r14-ipad-landscape-dark-selection.png; 双列表单/空结果 |
| 67 | selection 择日 | duo-closed-portrait·浅色 | 466×678 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | **PASS** | — | — | qa/evidence/duo-closed-routes/r14-duo-closed-selection.png; 单列表单 |
| 68 | selection 择日 | duo-closed-landscape·浅色 | 678×466 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | — | **FAIL** | — | Codex cases.csv duo-closed-landscape/selection: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 69 | selection 择日 | duo-tent·浅色 | 678×466 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 70 | selection 择日 | duo-open-portrait·浅色 | 669×951 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | — | **FAIL** | — | Codex cases.csv duo-open-portrait/selection: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 71 | selection 择日 | duo-open-landscape·浅色 | 951×669 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | — | **FAIL** | — | Codex cases.csv duo-open-landscape/selection: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 72 | selection 择日 | duo-tabletop·浅色 | 669×951 | 默认 | 择日根 Tab | 事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 73 | daily 每日一句 | phone-light·浅色 | 375×930 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | **PASS** | — | — | qa/evidence/daily-redesign/r14-daily-redesign-light.png (5cd55ffe…); 新卡片：经文/出处/含义/应用/分享卡 |
| 74 | daily 每日一句 | phone-dark·深色 | 375×930 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | **PASS** | — | — | qa/evidence/dark-pages/r14-daily-redesign-dark.png (b86c10a3…); 设计卡结构+分享卡已现 |
| 75 | daily 每日一句 | ipad-portrait·浅色 | 834×1194 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | **PASS** | — | — | qa/evidence/ipad-portrait-routes/r14-ipad-portrait-daily-light.png; iPad portrait 834×1194 |
| 76 | daily 每日一句 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | **PASS** | — | — | qa/evidence/ipad-portrait-routes/r14-ipad-portrait-daily-dark.png; iPad portrait 834×1194 |
| 77 | daily 每日一句 | ipad-landscape·浅色 | 1194×834 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | **PASS** | — | — | qa/evidence/ipad-landscape/r14-ipad-landscape-light-daily-v3.png (42974f9d…); 左解释/右分享卡，无重复 |
| 78 | daily 每日一句 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | **PASS** | — | — | qa/evidence/ipad-landscape-dark/r14-ipad-landscape-dark-daily-v3.png (5032ccb0…); 分享卡强制亮色 token，文字可读，已移除左列重复块 |
| 79 | daily 每日一句 | duo-closed-portrait·浅色 | 466×678 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | **PASS** | — | — | qa/evidence/duo-closed-routes/r14-duo-closed-daily.png; 单列解释 |
| 80 | daily 每日一句 | duo-closed-landscape·浅色 | 678×466 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | **FAIL** | — | Codex cases.csv duo-closed-landscape/daily: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 81 | daily 每日一句 | duo-tent·浅色 | 678×466 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 82 | daily 每日一句 | duo-open-portrait·浅色 | 669×951 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | **FAIL** | — | Codex cases.csv duo-open-portrait/daily: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 83 | daily 每日一句 | duo-open-landscape·浅色 | 951×669 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | **FAIL** | — | Codex cases.csv duo-open-landscape/daily: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 84 | daily 每日一句 | duo-tabletop·浅色 | 669×951 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 85 | folklore-detail 岁时详情 | phone-light·浅色 | 375×930 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 内容门禁：WD 正文为 P1 示例段落/内容准备中，正式内容未接入，不能评正文可读 |
| 86 | folklore-detail 岁时详情 | phone-dark·深色 | 375×930 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 同 85 内容缺口；dark 默认无有效详情证据（现有图误为 Home/旧 2027 千分位） |
| 87 | folklore-detail 岁时详情 | ipad-portrait·浅色 | 834×1194 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 内容缺口同 85；且无 iPad portrait 详情证据 |
| 88 | folklore-detail 岁时详情 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 内容缺口同 85；且无 iPad portrait dark 详情证据 |
| 89 | folklore-detail 岁时详情 | ipad-landscape·浅色 | 1194×834 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 内容缺口同 85；且无 iPad landscape 详情证据 |
| 90 | folklore-detail 岁时详情 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 内容缺口同 85；且无 iPad landscape dark 详情证据 |
| 91 | folklore-detail 岁时详情 | duo-closed-portrait·浅色 | 466×678 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | **PASS** | — | — | qa/evidence/duo-closed-routes/r14-duo-closed-folklore-detail.png; 紧凑头/满宽 |
| 92 | folklore-detail 岁时详情 | duo-closed-landscape·浅色 | 678×466 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | **FAIL** | — | Codex cases.csv duo-closed-landscape/folklore-detail: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 93 | folklore-detail 岁时详情 | duo-tent·浅色 | 678×466 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 94 | folklore-detail 岁时详情 | duo-open-portrait·浅色 | 669×951 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | **FAIL** | — | Codex cases.csv duo-open-portrait/folklore-detail: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 95 | folklore-detail 岁时详情 | duo-open-landscape·浅色 | 951×669 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | **FAIL** | — | Codex cases.csv duo-open-landscape/folklore-detail: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 96 | folklore-detail 岁时详情 | duo-tabletop·浅色 | 669×951 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 97 | countdown-detail 倒计日详情 | phone-light·浅色 | 375×930 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | **PASS** | — | — | qa/evidence/countdown-detail-phone/r14-countdown-detail-phone-light.png (04bcdbb6…); 生日/2027-02-06/85天/农历每年/提醒09:00 |
| 98 | countdown-detail 倒计日详情 | phone-dark·深色 | 375×930 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | **PASS** | — | — | qa/evidence/countdown-detail-phone/r14-countdown-detail-phone-dark.png (6b7c74d4…); dark 同字段可读 |
| 99 | countdown-detail 倒计日详情 | ipad-portrait·浅色 | 834×1194 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | **PASS** | — | — | qa/evidence/ipad-countdown-detail/r14-ipad-portrait-countdown-detail-light.png (36e82602…); 生日/2027-02-06/85天/农历每年/提醒09:00 |
| 100 | countdown-detail 倒计日详情 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | **PASS** | — | — | qa/evidence/ipad-countdown-detail/r14-ipad-portrait-countdown-detail-dark.png (8b20b8ca…); dark 同字段 |
| 101 | countdown-detail 倒计日详情 | ipad-landscape·浅色 | 1194×834 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | **PASS** | — | — | qa/evidence/ipad-countdown-detail/r14-ipad-landscape-countdown-detail-light.png (5a93d0dd…); 同字段 |
| 102 | countdown-detail 倒计日详情 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | **PASS** | — | — | qa/evidence/ipad-countdown-detail/r14-ipad-landscape-countdown-detail-dark.png (a69be861…); dark 同字段 |
| 103 | countdown-detail 倒计日详情 | duo-closed-portrait·浅色 | 466×678 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | **PASS** | — | — | qa/evidence/duo-closed-routes/r14-duo-closed-countdown-detail.png; 单列详情 |
| 104 | countdown-detail 倒计日详情 | duo-closed-landscape·浅色 | 678×466 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | **FAIL** | — | Codex cases.csv duo-closed-landscape/countdown-detail: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 105 | countdown-detail 倒计日详情 | duo-tent·浅色 | 678×466 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 106 | countdown-detail 倒计日详情 | duo-open-portrait·浅色 | 669×951 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | **FAIL** | — | Codex cases.csv duo-open-portrait/countdown-detail: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 107 | countdown-detail 倒计日详情 | duo-open-landscape·浅色 | 951×669 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | **FAIL** | — | Codex cases.csv duo-open-landscape/countdown-detail: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 108 | countdown-detail 倒计日详情 | duo-tabletop·浅色 | 669×951 | 默认 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 109 | fortune 每日一签 | phone-light·浅色 | 375×930 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/weather-fortune/r14-fortune-frame0.png (aaf6270f…); 每日一签 idle/待机 |
| 110 | fortune 每日一签 | phone-dark·深色 | 375×930 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/dark-pages/r14-fortune-redesign-dark.png (c0091914…); 主按钮旁常显跳过动画 |
| 111 | fortune 每日一签 | ipad-portrait·浅色 | 834×1194 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/ipad-portrait-routes/r14-ipad-portrait-fortune-light.png; iPad portrait 834×1194 |
| 112 | fortune 每日一签 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/ipad-portrait-routes/r14-ipad-portrait-fortune-dark.png; iPad portrait 834×1194 |
| 113 | fortune 每日一签 | ipad-landscape·浅色 | 1194×834 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/ipad-landscape/r14-ipad-landscape-fortune-real.png (402f7a0e…); 左标题/右签筒/底部全宽按钮+跳过 |
| 114 | fortune 每日一签 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/ipad-landscape-dark/r14-ipad-landscape-dark-fortune.png; 左标题/右筒/全宽按钮+跳过 |
| 115 | fortune 每日一签 | duo-closed-portrait·浅色 | 466×678 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/duo-closed-routes/r14-duo-closed-fortune.png; 单列签筒/按钮 |
| 116 | fortune 每日一签 | duo-closed-landscape·浅色 | 678×466 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | **FAIL** | — | Codex cases.csv duo-closed-landscape/fortune: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 117 | fortune 每日一签 | duo-tent·浅色 | 678×466 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 118 | fortune 每日一签 | duo-open-portrait·浅色 | 669×951 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | **FAIL** | — | Codex cases.csv duo-open-portrait/fortune: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 119 | fortune 每日一签 | duo-open-landscape·浅色 | 951×669 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | **FAIL** | — | Codex cases.csv duo-open-landscape/fortune: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 120 | fortune 每日一签 | duo-tabletop·浅色 | 669×951 | 默认 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 121 | compass 罗盘 | phone-light·浅色 | 375×930 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/compass-day/r14-compass-day-light-uitest.png (67df00b8…); 日方位选中/无选择时辰/五神+煞方+十二时辰 |
| 122 | compass 罗盘 | phone-dark·深色 | 375×930 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/compass-day/r14-compass-day-dark-uitest.png (62f45f2f…); dark 日方位/五神+煞方+十二时辰 |
| 123 | compass 罗盘 | ipad-portrait·浅色 | 834×1194 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/ipad-portrait-routes/r14-ipad-portrait-compass-light.png; iPad portrait 834×1194 |
| 124 | compass 罗盘 | ipad-portrait-dark·深色 | 834×1194 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/ipad-portrait-routes/r14-ipad-portrait-compass-dark.png; iPad portrait 834×1194 |
| 125 | compass 罗盘 | ipad-landscape·浅色 | 1194×834 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/ipad-landscape/r14-ipad-landscape-compass-real.png (ab5ff4cd…); 左控件/右盘面+竖排 legend |
| 126 | compass 罗盘 | ipad-landscape-dark·深色 | 1194×834 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/ipad-landscape-dark/r14-ipad-landscape-dark-compass.png; 左控件/右盘+legend |
| 127 | compass 罗盘 | duo-closed-portrait·浅色 | 466×678 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/duo-closed-routes/r14-duo-closed-compass.png (b5d25601…); 单列 控件→盘面→图例，符合设计 |
| 128 | compass 罗盘 | duo-closed-landscape·浅色 | 678×466 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | **FAIL** | — | Codex cases.csv duo-closed-landscape/compass: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 129 | compass 罗盘 | duo-tent·浅色 | 678×466 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 130 | compass 罗盘 | duo-open-portrait·浅色 | 669×951 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | **FAIL** | — | Codex cases.csv duo-open-portrait/compass: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 131 | compass 罗盘 | duo-open-landscape·浅色 | 951×669 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | **FAIL** | — | Codex cases.csv duo-open-landscape/compass: FAIL_AT_OBSERVATION（6s 空白/route 返 home）；archive 690a26b6… |
| 132 | compass 罗盘 | duo-tabletop·浅色 | 669×951 | 默认 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 133 | fortune 每日一签 | phone-light·浅色 | 375×930 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/fortune-result/r14-fortune-result-paper-phone-light.png (d5d7ef79…); 红绳卷轴，红色主按钮「收好今日一签」 |
| 134 | almanac 黄历 | phone-light·浅色 | 375×930 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/almanac-plain-off/r14-almanac-plain-off-phone-light.png (cd6638e1…); 白话开关灰/关，紧凑逐项保留 |
| 135 | fortune 每日一签 | phone-dark·深色 | 375×930 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/fortune-result/r14-fortune-result-paper-phone-dark.png (ce5f98a8…); dark 红绳卷轴/结果全显/红按钮 |
| 136 | almanac 黄历 | phone-dark·深色 | 375×930 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/almanac-plain-off/r14-almanac-plain-off-phone-dark.png (93b5eed5…); dark 白话关，紧凑逐项保留 |
| 137 | fortune 每日一签 | ipad-portrait·浅色 | 834×1194 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/fortune-result/r14-ipad-portrait-light-fortune-result-v3.png (e63496f6…); 卷轴居中/结果全显/红按钮 |
| 138 | almanac 黄历 | ipad-portrait·浅色 | 834×1194 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/almanac-plain-off/r14-ipad-portrait-almanac-light.png; 白话全解关闭，宜忌紧凑字段保留 |
| 139 | fortune 每日一签 | ipad-portrait-dark·深色 | 834×1194 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/fortune-result/r14-ipad-portrait-dark-fortune-result-v3.png (4a6a007f…); dark 卷轴/结果全显/红按钮 |
| 140 | almanac 黄历 | ipad-portrait-dark·深色 | 834×1194 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/almanac-plain-off/r14-ipad-portrait-almanac-dark.png; 白话全解关闭，宜忌紧凑字段保留 |
| 141 | fortune 每日一签 | ipad-landscape·浅色 | 1194×834 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/fortune-result/r14-ipad-landscape-light-fortune-result-v3.png (fc56f4b5…); 左标题/右卷轴/红按钮 |
| 142 | almanac 黄历 | ipad-landscape·浅色 | 1194×834 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/almanac-plain-off/r14-ipad-landscape-almanac-real.png; 白话全解关闭，宜忌紧凑字段保留 |
| 143 | fortune 每日一签 | ipad-landscape-dark·深色 | 1194×834 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/fortune-result/r14-ipad-landscape-dark-fortune-result-v3.png (e253249c…); dark 左标题/右卷轴/红按钮 |
| 144 | almanac 黄历 | ipad-landscape-dark·深色 | 1194×834 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/almanac-plain-off/r14-ipad-landscape-dark-almanac-v2.png; 白话全解关闭，宜忌紧凑字段保留 |
| 145 | fortune 每日一签 | duo-closed-portrait·浅色 | 466×678 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | **PASS** | — | — | qa/evidence/fortune-result/r14-duo-closed-fortune-result-v3.png (a34197b2…); 卷轴/结果全显/红按钮 |
| 146 | almanac 黄历 | duo-closed-portrait·浅色 | 466×678 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/almanac-plain-off/r14-duo-closed-almanac.png; 白话全解关闭，宜忌紧凑字段保留 |
| 147 | fortune 每日一签 | duo-closed-landscape·浅色 | 678×466 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | Codex 未覆盖 Duo 额外状态 |
| 148 | almanac 黄历 | duo-closed-landscape·浅色 | 678×466 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | Codex 未覆盖 Duo 额外状态 |
| 149 | fortune 每日一签 | duo-tent·浅色 | 678×466 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 150 | almanac 黄历 | duo-tent·浅色 | 678×466 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 151 | fortune 每日一签 | duo-open-portrait·浅色 | 669×951 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | Codex 未覆盖 Duo 额外状态 |
| 152 | almanac 黄历 | duo-open-portrait·浅色 | 669×951 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | Codex 未覆盖 Duo 额外状态 |
| 153 | fortune 每日一签 | duo-open-landscape·浅色 | 951×669 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | Codex 未覆盖 Duo 额外状态 |
| 154 | almanac 黄历 | duo-open-landscape·浅色 | 951×669 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | Codex 未覆盖 Duo 额外状态 |
| 155 | fortune 每日一签 | duo-tabletop·浅色 | 669×951 | 结果态全显，无内部滚动 | 首页一签工具卡 | 待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 156 | almanac 黄历 | duo-tabletop·浅色 | 669×951 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 157 | home 首页/日历 | phone-light·浅色 | 375×930 | 无匹配岁时/纪念，无空占位 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/portrait-states/r14-home-no-matches.png (b5965414…); 2026-06-15 no matches |
| 158 | home 首页/日历 | phone-light·浅色 | 375×930 | 定位允许/天气就绪 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/weather-fortune/r14-home-weather-loaded.png (31de88b6…); weather loaded |
| 159 | home 首页/日历 | phone-light·浅色 | 375×930 | 定位拒绝，核心不阻断 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/weather-fortune/r14-home-weather-denied.png (42030862…); weather denied |
| 160 | home 首页/日历 | phone-light·浅色 | 375×930 | 定位中/加载 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | **PASS** | — | — | qa/evidence/weather-fortune/r14-home-weather-locating.png (326c049c…); weather locating |
| 161 | almanac 黄历 | phone-light·浅色 | 375×930 | 无岁时/节日时隐藏入口 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/portrait-states/r14-almanac-no-festival.png (dad4eb3e…); 2026-06-15 |
| 162 | almanac 黄历 | phone-light·浅色 | 375×930 | 节气/冬季边界 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | **PASS** | — | — | qa/evidence/portrait-states/r14-almanac-winter.png (33365e06…); 2026-12-22 冬至/almanac winter |
| 163 | folklore-detail 岁时详情 | phone-light·浅色 | 375×930 | 今日解锁/已读边界 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 今日解锁仅有 P1 示例段落（5天），正文为占位稿，不能评正文/已读边界 |
| 164 | folklore-detail 岁时详情 | phone-light·浅色 | 375×930 | 离线/加载失败可重试 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 离线/加载失败态需断网注入，当前无独立证据，保持 NOT RUN |
| 165 | countdown-detail 倒计日详情 | phone-light·浅色 | 375×930 | 新建入口/校验 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | **PASS** | — | — | qa/evidence/countdown-new-form/r14-countdown-new-form-empty.png (01872ae6…) + filled (d2eaf443…); 名称空保存灰禁用/取消可用；输入名称保存红可用 |
| 166 | countdown-detail 倒计日详情 | phone-light·浅色 | 375×930 | 请求前说明，不擅自弹权限 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 请求前说明/权限前置无可复用证据，需人工/XCUITest 交互，保持 NOT RUN |
| 167 | countdown-detail 倒计日详情 | phone-light·浅色 | 375×930 | 系统权限弹窗 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 系统权限弹窗无法在无 GUI 的 CLI 稳定截取，需 XCUITest/真机，保持 NOT RUN |
| 168 | countdown-detail 倒计日详情 | phone-light·浅色 | 375×930 | 允许后安排提醒 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 允许后安排提醒需系统通知授权与等待，当前未覆盖，保持 NOT RUN |
| 169 | countdown-detail 倒计日详情 | phone-light·浅色 | 375×930 | 拒绝不阻断；设置返回重读 | 倒计日列表/首页，带条目 ID | 详情/编辑/删除；权限分支；通知更新；无效 ID 恢复 | — | — | **NOT RUN** | 拒绝后设置返回重读需系统设置交互，当前未覆盖，保持 NOT RUN |
| 170 | home 首页/日历 | phone-light·浅色 | 375×2500 | 默认 | 日历根 Tab；经文/签/岁时/摘要/月历入口 | Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确 | — | — | **NOT RUN** | 设计 375×2500 长图；现有仅 375×930 首屏，不能冒充长图 PASS |
| 171 | almanac 黄历 | phone-light·浅色 | 375×12000 | 默认 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 设计 375×2500 长图；无长图证据，保持 NOT RUN |
| 172 | almanac 黄历 | phone-light·浅色 | 375×6500 | 白话关：紧凑值仍保留全部字段 | 首页/月历/择日/前后日/罗盘返回 | 日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期 | — | — | **NOT RUN** | 设计 375×2500 长图；无长图证据，保持 NOT RUN |
| 173 | daily 每日一句 | phone-light·浅色 | 375×1650 | 默认 | 首页每日一句 | 完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡 | — | — | **NOT RUN** | 设计 375×2500 长图；现有为 375×930 首屏，保持 NOT RUN |
| 174 | folklore-detail 岁时详情 | phone-light·浅色 | 375×2400 | 默认 | 岁时列表/首页/黄历，带 eventID+版本 | 紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读 | — | — | **NOT RUN** | 设计 375×2500 长图；无长图证据，保持 NOT RUN |
| 175 | compass 罗盘 | phone-light·浅色 | 375×930 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/compass-selector/r14-compass-selector-light.png (2c73fc84…); 时方位+选择时辰+时间范围，五神标签可见 |
| 176 | compass 罗盘 | phone-dark·深色 | 375×930 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/compass-selector/r14-compass-selector-dark-v2.png (4a1cb98c…); 五神 pill 深墨可见+煞方 |
| 177 | compass 罗盘 | ipad-portrait·浅色 | 834×1194 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/ipad-compass-hour/r14-ipad-portrait-compass-hour-light.png (03899119…); 时方位+选择时辰/时间范围+五神+煞方+十二时辰 |
| 178 | compass 罗盘 | ipad-portrait-dark·深色 | 834×1194 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/ipad-compass-hour/r14-ipad-portrait-compass-hour-dark.png (2b07f387…); 时方位+选择时辰/时间范围+五神+煞方+十二时辰 |
| 179 | compass 罗盘 | ipad-landscape·浅色 | 1194×834 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/ipad-compass-hour/r14-ipad-landscape-compass-hour-light.png (3311ed7a…); 时方位+选择时辰/时间范围+五神+煞方+十二时辰 |
| 180 | compass 罗盘 | ipad-landscape-dark·深色 | 1194×834 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | **PASS** | — | — | qa/evidence/ipad-compass-hour/r14-ipad-landscape-compass-hour-dark.png (245c741a…); 时方位+选择时辰/时间范围+五神+煞方+十二时辰 |
| 181 | compass 罗盘 | duo-closed-portrait·浅色 | 466×678 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | Codex 未覆盖 Duo 额外状态（cases.csv 只 5 tab+7 路由） |
| 182 | compass 罗盘 | duo-closed-landscape·浅色 | 678×466 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | Codex 未覆盖 Duo 额外状态 |
| 183 | compass 罗盘 | duo-tent·浅色 | 678×466 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
| 184 | compass 罗盘 | duo-open-portrait·浅色 | 669×951 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | Codex 未覆盖 Duo 额外状态 |
| 185 | compass 罗盘 | duo-open-landscape·浅色 | 951×669 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | Codex 未覆盖 Duo 额外状态 |
| 186 | compass 罗盘 | duo-tabletop·浅色 | 669×951 | 时态；十二时辰/方向同步 | 黄历右上「值神罗盘」 | 日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致 | — | — | **NOT RUN** | Codex cases.csv: Tabletop/Tent 无 Device Hub 物理姿态控件，NOT RUN |
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
| S-01 | Selection 结果列表 light | **PASS** | `qa/evidence/portrait-states/r14-iphone-selection-results.png`；2026 年份无千分位、含日期/宜/忌/看当日 |
| S-02 | Selection 结果列表 dark | **PASS** | `qa/evidence/portrait-states/r14-iphone-selection-results-dark.png`；深底可读、日期/宜/忌/看当日 |
| D-01 | Daily 分享页 | **PASS** | `qa/evidence/portrait-states/r14-iphone-daily-share.png`；全屏分享卡（经文/标题/白话/出处/二维码）+系统分享，不再空白 |

- Countdown 详情已对应设计行 97；Selection 结果无独立设计行，单列 S-01。
- Folklore 详情正文暂为「内容准备中」，不标读；正式 12 条内容接入前按内容缺口处理，不作 PASS。

## 补充 · Compass 12 时辰

| ID | 时辰 | 结果 | 证据 |
|---|---|---|---|
| C-00 | 00 | **PASS** | `qa/evidence/compass-hours/r14-compass-hour0.png`；子时 |
| C-01 | 01 | **PASS** | `qa/evidence/compass-hours/r14-compass-hour1.png`（dev 图，01:00） |
| C-03 | 03 | **PASS** | `qa/evidence/compass-hours/r14-compass-hour3.png` |
| C-05 | 05 | **PASS** | `qa/evidence/compass-hours/r14-compass-hour5.png`；卯时·辛卯 05:00—06:59，煞西 |
| C-06 | 06 | **PASS** | `r14-compass-hour6.png`；卯时边界（旧截） |
| C-07 | 07 | **PASS** | `r14-compass-hour7.png`；辰时·壬辰 07:00—08:59，煞南 |
| C-09 | 09 | **PASS** | `r14-compass-hour9.png` |
| C-11 | 11 | **PASS** | `r14-compass-hour11.png`；午时·甲午 11:00—12:59，煞北 |
| C-13 | 13 | **PASS** | `r14-compass-hour13.png` |
| C-15 | 15 | **PASS** | `r14-compass-hour15.png` |
| C-17 | 17 | **PASS** | `r14-compass-hour17.png`；酉时·丁酉 17:00—18:59，煞东 |
| C-18 | 18 | **PASS** | `r14-compass-hour18.png`；酉时边界（旧截） |
| C-19 | 19 | **PASS** | `r14-compass-hour19.png`；戌时·戊戌 19:00—20:59，煞北 |
| C-21 | 21 | **PASS** | `r14-compass-hour21.png` |
| C-23 | 23 | **PASS** | `r14-compass-hour23.png`；子时·庚子 23:00—23:59，煞南 |

## 补充 · Home 完整/多内容态

| ID | 状态 | 结果 | 证据 |
|---|---|---|---|
| H-01 | Home 完整 light | **PASS** | `qa/evidence/home-full/r14-home-full-light.png`；冬至一候/日期/纪念/经文/双卡/黄历/倒计日1 可见 |
| H-02 | Home 完整 dark | **PASS** | `qa/evidence/home-full/r14-home-full-dark.png`；同内容深色可读 |

- 注：两张为 375×930 首屏证据，不是设计 375×2500 长图；screens.json 行 170 的长图全量仍 **NOT RUN**。

## 补充 · Duo folklore-detail T-10/T-9

| ID | 状态 | 结果 | 证据 |
|---|---|---|---|
| T-10 | 还有10天 | **NOTE/内容缺口** | `qa/evidence/duo-closed-routes/r14-folklore-detail-t10.png`；显示「内容准备中」，正文不可读 |
| T-09 | 还有9天 | **NOTE/内容缺口** | `qa/evidence/duo-closed-routes/r14-folklore-detail-t9.png`；显示「内容准备中」 |

- 示例稿 version=0 被内容门禁拦截，T-10 正文可读性无法验证；不标 PASS。

## 补充 · Duo Codex 中期

- Codex 中期 **36 用例未通过**，不标 PASS；最终证据到后统一复评。
- Tabletop/Tent 无 Device Hub 控件 → NOT RUN。
- Closed Landscape / Open Landscape 有白屏/rail 缺失，dev 修复中。
- 最终映射：36 case observations FAIL；唯一 matrix 行 33 FAIL（selection tab/route 重复）；Tabletop/Tent 24 NOT RUN；closed-portrait 13 既有 PASS 保留；额外状态 NOT RUN。实际 100 PASS/33 FAIL/55 NOT RUN，未硬凑 36/35。
- 归档 690a26b6…；修复后 2314dd8e… 尚未重跑 Duo；未操作 R14-Duo `B77A…`。

## 汇总
- 总行数：188（screens.json 校验）。
- 结果：PASS 100 / FAIL 33 / NOT RUN 55；另 X-01..X-05 动态字体 PASS、F 3 PASS/2 NOTE、M-01..M-04 PASS、W 5 PASS/1 NOT RUN、S-01 PASS、S-02 PASS、D-01 PASS；C-00..C-23 采样 15 个时点覆盖 12 时辰，全部 PASS；五神固定按设计结构待确认；H-01/H-02 首屏完整态 PASS；T-10/T-9 NOTE。
- 出口：每行至少 1 张原生截图；失败保留日志/设备/commit；未实现或真机不可得写 NOT RUN。
