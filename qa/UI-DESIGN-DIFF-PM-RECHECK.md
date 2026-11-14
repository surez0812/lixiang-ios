# UI 差异复核（PM，第二轮，对 `UI-DESIGN-DIFF-PM.md`）

- 2026-11-14｜实现 HEAD `6e183cf3`；新截图 `dev-evidence/P1/shots/r14-pm-*`；**只读，未启模拟器，未碰 Duo**
- 判定：已修 / 仍偏差 / 仍需补证据；只对已查看截图下结论

## 1. 逐条复核（对照首轮高危项）
| # | 首轮问题 | 本轮观察（证据） | 判定 |
|---|---|---|---|
| 1 | home 缺「今日岁时」「今日纪念」两卡 | 两卡**已出现**（`r14-pm-home-light.png`），等高、同行对齐；但内容为「暂无岁时/暂无纪念」占位 | **已修（布局）**；数据待接（非视觉） |
| 2 | home 红卡 +10pt | 红卡高度观感与设计接近（无像素量测工具）；卡距仍略紧 | **已修（观感）**；仍建议量测 |
| 3 | serif/宋体回退（日期/大标题） | 日期与「黄历」「宜忌」仍为**无衬线粗体**（PingFang），设计为宋体/serif | **仍偏差（高，未修）** |
| 4 | almanac 红卡缺「当日岁时」 | `r14-pm-almanac-light.png` 红卡仍只有 纪元/前后一天，**无当日岁时行** | **仍缺失（高）** |
| 5 | almanac 橙黄渐变背景 | 背景改为接近暖纸的浅色（仍轻微渐变）；未见橙黄大渐变 | **已修（观感）**；token 数值待核 |
| 6 | 宜忌缺逐项白话解释 | `r14-pm-almanac-vernacular.png` 开关 ON 后每项有「含义：…」解释 | **已修** |
| 7 | 值神罗盘/返回非玻璃 | 值神罗盘按钮、返回按钮呈**玻璃胶囊/着色玻璃感** | **已修（观感）**；真机/Reduce Transparency 待证据 |
| 8 | Liquid Glass tabbar/导航不真实 | tabbar 为玻璃胶囊（内容可透出）、导航按钮玻璃感 | **已修（部分）**；仍需深色/真机证据 |
| 9 | almanac 空白错误态 | 新 `r14-pm-*` 未见空白警告态；旧失败 shot 未复现 | **未复现**；需专项回归证据（非 PASS） |
| 10 | 黄历卡在 home 被底栏压住 / 间距 +8 | home 黄历卡底部仍延伸到 tabbar 下（内容被遮挡观感仍在）；间距无法量测 | **仍偏差/需证据** |
| 11 | folklore/detail/settings iPad+深色缺证据 | 仍**无** folklore/folklore-detail/settings 的 iPad/深色截图；compass 有 ipad/dark；daily/fortune/selection 仅 landscape | **仍需补证据（高）** |

## 2. 新增/剩余证据缺口（清单）
- 缺：folklore、folklore-detail、settings（iPhone 深色 + iPad portrait/landscape 全态）
- 缺：daily/fortune/selection 的 **iPad portrait** 与深色；fortune 动画 5 时间点；countdown 深浅/iPad
- 缺：真机 Liquid Glass（Reduce Transparency/深色）、动态字体大字号、iPad 横竖对比
- 缺：almanac 空白态负向回归截图

## 3. 结论
- **已修**：home 两卡（布局）、宜忌逐项白话、暖纸背景观感、玻璃按钮/tabbar 观感、home 红卡高度观感
- **仍偏差/缺失**：**almanac 当日岁时行缺失**、**serif 未修**、home 黄历卡与底栏关系、间距量测
- **仍需补证据**：folklore/folklore-detail/settings 全部 iPad/深色；daily/fortune/selection iPad portrait/深色；真机 glass/动态字体/动画
- 未修改代码/设计；不 push/merge；不含 Duo
