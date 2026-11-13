# D1 Design Tokens（R14 冻结）

来源：`r14-final/*.html` CSS 变量与 R11–R14 规范；**实现以原生 dynamic color 映射，不硬编码 hex 字符串**。PNG 的玻璃为离线模拟，真实玻璃由系统 Liquid Glass 提供。

## 1. 色板
| Token | Light | Dark | 用途 |
|---|---|---|---|
| `bg` | `#FFF8EC` | `#211D19` | App 背景 |
| `paper` | `#FFFCF5` | `#30281F` | 卡片/纸面 |
| `ink` | `#35291F` | `#F8ECD8` | 主文字 |
| `muted` | `#79634D` | `#C9B69C` | 次文/注释 |
| `line` | `#E8D6BA` | `#69523B` | 1px 分隔线 |
| `red` | `#A63D26` | `#FFAC88` | 朱色强调/选中/节气 |
| `gold` | `#B3863D` | `#D9B675` | 节气/装饰/星标 |
| `wash` | `#F6E8D1` | `#403326` | 浅底块/胶囊底 |
| `glass` | `#FFFCF5B8`（部分 `BF/E8`） | `#30281FC4`（部分 `C9/E8`） | 导航控制层玻璃 tint（仅控制层） |
| 文本对比 | ≥4.5:1 | ≥4.5:1 | 正文/按钮标签；装饰不承载信息 |

- 朱色/金色不得作为唯一信息编码（宜忌/状态需文字 + 图形）。
- 暗色不是简单反色；保留暖纸/朱色语言。
- 无印章，不使用程序绘制印章。

## 2. 字体与字号
| 角色 | 字体 | 字号/行高（参考） |
|---|---|---|
| 大标题/品牌 | Songti SC / Kaiti SC（标题） | 28–30；行高 1.2–1.3 |
| 页面 H1 | Songti SC 600 | 25–30 |
| 卡片 H2/H3 | Songti SC 600 | 17–19 / 15–16 |
| 正文 | PingFang SC 400/500 | 14–15 / 1.8–1.9 |
| 辅助/说明 | PingFang SC 500 | 12 / 1.6–1.7 |
| 标签/caption | PingFang SC 600 | 10–11 |
| 最小正文 | — | **12pt**；注释 ≥10pt；不再 <9pt |
| 引文 serif | Kaiti/Songti | 19–25（daily poster 25） |

- 支持 Dynamic Type；实现用 `Font.custom(...).relativeTo`/`UIFontMetrics`，上限按页面合同；长文可滚动不截断。
- 数字/日期用 tabular 不强制；中文标点不孤行。

## 3. 间距/尺寸/圆角
| 项 | 值 |
|---|---|
| 栅格 | 4pt 基准；常用 8/10/12/14/16/18/20/24 |
| 页面边距 | iPhone 18–20；iPad/宽屏 24–26；卡片内 14–20 |
| 卡片圆角 | 14/16/18/20/22/24；海报 20；玻璃胶囊 999 |
| 卡片间距 | 10–14（同组）；组间 18–24 |
| 触控最小 | **44×44pt**；主按钮高 ≥44；胶囊按钮 ≥44 |
| 底部 tab 避让 | 内容末尾 **84pt**（玻璃 tab 覆盖滚动内容） |
| 浮动返回/工具 | 44×44pt 玻璃圆钮；同组间距 8pt |
| 罗盘入口 | 普通 iPhone/iPad 右上「值神罗盘」文字玻璃按钮 **≥104×44pt**；返回左上 |
| 状态栏/导航 | 系统容器；不自绘 bar；Duo 右侧状态栏（见 PAGE-CONTRACTS/Duo notes） |

## 4. Liquid Glass（仅导航控制）
- 底部 Tab/浮动 tab、返回、值神罗盘、工具按钮：系统 glass/toolbar；**内容卡不铺玻璃**。
- 离线稿近似：`backdrop-filter: blur(24px) saturate(1.5)`；`background: var(--glass)`；`box-shadow: inset 0 1px 1px #fff9, 0 7px 25px #50381913`；圆角按容器。
- Reduce Transparency：玻璃降级为 `paper` 不透明；Increase Contrast：边框/文字加强。真实渲染需原生验收，不以 PNG 判 PASS。
- 5 Tab：日历 / 岁时 / 择日 / 倒计日 / 设置；图标详见 `ASSETS.md`。

## 5. 动效/状态
- 减少动态：fortune 用 150ms opacity-only；其他过渡≤200ms 或关闭。
- 触觉/声音不在设计稿范围；原生实现按系统规范。
- 状态色：未读朱点、倒计日 badge 朱红；不得只靠颜色区分。
