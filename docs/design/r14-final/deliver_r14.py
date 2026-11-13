import json,hashlib,zipfile
from pathlib import Path
from bs4 import BeautifulSoup
from PIL import Image,ImageDraw
import review_r14 as update
r=update.r;P=r.P;rows=json.loads((P/'screens.json').read_text())
featured=['home-phone-light','home-duo-tabletop','home-duo-open-portrait','almanac-duo-tabletop','fortune-duo-tabletop-result','daily-duo-tabletop','compass-duo-tabletop-hour','folklore-detail-duo-tabletop']
css='body{max-width:1400px;margin:0 auto;padding:32px;background:#fff8ec;color:#35291f;font:16px/1.7 -apple-system,sans-serif}a{color:#a63d26}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:20px}.card{background:#fffcf5;border:1px solid #e8d6ba;border-radius:24px;padding:20px}.card img{width:100%;height:360px;object-fit:contain;object-position:top}summary{cursor:pointer;font-weight:600;padding:12px}td{padding:8px;border-bottom:1px solid #e8d6ba}table{width:100%}'
body='<h1>历象 R14 · 布局精修</h1><p>本轮补充：首页双卡高度自适应、内容水平对齐。<a href="HOME-TOOLS-UPDATE.md">调整说明</a>。普通iPhone仅portrait；Duo Tabletop与Open Portrait统一669×951竖屏布局，各页共用同一布局。</p><p><a href="R14-COVERAGE.md">逐条覆盖</a> · <a href="R14-DESIGN-SPEC.md">规格</a> · <a href="R14-COPY.md">文案</a> · <a href="R14-overview.jpg">总览</a> · <a href="ios-handoff/R14-LayoutContract.md">iOS 接入约定</a></p><p>188 张 PNG 为离线设计合成，HTML 为交互原型；均不代表浏览器/模拟器运行验收。横屏两列可分别滚动，请在原型中审核。原始反馈继续保留。</p><div class="grid">'
for name in featured:
 row=next(v for v in rows if v['file']==name);body+=f'<article class="card"><h2>{r.PAGES[row["page"]]}</h2><p>{row["mode"]}</p><a href="{name}.png"><img loading="lazy" src="{name}.png"></a><p><a href="{name}.html">打开原型</a> · <a href="{name}.png">完整 PNG</a></p></article>'
body+='</div><h2 id="fortune-all">每日一签 · 全设备待机/结果</h2><table>'
for mode,w,h,dark in r.MODES:
 n='fortune-'+mode;body+=f'<tr><td>{mode}</td><td><a href="{n}.html">待机原型</a> · <a href="{n}.png">PNG</a></td><td><a href="{n}-result.html">结果原型</a> · <a href="{n}-result.png">PNG</a></td></tr>'
body+='</table><h2 id="compass-all">罗盘 · 全设备日/时设计（沿用）</h2><table>'
for mode,w,h,dark in r.MODES:
 n='compass-'+mode;body+=f'<tr><td>{mode}</td><td><a href="{n}.html">日方位原型</a> · <a href="{n}.png">PNG</a></td><td><a href="{n}-hour.html">时方位原型</a> · <a href="{n}-hour.png">PNG</a></td></tr>'
body+='</table><h2>全部页面与设备</h2>'
for mode,w,h,dark in r.MODES:
 body+=f'<details><summary>{mode} · {w}×{h}</summary><table>'
 for row in rows:
  if row['mode']!=mode:continue
  n=row['file'];body+=f'<tr><td>{r.PAGES[row["page"]]} {row["state"]} {"完整内容" if row["full"] else ""}</td><td><a href="{n}.html">原型</a></td><td><a href="{n}.png">PNG</a></td></tr>'
 body+='</table></details>'
(P/'index.html').write_text('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>历象 R14 设计审核</title><style>'+css+'</style>'+body+'</html>')
out=Image.new('RGB',(1800,1300),'#e8dfd1');d=ImageDraw.Draw(out)
for i,n in enumerate(featured):
 a=Image.open(P/(n+'.png'));a.thumbnail((430,600));x=(i%4)*450+(450-a.width)//2;y=(i//4)*650+30;out.paste(a,(x,y));d.text(((i%4)*450+5,(i//4)*650+6),n,fill='#35291f')
out.save(P/'R14-overview.jpg')
(P/'README.md').write_text('# 历象 R14 审核包\n\n打开index.html。首页双卡已追加自适应高度与横向内容对齐，见HOME-TOOLS-UPDATE.md。当前R14设备范围：普通iPhone仅竖屏；Tabletop共享Open Portrait的669×951竖屏。12种模式、188张PNG/HTML。\n\nHTML由review_r14.py生成；PNG沿用未变的R13设计，Tabletop直接复用对应Open Portrait图，关系见R14-RENDER-PROVENANCE.json。模式/HTML同构/PNG一致性见R14-MODE-VALIDATION.json；日期与标题DOM回归另附R14记录。\n\n当前规范与文案为R14-DESIGN-SPEC.md、R14-COVERAGE.md、R14-COPY.md。其他R13及更早文档/脚本是历史或生成依赖，不能将其中普通iPhone横屏内容视作当前设计。原R13目录保留历史。PNG为离线设计合成，非浏览器/模拟器截图；动画核心与build12未改。\n')
p=P/'ios-handoff/README.md';s=p.read_text();prefix='# 当前 R14 接入\n\n本轮变更以 R14-LayoutContract.md 和 ../R14-DESIGN-SPEC.md 为准，下方为 R9 留存参考。\n\n';p.write_text(s if s.startswith(prefix) else prefix+s)
manifest=[{'file':v['file']+'.png','sha256':hashlib.sha256((P/(v['file']+'.png')).read_bytes()).hexdigest()} for v in rows]
(P/'R14-SCREEN-MANIFEST.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2))
(P/'R14-TASK-PLAN.md').write_text('# R14 任务状态\n\n本轮设备范围与布局映射修正完成，逐条证据见 R14-COVERAGE.md。188 张 PNG/HTML、规格、文案、独立共享竖屏布局与接入约定已交付；源结构与脚本语法检查通过，另检查白话开关、文件链接、图片尺寸、导航及抽签按钮边界。本轮没有原生 App/浏览器运行验证。\n')
(P.parent/'CODEX-REVIEW-INDEX.md').write_text('# 历象当前审核入口 · R14\n\n- [设计审核入口](codex-review-v13/index.html)\n- [总览](codex-review-v13/R14-overview.jpg)\n- [逐条覆盖](codex-review-v13/R14-COVERAGE.md) · [规格](codex-review-v13/R14-DESIGN-SPEC.md) · [文案](codex-review-v13/R14-COPY.md)\n- [iOS 设计包](codex-review-v13/Lixiang-R14-iOS-Design-Handoff.zip)\n- [R13 历史保留](codex-review-v12/index.html)\n\nPNG 为离线设计合成；App/浏览器/模拟器运行未验证。build12 不提审。\n')
files=[p for p in P.rglob('*') if p.is_file() and not any(v in p.parts for v in ['.render-cache','__pycache__']) and p.suffix not in ['.zip','.sha256'] and p.name not in ['SHA256SUMS','.DS_Store']]
(P/'SHA256SUMS').write_text(''.join(hashlib.sha256(p.read_bytes()).hexdigest()+'  '+str(p.relative_to(P))+'\n' for p in sorted(files)))
with zipfile.ZipFile(P/'Lixiang-R14-iOS-Design-Handoff.zip','w',zipfile.ZIP_DEFLATED,compresslevel=5) as z:
 for p in files+[P/'SHA256SUMS']:z.write(p,p.relative_to(P))
p=P/'Lixiang-R14-iOS-Design-Handoff.zip';(P/(p.name+'.sha256')).write_text(hashlib.sha256(p.read_bytes()).hexdigest()+'  '+p.name+'\n')
print('Packaged',len(rows),'screens',round(p.stat().st_size/1024**2,1),'MB')
