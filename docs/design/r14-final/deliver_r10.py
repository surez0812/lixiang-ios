import json,hashlib,zipfile
from pathlib import Path
from bs4 import BeautifulSoup
from PIL import Image,ImageDraw
import review_r10 as update
r=update.r;P=r.P;rows=json.loads((P/'screens.json').read_text())
featured=['home-ipad-landscape','folklore-phone-light','folklore-detail-phone-light','daily-ipad-landscape','almanac-ipad-landscape','almanac-phone-light','compass-phone-light','countdown-duo-closed-portrait']
css='body{max-width:1400px;margin:0 auto;padding:32px;background:#fff8ec;color:#35291f;font:16px/1.7 -apple-system,sans-serif}a{color:#a63d26}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(260px,1fr));gap:20px}.card{background:#fffcf5;border:1px solid #e8d6ba;border-radius:24px;padding:20px}.card img{width:100%;height:360px;object-fit:contain;object-position:top}summary{cursor:pointer;font-weight:600;padding:12px}td{padding:8px;border-bottom:1px solid #e8d6ba}table{width:100%}'
body='<h1>历象 R10 · 布局精修</h1><p>本轮：紧凑岁时筛选/详情、居中工具卡、横屏分享两列、黄历主卡整合、独立日罗盘、横屏双列独立滚动、纪念日间距。</p><p><a href="R10-COVERAGE.md">逐条覆盖</a> · <a href="R10-DESIGN-SPEC.md">规格</a> · <a href="R10-COPY.md">文案</a> · <a href="R10-overview.jpg">总览</a> · <a href="ios-handoff/R10-LayoutContract.md">iOS 接入约定</a></p><p>200 张 PNG 为离线设计合成，HTML 为交互原型；均不代表浏览器/模拟器运行验收。横屏两列可分别滚动，请在原型中审核。原始反馈继续保留。</p><div class="grid">'
for name in featured:
 row=next(v for v in rows if v['file']==name);body+=f'<article class="card"><h2>{r.PAGES[row["page"]]}</h2><p>{row["mode"]}</p><a href="{name}.png"><img loading="lazy" src="{name}.png"></a><p><a href="{name}.html">打开原型</a> · <a href="{name}.png">完整 PNG</a></p></article>'
body+='</div><h2>全部页面与设备</h2>'
for mode,w,h,dark in r.MODES:
 body+=f'<details><summary>{mode} · {w}×{h}</summary><table>'
 for row in rows:
  if row['mode']!=mode:continue
  n=row['file'];body+=f'<tr><td>{r.PAGES[row["page"]]} {row["state"]} {"完整内容" if row["full"] else ""}</td><td><a href="{n}.html">原型</a></td><td><a href="{n}.png">PNG</a></td></tr>'
 body+='</table></details>'
(P/'index.html').write_text('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>历象 R10 设计审核</title><style>'+css+'</style>'+body+'</html>')
out=Image.new('RGB',(1800,1300),'#e8dfd1');d=ImageDraw.Draw(out)
for i,n in enumerate(featured):
 a=Image.open(P/(n+'.png'));a.thumbnail((430,600));x=(i%4)*450+(450-a.width)//2;y=(i//4)*650+30;out.paste(a,(x,y));d.text(((i%4)*450+5,(i//4)*650+6),n,fill='#35291f')
out.save(P/'R10-overview.jpg')
(P/'README.md').write_text('# 历象 R10 审核包\n\n打开 index.html。当前规范：R10-DESIGN-SPEC.md；逐条覆盖：R10-COVERAGE.md；文案：R10-COPY.md。200 张 PNG 为离线设计合成，未作浏览器/模拟器运行验收。\n\n生成：review_r10.py；离线导出：render_r10.py；索引：deliver_r10.py。前轮脚本链为生成依赖。Python 环境依赖同 R9，R9 命名规范文件为历史参考；冲突以 R10 为准。已批准动画保持冻结，build12 不变。\n')
p=P/'ios-handoff/README.md';s=p.read_text();prefix='# 当前 R10 接入\n\n本轮变更以 R10-LayoutContract.md 和 ../R10-DESIGN-SPEC.md 为准，下方为 R9 留存参考。\n\n';p.write_text(s if s.startswith(prefix) else prefix+s)
manifest=[{'file':v['file']+'.png','sha256':hashlib.sha256((P/(v['file']+'.png')).read_bytes()).hexdigest()} for v in rows]
(P/'R10-SCREEN-MANIFEST.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2))
(P/'R10-TASK-PLAN.md').write_text('# R10 任务状态\n\n本轮十项修改已完成，逐条证据见 R10-COVERAGE.md。200 张 PNG/HTML、规格、文案、日罗盘页与接入约定已交付；源结构与脚本语法286项检查通过，另检查白话开关、文件链接、图片尺寸、导航及抽签按钮边界。本轮没有原生 App/浏览器运行验证。\n')
(P.parent/'CODEX-REVIEW-INDEX.md').write_text('# 历象当前审核入口 · R10\n\n- [设计审核入口](codex-review-v9/index.html)\n- [总览](codex-review-v9/R10-overview.jpg)\n- [逐条覆盖](codex-review-v9/R10-COVERAGE.md) · [规格](codex-review-v9/R10-DESIGN-SPEC.md) · [文案](codex-review-v9/R10-COPY.md)\n- [iOS 设计包](codex-review-v9/Lixiang-R10-iOS-Design-Handoff.zip)\n- [R9 历史保留](codex-review-v8/index.html)\n\nPNG 为离线设计合成；App/浏览器/模拟器运行未验证。build12 不提审。\n')
files=[p for p in P.rglob('*') if p.is_file() and not any(v in p.parts for v in ['.render-cache','__pycache__']) and p.suffix not in ['.zip','.sha256'] and p.name not in ['SHA256SUMS','.DS_Store']]
(P/'SHA256SUMS').write_text(''.join(hashlib.sha256(p.read_bytes()).hexdigest()+'  '+str(p.relative_to(P))+'\n' for p in sorted(files)))
with zipfile.ZipFile(P/'Lixiang-R10-iOS-Design-Handoff.zip','w',zipfile.ZIP_DEFLATED,compresslevel=5) as z:
 for p in files+[P/'SHA256SUMS']:z.write(p,p.relative_to(P))
p=P/'Lixiang-R10-iOS-Design-Handoff.zip';(P/(p.name+'.sha256')).write_text(hashlib.sha256(p.read_bytes()).hexdigest()+'  '+p.name+'\n')
print('Packaged',len(rows),'screens',round(p.stat().st_size/1024**2,1),'MB')
