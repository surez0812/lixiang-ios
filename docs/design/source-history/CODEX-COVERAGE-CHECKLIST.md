# 历象三屏修订 · 逐条覆盖清单（Codex）

> 事实源：`handover/calendar-20261111/reviews/SURE-REVIEW-R3-2026-11-12.md` + 会话 17:18 意见。
> 本清单逐条对应 Sure 意见，证据为 PNG/规格文件名。**全目录无印章**。

| 编号 | Sure 意见 | 落实 | 证据 |
|---|---|---|---|
| A1/A2 | 删除印章（太丑） | 全部删除，Hero/每日一句/单日详情/分享卡均无印章 | 所有 PNG；`grep seal build_*.py` 仅注释 |
| A3 | 节气三候、左上角随节气/候更新 | 左上角徽标改为「今日节气 · 立冬 · 一候 水始冰」；单日页「冬至 · 一候 蚯蚓结」 | `hero-light.png`、`day-light.png`、`CODEX-DELIVERY-SPEC §二` |
| A4 | iPad 单日+首页合并重设；左单日可滑切日；右月历浮动小卡、元素完整 | 左列多卡（Hero/三小卡/黄历/岁时/择日），右列固定月历（30 天+农历小字+节气/节日点+选中高亮+图例） | `ipad-merged-landscape-light.png`、`ipad-merged-portrait-light.png`、`ipad-merged-*-dark.png` |
| B1 | 每日一句顶部 Liquid Glass，去 title、去解释按钮，只留返回+分享 | 玻璃 pill 仅返回 ‹ 与 分享 ↗，无 title、无解释按钮 | `daily-light.png`、`daily-dark.png`、`ipad-daily-*` |
| B2 | 经文卡按经文+解释长度动态高度 | 出短版 `daily-light.png` 与长版 `daily-long.png`（卡片自适应增高、页面滚动） | `daily-light.png`、`daily-long.png`、spec §四 |
| C1 | 白话全解/一签/天气 一行三小卡；一签 icon 无箭头 | 三小卡一行；每日一签用签筒 icon，无箭头 | `day-light.png`、`day-dark.png` |
| C2 | 去右上分享、去提醒 | 单日页顶部无分享、无提醒；Hero 卡也无分享 icon | `day-light.png` |
| C3 | 去顶部 title | 单日页顶部仅玻璃返回钮 | `day-light.png` |
| C4 | 返回按钮 Liquid Glass | 玻璃圆钮（blur 22/cream 边） | `day-light.png`、spec §二 |
| C5 | 今日黄历继续精修 | 统一卡分组：宜忌 chips / 四行 ⓘ / 方位 2×2 + 罗盘 / 吉凶神 ⓘ / 时辰 12 条 | `day-light.png`、`day-full-light.png` |
| C6 | 岁时下加择日卡 | 岁时卡下方新增「择日 · 吉日查询 ›」 | `day-full-light.png`、`day-full-dark.png` |
| D1 | 分享卡只要亮色 | 仅 `share-light.png`，无暗色 | `share-light.png` |
| E1 | Duo close/open 竖：同 iPhone，导航按钮右侧状态栏 | 右侧竖栏（日历/民俗/设置/更多），无 navigation bar | `duo-poses.png` 上排左 |
| E2 | Duo close/open 横 + tent：同 iPad 合并 | 左单日多卡 + 右月历两列 | `duo-poses.png` 上排中 / 下排左 |
| E3 | tabletop 分屏 | 首页上=大卡/下=月历；单日页上=大卡+白话+一签+天气/下=黄历+岁时+择日 | `duo-poses.png` 下排中 |
| E4 | Duo skill/古琴经验 | 依据古琴团队 `skills/iphone-duo-design-notes.md`（右侧导航/toolbarVerticalEdge/折叠避让/短边≥600 判内屏） | spec §七；Duo 经验文档 |
| F1 | 每日一签整屏+动画 | idle/shake/result 三关键帧；签筒摇→翻卡→结果 | `qian-idle-light.png`、`qian-shake-light.png`、`qian-result-light.png`（暗色同名） |
| F2 | 本地固化，不调 AI API | spec 明确签种+签语本地 JSON、确定性映射、无网络调用 | spec §八 |
| F3 | 设计+文案给 Sure review | 10 条签语样例（含义/影响/怎么用）+ 择日/白话/节气/分享文案 | `CODEX-COPY.md` |

## 生成/复跑
```
python3 build_phone.py     # 手机/分享卡/每日一签
python3 build_ipad_duo.py  # iPad 合并 / iPad 每日一句 / Duo 六姿态
```

## 已知假设 / 依赖
- 节气三候数据由 dev 落地（24×3=72 候），本稿使用示例候名。
- 每日一签完整 100 条签语待内容侧补全（本稿 10 条样例）。
- Duo 六姿态为设计示意，实机 NOTRUN，需真机验收。
- iPad 字体按 1194×834 / 1024×1366 出图，落地时需按真机 pt 适配。
