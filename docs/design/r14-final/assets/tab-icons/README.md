# r7-tab-icons · 历象四枚 Tab 矢量图标（D1 统一规格）

## 文件
| 文件 | 对应 tab | 说明 |
|---|---|---|
| `tab-calendar.svg` | 日历 | 日历框 + 装订环 + 日期点阵 |
| `tab-suishi.svg` | 岁时 | 一茎双叶（四时生长），区别于日历 |
| `tab-countdown.svg` | 倒计日 | 沙漏（时间流逝/倒计时） |
| `tab-settings.svg` | 设置 | 齿轮（8 齿 + 中心圆） |

## 统一规格
- 画布 **28 × 28**，内容安全区 2px（实际绘制 4–24pt）
- 描边 **1.8**，`stroke-linecap/linejoin: round`
- 颜色 `currentColor`（SwiftUI 用 `.renderingMode(.template)` + `.tint`）
- 无填充（仅日期点/沙漏中心点用 `currentColor` 实心点）
- 视觉重心统一在 (14, 14)，四枚并排时黑度一致；选中态用 accent（朱），未选用 ink3
- 同一套曲线语言：外轮廓圆角、端点圆、无尖角

## 设计理由（避免四枚撞脸）
- 日历=方框+格点；岁时=有机双叶；倒计日=三角对称沙漏；设置=中心对称齿轮
- 轮廓差异：方 / 有机 / 三角 / 放射，缩到 20pt 仍可区分
- 不用 SF Symbols 原样，避免与系统图标混用；由 designer 后续可按此 SVG 微调

## 交付与使用
- 当前交付 **SVG master**（可直接进 Sketch/Figma/AI，或转 PDF）
- 生成 App 资源：Xcode Asset Catalog 用 **PDF（保留矢量）** 或 1x/2x/3x PNG（28/56/84）
- Sketch 导入：新建 28×28 artboard → 拖入 SVG → 检查描边 1.8 → 导出 PDF/PNG
- 代码接入（后续，不在本轮）：`Image("tab-calendar").renderingMode(.template)`；不要改动 build12

## 备注
- 本目录仅设计素材，不改 App、不构建、不提交。
- 若 Sure 要更"朱印/暖纸"风格，可在选中态加 1px 朱色描边或 8% 朱色底，不改变线性图标本体。
