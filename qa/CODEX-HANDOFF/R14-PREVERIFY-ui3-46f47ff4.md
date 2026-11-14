# UI3 pre-verify（46f47ff4）

- 包：`P1/Lixiang-R14-1.0-13-ui3-46f47ff4-debug-simulator.tar.gz`
  - tar `869ca3e3…`；binary `3ef685a1…`；commit `46f47ff4…`；1.0(13)；events `79b80283…`。
- QA 未操作设备；源码/测试/团队截图复核。

## A. HOME-TOOLS final（PASS，phone/xL 范围）
- `012f79f4`：D1Card padding8、VStack spacing2、icon22 + heading14/600、标题/说明/操作居中、action≥44、双卡下方16pt。
- `R14HomeToolsUITests` 断言：两卡等高±1、标题组居中±2.5、16pt gap±3、按钮≥44、操作居中；phone/xL 两组。
- 团队截图 `r14-hometools-phone.png`（12:21 更新）显示卡等高/居中；xl 截图旧（11:37）但测试源覆盖。
- **17状态/长城市/天气全态仍 NOT RUN**；仅 phone/xL 证据。

## B. compact selector（PASS，代码/单测范围）
- `46f47ff4` 新增 `R14HomeLayoutMode.mode`：width>=744 wide；width>=480 && width>height compact；其余 standard；Home 分支实际调用。
- `HomeLayoutModeTests` 4/4：594×360/480×320/700×400 compact；402×874/479×320 standard；744×1024/1024×768 wide；force 仅测试。
- 真实 Duo Closed/iPad/right rail **NOT RUN**；ForceCompact 不作验收。

## C. UI-001（OPEN）
- 代码未改；团队 light/dark 三态 SHA 不同，但 Codex 独立 light 三态仍缺（light mid/bottom）。
- 本机 UI test 受 pty/SwiftPM 权限阻断；已记录 light-first 仅作 QA 尝试，不冒充三态。
- 任务只要求 A/B 复核；C 按设备窗口决定，当前 **OPEN**，不写 PASS。

## 结论
- A（phone/xL HOME-TOOLS）PASS；B（compact selector 代码/单测）PASS；C OPEN，真实 Duo/iPad/17状态 NOT RUN。整体不宣称为 UI 全量完成。
- 矩阵 100/33/55 不变；内容/素材/原生通知状态不变。
