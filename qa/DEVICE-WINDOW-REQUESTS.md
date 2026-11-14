# 后续设备窗口需求（QA）

- 当前可用：R14-QA-iPhone `0B71AEF4`、R14-QA-iPad `415BFB3F`（不碰 4 台锁定机）。
- R14-QA-iPad `screenConfig` 仅有 portrait mode（2752x2064/1194x834 均无有效 mode）；**iPad 横屏需要真实 landscape 窗口/GUI 旋转**。
- 真实 Duo Closed compact / iPad landscape / dark：由 Codex 新任务使用指定 Duo/iPad 窗口；QA 不争用锁定设备。
- 长图 174：当前只有首屏；需 375×2400/2500 长图采集能力（滚动截图/拼接工具）与内容高度足够；否则 NOT RUN。
- 真机通知 166-169：physical iPhone unavailable；需真机窗口，模拟器注入不能替代。
- 请 Lead 分配窗口时给出设备/UDID/姿态/时间段；QA 按窗口串行，不擦数据。
