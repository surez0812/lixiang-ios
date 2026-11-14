#!/usr/bin/env python3
"""Generate R14-QA-MATRIX.md from the authoritative screens.json (188 rows)."""
import json, hashlib, pathlib
ROOT=pathlib.Path(__file__).resolve().parents[1]
SCREENS=ROOT.parent/'lixiang-design-handoff-20261113/docs/design/r14-final/screens.json'
OUT=ROOT/'docs/R14-QA-MATRIX.md'
s=json.loads(SCREENS.read_text()); assert len(s)==188, len(s)
sha=hashlib.sha256(SCREENS.read_bytes()).hexdigest()
pn={'home':'首页/日历','almanac':'黄历','compass':'罗盘','daily':'每日一句','fortune':'每日一签','folklore':'岁时列表','folklore-detail':'岁时详情','selection':'择日','countdown':'倒计日','countdown-detail':'倒计日详情','settings':'设置'}
entry={'home':'日历根 Tab；经文/签/岁时/摘要/月历入口','almanac':'首页/月历/择日/前后日/罗盘返回','compass':'黄历右上「值神罗盘」','daily':'首页每日一句','fortune':'首页一签工具卡','folklore':'岁时根 Tab；列表活动','folklore-detail':'岁时列表/首页/黄历，带 eventID+版本','selection':'择日根 Tab','countdown':'倒计日根 Tab；新增/已有条目','countdown-detail':'倒计日列表/首页，带条目 ID','settings':'设置根 Tab；子流程返回'}
exp={'home':'Hero 日期/节气/农历/宜忌摘要；双卡等高；月历；真实数据；点击路由正确','almanac':'日期/农历/干支/宜忌/值神/冲煞/星宿/时辰/岁时；改日整组重算；白话开关；无独立大日期','compass':'日期/日时切换/十二时辰/五吉神/煞方；进入不空白；日期一致','daily':'完整经文/出处/含义/应用；四传统偏好；长文可读；分享卡','fortune':'待机→动画→结果；签号/题/四句/签意/建议全显；标题常驻；同日同签','folklore':'列表类别/日期/剩余/解锁/未读；未解锁不泄正文','folklore-detail':'紧凑头+WKWebView 正文；eventID+版本；加载/离线/失败；成功才已读','selection':'事项/起止/周末/纪念冲突；空态/倒序提示；结果进黄历','countdown':'多条列表；Tab 最近天数（0 显示字符串）；新增/编辑/删除；通知','countdown-detail':'详情/编辑/删除；权限分支；通知更新；无效 ID 恢复','settings':'外观/历法/经典偏好/术语/提醒/许可/版本；重启持久化'}
mods={'':'默认','full':'长图/全文可达、无裁断','plain-off':'白话关：紧凑值仍保留全部字段','result':'结果态全显，无内部滚动','hour':'时态；十二时辰/方向同步','today':'今日解锁/已读边界','offline':'离线/加载失败可重试','new':'新建入口/校验','preprompt':'请求前说明，不擅自弹权限','system-prompt':'系统权限弹窗','allowed':'允许后安排提醒','denied':'拒绝不阻断；设置返回重读','previous':'前一日整组重算','next':'后一日整组重算','winter':'节气/冬季边界','no-festival':'无岁时/节日时隐藏入口','weather-authorized':'定位允许/天气就绪','weather-denied':'定位拒绝，核心不阻断','weather-loading':'定位中/加载','no-matches':'无匹配岁时/纪念，无空占位'}
import json as _json, os as _os
OVERRIDES=_json.loads((ROOT/'qa/status-overrides.json').read_text()) if (ROOT/'qa/status-overrides.json').exists() else {}
lines=['# 历象 R14 · 188 状态 QA 矩阵','',f'- 生成器：`scripts/r14-matrix-gen.py`；权威源：`screens.json` SHA256 `{sha}`；设计条目 188 条；**设计稿 ≠ 实现/验收通过**。','- 每行先按对应设计 PNG 自查，再在模拟器/真机跑同状态；结果只允许 PASS/FAIL/NOT RUN；证据列写截图/日志/设备。','- 当前阶段：**全部 NOT RUN**（开发自测未交；未测未就绪页面，不用设计图代替原生结果）。','- 12 画布：phone light/dark 375×930；iPad 834×1194、1194×834 ×亮暗；Duo 六姿态；Tabletop=OpenPortrait 669×951。','- page 分组不合并：home/almanac/compass/daily/fortune/folklore/folklore-detail/selection/countdown/countdown-detail/settings。','','| # | 页面 | 模式/画布 | 尺寸 | 状态 | 入口 | 期望 | PASS | FAIL | NOT RUN | 证据 |','|---:|---|---|---|---|---|---|---|---|---|---|']
for i,x in enumerate(s,1):
 p=x['page']; st=x.get('state') or ''; label=mods.get(st,st or '默认'); canvas=f"{x['mode']}·{'深色' if x.get('dark') else '浅色'}"; dim=f"{x['width']}×{x['height']}"; ev=f"`r14-final/{x['file']}.png`"
 ov=OVERRIDES.get(str(i),{}); status=ov.get('status','NOT RUN'); evidence=ov.get('evidence','待证；'+ev)
 marks={k:('**'+k+'**' if k==status else '—') for k in ['PASS','FAIL','NOT RUN']}
 lines.append(f"| {i} | {p} {pn.get(p,'')} | {canvas} | {dim} | {label} | {entry.get(p,'')} | {exp.get(p,'')} | {marks['PASS']} | {marks['FAIL']} | {marks['NOT RUN']} | {evidence} |")
# 补充：动态字体不属于设计 188 行，单列避免计数污染
lines += ['','## 补充 · 动态字体 xLarge（不计入 188）','','| ID | 页面 | 启动 | 结果 | 证据 |','|---|---|---|---|---|',
 '| X-01 | Home | `-LixiangTypeScale xl` | **PASS** | `qa/evidence/dynamic-v2/xl-home.png` |',
 '| X-02 | Almanac | `-LixiangTypeScale xl` | **PASS** | `qa/evidence/dynamic-v2/xl-almanac.png` |',
 '| X-03 | Compass | `-LixiangTypeScale xl` | **PASS** | `qa/evidence/dynamic-v2/xl-compass.png` |',
 '| X-04 | Daily | `-LixiangTypeScale xl` | **PASS** | `qa/evidence/dynamic-v2/xl-daily.png` |',
 '| X-05 | Folklore detail | `-LixiangTypeScale xl` | **PASS** | `qa/evidence/dynamic-v2/xl-folklore-detail.png` |',
 '','- 说明：只验字体放大布局；VoiceOver/a1/旋转组合 NOT RUN；详见 `qa/DYNAMIC-TYPE.md`。','- 字体未找到 Songti/Kaiti，回退系统 serif；设计字体差异记为已知偏差，不标 PASS。']
# 补充：天气六态（不计入 188；initial 用 v2 home）
lines += ['','## 补充 · Home 天气六态','','| ID | 状态 | 结果 | 证据 |','|---|---|---|---|',
 '| W-01 | initial | **PASS** | `qa/evidence/firstbatch-v2/iPhone16Pro-tab0.png` |',
 '| W-02 | locating | **PASS** | `qa/evidence/weather-fortune/r14-home-weather-locating.png` |',
 '| W-03 | denied | **PASS** | `qa/evidence/weather-fortune/r14-home-weather-denied.png` |',
 '| W-04 | failed | **PASS** | `qa/evidence/weather-fortune/r14-home-weather-failed.png` |',
 '| W-05 | loaded | **PASS** | `qa/evidence/weather-fortune/r14-home-weather-loaded.png` |',
 '| W-06 | denied→系统设置返回 | **NOT RUN** | 需系统设置返回重读权限；未测 |']
# 补充：Fortune 1450ms 关键帧
lines += ['','## 补充 · Fortune 1450ms 关键帧','','| ID | 时间 | 结果 | 证据/判断 |','|---|---|---|---|',
 '| F-01 | 0ms | **PASS** | `qa/evidence/weather-fortune/r14-fortune-frame0.png`；待机/标题常驻 |',
 '| F-02 | 180ms | **NOTE** | 数学零交叉；与 0ms 同 SHA `aaf6270f…`，非缺陷 |',
 '| F-03 | 600ms | **NOTE** | 数学零交叉；与 0ms 同 SHA `aaf6270f…`，非缺陷 |',
 '| F-04 | 1050ms | **PASS** | `r14-fortune-frame1050.png`；签筒升起动作 |',
 '| F-05 | 1450ms | **PASS** | `r14-fortune-frame1450.png`；结果全显、标题常驻 |','',
 '- 说明：180/600 为 ApprovedFortuneCore 零交叉边界，与 0ms 同图属正确数学；不标 FAIL。','', '### 运动关键帧（补充）','', '| ID | 时间 | 结果 | 证据 |','|---|---|---|---|','| M-01 | 300ms | **PASS** | `qa/evidence/weather-fortune/r14-fortune-frame300.png` |','| M-02 | 450ms | **PASS** | `qa/evidence/weather-fortune/r14-fortune-frame450.png` |','| M-03 | 800ms | **PASS** | `qa/evidence/weather-fortune/r14-fortune-frame800.png` |','| M-04 | 900ms | **PASS** | `qa/evidence/weather-fortune/r14-fortune-frame900.png` |']
# 补充：交互状态（不属于 188 设计行）
lines += ['','## 补充 · 交互状态','','| ID | 状态 | 结果 | 证据 |','|---|---|---|---|',
 '| S-01 | Selection 结果列表 light | **PASS** | `qa/evidence/portrait-states/r14-iphone-selection-results.png`；2026 年份无千分位、含日期/宜/忌/看当日 |','| S-02 | Selection 结果列表 dark | **PASS** | `qa/evidence/portrait-states/r14-iphone-selection-results-dark.png`；深底可读、日期/宜/忌/看当日 |','| D-01 | Daily 分享页 | **PASS** | `qa/evidence/portrait-states/r14-iphone-daily-share.png`；全屏分享卡（经文/标题/白话/出处/二维码）+系统分享，不再空白 |','',
 '- Countdown 详情已对应设计行 97；Selection 结果无独立设计行，单列 S-01。','- Folklore 详情正文暂为「内容准备中」，不标读；正式 12 条内容接入前按内容缺口处理，不作 PASS。']
# 补充：Compass 12 时辰
lines += ['','## 补充 · Compass 12 时辰','','| ID | 时辰 | 结果 | 证据 |','|---|---|---|---|',
 '| C-00 | 00 | **PASS** | `qa/evidence/compass-hours/r14-compass-hour0.png`；子时 |',
 '| C-01 | 01 | **PASS** | `qa/evidence/compass-hours/r14-compass-hour1.png`（dev 图，01:00） |',
 '| C-03 | 03 | **PASS** | `qa/evidence/compass-hours/r14-compass-hour3.png` |',
 '| C-05 | 05 | **PASS** | `qa/evidence/compass-hours/r14-compass-hour5.png`；卯时·辛卯 05:00—06:59，煞西 |',
 '| C-06 | 06 | **PASS** | `r14-compass-hour6.png`；卯时边界（旧截） |',
 '| C-07 | 07 | **PASS** | `r14-compass-hour7.png`；辰时·壬辰 07:00—08:59，煞南 |',
 '| C-09 | 09 | **PASS** | `r14-compass-hour9.png` |',
 '| C-11 | 11 | **PASS** | `r14-compass-hour11.png`；午时·甲午 11:00—12:59，煞北 |',
 '| C-13 | 13 | **PASS** | `r14-compass-hour13.png` |',
 '| C-15 | 15 | **PASS** | `r14-compass-hour15.png` |',
 '| C-17 | 17 | **PASS** | `r14-compass-hour17.png`；酉时·丁酉 17:00—18:59，煞东 |',
 '| C-18 | 18 | **PASS** | `r14-compass-hour18.png`；酉时边界（旧截） |',
 '| C-19 | 19 | **PASS** | `r14-compass-hour19.png`；戌时·戊戌 19:00—20:59，煞北 |',
 '| C-21 | 21 | **PASS** | `r14-compass-hour21.png` |',
 '| C-23 | 23 | **PASS** | `r14-compass-hour23.png`；子时·庚子 23:00—23:59，煞南 |']
# 12 时辰覆盖不全，不宣称全量 PASS
# 补充：Home 完整态可见内容
lines += ['','## 补充 · Home 完整/多内容态','','| ID | 状态 | 结果 | 证据 |','|---|---|---|---|',
 '| H-01 | Home 完整 light | **PASS** | `qa/evidence/home-full/r14-home-full-light.png`；冬至一候/日期/纪念/经文/双卡/黄历/倒计日1 可见 |',
 '| H-02 | Home 完整 dark | **PASS** | `qa/evidence/home-full/r14-home-full-dark.png`；同内容深色可读 |','',
 '- 注：两张为 375×930 首屏证据，不是设计 375×2500 长图；screens.json 行 170 的长图全量仍 **NOT RUN**。']
# 补充：Duo folklore-detail T-10/T-9 内容缺口
lines += ['','## 补充 · Duo folklore-detail T-10/T-9','','| ID | 状态 | 结果 | 证据 |','|---|---|---|---|',
 '| T-10 | 还有10天 | **NOTE/内容缺口** | `qa/evidence/duo-closed-routes/r14-folklore-detail-t10.png`；显示「内容准备中」，正文不可读 |',
 '| T-09 | 还有9天 | **NOTE/内容缺口** | `qa/evidence/duo-closed-routes/r14-folklore-detail-t9.png`；显示「内容准备中」 |','',
 '- 示例稿 version=0 被内容门禁拦截，T-10 正文可读性无法验证；不标 PASS。']
# 补充：Duo Codex 中期
lines += ['','## 补充 · Duo Codex 中期','',
 '- Codex 中期 **36 用例未通过**，不标 PASS；最终证据到后统一复评。',
 '- Tabletop/Tent 无 Device Hub 控件 → NOT RUN。',
 '- Closed Landscape / Open Landscape 有白屏/rail 缺失，dev 修复中。',
 '- 最终映射：36 case observations FAIL；唯一 matrix 行 33 FAIL（selection tab/route 重复）；Tabletop/Tent 24 NOT RUN；closed-portrait 13 既有 PASS 保留；额外状态 NOT RUN。实际 100 PASS/33 FAIL/55 NOT RUN，未硬凑 36/35。',
 '- 归档 690a26b6…；修复后 2314dd8e… 尚未重跑 Duo；未操作 R14-Duo `B77A…`。']
lines += ['','## 汇总','- 总行数：188（screens.json 校验）。','- 结果：PASS 100 / FAIL 33 / NOT RUN 55；另 X-01..X-05 动态字体 PASS、F 3 PASS/2 NOTE、M-01..M-04 PASS、W 5 PASS/1 NOT RUN、S-01 PASS、S-02 PASS、D-01 PASS；C-00..C-23 采样 15 个时点覆盖 12 时辰，全部 PASS；五神固定按设计结构待确认；H-01/H-02 首屏完整态 PASS；T-10/T-9 NOTE。','- 出口：每行至少 1 张原生截图；失败保留日志/设备/commit；未实现或真机不可得写 NOT RUN。']
OUT.write_text('\n'.join(lines)+'\n'); print(f'wrote {OUT} rows={len(s)} sha={sha}')
