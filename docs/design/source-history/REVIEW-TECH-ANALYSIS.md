# Sure 17 条 Review · 技术分析（read-only，2026-11-12）

> 只读分析，不改 build9 代码。证据：`dev-evidence/P1/review-shichen-samples.csv`（3 天 × 12 时辰原始字段）。
> 工作量单位为 dev 人日；phase 建议：P1 = build 10/1.0.x 内可做；P2 = 1.1；P3 = 后续/按需。

## 0) 总览
| # | 需求 | 结论 | 工作量 | 依赖 | 风险 | 建议 phase |
|---|---|---|---|---|---|---|
| 1 | 时辰富数据 | 可行（库内已有大部分） | 1–2d 展示/判定 | LunarSwift 1.1.9 | 口径争议、缺刑冲合害 | P1（仅展示层） |
| 2 | 天气 | 可行，需选有资质数据源 | 3–5d | 和风/高德 key、定位权限、隐私更新 | 合规/许可、地区精度 | P2 |
| 3 | 分享大卡 | 可行 | 2–3d | ImageRenderer/ShareLink/QR | 快照主题/尺寸/Dynamic Type | P1 |
| 4 | 单日左右滑 | 可行 | 1–2d | 现有 NavigationStack/ScrollView | 手势冲突、状态保持 | P1 |
| 5 | 大卡分区点击 | 可行（B3 已验证教训） | 0.5–1d | 无 | 嵌套交互被吞 | P1 |
| 6 | 民俗 remote admin | 可行但需后端 | 5–8d web + 1–2d App | 主站栈/鉴权/存储 | 运维、鉴权、发布回滚 | P2 |
| 7 | 道历/佛历开关+显示 | 可行（`ReligionDisplay` 已就绪） | 2–3d | 内容复核已完成 | 审核合规 | P1/P2 |
| 8 | 365 天每日一句包 | 可行 | 0.5–1d App + 内容 | PM qwen4 内容 | 缺日 fallback/版权 | P1 |

## 1) lunar-swift 时辰富数据 spike
- 每时辰（`lunar.times[0…12]`，index 0 早子、12 晚子）可取：
  - `ganZhi`（时干Z）、`minHm/maxHm`（时段）
  - `yi[] / ji[]`（宜/忌词表，可计数）
  - `tianShen`（天神，如天刑）、`tianShenLuck`（**吉/凶**黄黑道结果）
  - `chongDesc`（冲，如「(甲午)马」）、`sha`（煞方，南/北/东/西）
  - 五神方位：`positionXi/Fu/Cai/YangGui/YinGui`（Desc）
- 样例：`review-shichen-samples.csv`（2026-01-03 / 11-11 / 12-22 各 12 段，36 行全字段）
- 能支撑：「时辰宜忌/吉凶（黄黑道）」展示、煞方/五神随时辰变化
- **缺**：每时辰的刑冲合害细目（库内只有日级 chong 与时辰 sha）、逐时神煞清单（仅 day 级 jiShen/xiongSha）；若产品要「时辰吉凶判定」需分层：
  - 建议：**黄黑道用 `tianShenLuck`（text only，不染色带）**；色带仍用 PM B″ 的宜忌计数 presence（已签）
  - 建议文案：「吉/凶为传统黄黑道说法，非预测」；不与色带混用
- 风险：不同历书流派对时家吉凶口径不同；需内容/顾问确认；仅展示、不做决策建议。

## 2) 天气
- 候选：
  - **和风天气 QWeather**：国内商用常见，免费开发版有 key、Web API（实时/逐小时/7 天）；**推荐**（文档完善、合规主体明确，需企业/个人 key）
  - 高德天气：需 key、与地图/定位配套；免费额度；商用需按高德条款（展示来源）
  - 心知天气 / 彩云：企业级，免费额度小
  - Open-Meteo：免 key、全球、但**国内商用许可/精度需评估**（仅原型）
- 定位策略：**不强制精确定位** → 首次询问「允许/手动选城市」；拒绝则用默认城市/上次城市；`NSLocationWhenInUseUsageDescription` 文案；不后台定位
- 缓存：30–60 分钟 TTL（按城市+日期），失败回退缓存 + 「上次更新」时间；离线不阻塞日历主流程
- 隐私更新：定位用途/天气服务商/缓存期限/撤回方式 → `privacy.md` 版本 +1、生效日更新；App 内「数据来源」标注
- 工作量：网络层+缓存 1.5d、定位权限/城市选择 1d、UI 1d、错误/离线 0.5d、隐私/审核 0.5–1d
- 风险：数据许可（必须用有资质源）、定位权限被拒的体验、审核问询；建议 P2（1.1）

## 3) 分享（大卡 → JPEG + QR）
- 渲染：`ImageRenderer(content: ShareCardView(...))`（iOS 16+，已 min 17）→ `renderer.scale = 3`、`uiImage` → JPEG 0.85；固定浅色/暗色两版或按当前主题
- 分享：`ShareLink(item: TransferableImage, subject:, message:)`（或 `UIActivityViewController`）；同时附带内容 URL
- QR：`CIContext` + `CIFilter.qrCodeGenerator()`（纠错 M、尺寸 512→显示 120），内容 `https://lixiang.zhaoyao.xin/d/<yyyy-MM-dd>`；中心留白/角标不遮码
- 风险：快照环境（Dynamic Type/Reduce Motion/主题）需固定参数；大图内存（3x 卡片 ~3–6MB JPEG）；QR 内容需 webdev 提供落地页；分享文案不含预测
- 工作量 2–3d（含落地页联调）

## 4) 单日左右滑
- 推荐：**`TabView(selection:)` + `.tabViewStyle(.page(indexDisplayMode: .never))`**，每页独立 `DayDetailScreen(date:)`；导航/状态在父层
- 或在合并卡上 `simultaneousGesture(DragGesture)`；**不要**与垂直 ScrollView 用 `highPriorityGesture`（会抢滚动）
- 预取：AppState 已有 370/420 天缓存，算下一/前一天 <1ms；可在 `onChange(selection)` 预取 ±1 并 `Task.detached` 预热
- 风险：左右滑与返回手势冲突（边缘）、页面切换闪动（预渲染±1）、状态（展开/滚动）需按日期保存；用 `TabView` 最稳
- 工作量 1–2d（含状态保存/预取/测试）

## 5) 大卡分区点击
- 结构：卡内用独立 `Button`/`NavigationLink` 子区域（图片、日期、quote），**外层不用整卡 NavigationLink**；每区 `.contentShape(Rectangle())`、`.zIndex(1)`、min 44pt 命中
- B3 教训：marker 不能在 NavigationLink label 内；同样适用于 quote/日期/图片
- a11y：每区独立 label + `.accessibilityElement(children:.ignore)`；避免重复朗读
- 工作量 0.5–1d

## 6) 民俗 remote admin（最小可行）
- 现状：主站静态（webdev v3.5 staging）；App 走 B′ manifest + 静态 HTML 缓存
- 最小方案：
  - **Cloudflare Pages Functions / Next Route Handler**：`/admin` 挂 **Cloudflare Access（邮箱 OTP）** 或 Basic+2FA；不新建账号体系
  - `/api/admin/manifest` GET/PUT：JSON schema 校验（slug/title/unlockDate/contentVersion/sha256/updatedAt/sources/license）；PUT 前跑 HTML→sha256
  - 存储：KV/对象存储保存 `ceremony/<slug>` HTML + manifest；draft/ published 两前缀；**预览**走 `?preview=token`；**发布**写 published + 增加 contentVersion + updatedAt + 审计日志（谁/何时/前后 SHA）
  - 回滚：保留最近 N 版（对象存储版本/前缀），一键切 hashes
  - App：现有 `HTTPContentSource` 已兼容 manifest 404/离线；admin 只影响发布侧，App 不改
- 依赖：主站技术栈确认（是否允许 Functions/后端）、域名/WAF、鉴权、内容 schema 签字
- 风险：运维/安全面扩大；发布误操作；建议只做「内容运营后台」不做通用 CMS
- 工作量：web 5–8d（含鉴权/预览/发布/审计），App 1–2d（联调/异常态）；P2

## 7) 道历/佛历设置+显示
- 复用 `ReligionDisplay`（已实现：名称映射/HIDDEN/免责声明）；B4 已完成 spike + 交叉核验 + PM PASS
- 实现：设置「日历显示」两个开关（UserDefaults，默认关）；月历格小点（道/佛节日，颜色区分、可关）；日详情节日行；设置页免责声明
- 工作量 2–3d（Core 行/开关 0.5、UI 1、测试/截图 0.5–1、审核文案 0.5）
- 风险：宗教内容审核/地区合规；不推送/不推荐；佛历 `result` 不展示（已定）

## 8) 365 天每日一句内容包
- Schema（建议）：`{ "date": "MM-DD" | null, "chapter": 1…81, "quote": "...", "zh": "...", "en": "...", "source": "王弼本（公版）" }`；一天一条，允许同章复用
- App：`Resources/PlainLanguage/daodejing-daily.json`（或 365 条数组）；按 `MM-DD` 读取（北京日界），缺日 → 回退现有 `(epochDay % 81)+1` 轮换；闰日 2/29 用 fallback
- 内容：PM 用 qwen4 生成 + 人工/双源核对；缺日统计脚本（App/内容两侧）
- 工作量 App 0.5–1d（loader/fallback/测试）；内容按 365 条估 2–3 人日（qwen4+复核）
- 风险：版权（公版原文）、重复/质量、每日一致性（跨端同一天同一条）

## 建议交付顺序（P1 批次）
1. #5 分区点击（0.5–1d）
2. #4 单日左右滑（1–2d）
3. #3 分享大卡+QR（2–3d，需 webdev 落地页）
4. #8 每日一句包（App 0.5–1d + 内容）
5. #1 时辰富数据「展示层」（黄黑道文字 + 五神/煞随小时）1–2d
6. #7 道历/佛历开关+显示（2–3d）
→ 合计约 7–12 dev 人日（不含内容/designer/QA）；#2 天气、#6 admin 放 P2。
