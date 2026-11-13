import json,logging
from weasyprint import HTML
from render_designs import fetch
import review_r12 as u
logging.getLogger('weasyprint').setLevel(logging.ERROR)
results=[]
def walk(box):
 actual=getattr(box,'_box',box)
 yield actual
 for child in getattr(actual,'children',[]):yield from walk(child)
for mode,w,h,dark in u.r.MODES:
 src=(u.P/f'compass-{mode}.html').read_text();src=src.replace('</style>',f'@page{{size:{w}px {h}px;margin:0}}</style>',1)
 doc=HTML(string=src,base_url=str(u.P)+'/',url_fetcher=fetch).render();boxes=[]
 for b in walk(doc.pages[0]._page_box):
  e=getattr(b,'element',None)
  if e is not None and 'compass-stage' in e.get('class','').split() and b.width>0 and b.height>0:boxes.append(b)
 assert boxes,mode+' has no positive initial compass box'
 b=max(boxes,key=lambda b:b.width*b.height);assert b.width>=100 and b.height>=100
 results.append({'mode':mode,'initialCompassRect':[round(b.position_x,2),round(b.position_y,2),round(b.width,2),round(b.height,2)],'hasVisibleInitialLayout':True})
(u.P/'R12-COMPASS-INITIAL-LAYOUT.json').write_text(json.dumps({'method':'Complete standalone HTML in offline WeasyPrint layout; no JS or browser executed','results':results},ensure_ascii=False,indent=2));print('PASS full standalone compass initial layout',len(results),'modes')
