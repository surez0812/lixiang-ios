# 历象三屏设计修订 · Codex 交付规格

产出目录：`handover/calendar-20261111/proposals/lixiang-1.0-20261111/final-revision-codex/`
生成方式：HTML + headless Chrome 截图（`build_phone.py`、`build_ipad_duo.py`），可复跑。
**本版无任何印章**（Hero / 每日一句 / 单日详情 / 分享卡全部无印章）。

## 一、D1 Tokens
| Token | 亮 | 暗 |
|---|---|---|
| bg | `radial-gradient(120% 90% at 30% 8%, #FFF8EC 0%, #F7EBDC 55%, #EFCB95 100%)` | `#2A1A12 → #241710 → #160D09` |
| paper | `#FFF8EC` | `#2F2016` |
| ink | `#3A2417` | `#F7E6CE` |
| ink2 | `#7A4F35` | `#D9B794` |
| ink3 | `#A67B58` | `#B08A68` |
| red | `#C0452C` | `#F08A5C` |
| orange | `#E07A3C` | `#FF9A5C` |
| green | `#7C8F5E` | `#9FAF7E` |
| line | `#E7C9A4` | `#4A3322` |
| cream | `#FFF1D8` | `#FFEED4` |

- 卡片圆角 22–24；卡片阴影 `0 18px 36px rgba(60,30,10,.12)`。
- 正文对比 ≥4.5:1；小字最小 9.5pt（手机）/ 11pt（iPad）。
- 字体：标题 Songti SC，经文 Kaiti SC，正文 -apple-system/PingFang SC。

## 二、Liquid Glass（仅导航/控制层）
- 顶部返回/分享用玻璃 pill / 玻璃圆钮：`linear-gradient(135deg, cream 40%, paper 60%)` + `backdrop-filter: blur(22px) saturate(1.3)` + 1px cream 边 + 轻阴影。
- iOS 26：`.glassEffect()` / `.buttonStyle(.glass)` / `GlassEffectContainer`；iOS 17 回退 `.ultraThinMaterial`。
- 规则：玻璃只承载返回、分享、tab 等控制；**不用于内容卡**。

## 三、首屏 Hero（`hero-*.png`）
- 结构：状态栏 → 导航（昭杳·历象 / 搜索）→ Hero 卡 → 完整月历 → 岁时/择日快捷卡。
- Hero 卡：节气图 200（compact 150）+ 渐隐；左上「❄ 今日节气 · 立冬 · 一候 水始冰」；日期 16/600 → 农历干支 10.5 → 节日 chips（1+N）→ 朱橙 quote 面板（21 楷体 + 出处 + 读解释/分享）。
- **无印章**；不得用印章撑高卡片。
- 月历：完整 30 天 + 周标题 + 节气/节日点 + 下方「岁时/择日」快捷卡。

## 四、每日一句 page（`daily-*.png`、`ipad-daily-*`）
- 顶部 Liquid Glass：**只留返回 + 分享**；无 title、无「解释」按钮。
- 经文卡：label「今日经文 · 道经」→ quote 25 楷体 → 出处 → 分隔线 → 白话解释 11.5/1.85 → 分享/保存按钮。
- **动态高度**：卡片按 quote 行数 + 解释长度自适应；`daily-long.png` 为长文示例（卡片变高、页面滚动），短签不留固定空高。
- 分享卡预览：1080×1350、QR 内置（无印章）。

## 五、单日详情（`day-*.png`、`day-full-*.png`、`ipad-merged-*`）
- 顶部：仅 Liquid Glass 返回圆钮；**无 title、无右上分享、无提醒**。
- Hero（compact）：图 150 + 节气候 badge + 日期/农历/干支 + 节日 chips + quote 条（读解释）；**无分享 icon**。
- 三小卡一行：白话全解（toggle）/ 每日一签（签筒 icon，无箭头）/ 今日天气。
- 今日黄历（一张统一卡，分组 + 1px 分隔）：
  - 宜 chips / 忌 chips（仅此一处）
  - 五行 / 值神 / 冲煞 / 星宿（每行 ⓘ）
  - 财神/福神/喜神/阳贵 2×2 + 紧凑罗盘 64
  - 吉神宜趋 / 凶神宜忌（每行 ⓘ）
  - 时辰 12 段横条
- 岁时卡（不写「未来 10 天」）。
- **择日卡**：岁时下方，「吉日查询 ›」。
- 完整页 `day-full-*`（375×1200）确认 1.1–1.2 屏自然滚动、无截断。

## 六、iPad 合并（`ipad-merged-landscape/portrait-*`）
- 左：单日详情多卡（Hero / 三小卡 / 今日黄历 / 岁时 / 择日），可左右滑切日。
- 右：**月历浮动小卡，不随左列滚动**；完整元素（月份、周标题、30 天、农历小字、节气/节日点、选中高亮、图例）。
- 横：左 660 + 右 400；竖：左 600 + 右 360；月历下方补「岁时/择日」快捷卡。
- iPad 不照抄 iPhone：左列多卡铺满宽高，右列固定月历。

## 七、iPhone Duo 六姿态（`duo-poses.png`）
- 原则：**无 navigation bar**；导航按钮用系统 toolbar 放**右侧状态栏**；竖屏同 iPhone；横屏 / tent 同 iPad 合并；tabletop 上下分屏。
- 闭合竖：单列 + 右侧竖栏（日历/民俗/设置/更多）。
- 闭合横 / 展开横 / tent：左单日多卡 + 右月历（同 iPad 合并）。
- 展开竖：两列（左单日 / 右月历）。
- Tabletop：首页上=今日大卡、下=月历；单日页上=今日大卡+白话+一签+天气、下=今日黄历+岁时+择日。
- 说明：此为**设计约束与关键示意**，非实机验收（NOTRUN）。

## 八、每日一签（`qian-{idle,shake,result}-*`）
- 整屏：状态栏 → 玻璃返回 → 标题「每日一签」→ 副标题「静心一刻 · 传统签文参考」。
- idle：签筒 + 「轻摇签筒，诚心一签」+ 摇一签按钮。
- shake：签筒摇晃态（左右 6°/120ms×3）+ 「摇签中…」。
- result：签号/等级/签语 + **含义 / 影响 / 怎么用** 三段 + 收下此签 / 分享。
- 动画规格：签筒摇 → 签条落下/翻面 → 结果卡淡入，总 300–450ms；Reduce Motion 时静态直接出结果。
- **本地固化**：签种 + 签语 + 三段解释全部放 App 本地 JSON，手机端**不调 AI API、不联网**；日期确定性映射 + 缺日哈希。
- 文案样例见 `CODEX-COPY.md`；完整 100 条待内容侧补全。

## 九、分享卡（`share-light.png`）
- **仅亮色**，1080×1350 JPEG 来源图。
- 内容：顶部节气图 + 渐隐；「历象 · 每日一句 · 道经」；quote；出处；日期 + 农历 + 节气候；QR（App Store `id6833252283`，已重新生成无印章版）；「App Store 搜索「历象」」。
- 无印章、无暗色版本。

## 十、假设与依赖
- 节气三候数据已由 dev 落地（24×3=72 候）；本稿 badge 用「立冬·一候 水始冰 / 冬至·一候 蚯蚓结」示例。
- 每日一签完整 100 条签语待 PM 内容侧补全；本稿给 10 条样例。
- Duo 六姿态为设计示意，实机 NOTRUN。
- 所有 PNG 可复跑：`python3 build_phone.py && python3 build_ipad_duo.py`。
