# 阿里云首批素材视觉抽检（修复前 37 → 复检后 39）

> **复检后口径（2026-11-14）**：candidates **39 = 产品38 + test1**（24节气+14节日）；6项复检全部 PASS；12 hero 仍 pending；不接 App。修复前 37/33 表保留为历史快照。

- 路径：`App/Resources/SeasonalArt/candidates/`
- 实际：**37 个 WebP** = 24 节气 + 12 节日 + 1 测试样张；产品素材 **36**，测试样张 `test-lichun` 排除。
- 规格：全部 1024×576（16:9）、RGB 无 alpha、**≤120KB**；最大 `term-mangzhong` 73,864B（约72.1KiB）。
- 结论：**33 PASS、3 待修、1 排除**；无人物/脸/手/宗教场所/符咒；无 App/矩阵改动。
- 12 条 hero 仍 pending-design；内容行 85-90/163/174 仍 NOT RUN。

## 待修（3）
1. `fest-laba.webp`：画面近空白（2.6KB），无法识别腊八主题；重出/补主体。
2. `fest-xiezao.webp`：左侧伪文字/不可辨汉字（红字），违反“无伪文字/水印/签名”；删除或替换。
3. `term-dashu.webp`：顶部极细伪文字/签名水印；删除后重出。

## 观察项（非红线）
- `fest-duanwu` 主体极弱、端午可读性低；`term-jingzhe`/`term-dongzhi` 大面积留白。建议设计确认，不单独判 FAIL。

## 季节/题材核对
- 24 节气：春（立春/雨水/惊蛰/春分/清明/谷雨）、夏（立夏/小满/芒种/夏至/小暑/大暑）、秋（立秋/处暑/白露/秋分/寒露/霜降）、冬（立冬/小雪/大雪/冬至/小寒/大寒）逐张与画面主体核对，季节均不冲突；大雪=雪窗/茶、冬至=罐/留白、小寒=梅，属可接受意象。
- 12 节日：春节/元宵/清明/端午/七夕/中元/中秋/重阳/腊八/谢灶/除夕/上巳；腊八/谢灶待修，其余题材可辨。
- 缺失：**下元节、祭祖** 2 张未在 candidates；PM 计划补。
- **46 vs 37**：PM 口述首批37、计划+2；仓库实际 37（含 test），根目录另有48张终稿；46 口径未在包内对上，需 PM 清单。
- **根终稿 spec 缺陷**：`App/Resources/SeasonalArt/term-daxue-light.webp` 207,196B >120KB；仍在包内则记 spec 缺陷，压图后需新 SHA，不能因旧图放过。

## 全量清单（SHA/尺寸/体积/状态）
| 文件 | 尺寸 | bytes | SHA256 | 状态 | 备注 |
|---|---:|---:|---|---|---|
| fest-chongyang.webp | 1024×576 | 43112 | `82824d83211d7427fa43101c370fd29b2e0ecefb7a9f1c73f4dbb1de0531b1e9` | PASS |  |
| fest-chunjie.webp | 1024×576 | 10048 | `75c4cfa3a8299242d3486a4daac70d7af940e478de77713c7515b250487bd3ce` | PASS |  |
| fest-chuxi.webp | 1024×576 | 7894 | `9ca24795271b920f9d536a86ae31860ac69e361ffefa10fe6a162b6d8b374651` | PASS |  |
| fest-duanwu.webp | 1024×576 | 7148 | `30a2aac1fe9499917436c072dd3c2d8f43d342837724fee4e0a163b98f170288` | PASS（观察） | 主体极弱/仅右上细线，端午主题可读性低（非红线，建议加强） |
| fest-laba.webp | 1024×576 | 2600 | `f2b841d0f7fbba60416d55e640c121b12c851725e1b014faffb6f83a2b132345` | 待修 | 画面近空白（2.6KB），无法识别腊八主题；待重出/补主体 |
| fest-qingming-festival.webp | 1024×576 | 35800 | `dab4932b4f7261bf9472917c565ac916cfef8710a1792e71a77f1bd15bf6fff6` | PASS |  |
| fest-qixi.webp | 1024×576 | 38132 | `fad463f3c2f81b89832db4eb4a69bf7ecb7d0a64c49b6d751aec11d7b2e8729f` | PASS |  |
| fest-shangsi.webp | 1024×576 | 61096 | `5cac3a405310e7c2e8d81cdfde6c257d593583b9115f38856001017f044886b9` | PASS |  |
| fest-xiezao.webp | 1024×576 | 11422 | `ebc0647a214336f008d366e33226942c2a6b7d19e5c0a807a3a9d522828a52d0` | 待修 | 画面左侧有伪文字/不可辨汉字（似“祭?…”），违反无伪文字红线；待修 |
| fest-yuanxiao.webp | 1024×576 | 17542 | `d9d527f1192a3514b9f69739d1449b04fb0c438fe0edf9d7fdcb56ddcf78cc93` | PASS |  |
| fest-zhongqiu.webp | 1024×576 | 23820 | `15ebe2a300c23b9c5d855129b765f78dc2b1dac7017f0afd846ec0b6fdd46083` | PASS |  |
| fest-zhongyuan.webp | 1024×576 | 21292 | `b78fb1be945b5ded08b43cc34be442f38adc2b1b1cdc477ba024f0142d8a8709` | PASS |  |
| term-bailu.webp | 1024×576 | 30476 | `e6b38b2bf66378fd753cd154d00ffdc9ff82f376d77ba5cb16c1841c9b518445` | PASS |  |
| term-chunfen.webp | 1024×576 | 26182 | `e7e6c94ccb77380b48e8f1b6af11f98584430f962e5b77bcddeb0d056d3e8117` | PASS |  |
| term-chushu.webp | 1024×576 | 5034 | `ea11da631de813e0d85f9d01fefc69786a77fc2598fee66ba2af565bc2ea0922` | PASS |  |
| term-dahan.webp | 1024×576 | 38338 | `3b7767ff4002274300b12f4b5649ceaa3ddd3f8bdb46bb8a3054aa6820b69b65` | PASS |  |
| term-dashu.webp | 1024×576 | 22292 | `85703ad68a443d2db217d5f5e440d5cf1e07c0267553975d15c969a34be84840` | 待修 | 顶部有极细伪文字/签名水印；违反无水印/签名红线；待修 |
| term-daxue.webp | 1024×576 | 28402 | `4457aadb0c8173884537477632c35a2b8d1fe9e6981835bcdcb078483fc991d8` | PASS |  |
| term-dongzhi.webp | 1024×576 | 18756 | `99e90d6185fa917eaf0f645755a131cb3af7d8645cbf051d084cb78e397a7556` | PASS（观察） | 大面积留白，仅坛/罐主体（风格可接受，建议设计确认） |
| term-guyu.webp | 1024×576 | 35644 | `83f2609429b2e0a0d81e03a4d3ef896805b65bd8a8f8382f77259f2281594256` | PASS |  |
| term-hanlu.webp | 1024×576 | 54212 | `c99b927fa00b8a7ae36806f3a5abe9f702ee51da46fc3a5bb28a282c0e418777` | PASS |  |
| term-jingzhe.webp | 1024×576 | 13744 | `8b3c526318ad20f5c10bff01dc39b48c6eae439ac0d48153e1d54a4f95e4e50c` | PASS（观察） | 大面积留白/主体弱（风格可接受，建议设计确认） |
| term-lichun.webp | 1024×576 | 62158 | `742eabbc1d6df19de20e07860a9095aee45c945c7fe53e8a4e4bd9b8905c4e25` | PASS |  |
| term-lidong.webp | 1024×576 | 23238 | `a6fdab04f2330168757a8830ebd431af4a0449664cbb93e55c30fbd79342c2fa` | PASS |  |
| term-liqiu.webp | 1024×576 | 34982 | `29172b5dfd745dcf9d04464cb1538488e5c939e496bd83812caee683bc1bbe4e` | PASS |  |
| term-lixia.webp | 1024×576 | 23748 | `50bbe1af3bfa3aac11057f4e769add3cb083fce6059d2db931e519136a66c3a3` | PASS |  |
| term-mangzhong.webp | 1024×576 | 73864 | `84db852a56f90899c9cbc059a78ca2133b3857466ab1fe85bc48b5b4c4a79972` | PASS |  |
| term-qingming.webp | 1024×576 | 37440 | `b19a024d8a32a13f5a370e157fc0e6d71ab9766fab8b3f1907f27e5b65e192eb` | PASS |  |
| term-qiufen.webp | 1024×576 | 11530 | `58e9eab8d71dfb3480f9da60d7a1082a0345624ed73b057843d1d31677b4e4d6` | PASS |  |
| term-shuangjiang.webp | 1024×576 | 18240 | `d5b315c5ea4d3d78488bb1aa5f046ffb1b1fe5f8067ae2fa0cf6da1f1ab89956` | PASS |  |
| term-xiaohan.webp | 1024×576 | 31716 | `4bb6dad4339b1be8768991e22fc631c487bbef86b78a99822a68e871d5821dcd` | PASS |  |
| term-xiaoman.webp | 1024×576 | 21062 | `22791aaf5dca555321128a7e006aa8c1d35ace75000af167d8349315ec116b65` | PASS |  |
| term-xiaoshu.webp | 1024×576 | 17264 | `90443e7f732281fd184cf8c18918d469eb029741ce2fef33c2d9636a6b600343` | PASS |  |
| term-xiaoxue.webp | 1024×576 | 38030 | `de71dbfdeaa62f0e2d2561860456b1d057fc44fb000348208cd0325d9ff33ab7` | PASS |  |
| term-xiazhi.webp | 1024×576 | 18688 | `bfbafa70f5cc6db5d34055a5ec74aec5ac08cacebc0d94cf8b1a376359dea00d` | PASS |  |
| term-yushui.webp | 1024×576 | 65324 | `747b1e055ed3882410a1ed637239187e3c990a564a06be3b6f03ebf7fe64516c` | PASS |  |
| test-lichun.webp | 1024×576 | 60728 | `9a2ca091c04bc08b8b53e6d95fa9079943da8db8ae7e4b9287c6cc4a3d9bd84f` | 排除 | 测试样张，不计入产品素材 |

## 边界
- 只做视觉/规格抽检；未接 App、未改矩阵、未发布。
- 素材通过不代表 12 hero/内容行 PASS；hero pending-design。

## 复检 v2（2026-11-14，已通过）
> 复检后总数：**39 candidates = 38 产品 + 1 test**（24 节气 +14 节日）；花费 ¥11.0（余 ¥39）。此前 37/33 为修复前快照。

| 项 | 新 SHA256 | bytes | 结果 |
|---|---|---:|---|
| fest-laba | `c1ae3793…` | 18,666 | PASS：腊八粥主体清晰 |
| fest-xiezao | `71c14231…` | 18,200 | PASS：无伪文字/春联，灶壶/果品 |
| term-dashu | `c213edbc…` | 70,666 | PASS：无签名/水印 |
| fest-xiayuan（新） | `b3e0bb7f…` | 23,882 | PASS：下元夜灯/山水，无宗教场所 |
| fest-jizu（新） | `3f733ceb…` | 32,624 | PASS：窗前花束，克制无人物 |
| root term-daxue-light | `1b6e2610…` | 115,952 | PASS：1500×1880，≤120KB，可解码；质量无可见明显损伤 |

- 6 项复检全部 PASS；candidates 39 = 24 节气 +14 节日 +1 test；产品 38。
- 12 hero 仍 **pending-design**；内容行 85-90/163/174 仍 **NOT RUN**；不接 App、不改矩阵。
