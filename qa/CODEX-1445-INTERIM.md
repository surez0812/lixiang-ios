# Codex 1445 interim（真实 Duo Closed compact / startup）

- 包：`clean-38b34c5a`（tar `36d20ef2…`、binary `b4ddbe8e…`、commit `38b34c5a`、1.0(13)）。
- 结果：**interim / 不判 PASS**；矩阵 100/33/55 不改；任务状态不改。

## 1. 真实 Duo Closed Landscape（FAIL_UI）
- **自动 compact 已生效**（非 ForceCompact）。
- **FAIL_UI**：
  - Home tools 面板空白高度过大；
  - 标题/操作贴近/超出下边缘；
  - 被浮动 tab 胶囊遮挡。
- OpenPortrait Home tools 看起来正常；**不推断整页 PASS**。
- 需要 dev 修 Closed compact tools 高度/底部安全区/胶囊遮挡，再新包复测。

## 2. Startup（需 same-run first rendered frame）
- prepare.done <1s；content.ready 4–5.4s；真实 Home 需额外约 20s。
- **不能把 content.ready 或 8s 截图当 first rendered frame**；需 same-run 首帧时间 + 截图/包/设备/姿态证据。
- 接收模板：`qa/STARTUP-FIRSTFRAME-EVIDENCE.md`。

## 边界
- 矩阵不改；不操作设备/不发布；不把 interim 当 final。

## 3. OpenLandscape 侧栏（新增 FAIL_UI）
- rail 存在，但**几何不符/遮挡内容**；到达不等于通过。
- 设计规格（Sure）：`right=23, width=50, height=252, top=401`；5 slot × 48；tab 44；icon 25。
- 需要逐屏对照最终原稿：侧栏相对 safe area 位置、slot 间距、tab 44/icon25、颜色/字号、内容避让/不被遮挡。
- 等 dev 修后新包 targeted-retest；矩阵不改。
- Closed compact tools FAIL_UI 保持既有记录，本轮不重试。

## 4. 1530 compactfix（PARTIAL UI）
- 真实 Duo Closed Landscape：**巨大空白 panel 已解决**；light/dark 标题/说明/操作可见；实际滚动到底日历末行在胶囊上方；首/末未见全宽底带。
- 仍存：**胶囊初始位压下方卡边**（设计决策待 PM/设计确认）；44pt 命中/token/字体/dark 原稿匹配未量测；不整体 PASS。
- same-run 原始 log：light PID6158 prepare.done1498ms/content.ready8822ms/home.appear8916ms/firstContentFrame11835ms（先 portrait 后旋转）；dark PID7755 prepare.done973ms/content.ready6956ms/home.appear7108ms/firstContentFrame33748ms。
- **firstContentFrame 是 onAppear/next-runloop marker，不是 compositor 呈现确认**；仅记录，不判性能。
- 旧 Closed build 不重复。

## 5. 1545 railfix（NOT ACCEPTED）
- 包 hash 匹配；真实 R14-Duo OpenLandscape scene951×669/geo867×635/rail true。
- 本次 app **未到达 rendered Home**：持续「历象·正在准备今日」；content.ready 1616ms，但无 home.appear/firstContentFrame/LXRAIL frame；无法验证 rail 几何/避让/5tab/dark。
- dev 查 content.ready→layout、五个 NavigationStack、safe-area top/right 折算（假设，非定因）。
- Duo/iPad 已释放、数据保留；不把静态 preverify 当 runtime acceptance。

## 6. 1600 layoutfix ACK（2b55da5a）
- 包 hash 匹配；真实设备。
- **修好**：Duo OpenLandscape 可到 Home（home.appear + firstContentFrame）；iPad portrait 单列；landscape 两栏 + detail 左摘要/右文章。
- **FAIL_UI**：sidebar `x=867` vs design `x=878`（右距 34 应 23，偏左 11pt）；safe-area 换算待修。
- **PARTIAL**：iPad 字号/卡片/文章纸面比例仍差；UI-001 仅 first/after-drag，无三态（scroll addendum 已并入）。
- 矩阵 100/33/55 不改；startup 能到 Home 不等于全性能/全 UI PASS。
