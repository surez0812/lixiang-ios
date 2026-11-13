# 历象三屏设计修订 · Codex 任务计划

事实源：`handover/calendar-20261111/reviews/SURE-REVIEW-R3-2026-11-12.md` + 会话 17:18 意见。
核心原则：**删除所有印章**；D1 暖纸风格；不密网格；Liquid Glass 只用于导航层；Duo 按 skill；每日一签本地固化。

| # | 意见 | 任务 | 交付物 | 状态 |
|---|---|---|---|---|
| 0 | 全局 | 删除所有印章；统一 D1 tokens | 所有 PNG 无印章；`CODEX-DELIVERY-SPEC.md` | 进行中 |
| A1 | 首屏 Hero | 重做 Hero（去印章、节气三候 badge、quote 面板、分享） | `hero-light/dark.png`、`hero-ipad-land/portrait.png` | 待做 |
| A3 | 节气三候 | 左上角「今日节气 · 立冬 · 一候 水始冰」随节气/候 | 含在 Hero 样张 + 规格 | 待做 |
| A4 | iPad 合并 | 左单日多卡铺满 + 右月历浮动小卡（元素完整） | `ipad-merged-land/portrait.png` | 待做 |
| B1 | 每日一句顶部 | Liquid Glass 只留返回+分享，去 title/解释 | `daily-light/dark.png`、`daily-ipad-*` | 待做 |
| B2 | 经文卡动态高度 | 出短/长两版证明自适应 | `daily-long.png` + 规格 | 待做 |
| C1 | 三小卡 | 白话全解/每日一签(icon)/天气 一行三卡 | 含在 `day-*` | 待做 |
| C2 | 去分享/提醒 | 单日详情右上无分享/提醒 | 含在 `day-*` | 待做 |
| C3 | 去顶部 title | 顶部无 title | 含在 `day-*` | 待做 |
| C4 | 返回 Liquid Glass | 返回圆钮 glass | 含在 `day-*` | 待做 |
| C5 | 今日黄历精修 | 分组/字体/icon/罗盘精修，去堆字 | 含在 `day-*` | 待做 |
| C6 | 择日卡 | 岁时下加择日卡 | 含在 `day-*` | 待做 |
| D1 | 分享卡 | 只亮色 | `share-light.png` | 待做 |
| E1 | Duo 竖 | close/open 竖：iPhone 布局 + 右侧状态栏导航 | `duo-poses.png` 对应帧 | 待做 |
| E2 | Duo 横/tent | close/open 横 + tent：iPad 合并布局 | `duo-poses.png` 对应帧 | 待做 |
| E3 | tabletop | 首页上大卡下月历；单日页上(大卡+白话+一签+天气)下(黄历+岁时+择日) | `duo-poses.png` 对应帧 | 待做 |
| F1 | 每日一签 | 整屏 + 动画关键帧 | `qian-idle/shake/result.png` | 待做 |
| F2 | 本地固化 | spec 说明本地 JSON、无 AI API | `CODEX-DELIVERY-SPEC.md` | 待做 |
| F3 | 文案 | 签语样例 8–12 条、择日文案、白话示例 | `CODEX-COPY.md` | 待做 |

## 产出目录
`handover/calendar-20261111/proposals/lixiang-1.0-20261111/final-revision-codex/`

## 验收
- [ ] 所有 PNG 无印章（grep 生成脚本确认）
- [ ] Hero 375 亮暗 + iPad 横竖
- [ ] Daily 375 亮暗 + 长文版 + iPad 横竖
- [ ] Day 375 亮暗 + iPad 横竖（合并）
- [ ] Duo 六姿态
- [ ] 分享卡仅亮色
- [ ] 每日一签 3 帧
- [ ] spec / copy / checklist / SHA 清单齐全
