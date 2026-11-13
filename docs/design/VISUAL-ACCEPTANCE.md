# 逐页视觉对照清单（QA 视觉验收依据）

- 主表：`SCREEN-VISUAL-CHECKLIST.csv`（188 行；每条 `design_png` → 待填 `native_screenshot_path`/`diff_status`/`severity`/`notes`）。
- 设计源：`r14-final/screens.json`（188 条，12 画布）；原型 `r14-final/index.html`；像素 PNG 为离线合成，**不是原生截图**。
- 规则：以 R14 + HOME-TOOLS 为唯一基线；不拿 R3/早期 final-revision 对比；普通 iPhone 仅 portrait；Split View 不在范围。

## 1. 对照流程（每屏）
1. 按 `mode/state/full` 在原生 App 复现同一入口、日期、权限、动效时间点；普通 iPhone 只竖屏。
2. 截原生图（真机优先；模拟器标注），命名 `<screen>-native.png`，回填 CSV。
3. 与设计 PNG 同尺寸叠加对比（100%；不缩放裁切）；记录差异。
4. 用页面合同（`PAGE-CONTRACTS.md`）逐条核对行为，不只看像素。
5. QA 结论：PASS / PASS-WITH-NOTES / FAIL / NOT RUN；FAIL 有复现步骤+设备+系统+commit。
6. 全设备矩阵：phone portrait light/dark；iPad portrait/landscape light/dark；Duo 六姿态。未测即 NOT RUN，不以 PNG/HTML 代替。

## 2. 差异分级
| 级别 | 判定 | 示例 |
|---|---|---|
| **P0 阻断** | 布局错位/裁切/不可点/错误状态/数据错误 | 内容被 tab 遮挡；日期只换标题；权限拒绝无 UI；fortune 结果被裁；Duo 折叠区可点 |
| **P1 高** | 视觉明显偏离 token/结构，但可用 | 字号层级错、卡片间距错、玻璃层缺失/铺到内容、双卡不等高 |
| **P2 中** | 细节 token/文案/图标差异 | 1–2pt 间距、圆角、描边、图标 1px |
| **P3 低** | 可接受平台差异 | 系统字体渲染/玻璃折射差异、状态栏 |

- 几何：关键容器 ±1pt 内为 PASS；颜色：平面色 ΔE2000 ≤2；文本换行/行数必须一致（动态字体另测）。
- 玻璃：离线 PNG 仅材质模拟；真实折射/高光差异不算 P1，但“内容铺玻璃”“控制不可点”算 P1/P0。
- 系统栏/安全区：设计 canvas 含模拟 chrome；原生以真实 safe area 为准（见 IMPLEMENTATION-HANDOFF）。

## 3. 状态/行为必测（按页面合同）
- 通用：长文/动态字体、VoiceOver、Reduce Motion/Transparency、重复点击、返回恢复、前后台、姿态切换、离线。
- home：17 状态 + 天气 5 态 + 权限拒绝/设置返回；双卡等高对齐；无命中不占位。
- almanac：跨月/年/闰年/时区；白话开/关往返；空/多岁时；前一天/后一天；罗盘往返日期保持。
- compass：12 时辰/日时切换/重入/离线素材；日期参数。
- daily：最长经文+来源、二维码可扫、深色 App 亮色分享、取消/失败/保存权限。
- fortune：冻结 SHA、五关键点、跳过/减少动态/中断/前后台/折叠、同日同签/跨日；标题常驻；结果无内部滚动。
- folklore/detail：0/10/11/15 天、过期、分类空态、版本未读、加载/缓存/离线/失败；Web 正文不另造导航。
- selection/countdown/detail：合法/倒置/空、真实筛选；多条/0/10/11/重复/农历闰月/2月29；通知全分支。
- settings：重启/跨页同步/系统主题/道佛开关/真实链接/版本。
- Duo：六姿态内容/控件/折叠避让；Tabletop=Open Portrait 布局；close landscape 筛选换行不横滑。
- iPad：横竖独立滚动/两端满高；分享 poster 只亮色。

## 4. 交付节奏
- 先做 1 条完整链（home→almanac→compass→返回）全设备 PASS，再扩 188 屏。
- 设计侧提供 PNG/HTML/尺寸/状态；QA 填 CSV；设计只读复核视觉差异（不写产品代码）。
- 每轮差异汇总：P0/P1 计数、按页面/模式分布、未测清单；P0 清零后才可提“视觉 PASS 候选”。
