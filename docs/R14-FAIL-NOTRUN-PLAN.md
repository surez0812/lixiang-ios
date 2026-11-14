# R14 33 FAIL + 55 NOT RUN 逐行整改计划

基线：`docs/R14-QA-MATRIX.md` **100 PASS / 33 FAIL / 55 NOT RUN**；历史包 e83753a8/b3d89116/8c4119b1 结果按 build 保留，不混写。

## 逐行表（88 行）

| 行 | 页面 | 画布 | 状态 | 状态值 | 根因/缺口 | 负责人 | 依赖 | 对应包 commit | 非作者 QA | 证据 |
|---:|---|---|---|---|---|---|---|---|---|---|
| 8 | home 首页/日历 | duo-closed-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 9 | home 首页/日历 | duo-tent·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 10 | home 首页/日历 | duo-open-portrait·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 11 | home 首页/日历 | duo-open-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 12 | home 首页/日历 | duo-tabletop·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 20 | almanac 黄历 | duo-closed-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 21 | almanac 黄历 | duo-tent·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 22 | almanac 黄历 | duo-open-portrait·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 23 | almanac 黄历 | duo-open-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 24 | almanac 黄历 | duo-tabletop·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 32 | folklore 岁时列表 | duo-closed-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 33 | folklore 岁时列表 | duo-tent·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 34 | folklore 岁时列表 | duo-open-portrait·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 35 | folklore 岁时列表 | duo-open-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 36 | folklore 岁时列表 | duo-tabletop·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 44 | countdown 倒计日 | duo-closed-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 45 | countdown 倒计日 | duo-tent·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 46 | countdown 倒计日 | duo-open-portrait·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 47 | countdown 倒计日 | duo-open-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 48 | countdown 倒计日 | duo-tabletop·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 56 | settings 设置 | duo-closed-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 57 | settings 设置 | duo-tent·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 58 | settings 设置 | duo-open-portrait·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 59 | settings 设置 | duo-open-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 60 | settings 设置 | duo-tabletop·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 68 | selection 择日 | duo-closed-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 69 | selection 择日 | duo-tent·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 70 | selection 择日 | duo-open-portrait·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 71 | selection 择日 | duo-open-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 72 | selection 择日 | duo-tabletop·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 80 | daily 每日一句 | duo-closed-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 81 | daily 每日一句 | duo-tent·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 82 | daily 每日一句 | duo-open-portrait·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 83 | daily 每日一句 | duo-open-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 84 | daily 每日一句 | duo-tabletop·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 85 | folklore-detail 岁时详情 | phone-light·浅色 | 默认 | NOT RUN | 正式岁时内容未接入（示例稿被内容门禁拦截） | PM 内容 + dev 接入 | 正式 12 条内容/版本审批 | 下一内容包 | QA 复测详情 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 86 | folklore-detail 岁时详情 | phone-dark·深色 | 默认 | NOT RUN | 正式岁时内容未接入（示例稿被内容门禁拦截） | PM 内容 + dev 接入 | 正式 12 条内容/版本审批 | 下一内容包 | QA 复测详情 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 87 | folklore-detail 岁时详情 | ipad-portrait·浅色 | 默认 | NOT RUN | 正式岁时内容未接入（示例稿被内容门禁拦截） | PM 内容 + dev 接入 | 正式 12 条内容/版本审批 | 下一内容包 | QA 复测详情 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 88 | folklore-detail 岁时详情 | ipad-portrait-dark·深色 | 默认 | NOT RUN | 正式岁时内容未接入（示例稿被内容门禁拦截） | PM 内容 + dev 接入 | 正式 12 条内容/版本审批 | 下一内容包 | QA 复测详情 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 89 | folklore-detail 岁时详情 | ipad-landscape·浅色 | 默认 | NOT RUN | 正式岁时内容未接入（示例稿被内容门禁拦截） | PM 内容 + dev 接入 | 正式 12 条内容/版本审批 | 下一内容包 | QA 复测详情 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 90 | folklore-detail 岁时详情 | ipad-landscape-dark·深色 | 默认 | NOT RUN | 正式岁时内容未接入（示例稿被内容门禁拦截） | PM 内容 + dev 接入 | 正式 12 条内容/版本审批 | 下一内容包 | QA 复测详情 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 92 | folklore-detail 岁时详情 | duo-closed-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 93 | folklore-detail 岁时详情 | duo-tent·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 94 | folklore-detail 岁时详情 | duo-open-portrait·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 95 | folklore-detail 岁时详情 | duo-open-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 96 | folklore-detail 岁时详情 | duo-tabletop·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 104 | countdown-detail 倒计日详情 | duo-closed-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 105 | countdown-detail 倒计日详情 | duo-tent·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 106 | countdown-detail 倒计日详情 | duo-open-portrait·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 107 | countdown-detail 倒计日详情 | duo-open-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 108 | countdown-detail 倒计日详情 | duo-tabletop·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 116 | fortune 每日一签 | duo-closed-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 117 | fortune 每日一签 | duo-tent·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 118 | fortune 每日一签 | duo-open-portrait·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 119 | fortune 每日一签 | duo-open-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 120 | fortune 每日一签 | duo-tabletop·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 128 | compass 罗盘 | duo-closed-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 129 | compass 罗盘 | duo-tent·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 130 | compass 罗盘 | duo-open-portrait·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 131 | compass 罗盘 | duo-open-landscape·浅色 | 默认 | FAIL | 旧包 6s/22s 白屏/底栏观测；rail/route 已修未逐页重验 | QA/Codex 复测；dev 按需修 | Duo pose + 新包 | b3d89116/新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 132 | compass 罗盘 | duo-tabletop·浅色 | 默认 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 147 | fortune 每日一签 | duo-closed-landscape·浅色 | 结果态全显，无内部滚动 | NOT RUN | Duo 结果态/白话关未在修复后按姿态复验 | QA/Codex 复测 | Duo pose 重验 | 8c4119b1 后新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 148 | almanac 黄历 | duo-closed-landscape·浅色 | 白话关：紧凑值仍保留全部字段 | NOT RUN | Duo 结果态/白话关未在修复后按姿态复验 | QA/Codex 复测 | Duo pose 重验 | 8c4119b1 后新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 149 | fortune 每日一签 | duo-tent·浅色 | 结果态全显，无内部滚动 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 150 | almanac 黄历 | duo-tent·浅色 | 白话关：紧凑值仍保留全部字段 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 151 | fortune 每日一签 | duo-open-portrait·浅色 | 结果态全显，无内部滚动 | NOT RUN | Duo 结果态/白话关未在修复后按姿态复验 | QA/Codex 复测 | Duo pose 重验 | 8c4119b1 后新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 152 | almanac 黄历 | duo-open-portrait·浅色 | 白话关：紧凑值仍保留全部字段 | NOT RUN | Duo 结果态/白话关未在修复后按姿态复验 | QA/Codex 复测 | Duo pose 重验 | 8c4119b1 后新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 153 | fortune 每日一签 | duo-open-landscape·浅色 | 结果态全显，无内部滚动 | NOT RUN | Duo 结果态/白话关未在修复后按姿态复验 | QA/Codex 复测 | Duo pose 重验 | 8c4119b1 后新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 154 | almanac 黄历 | duo-open-landscape·浅色 | 白话关：紧凑值仍保留全部字段 | NOT RUN | Duo 结果态/白话关未在修复后按姿态复验 | QA/Codex 复测 | Duo pose 重验 | 8c4119b1 后新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 155 | fortune 每日一签 | duo-tabletop·浅色 | 结果态全显，无内部滚动 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 156 | almanac 黄历 | duo-tabletop·浅色 | 白话关：紧凑值仍保留全部字段 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 163 | folklore-detail 岁时详情 | phone-light·浅色 | 今日解锁/已读边界 | NOT RUN | 正式岁时内容未接入（示例稿被内容门禁拦截） | PM 内容 + dev 接入 | 正式 12 条内容/版本审批 | 下一内容包 | QA 复测详情 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 164 | folklore-detail 岁时详情 | phone-light·浅色 | 离线/加载失败可重试 | NOT RUN | 离线/加载失败状态未实现/未注入 | dev 实现 + QA 注入 | 网络异常注入/本地内容服务 | 下一包 | QA 离线复测 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 166 | countdown-detail 倒计日详情 | phone-light·浅色 | 请求前说明，不擅自弹权限 | NOT RUN | 通知权限前置/弹窗/允许/拒绝返回未测 | dev 检查 + QA 新装/真机 | 通知权限交互与设置返回 | 下一包 | QA 权限复测 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 167 | countdown-detail 倒计日详情 | phone-light·浅色 | 系统权限弹窗 | NOT RUN | 通知权限前置/弹窗/允许/拒绝返回未测 | dev 检查 + QA 新装/真机 | 通知权限交互与设置返回 | 下一包 | QA 权限复测 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 168 | countdown-detail 倒计日详情 | phone-light·浅色 | 允许后安排提醒 | NOT RUN | 通知权限前置/弹窗/允许/拒绝返回未测 | dev 检查 + QA 新装/真机 | 通知权限交互与设置返回 | 下一包 | QA 权限复测 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 169 | countdown-detail 倒计日详情 | phone-light·浅色 | 拒绝不阻断；设置返回重读 | NOT RUN | 通知权限前置/弹窗/允许/拒绝返回未测 | dev 检查 + QA 新装/真机 | 通知权限交互与设置返回 | 下一包 | QA 权限复测 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 170 | home 首页/日历 | phone-light·浅色 | 默认 | NOT RUN | 2500/1650/12000 长图或全量滚动缺证 | QA 长图采集/拼接 | 长图方案 | 证据补齐包 | QA 长图 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 171 | almanac 黄历 | phone-light·浅色 | 默认 | NOT RUN | 2500/1650/12000 长图或全量滚动缺证 | QA 长图采集/拼接 | 长图方案 | 证据补齐包 | QA 长图 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 172 | almanac 黄历 | phone-light·浅色 | 白话关：紧凑值仍保留全部字段 | NOT RUN | 2500/1650/12000 长图或全量滚动缺证 | QA 长图采集/拼接 | 长图方案 | 证据补齐包 | QA 长图 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 173 | daily 每日一句 | phone-light·浅色 | 默认 | NOT RUN | 2500/1650/12000 长图或全量滚动缺证 | QA 长图采集/拼接 | 长图方案 | 证据补齐包 | QA 长图 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 174 | folklore-detail 岁时详情 | phone-light·浅色 | 默认 | NOT RUN | 正式岁时内容未接入（示例稿被内容门禁拦截） | PM 内容 + dev 接入 | 正式 12 条内容/版本审批 | 下一内容包 | QA 复测详情 | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 181 | compass 罗盘 | duo-closed-portrait·浅色 | 时态；十二时辰/方向同步 | NOT RUN | Duo 罗盘时态未在修复后按姿态复验 | QA/Codex 复测 | Duo pose 重验 | 8c4119b1 后新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 182 | compass 罗盘 | duo-closed-landscape·浅色 | 时态；十二时辰/方向同步 | NOT RUN | Duo 罗盘时态未在修复后按姿态复验 | QA/Codex 复测 | Duo pose 重验 | 8c4119b1 后新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 183 | compass 罗盘 | duo-tent·浅色 | 时态；十二时辰/方向同步 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 184 | compass 罗盘 | duo-open-portrait·浅色 | 时态；十二时辰/方向同步 | NOT RUN | Duo 罗盘时态未在修复后按姿态复验 | QA/Codex 复测 | Duo pose 重验 | 8c4119b1 后新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 185 | compass 罗盘 | duo-open-landscape·浅色 | 时态；十二时辰/方向同步 | NOT RUN | Duo 罗盘时态未在修复后按姿态复验 | QA/Codex 复测 | Duo pose 重验 | 8c4119b1 后新包 | QA/Codex | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |
| 186 | compass 罗盘 | duo-tabletop·浅色 | 时态；十二时辰/方向同步 | NOT RUN | Device Hub 姿态约定：Tabletop=PartiallyOpen+rotation；Tent≡ClosedLandscape；28 行（14 对） | QA 记录 / 外部决策 | Device Hub 姿态入口 | 不得替代 | 保持 NOT RUN | `shots/codex-rail-route-b3d89116/` 或 `qa/evidence/` |

## 分组与批次

### A. Duo 33 FAIL（旧观测失败，需新包按姿态逐页重验）
- 行：8,10,11,20,22,23,32,34,35,44,46,47,56,58,59,68,70,71,80,82,83,92,94,95,104,106,107,116,118,119,128,130,131
- 根因：2314/e837 包 6s/22s 白屏、底部 Tab；b3d89116 已确认 Open rail/Closed 底栏/seed route，但这些行未逐页复验
- 负责人：QA/Codex 复测；dev 按新证据修
- 关闭条件：新不可变包 + 对应姿态/页面视觉证据；禁止代码检查替代

### B. Tabletop/Tent 28 行（14 对）NOT RUN（环境限制）
- 行：9,12,21,24,33,36,45,48,57,60,69,72,81,84,93,96,105,108,117,120,129,132 等
- 原因：Device Hub 无 Tent/Tabletop 入口；不得用 PartiallyOpen/OpenPortrait 替代
- 需要外部：Sure/Codex 提供可达步骤或接受缺口

### C. 非 Duo 内容缺口（7 行）
- 85-90,163,174：正式 12 条岁时内容/版本审批；示例稿仅“内容准备中”，不能 PASS
- 负责人：PM 内容 + dev 接入 + QA 复测

### D. 非 Duo 功能/证据缺口
- 164 离线/失败态：dev 实现 + QA 断网注入
- 166-169 通知权限：dev 检查 + QA 新装/真机
- 170-174 长图：QA 采集/拼接；不能以首屏冒充

### E. Duo 结果/时态（16 行）
- 147-156 结果态/白话关；181-186 罗盘时态；待新包按姿态复验

## 下一批分工
- **calendar-dev**：离线/错误态、通知权限流程、长图渲染/导出、Duo 结果/时态回归；每个修复报 commit + 证据。
- **calendar-pm**：正式 12 条岁时/四季素材/签文缺口清单与验收口径；术语/双语终审。
- **superwebqa**：按行重验、证据路径、矩阵逐项回填；禁止批量 PASS。
- **Lead**：不可变包元数据、协调设备窗口、最终交付。

## 真正需要外部协助的阻塞
1. **Device Hub Tabletop/Tent 可达入口**（设备/UDID/姿态/步骤/证据/空闲窗口）——目前无，28 行（14 对） NOT RUN。
2. **正式内容交付**：12 条岁时正文、完整签库、四季素材——需内容授权/交付。
3. **Codex Duo 复测窗口**：4 台设备已 shutdown，需协调重启与串行测试；不与 Codex 争用。
4. **通知权限真机/系统弹窗**：模拟器 notification 权限交互需真机或可注入环境。

## 1445 逐行证据补记（不改状态）
- Duo43 CSV：2 FAIL_UI（row8 Closed home、row11 OpenLandscape home）/16 PARTIAL/25 NOT_RUN；0 PASS_UI。
- iPad/compact/dark：iPad portrait 误两栏、landscape 压缩/空白、detail 布局不符、UI-001 三态仍 PARTIAL；Closed compact tools 空白/遮挡。
- 以上仅为证据记录；矩阵/行状态不改，等修复新包 targeted-retest。
