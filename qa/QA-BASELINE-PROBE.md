# QA 基线探测（非 Duo，8c4119b1 冻结包）

- 专用 QA 设备（仅这两台，未碰 4 台锁定机）：
  - iPhone `R14-QA-iPhone` `0B71AEF4-1E34-47A3-937A-3A097A0D0362`
  - iPad `R14-QA-iPad` `415BFB3F-136B-4FC6-9B41-A5DDD9A832C0`（本轮仅 iPhone 探测）
- 基线包：`dev-evidence/P1/Lixiang-R14-1.0-13-bilingual-8c4119b1-debug-simulator.tar.gz`
  - tar SHA256 `7b5b6dbb35c9d5a29cc1d87936176f62efeccec569a8507c399ba051b2486ad8`
  - binary SHA256 `a036b0bc65c9a0ab1e2ca067b558bb3290f14d581c16a893477d0689da1b8488`
  - commit `8c4119b1`
- 采集脚本：`scripts/r14-qa-baseline-probe.sh`（仅 `R14-QA-*`；默认 WAIT=8，可 `WAIT=25` 延长）。

## 无注入当前行为
- 8s：启动仍为「历象·正在准备今日」loading 屏，不是白屏、也不是详情页。
- 25s：
  - `-LixiangSeedCountdown 1 -LixiangR14Route countdownDetail` 能进入「倒计日」详情：生日/2027-02-06/还有84天/农历每年/提醒09:00；**本地通知提醒开关已为开**。
  - `-LixiangTab 3 -LixiangSeedCountdown 1` 进入倒计日列表：生日 84天后，提醒09:00/App内提醒已开启；出行/纪念日「提醒未开启」。
  - `-LixiangR14Route folkloreDetail` 进入谢灶 locked 详情：2027-01-30/还有77天/「还有77天解锁」。
- **结论**：基线未注入时无法验证 164 的离线/失败重试，也无法验证 166-169 的四段权限交互；当前截图只作 baseline 行为记录，**不标 PASS**。

## 已准备步骤
1. 用 `scripts/r14-qa-baseline-probe.sh` 安装/启动，固定 `WAIT=25`；每次 uninstall/install 保证新装。
2. 164：
   - dev 提供离线/超时/500 注入参数（launch arg 或 mock server）；
   - 分别跑无缓存/有缓存/失败重试/恢复网络；
   - 截图命名 `qa-164-{offline-uncached,offline-cached,timeout,retry-ok}.png`。
3. 166-169：
   - `xcrun simctl privacy <UDID> reset notifications` 清权限；
   - 启动 seeded detail，触发“请求前说明”；
   - XCUITest/手工点 system alert：允许 / 拒绝 / 设置返回；
   - 截图 4 态 + `simctl privacy` 状态记录；
   - 不能只凭详情页已有开关判 PASS。
4. 每状态记录：build/tar/binary、launch args、权限状态、截图、元素 label、时间。

## 待 dev
- 164 注入参数与预期错误 UI/重试文案。
- 166-169 的请求前说明入口 label、系统弹窗预期、允许/拒绝后的持久化及设置返回路径。
- 后续新包 SHA 与对应 commit；A/B/C 分组更新。
