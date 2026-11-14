# 岁时 webpage 样例 v2（R14/Codex tokens，待 Sure review）

- 2026-11-14｜5 例：立春/清明/端午/中秋/重阳；每目录：`article.json`、`light.html`、`dark.html`、`heroes/<id>.webp`
- 设计 tokens：bg `#FFF8EC`、paper `#FFFCF5`、ink `#35291F`、muted `#79634D`、red `#A63D26`、gold `#B3863D`、line `#E8D6BA`、wash `#F6E8D1`
- 卡片：1px line、radius 24、paper、padding 19；标题 Songti；朱红点缀；大留白
- **webpage 不含 header hero**：hero 图单独放 `heroes/`，App 用 `heroImageURL`
- **网页不渲染**：note/「不作吉凶判断」/延伸阅读/来源链接/updatedAt（这些仅在 JSON 保留）
- 暗色：`data-theme="dark"`；`prefers-color-scheme` 自动；响应式 375/iPad/Duo 单列卡
- 最终 HTML 由我们的模板渲染；批量前先 review 5 例

## Hero 修正（2026-11-14，Lead review 后）
- `duanwu`：龙舟+粽子+艾草，84,238B，SHA `acab64b9…`（原图近乎空白已替换）
- `lichun`：柳枝+融冰，主体居中，39,562B，SHA `a33b7220…`
- `qingming`：柳枝+青山细雨，主体居中，30,928B，SHA `78c91c59…`
- `zhongqiu`/`chongyang` 保留；总调用 60 次、¥12.0；仍不批量

## Review index（2026-11-14，Lead 改版，勿覆盖）
- `index.html` 已含 5 张 hero + 亮/暗 webpage 链接（SHA 以 Lead 版本为准 `9c68ec35…`）
- duanwu hero 色彩比其余更饱和/偏插画；若 Sure 觉得跳脱，再单张重跑；其余 4 张保留

## Gallery（2026-11-14，Lead 新增，勿覆盖）
- `gallery.html`：5 张 hero base64 内嵌 + 亮/暗 webpage 链接，解决本地预览相对路径不加载问题；SHA 以 Lead 版本 `cf2b8794…` 为准
- `index.html` 保持 Lead 改版（不做相对路径回退）
