# 开发流程（历象 / Lixiang）

> 状态：**骨架阶段**（2026-11-11）。本文件区分「现在可用」与「工程/脚本就绪后可用」，
> 避免把计划中的命令写成已存在。参考昭杳既有 App（琴调）的工程与 QA 约定，按本产品裁剪。
> 硬门禁：**视觉方向 + mockup 经 Sure 批准前，不建 Xcode 工程、不写 UI 产品代码**。

---

## 1. 工作机与纪律

- 只用 `/usr/bin/git`（本机 `/usr/local/bin/git` 是 x86 版本，Apple Silicon 上 `Bad CPU type`）；SwiftPM 拉依赖也要求 `/usr/bin` 在 PATH 前部：
  `PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin swift build`
- 派生数据放**工作目录内**（`./DerivedData`），日志/结果放 `./.qa/`（已 gitignore）；不写 `/tmp` 以外的共享目录。
- **模拟器只动名字以 `Lixiang-` 开头的**；收尾只按 UDID 关自己的，**永不** `simctl shutdown all`；不碰其他人的设备。
- 不装/不升级任何系统组件（Xcode、模拟器运行时、macOS、Node、brew），不改全局 Xcode 设置；需要时先问 Lead/Sure。
- **不碰生产**：`ceremony/` 静态目录 + 每日 cron 与官网上线窗口一起交 ops（Lead 2026-11-11 定），本仓库不单独动生产。
- 不把密钥/凭据写进仓库或证据；v1.0 **无**统计/广告/账号 SDK，`Local.xcconfig` 不进库。
- 公开仓库推送身份用 GitHub noreply（`Sure Zhang <42809153+surez0812@users.noreply.github.com>`），**不要**用公司邮箱（Lead 2026-11-11 确认）。

## 2. 现在可用的命令

```bash
# 核心包骨架（唯一有代码的目录）：构建 + 测试（会拉取 LunarSwift 1.1.9）
cd packages/LixiangCalendarCore
PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin swift build
PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin swift test
```

> `Package.resolved` 已入库并 pin `lunar-swift 1.1.9`（`2397017c…`）；升级必须走 §7 的数据门禁。

## 3. 构建与测试（工程生成后；命令占位，脚本在 `scripts/` 落地时同步更新本文件）

- 工程由 **XcodeGen 2.46.0** 从 `project.yml` 生成（视觉批后加入）；`.xcodeproj` 入库、**不手改**；改 `project.yml` 后重生成并一起提交。
- 构建：`xcodebuild -project Lixiang.xcodeproj -scheme Lixiang -destination id=<UDID> CODE_SIGNING_ALLOWED=NO build`
- 测试：`xcodebuild test ... -resultBundlePath .qa/test-<tag>.xcresult`；计数以 `xcrun xcresulttool get test-results summary` 为准。
- 证据脚本约定（实现阶段落地 `scripts/mac/` 时）：`build.sh` / `test.sh` / `shots.sh` / `evidence.sh` / `sim-create.sh` / `sim-shutdown.sh`；
  日志第一行统一写 **`# tested_sha=<HEAD> dirty_files=<n> <时间>`**（dirty = 改动+暂存+未跟踪，`.qa/` 不计）。

## 4. 模拟器矩阵

| 名称（计划） | 设备 | 运行时 | 用途 |
|---|---|---|---|
| `Lixiang-iPhone17Pro` | iPhone 17 Pro | iOS 27.2 | 主力 iPhone（6.3″ 1206×2622 商店套图） |
| `Lixiang-iPhoneSE3-iOS18` | iPhone SE (3rd) | iOS 18.6 | **最小屏基准 375×667pt** + iOS 18 回归 |
| `Lixiang-iPad13` | iPad Pro 13″（无则 iPad Air 13″） | iOS 27.2 | iPad 13″ 竖 2064×2752 / 横 / 双栏 |
| `Lixiang-iPad11` | iPad Pro 11″（或 Air 11″） | iOS 27.2 | iPad 11″ 竖横回归 |
| `Lixiang-iPhoneDuo` | iPhone Duo（`iPhone19,4`） | iOS 27.2 | 折叠屏：外屏/内屏 × 竖横 × poses（见 §5） |

- 运行时用**已装的**，不另装；`sim-create.sh` 幂等创建、UDID 写 `.qa/sims.env`。
- 截图：`xcrun simctl io <udid> screenshot --display=<1|3>`；只拍自己建的设备。

## 5. Duo 姿态（poses）规范

官方点值（不可硬编码进布局，仅用于验收/截图规格）：

| 姿态 | 显示屏 | 点（pt） | 像素（@3x） | 版式（目标） |
|---|---|---|---|---|
| closed（合上） | 外屏 `1` | 466×678 | 1398×2034 | 单栏（竖） |
| open 内屏竖 | 内屏 `3` | 669×951 | 2007×2853 | 单栏；水平折痕避让（fold 在 475.5pt） |
| open 内屏横 | 内屏 `3` | 951×669 | 2853×2007 | **两栏**（月历 ｜ 日详情）；fold 在 475.5pt 竖线 |
| tabletop（半折 ~90°） | 内屏 `3` | 669×951 | 2007×2853 | **上内容 / 折痕带（27pt）/ 下控制**；用 `reservedRegions(kind:.division)` 真实 frame |
| tent（帐篷） | 内屏 `3`（或外屏，按实测） | — | — | **discovery 先行**：识别方式/可用区域验证后再定版式；A13 前不对外宣传 |

- **切姿态**：`simctl` 没有姿态命令。用 Xcode Device Hub 的姿态按钮（合上/半开/展开；按住 Option 有铰链角度），
  或 mobile-mcp 的 `mobile_fold_device`（posture `folded` / `open`）；脚本化测试用 DEBUG 注入 `-LixiangFakeTabletop`
  （在任意模拟器造水平折痕 frame，Release 不解析），**不靠固定 sleep**、用无障碍树轮询等待。
- **折叠线/铰链区不可放控件与文字**；reserved region 的 frame 已含 margins，**不要二次加**。
- **A13 门禁**：所有 Duo 姿态在真机/Duo 模拟器验证通过前，商店/官网文案不得宣称 Duo 支持（统一写「开发中」）。

## 6. DEBUG 启动参数（计划命名，`#if DEBUG` 门控，Release 一律忽略）

| 参数 | 用途 |
|---|---|
| `-LixiangDebugDate 2027-02-05` | 注入「今天」（UTC+8 日界），用于内容三态/月历/通知测试 |
| `-LixiangDebugTime "2027-02-05T23:30:00+08:00"` | 注入时刻（三态边界、跨日刷新） |
| `-LixiangContentFixture <dir>` | 内容 manifest/正文本地 fixture（不联网） |
| `-LixiangResetState` | 清纪念日/设置/缓存（幂等 UI 测试） |
| `-LixiangSkipOnboarding` | 跳过首启流程 |
| `-LixiangFakeTabletop` | 注入水平折痕，确定性验证上下分区 |
| `-LixiangFakeNotificationPrompt granted\|denied` | 假通知权限，测试不弹真实系统权限 |
| `-LixiangLang zh-Hans\|en` | 强制语言（截图/文案验收） |

> 规则：测试**不请求真实通知权限**、不联网、不写用户真实数据；真实权限只在 Sure 本人真机验证。

## 7. 数据准确性门禁（发布前必跑）

1. **golden 差分**：与 `lunar-python` 同版本对拍 —— 核心 1900–2100 逐日、黄历 5 年逐日、节假日 2001–2030；**差异必须为 0**（方法/基线见内部交接 `tech/evidence/`，实现阶段转成 `Tests/Fixtures/`）。
2. **权威源**：节气/农历对照（紫金山天文台 / 香港天文台 / 香港天文学会年历，按年补表）；节假日 vs 国务院办公厅年度通知（`gov.cn`）。
3. **规则测试**：`dateRule`（lunar / solar / solar-term / last-day-of-lunar-month）、闰月三态、`dayFallback`、**`regionalDates` 逐条 unlockDate**、除夕大小月（如 2027-02-05 腊月廿九）、2/29 内容 `skip`。
4. **升级 `LunarSwift`**：必须附全量差分 0 + 体积/性能对比 + 变更说明；差异≠0 逐条解释。
5. 口径：宜忌/神煞**只保证与 6tail 实现一致**，不宣称「最准/权威」。

## 8. 内容解锁（三态）验证

- 未到 → 只显示 teaser（**不含流程/供品/步骤/禁忌细节**）；当日 → 全文；已过 → 全文+「已过」+ 明年日期。
- **防绕过**：未解锁正文不在 App 包/不在服务器静态目录/不缓存；锁定期分享只到锁定页；WebView 不直连未授权 URL。
- 静态发布（B′）：`https://lixiang.zhaoyao.xin/ceremony/<slug>` + `/ceremony/manifest.json`（只含已解锁条目）；正文 **sha256 校验**通过才落盘/渲染。
- 地区日期：谢灶北 `lunar 12-23` / 南 `lunar 12-24` 各自到日解锁（2027 北 01-30 / 南 01-31；01-30 当天南仍锁定）。

## 9. 证据规范（QA / 验收）

- **作者 ≠ 验收人**；同一 SHA 真实测试；无 CI 不等于通过。
- 每份证据写：命令、设备/UDID、运行时、语言、主题、**build SHA**、结果（PASS/FAIL/NOTRUN）、日志/截图路径。
- 未跑/不可跑的项目显式写 **NOTRUN**，不得写成通过；**不得为凑绿改断言/放宽阈值**。
- 截图：**模拟器真 capture**（不 PS/不合成/不放旧图），原始 PNG + `MANIFEST`（sha256/尺寸/来源/命令）；App Store 套图去掉 alpha（`.rgb.png`）。
- 证据落内部 `handover/calendar-20261111/evidence/`（不进本仓库）；本仓库只保留可复现的脚本与测试。
- 日志/测试产物在 `.qa/`，打包时排除 `xcresult`/`DerivedData`，清理 macOS `._*`。

## 10. 版本与发版（实现阶段）

- `MARKETING_VERSION` 必须与 App Store Connect 版本逐字一致；`CURRENT_PROJECT_VERSION` 每次上传 +1、不重复使用、`archive` 前入库。
- 签名团队/描述文件、TestFlight/上传一律**须 Sure 明确同意**；本仓库当前不配置签名。
- 上架素材（截图/文案/隐私）以 PM/designer 定稿 + QA 签字为准。

## 11. 范围红线（当前阶段）

- 不建 Xcode 工程、不写 UI/业务代码（等视觉方向批准）。
- 不改生产、不动 nginx/证书/内容服务（`ceremony/` 与官网上线窗口一起交 ops）。
- 不碰其它产品仓库（`guqin-tuner`、`guqin-scores` 只读参考）。

---

## 12. 视觉批后开工顺序（Lead 2026-11-11 定）

1. `project.yml` + **XcodeGen 2.46.0** 生成 `Lixiang.xcodeproj`（工程骨架，先不加业务逻辑）
2. App 骨架：**4 Tab**（月历 / 民俗 / 纪念日 / 设置）+ 启动/依赖注入 + **本地通知权限说明文案**（首次请求时机与文案；不弹冷启动）
3. 进 D1（核心历法接入 + 月历/日详情）
4. D2 内容三态+B′ 管线 → D3 纪念日/通知/小组件 → D4 Duo 全姿态/iPad → QA
5. `ceremony/` 静态目录 + 每日 cron：**随 lixiang 官网上线窗口一起交 ops**，开发期不单独动生产
