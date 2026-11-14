# Hero v4：原汁宣和院体工笔 + 丰富矿物彩（5 张 review）

- 2026-11-14｜按 `qa/HERO-STYLE-TEMPLATE.md` v2 执行；wanx2.1-t2i-plus、1024×576、seed 20261111、每 id 2 候选选 1
- 选中：lichun-c2 / qingming-c1 / duanwu-c2 / zhongqiu-c1 / chongyang-c1
- 风格：宣和院体工笔细线 + 矿物颜料分层（azurite/malachite/cinnabar/ochre/indigo/gamboge/gold）于做旧绢本；无 modern flat/暖纸克制；色彩丰富但不刺眼
- 对照结论：与“宣和院体工笔彩绘”同向；主体居中下半、上三分之一留白；无文字/人物/宗教场所；duanwu 为青绿+朱红，不荧光
- 路径：`heroes/<id>.webp`（16:9 ≤120KB）；`<id>/light.html`、`dark.html`、`article.json`
- `index.html` = `gallery.html`（hero base64 内嵌）
- 本轮 12 次候选（qingming 重跑 2）¥2.4；累计 72 次、¥14.4（预算 ≤50）
- 未批量、不 TestFlight/测试包；等 Sure 看 5 张

## 端午单张返修（2026-11-14）
- 仅替换 `heroes/duanwu.webp`：龙舟+粽子+艾草，青瓷绿+克制朱红/赭石，宣和院体工笔矿物彩
- 其余 4 张与 webpage 不动；本轮 2 次 ¥0.4，累计 74 次、¥14.8

## 端午整船返修（2026-11-14，第 3 轮）
- 仅替换 `heroes/duanwu.webp`：**整条木龙舟侧视**（龙头/龙尾/船身鳞纹完整可见）+ 两只粽子为次要点缀；宣和院体工笔矿物彩、青瓷绿+克制朱红
- 本轮 3 候选选 1；累计 77 次、¥15.4；其余 4 张/网页未动

## 端午多模型 A/B（2026-11-14）
- 可用图片模型（API 列表实测价）：wanx2.1-t2i-plus ¥0.2/张；wan2.2-t2i-plus ¥0.2/张；wan2.2-t2i-flash ¥0.14；wan2.5-t2i-preview ¥0.2/张；wan2.6-t2i 标价 ¥0.2 但本 key 调用 400（不可用）；wan2.7-image ¥0.2 / pro ¥0.5
- 本轮：wan2.1 control ×1、wan2.2-t2i-plus ×3、wan2.5-t2i-preview ×2；6 次 ¥1.2；累计 83 次 ¥16.6
- 排名（龙舟/粽子/画风/绢本质感）：**1) wan2.5-t2i-preview（25-1，选中）**；2) wan2.2-t2i-plus（粽子最真实但龙舟偏小）；3) wan2.1（粽子几何化，不合格）
- 最终端午：wan2.5-t2i-preview，整船+两枚裹叶捆绳粽子，工笔矿物彩；其余 4 张不动
