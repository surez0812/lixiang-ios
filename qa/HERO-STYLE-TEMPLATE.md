# 历象 hero 统一生图模板 v2（原汁宣和院体 + 丰富矿物彩色）

- 目标：24 节气 + 19 节日 hero 统一风格。
- 风格锚点：**北宋宣和院体 / 工笔设色，原汁绢本感 + 丰富矿物颜料色**；**去掉现代暖纸克制的观感**。
- 实际生成：PM 用 Aliyun wanx 普通图片 key；预算 ≤ ¥50（已花 ¥14.0，余 ¥36）。

## 1. 主 prompt（英文）

> Traditional Northern Song Xuanhe academy court painting, gongbi (meticulous fine-line) style with layered mineral-pigment color on aged silk — azurite, malachite, cinnabar, ochre, indigo, gamboge, gold; refined, elegant, poetic, rich but not garish. Subject: {SUBJECT}. Include one or two small elegant figures in Song-dynasty robes as scenic staffage, seen from behind or in the distance; faces are not recognizable. Aged silk/米黄 ground with subtle silk weave texture; clear focal subject placed center/lower two-thirds; upper third calm negative space for UI. No text, no modern clothing, no portrait close-up, no religious statue, no temple, no talisman. 16:9 composition.

## 2. 统一 negative

> text, letters, words, typography, signage, banner text, inscription, watermark, signature, calligraphy, Chinese characters, logo, modern clothing, portrait close-up, recognizable face, religious statue, temple, talisman, coins, neon, glass, 3d render, plastic, dark background, busy composition, cluttered, empty, blank, sparse, photorealistic, anime, cartoon, sketch, modern flat design, minimal

## 3. 统一参数

- model：`wanx2.1-t2i-plus`
- size：`1024*576`（16:9）
- seed：`20261111`
- n：每 id 2 张候选，PM/QA 选 1
- key：`/Users/surezhang/.dashscope/image.env`；记录 key_source/usage

## 4. Subject 模板（先验 5 张）

- 立春：fresh willow buds, thin melting ice, soft green mineral wash, pale sun
- 清明：weeping willow, misty green hills, gentle rain, indigo-and-ochre
- 端午：dragon boat bow, zongzi, mugwort; azurite green + cinnabar, not neon
- 中秋：full moon, mooncakes, osmanthus; gold + cinnabar + indigo
- 重阳：chrysanthemums, autumn hills; cinnabar + ochre + gold

## 5. 验收

1. 5 张与“宣和院体工笔 + 丰富矿物彩”风格一致；不是现代 flat/minimal；
2. 16:9、≤120KB webp、无文字/人物/宗教场所；
3. 色彩丰富但不刺眼/不荧光、不过度留白、主体清楚；
4. Sure 看 5 张通过后，才批量 43 张；不 TestFlight/不测试包。
