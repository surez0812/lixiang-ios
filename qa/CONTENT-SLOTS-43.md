# 历象 43 坑权威清单（Admin 预置唯一依据）

- 2026-11-14｜数量 **43** = 24 节气 + 19 节日
- **清明定案 B**：`term-qingming`（节气）+ `fest-qingming`（节日）双挂，故 24+19=43 唯一坑
- slug 稳定：`term-<id>` / `fest-<id>`；后续 43 文/43 图 manifest 必须用同一 slug

| # | slug | name | type | lunarRule | dateRule | heroPromptSubject | contentPromptSubject |
|---|---|---|---|---|---|---|---|
| 1 | `term-lichun` | 立春 | term | —（节气） | solarTerm(立春) | willow buds, thin ice, pale distant sun | 立春：柳芽、薄冰、早春水岸 |
| 2 | `term-yushui` | 雨水 | term | —（节气） | solarTerm(雨水) | spring rain, wet stone path, budding branches | 雨水：春雨、湿润石径、新芽 |
| 3 | `term-jingzhe` | 惊蛰 | term | —（节气） | solarTerm(惊蛰) | spring thunder, awakening insects, fresh grass | 惊蛰：春雷、苏醒的虫、新草 |
| 4 | `term-chunfen` | 春分 | term | —（节气） | solarTerm(春分) | spring equinox, swallows, peach blossoms | 春分：燕子、桃花、昼夜平分 |
| 5 | `term-qingming` | 清明 | term | —（节气） | solarTerm(清明) | weeping willow, misty hills, gentle rain | 清明：垂柳、青山、细雨 |
| 6 | `term-guyu` | 谷雨 | term | —（节气） | solarTerm(谷雨) | grain rain, young rice shoots, drizzle | 谷雨：秧苗、细雨、暮春 |
| 7 | `term-lixia` | 立夏 | term | —（节气） | solarTerm(立夏) | early summer lotus leaves, warm green | 立夏：荷叶、初夏绿意 |
| 8 | `term-xiaoman` | 小满 | term | —（节气） | solarTerm(小满) | wheat field, soft sunlight | 小满：麦田、柔和日光 |
| 9 | `term-mangzhong` | 芒种 | term | —（节气） | solarTerm(芒种) | rice paddies, busy green | 芒种：水田、农忙绿意 |
| 10 | `term-xiazhi` | 夏至 | term | —（节气） | solarTerm(夏至) | lotus pond, strong sun shadow | 夏至：荷塘、烈日树影 |
| 11 | `term-xiaoshu` | 小暑 | term | —（节气） | solarTerm(小暑) | cicada, shade, warm breeze | 小暑：蝉鸣、树荫、暖风 |
| 12 | `term-dashu` | 大暑 | term | —（节气） | solarTerm(大暑) | summer sun, watermelon, deep shade | 大暑：烈日、西瓜、浓荫 |
| 13 | `term-liqiu` | 立秋 | term | —（节气） | solarTerm(立秋) | falling leaves, golden light | 立秋：落叶、金色光线 |
| 14 | `term-chushu` | 处暑 | term | —（节气） | solarTerm(处暑) | cool grass, evening clouds | 处暑：凉草、晚云 |
| 15 | `term-bailu` | 白露 | term | —（节气） | solarTerm(白露) | dew on grass, morning mist | 白露：草叶露水、晨雾 |
| 16 | `term-qiufen` | 秋分 | term | —（节气） | solarTerm(秋分) | persimmons, balanced light | 秋分：柿子、均衡光线 |
| 17 | `term-hanlu` | 寒露 | term | —（节气） | solarTerm(寒露) | chrysanthemum, dew on leaves | 寒露：菊花、叶上冷露 |
| 18 | `term-shuangjiang` | 霜降 | term | —（节气） | solarTerm(霜降) | red maple, frost on ground | 霜降：红枫、地面初霜 |
| 19 | `term-lidong` | 立冬 | term | —（节气） | solarTerm(立冬) | bare branches, first frost, warm lantern | 立冬：枯枝、初霜、暖灯 |
| 20 | `term-xiaoxue` | 小雪 | term | —（节气） | solarTerm(小雪) | light snow, grey sky, warm window | 小雪：薄雪、灰天、暖窗 |
| 21 | `term-daxue` | 大雪 | term | —（节气） | solarTerm(大雪) | heavy snow, warm lamp, quiet courtyard | 大雪：厚雪、暖灯、静院 |
| 22 | `term-dongzhi` | 冬至 | term | —（节气） | solarTerm(冬至) | winter solstice, dumplings, warm lantern | 冬至：汤圆/饺子、暖灯、长夜 |
| 23 | `term-xiaohan` | 小寒 | term | —（节气） | solarTerm(小寒) | plum blossoms, snow patches | 小寒：梅花、残雪 |
| 24 | `term-dahan` | 大寒 | term | —（节气） | solarTerm(大寒) | icy river, bare tree, cold light | 大寒：冰河、枯树、清冷光 |
| 25 | `fest-chunjie` | 春节 | festival | lunar(1,1) | lunar(1,1) | red lanterns, reunion table | 春节：红灯笼、团圆饭 |
| 26 | `fest-yuanxiao` | 元宵 | festival | lunar(1,15) | lunar(1,15) | round lanterns, tangyuan | 元宵：圆灯、汤圆、灯会 |
| 27 | `fest-qingming` | 清明 | festival | solarTerm(清明) | solarTerm(清明) | willow, green hills, gentle rain | 清明：垂柳、青山、细雨 |
| 28 | `fest-duanwu` | 端午 | festival | lunar(5,5) | lunar(5,5) | dragon boat, zongzi, mugwort | 端午：龙舟、粽子、艾草 |
| 29 | `fest-qixi` | 七夕 | festival | lunar(7,7) | lunar(7,7) | magpie bridge, stars, silk ribbons | 七夕：鹊桥、星空、丝带 |
| 30 | `fest-zhongyuan` | 中元 | festival | lunar(7,15) | lunar(7,15) | river lanterns, quiet water at dusk | 中元：河灯、暮色水面 |
| 31 | `fest-zhongqiu` | 中秋 | festival | lunar(8,15) | lunar(8,15) | full moon, mooncakes, osmanthus | 中秋：满月、月饼、桂花 |
| 32 | `fest-chongyang` | 重阳 | festival | lunar(9,9) | lunar(9,9) | chrysanthemums, autumn hills | 重阳：菊花、秋山、敬老 |
| 33 | `fest-laba` | 腊八 | festival | lunar(12,8) | lunar(12,8) | laba porridge, red beans, warm kitchen | 腊八：腊八粥、红豆、暖厨房 |
| 34 | `fest-xiezao` | 谢灶 | festival | lunar(12,23)/lunar(12,24) 南北 | lunar(12,23)/lunar(12,24) 南北 | kitchen stove, candy, teapot | 谢灶：灶台、糖瓜、茶壶 |
| 35 | `fest-chuxi` | 除夕 | festival | lastDayOfLunarMonth(12) | lastDayOfLunarMonth(12) | red lanterns, reunion dinner, night | 除夕：红灯笼、年夜饭、守岁 |
| 36 | `fest-shangsi` | 上巳 | festival | lunar(3,3) | lunar(3,3) | riverside willows, spring water | 上巳：水边柳枝、春水 |
| 37 | `fest-xiayuan` | 下元 | festival | lunar(10,15) | lunar(10,15) | late autumn river, lanterns, quiet water | 下元：晚秋水岸、暖灯 |
| 38 | `fest-jizu` | 祭祖 | festival | solarTerm(清明)/lunar(7,15)/lastDayOfLunarMonth(12) | solarTerm(清明)/lunar(7,15)/lastDayOfLunarMonth(12) | family memorial table, chrysanthemums, courtyard | 祭祖：供桌、白菊、庭院 |
| 39 | `fest-yulanpen` | 盂兰盆 | festival | lunar(7,15) | lunar(7,15) | lotus pond at dusk, white lotus | 盂兰盆：荷塘白莲、暮色 |
| 40 | `fest-hanshi` | 寒食 | festival | 清明前1日 | 清明前1日 | cold spring dishes, willow branches | 寒食：冷食、柳枝、春寒 |
| 41 | `fest-longtaitou` | 龙抬头 | festival | lunar(2,2) | lunar(2,2) | early spring fields, dragon motif, haircut | 龙抬头：春耕田野、龙纹 |
| 42 | `fest-sheri` | 社日 | festival | 立春后第五个戊日（春社）/立秋后第五个戊日（秋社） | 立春后第五个戊日（春社）/立秋后第五个戊日（秋社） | village gathering, spring fields, community | 社日：村落聚会、春社田野 |
| 43 | `fest-guanlian` | 观莲 | festival | lunar(6,24) | lunar(6,24) | lotus flowers, summer pond | 观莲：荷花、夏日池塘 |

## 19 节日名单（确认）
春节/元宵/清明/端午/七夕/中元/中秋/重阳/腊八/谢灶(小年)/除夕/上巳/下元/祭祖/盂兰盆/寒食/龙抬头/社日/观莲

## 24 节气
立春/雨水/惊蛰/春分/清明/谷雨/立夏/小满/芒种/夏至/小暑/大暑/立秋/处暑/白露/秋分/寒露/霜降/立冬/小雪/大雪/冬至/小寒/大寒
