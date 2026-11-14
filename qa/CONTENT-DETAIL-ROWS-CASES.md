# 内容详情行 85-90/163/174 验收用例（hero 已接入）

- 前置：新 immutable 包 + hero 已接入；12 approved 内容（events `79b80283…`）；真实日期/可用 debug date；不改 188 矩阵。
- 当前内容行仍 **NOT RUN**；hero 接入只解除资产前置，不自动 PASS。
- 统一检查：紧凑头 + 正文；eventID+版本；加载/离线/失败；成功才已读；hero 显示且 alt/16:9 无异常；深色/浅色；真实日期边界。

## A. 基础详情（85-90）
| 行 | 设备/主题 | 检查 |
|---|---|---|
| 85 | phone-light 375×930 | 真实可读详情（如 chongyang 已过去/xiayuan 9天内）；紧凑头+正文；eventID/version；success 才已读 |
| 86 | phone-dark | 同 85，深色；不得用旧 Home/千分位图冒充实测 |
| 87 | iPad portrait-light 834×1194 | 同 85；iPad 布局/hero 16:9/正文可滚动 |
| 88 | iPad portrait-dark | 同 87 深色 |
| 89 | iPad landscape-light 1194×834 | 同 85；横屏布局/hero/正文 |
| 90 | iPad landscape-dark | 同 89 深色 |
- 加载中：loading 态可见；离线/失败：banner+重试；重试成功才 markRead；不得正文占位。
- 日期：未来>10天锁定；已过去/今日解锁可读；用真实日期或 `-LixiangDebugDate` 记录。

## B. 今日解锁/已读边界（163）
1. 设日期=event 当日（或 unlockOffset 边界）；详情可读，hero 正常。
2. 成功打开正文后才已读；加载/失败/占位不得标已读。
3. 重进详情已读状态保持；列表未读标记变化正确。
4. 未解锁/未来仍锁定；不泄正文。

## C. 长图（174）
1. 375×2400/2500 目标长图，非首屏替代；手机 light。
2. 全量滚动：Hero/头/正文/来源/底部操作/末项；无接缝跳变/tabbar 重复/裁切。
3. 记录实际高度；未达标保持 NOT RUN。
4. 如需多设备长图另立用例，不与 174 混写。

## D. 记录
- 每行设备/主题/日期/eventID/包 SHA/截图；hero 验收见 hero 用例。
- 内容行逐行证据齐后才可改；矩阵不改；不发布。
