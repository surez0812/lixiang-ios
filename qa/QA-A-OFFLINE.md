# A / 行164 离线/失败/重试 复测（9804c16e）

- 包：`P1/Lixiang-R14-1.0-13-offline-9804c16e-debug-simulator.tar.gz`
  - tar `1645f834…`；binary `00f751fc…`；commit `9804c16e`
- 设备：仅 `R14-QA-iPhone` `0B71AEF4…`；未碰 4 台锁定机。
- 脚本：`scripts/r14-qa-a-offline.sh`；证据：`qa/evidence/qa-a-offline/`。

## 观察
| 状态 | 启动参数 | 结果 |
|---|---|---|
| ForceLoading | `-LixiangForceLoading` | 顶部「正在加载岁时内容…」loading 条 → PASS（loading 态） |
| 无缓存离线 | `-LixiangForceOffline`（新装，等待45s） | 顶部「内容服务不可用 · 当前为离线内容」+「重试」；详情锁定/无假正文 |
| 有缓存离线 | 正常加载谢灶（debug date 2027-01-30）→ `-LixiangForceOffline` | banner 在，缓存区仅「内容准备中」，无正式正文可证明 |
| failed | `-LixiangForceLoadFail` | 「岁时内容加载失败」+「重试」；无假内容 → PASS（失败态） |
| retry-success | `-LixiangOfflineRetry` | 关闭 banner，进入谢灶详情（锁定/内容准备中），无 loading 卡死 |
| 详情不标读 | 上述详情 | 未出现已读标记；因正文内容缺口，不能评内容已读 |

## 判定
- **行164 保持 NOT RUN**。
- 原因：四态中「有缓存离线仍显示缓存正文」无法证明——正式正文未接入，只能看到「内容准备中」；按 Lead 要求不能用示例稿/内容准备中判 PASS。
- 已证明：loading、离线 banner+重试、failed card+重试、retry 后不卡死；a11y label（`folklore.offlineBanner` / `folklore.failedCard`）未用 XCUITest 断言。
- 待正式内容或可测 fixture 接入后，补「缓存正文可读」与 a11y 断言，再复评 164。
