import json,logging
from bs4 import BeautifulSoup
from weasyprint import HTML
from render_designs import fetch
import review_r13 as u
logging.getLogger('weasyprint').setLevel(logging.ERROR)
def walk(box):
 box=getattr(box,'_box',box);yield box
 for child in getattr(box,'children',[]):yield from walk(child)
def boxes(doc,match):
 return [b for b in walk(doc.pages[0]._page_box) if getattr(b,'element',None) is not None and match(b.element)]
results=[]
for mode,w,h,dark in u.r.MODES:
 src=(u.P/f'fortune-{mode}-result.html').read_text().replace('</style>',f'@page{{size:{w}px {h}px;margin:0}}</style>',1)
 doc=HTML(string=src,base_url=str(u.P)+'/',url_fetcher=fetch).render();visual=max(boxes(doc,lambda e:'fortune-visual' in e.get('class','').split()),key=lambda b:b.width*b.height)
 advice=boxes(doc,lambda e:e.get('id')=='advice');assert advice,mode
 bottom=max(b.position_y+b.height for b in advice);assert bottom<=visual.position_y+visual.height+2,(mode,bottom,visual.position_y+visual.height)
 title=max(boxes(doc,lambda e:'persistent-fortune-title' in e.get('class','').split()),key=lambda b:b.width*b.height);g=u.fortune_geometry(mode)
 if g['side']:assert abs((title.position_y+title.height/2)-(visual.position_y+visual.height/2))<3,(mode,'vertical title alignment')
 else:assert abs((title.position_x+title.width/2)-(visual.position_x+visual.width/2))<3,(mode,'horizontal title alignment')
 results.append({'mode':mode,'titleAligned':True,'adviceBottom':round(bottom,2),'visualBottom':round(visual.position_y+visual.height,2),'fullContentWithinViewport':True})
(u.P/'R13-FULL-PAGE-LAYOUT.json').write_text(json.dumps({'method':'Complete HTML in offline WeasyPrint layout, no browser or JS paint','results':results},ensure_ascii=False,indent=2));print('PASS full fortune source layout and title alignment',len(results))
