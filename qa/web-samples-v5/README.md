# Hero v5：平涂工笔 + 点景人物（5 张 review）

- 2026-11-14｜qwen-image-3.0-pro（multimodal-generation sync）；size=1024*576（模型支持，无裁切/无拉伸）；每 id 2 候选选 1
- 选中：lichun-c1 / qingming-c2 / duanwu-c2 / zhongqiu-c1 / chongyang-c1
- 每张 1–2 个宋制衣袍人物，远景/背影，不露正脸，作为点景不抢主体
- flat 2D 工笔矿物彩；无 modern clothing/portrait close-up/recognizable face；无文字/宗教场所
- 路径：`heroes/<id>.webp`（16:9 1024×576、≤120KB）；webpage 沿用 v4（卡片/宋体/暖纸），未改版式
- 本次 10 次 ¥2.5；累计 101 次 ¥21.36；未批量、不 TestFlight/测试包
- 注意：主图 env `/Users/surezhang/.dashscope/image.env` 于 15:49 被清空（仅 1 字节）；本轮使用**回退图片 env** `/Users/surezhang/work/ZhaoYao/.secrets/dashscope-image.env`，未用 token/top plan

## 内容 v2：qwen4 丰富文案（2026-11-14）
- 5 篇 `content/<id>/article.json`（qwen4 token plan；仅文本，未用图片 env）
- 每篇 ≥4 节，含「来由与历史起源」「风俗习惯（南北差异）」「日常小仪式（steps）」；sources 2 条 https
- 仅 `light.html`（**已去掉 dark.html / dark tokens**），沿用 v5 卡片/宋体/暖纸版式；**不渲染 note/sources/updatedAt**，无 header hero
- 预算：token plan 另行记账，不计入图片 ¥ 预算
