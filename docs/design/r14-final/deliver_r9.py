from pathlib import Path
import json,html,hashlib,io
import cairosvg
from PIL import Image
import review_r9 as r
P=r.P
rows=json.loads((P/'screens.json').read_text())
css='body{background:#fff8ec;color:#35291f;font:16px -apple-system,BlinkMacSystemFont,sans-serif;margin:0 auto;padding:32px;max-width:1320px;line-height:1.7}a{color:#a63d26}h1,h2{font-family:serif}.grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:20px}.card{background:#fffcf5;border:1px solid #e8d6ba;border-radius:24px;padding:20px}.card img{width:100%;max-height:520px;object-fit:contain;object-position:top}summary{cursor:pointer;font-weight:600}table{width:100%;border-collapse:collapse}td,th{border-bottom:1px solid #e8d6ba;text-align:left;padding:9px}small{color:#79634d}'
featured=['home-phone-light-full','home-ipad-landscape','home-duo-open-portrait','home-duo-tabletop','home-duo-closed-landscape','almanac-phone-light-plain-off-full']
body='<h1>历象 R9 · 统一首页与浮动导航</h1><p>本轮按最新意见覆盖旧布局：所有设备首页合并，五项导航，月历直接进入黄历详情。以下 PNG 是离线设计合成图，HTML 是可交互设计原型；不是浏览器或模拟器截图。</p><p><a href="R9-COVERAGE.md">逐条意见覆盖</a> · <a href="R9-DESIGN-SPEC.md">设计规格</a> · <a href="R9-COPY.md">文案</a> · <a href="R9-VALIDATION.json">检查记录</a> · <a href="ios-handoff/README.md">iOS 接入说明</a></p><div class="grid">'
for name in featured:
 row=next(v for v in rows if v['file']==name);body+=f'<article class="card"><h2>{r.PAGES[row["page"]]} · {row["mode"]}</h2><a href="{name}.png"><img loading="lazy" src="{name}.png"></a><p><a href="{name}.html">打开原型</a> · <a href="{name}.png">查看完整 PNG</a></p></article>'
body+='</div><h2>全部设备与页面</h2><p>普通 iPhone 固定竖屏；Duo open-portrait 和 tabletop 顶部状态、底部导航。其余 Duo 布局保留侧边栏，内容到侧栏仅 8pt。</p>'
for mode,w,h,dark in r.MODES:
 body+=f'<details><summary>{mode} · {w}×{h} pt</summary><table><tr><th>页面/状态</th><th>原型</th><th>PNG</th></tr>'
 for row in rows:
  if row['mode']!=mode:continue
  name=row['file'];body+=f'<tr><td>{r.PAGES[row["page"]]} {row["state"]} {"完整滚动内容" if row["full"] else ""}</td><td><a href="{name}.html">HTML</a></td><td><a href="{name}.png">PNG</a></td></tr>'
 body+='</table></details>'
body+='<h2>修正后的 Duo 参考</h2><p>采用本轮 2007×2853 News 截图；tabletop 按本轮要求采用横向内容、顶状态/底导航，未声称模拟器实测。</p><a href="references/duo_open_portrait.png">原始参考截图</a><h2>已定稿动画</h2><p><a href="fortune-phone-light.html">交互 Demo</a> · <a href="fortune-demo.mp4">原定稿 MP4</a> · <a href="ApprovedMotionManifest.json">冻结校验清单</a>。所有 14 种容器已有待机/结果态。</p>'
(P/'index.html').write_text('<!doctype html><html lang="zh-CN"><meta charset="utf-8"><title>历象 R9 设计审核</title><style>'+css+'</style>'+body+'</html>')
for color,name in [('#35291F','tab-selection')]:
 svg=(P/'assets/tab-icons/tab-selection.svg').read_text().replace('currentColor',color)
 d=P/'ios-handoff/LixiangAssets.xcassets/TabSelection.imageset';d.mkdir(exist_ok=True)
 cairosvg.svg2pdf(bytestring=svg.encode(),write_to=str(d/'tab-selection.pdf'))
 (d/'Contents.json').write_text(json.dumps({'images':[{'filename':'tab-selection.pdf','idiom':'universal'}],'info':{'author':'xcode','version':1},'properties':{'preserves-vector-representation':True,'template-rendering-intent':'template'}},indent=2))
 for scale in [1,2,3]:cairosvg.svg2png(bytestring=svg.encode(),write_to=str(P/f'assets/tab-icons/tab-selection@{scale}x.png'),output_width=28*scale,output_height=28*scale)
