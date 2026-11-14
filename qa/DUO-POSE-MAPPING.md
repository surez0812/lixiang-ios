# Duo Tabletop/Tent 映射表（仅准备，不改 PASS）

- 约定：`qa/DEVICE-POSE-CONVENTIONS.md`；参考截图 `P1/shots/duo-tabletop-devicehub-user.webp`（`07961e7e…`）。
- **矩阵实际 28 行（14 对）Tent/Tabletop 全部 NOT RUN**；Tent 仅 candidate 复用 Closed Landscape，未判 PASS。
- **Tabletop**：物理姿态必须 Partially Open + rotation 单独测；**design=OpenPortrait**（669×951）布局验收；不得用旧 PartiallyOpen/OpenPortrait 物理姿态替代。
- 本表不改变矩阵 100/33/55。

| 页面/状态 | Tent 行 | Tabletop 行（design=OpenPortrait） | Tent candidate（仅 citable，不 PASS） | 状态 |
|---|---:|---:|---|---|
| home | 9 | 12 | Closed Landscape 22s（tab0） | NOT RUN |
| almanac 默认 | 21 | 24 | Closed Landscape 22s | NOT RUN |
| folklore | 33 | 36 | Closed Landscape 22s（tab1） | NOT RUN |
| countdown | 45 | 48 | Closed Landscape 22s（tab3） | NOT RUN |
| settings | 57 | 60 | Closed Landscape 22s（tab4） | NOT RUN |
| selection | 69 | 72 | Closed Landscape 22s | NOT RUN |
| daily | 81 | 84 | Closed Landscape（daily 仍 Home，candidate 不足） | NOT RUN |
| folklore-detail | 93 | 96 | Closed Landscape route 未完成 | NOT RUN |
| countdown-detail | 105 | 108 | Closed Landscape route 未完成 | NOT RUN |
| fortune 默认 | 117 | 120 | Closed Landscape 22s | NOT RUN |
| compass 默认 | 129 | 132 | Closed Landscape（compass 仍 Home，candidate 不足） | NOT RUN |
| fortune 结果态 | 149 | 155 | Closed Landscape 证据不足 | NOT RUN |
| almanac 紧凑态 | 150 | 156 | Closed Landscape 证据不足 | NOT RUN |
| compass 时态 | 183 | 186 | Closed Landscape 证据不足 | NOT RUN |

## 复用规则
- Tent 报告必须写「按约定等同 Closed Landscape」；不得声称独立测过 Tent。
- Tabletop 必须单独姿态证据；Closed/Open/PartiallyOpen portrait 旧结果一律不能替代。
- Codex 返回逐行结果后由 QA 核对；本表不改变任何 PASS/FAIL/NOT RUN。

## D. Codex rows-28 逐行 verdict（仅供映射，不改 188 statuses）
- 统计：14 FAIL_UI / 11 PARTIAL / 2 PASS_STATE_ONLY / 1 NOT_RUN_FULL_STATE；REACHED≠PASS。
| 行 | pose | physical/design | 页面 | 状态 | verdict | 证据 |
|---:|---|---|---|---|---|---|
| 9 | Tent | Closed Landscape / Tent≡Closed | home 首页/日历 | 默认 | **FAIL_UI** | `evidence/closed-landscape-valid/tab0-60s.png` |
| 12 | Tabletop | Partially Open + Rotate Right / design=OpenPortrait | home 首页/日历 | 默认 | **FAIL_UI** | `evidence/tabletop-valid/tab0-60s.png` |
| 21 | Tent | Closed Landscape / Tent≡Closed | almanac 黄历 | 默认 | **FAIL_UI** | `evidence/closed-landscape-valid/almanac-60s.png` |
| 24 | Tabletop | Partially Open + Rotate Right / design=OpenPortrait | almanac 黄历 | 默认 | **FAIL_UI** | `evidence/tabletop-valid/almanac-60s.png` |
| 33 | Tent | Closed Landscape / Tent≡Closed | folklore 岁时列表 | 默认 | **FAIL_UI** | `evidence/closed-landscape-valid/tab1-60s.png` |
| 36 | Tabletop | Partially Open + Rotate Right / design=OpenPortrait | folklore 岁时列表 | 默认 | **FAIL_UI** | `evidence/tabletop-valid/tab1-60s.png` |
| 45 | Tent | Closed Landscape / Tent≡Closed | countdown 倒计日 | 默认 | **FAIL_UI** | `evidence/closed-landscape-valid/tab3-60s.png` |
| 48 | Tabletop | Partially Open + Rotate Right / design=OpenPortrait | countdown 倒计日 | 默认 | **FAIL_UI** | `evidence/tabletop-valid/tab3-60s.png` |
| 57 | Tent | Closed Landscape / Tent≡Closed | settings 设置 | 默认 | **FAIL_UI** | `evidence/closed-landscape-valid/tab4-60s.png` |
| 60 | Tabletop | Partially Open + Rotate Right / design=OpenPortrait | settings 设置 | 默认 | **FAIL_UI** | `evidence/tabletop-valid/tab4-60s.png` |
| 69 | Tent | Closed Landscape / Tent≡Closed | selection 择日 | 默认 | **FAIL_UI** | `evidence/closed-landscape-valid/selection-60s.png` |
| 72 | Tabletop | Partially Open + Rotate Right / design=OpenPortrait | selection 择日 | 默认 | **FAIL_UI** | `evidence/tabletop-valid/selection-60s.png` |
| 81 | Tent | Closed Landscape / Tent≡Closed | daily 每日一句 | 默认 | **PARTIAL** | `evidence/closed-landscape-valid/daily-60s.png` |
| 84 | Tabletop | Partially Open + Rotate Right / design=OpenPortrait | daily 每日一句 | 默认 | **PARTIAL** | `evidence/tabletop-valid/daily-60s.png` |
| 93 | Tent | Closed Landscape / Tent≡Closed | folklore-detail 岁时详情 | 默认 | **PARTIAL** | `evidence/closed-landscape-valid/folkloreDetail-60s.png` |
| 96 | Tabletop | Partially Open + Rotate Right / design=OpenPortrait | folklore-detail 岁时详情 | 默认 | **PARTIAL** | `evidence/tabletop-valid/folkloreDetail-60s.png` |
| 105 | Tent | Closed Landscape / Tent≡Closed | countdown-detail 倒计日详情 | 默认 | **PARTIAL** | `evidence/closed-landscape-valid/countdownDetail-60s.png` |
| 108 | Tabletop | Partially Open + Rotate Right / design=OpenPortrait | countdown-detail 倒计日详情 | 默认 | **PARTIAL** | `evidence/tabletop-valid/countdownDetail-60s.png` |
| 117 | Tent | Closed Landscape / Tent≡Closed | fortune 每日一签 | 默认 | **PARTIAL** | `evidence/closed-landscape-valid/fortune-60s.png` |
| 120 | Tabletop | Partially Open + Rotate Right / design=OpenPortrait | fortune 每日一签 | 默认 | **PARTIAL** | `evidence/tabletop-valid/fortune-60s.png` |
| 129 | Tent | Closed Landscape / Tent≡Closed | compass 罗盘 | 默认 | **FAIL_UI** | `evidence/closed-landscape-valid/compass-60s.png` |
| 132 | Tabletop | Partially Open + Rotate Right / design=OpenPortrait | compass 罗盘 | 默认 | **FAIL_UI** | `evidence/tabletop-valid/compass-60s.png` |
| 149 | Tent | Closed Landscape / Tent≡Closed | fortune 每日一签 | 结果态全显，无内部滚动 | **PASS_STATE_ONLY** | `fortune-result-closed-landscape.png` |
| 150 | Tent | Closed Landscape / Tent≡Closed | almanac 黄历 | 白话关：紧凑值仍保留全部字段 | **NOT_RUN_FULL_STATE** | `evidence/closed-landscape-valid/almanac-60s.png` |
| 155 | Tabletop | Partially Open + Rotate Right / design=OpenPortrait | fortune 每日一签 | 结果态全显，无内部滚动 | **PASS_STATE_ONLY** | `fortune-result-tabletop.png` |
| 156 | Tabletop | Partially Open + Rotate Right / design=OpenPortrait | almanac 黄历 | 白话关：紧凑值仍保留全部字段 | **PARTIAL** | `almanac-off-lower-tabletop.png` |
| 183 | Tent | Closed Landscape / Tent≡Closed | compass 罗盘 | 时态；十二时辰/方向同步 | **PARTIAL** | `compass-hour-closed-landscape.png` |
| 186 | Tabletop | Partially Open + Rotate Right / design=OpenPortrait | compass 罗盘 | 时态；十二时辰/方向同步 | **PARTIAL** | `compass-hour-tabletop.png` |

## E. Codex 1445 Duo43 逐行 verdict（2 FAIL_UI/16 PARTIAL/25 NOT_RUN; 0 PASS_UI）
| 行 | pose | page | reached | verdict | screenshot | notes |
|---:|---|---|---|---|---|---|
| 8 | duo-closed-landscape·浅色 | home 首页/日历 | yes | **FAIL_UI** | `shots/closed-landscape-light-tab0.png` | Real automatic compact: abnormal blank tools panels, title/action at bottom under capsule. Stop repeated old-build testing per user. |
| 10 | duo-open-portrait·浅色 | home 首页/日历 | yes | **PARTIAL** | `shots/open-portrait-light-tab0.png` | Real page reached; full matching-original/state/interaction audit incomplete. No UI PASS. |
| 11 | duo-open-landscape·浅色 | home 首页/日历 | yes | **FAIL_UI** | `shots/open-landscape-light-home-stable.png` | Five right Tab buttons present and functional, but position/proportions differ from final HTML and overlay content. |
| 20 | duo-closed-landscape·浅色 | almanac 黄历 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 22 | duo-open-portrait·浅色 | almanac 黄历 | yes | **PARTIAL** | `shots/open-portrait-light-almanac.png` | Real page reached; full matching-original/state/interaction audit incomplete. No UI PASS. |
| 23 | duo-open-landscape·浅色 | almanac 黄历 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 32 | duo-closed-landscape·浅色 | folklore 岁时列表 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 34 | duo-open-portrait·浅色 | folklore 岁时列表 | yes | **PARTIAL** | `shots/open-portrait-light-tab1.png` | Real page reached; full matching-original/state/interaction audit incomplete. No UI PASS. |
| 35 | duo-open-landscape·浅色 | folklore 岁时列表 | yes | **PARTIAL** | `shots/open-landscape-folklore-click.png` | Actual right sidebar click reached target Tab. Complete per-screen design/state audit pending; shared rail overlap remains. |
| 44 | duo-closed-landscape·浅色 | countdown 倒计日 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 46 | duo-open-portrait·浅色 | countdown 倒计日 | yes | **PARTIAL** | `shots/open-portrait-light-tab3.png` | Real page reached; full matching-original/state/interaction audit incomplete. No UI PASS. |
| 47 | duo-open-landscape·浅色 | countdown 倒计日 | yes | **PARTIAL** | `shots/open-landscape-countdown-click.png` | Actual right sidebar click reached target Tab. Complete per-screen design/state audit pending; shared rail overlap remains. |
| 56 | duo-closed-landscape·浅色 | settings 设置 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 58 | duo-open-portrait·浅色 | settings 设置 | yes | **PARTIAL** | `shots/open-portrait-light-tab4.png` | Real page reached; full matching-original/state/interaction audit incomplete. No UI PASS. |
| 59 | duo-open-landscape·浅色 | settings 设置 | yes | **PARTIAL** | `shots/open-landscape-settings-click.png` | Actual right sidebar click reached target Tab. Complete per-screen design/state audit pending; shared rail overlap remains. |
| 68 | duo-closed-landscape·浅色 | selection 择日 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 70 | duo-open-portrait·浅色 | selection 择日 | yes | **PARTIAL** | `shots/open-portrait-light-tab2.png` | Real page reached; full matching-original/state/interaction audit incomplete. No UI PASS. |
| 71 | duo-open-landscape·浅色 | selection 择日 | yes | **PARTIAL** | `shots/open-landscape-selection-click.png` | Actual right sidebar click reached target Tab. Complete per-screen design/state audit pending; shared rail overlap remains. |
| 80 | duo-closed-landscape·浅色 | daily 每日一句 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 82 | duo-open-portrait·浅色 | daily 每日一句 | yes | **PARTIAL** | `shots/open-portrait-light-daily.png` | Real page reached; full matching-original/state/interaction audit incomplete. No UI PASS. |
| 83 | duo-open-landscape·浅色 | daily 每日一句 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 92 | duo-closed-landscape·浅色 | folklore-detail 岁时详情 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 94 | duo-open-portrait·浅色 | folklore-detail 岁时详情 | yes | **PARTIAL** | `shots/open-portrait-light-folkloreDetail.png` | Real page reached; full matching-original/state/interaction audit incomplete. No UI PASS. Locked Xiezao detail reached; article body not validated. |
| 95 | duo-open-landscape·浅色 | folklore-detail 岁时详情 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 104 | duo-closed-landscape·浅色 | countdown-detail 倒计日详情 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 106 | duo-open-portrait·浅色 | countdown-detail 倒计日详情 | yes | **PARTIAL** | `shots/open-portrait-light-countdownDetail.png` | Real page reached; full matching-original/state/interaction audit incomplete. No UI PASS. |
| 107 | duo-open-landscape·浅色 | countdown-detail 倒计日详情 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 116 | duo-closed-landscape·浅色 | fortune 每日一签 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 118 | duo-open-portrait·浅色 | fortune 每日一签 | yes | **PARTIAL** | `shots/open-portrait-light-fortune.png` | Real page reached; full matching-original/state/interaction audit incomplete. No UI PASS. |
| 119 | duo-open-landscape·浅色 | fortune 每日一签 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 128 | duo-closed-landscape·浅色 | compass 罗盘 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 130 | duo-open-portrait·浅色 | compass 罗盘 | yes | **PARTIAL** | `shots/open-portrait-light-compass.png` | Real page reached; full matching-original/state/interaction audit incomplete. No UI PASS. |
| 131 | duo-open-landscape·浅色 | compass 罗盘 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 147 | duo-closed-landscape·浅色 | fortune 每日一签 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 148 | duo-closed-landscape·浅色 | almanac 黄历 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 151 | duo-open-portrait·浅色 | fortune 每日一签 | yes | **PARTIAL** | `shots/open-portrait-fortune-result.png` | Actual draw reached result #6; four lines, meaning/advice visible. Same-day persistence and complete design/animation audit not done. |
| 152 | duo-open-portrait·浅色 | almanac 黄历 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 153 | duo-open-landscape·浅色 | fortune 每日一签 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 154 | duo-open-landscape·浅色 | almanac 黄历 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 181 | duo-closed-portrait·浅色 | compass 罗盘 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 182 | duo-closed-landscape·浅色 | compass 罗盘 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 184 | duo-open-portrait·浅色 | compass 罗盘 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
| 185 | duo-open-landscape·浅色 | compass 罗盘 | not_attempted | **NOT_RUN** | `` | Not completed on this build; no UI approval. |
