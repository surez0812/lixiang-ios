# 岁时正文样例（qwen4 prompt 模板 + 5 例，待 Sure review）

- 2026-11-14｜依据 `r14-final/templates/CONTENT-PROMPT.md`、`festival-article.schema.json`、`festival-article.css`、`render_article.py`、`webpages/*.html`
- **Prompt 模板**：`PROMPT-TEMPLATE.md`（只输出 JSON；HTML 由渲染器生成）
- **样例**：立春/清明/端午/中秋/重阳；各含 `article.json`、`light.html`、`dark.html`、`prompt.txt`
- **webpage 不含 header hero**：已移除 `img.web-hero`；App 用 `heroImageURL`
- 样式内联；暗色 `data-theme="dark"`；手机/iPad/Duo/分屏按模板 tokens（单列/最大宽度/系统字号）
- 内容：无效果承诺/预测/宗教劝诱/医疗指令；地区差异标注；来源 https；不写导航/权限/安装引导/脚本
- 边界：样例 draft；Sure review 后才批量；最终 HTML 由模板渲染器生成

## 全量节日清单（建议 19 个，待 Sure 确认）
现有 15：春节、元宵、清明、端午、七夕、中元、中秋、重阳、腊八、谢灶（小年）、除夕、上巳、下元、祭祖、盂兰盆
拟增 4：寒食、龙抬头（二月二）、社日、观莲节
- 寒食与清明日期相近但语义不同，是否单独成页待定
- 24 节气：立春…大寒（全 24）
- 覆盖 5/43（24+19）；批量在样板 review 后执行
