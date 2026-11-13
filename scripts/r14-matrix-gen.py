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
lines += ['','## 汇总','- 总行数：188（screens.json 校验）。','- 结果：PASS 0 / FAIL 0 / NOT RUN 188。','- 出口：每行至少 1 张原生截图；失败保留日志/设备/commit；未实现或真机不可得写 NOT RUN。']
OUT.write_text('\n'.join(lines)+'\n'); print(f'wrote {OUT} rows={len(s)} sha={sha}')
