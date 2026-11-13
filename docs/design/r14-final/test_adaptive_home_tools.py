import json,logging
from bs4 import BeautifulSoup
from weasyprint import HTML
from render_designs import fetch
import review_r14 as u
logging.getLogger('weasyprint').setLevel(logging.ERROR)
def walk(b):
 b=getattr(b,'_box',b);yield b
 for c in getattr(b,'children',[]):yield from walk(c)
def box(doc,id):
 xs=[b for b in walk(doc.pages[0]._page_box) if getattr(b,'element',None) is not None and b.element.get('id')==id];assert xs,id;return max(xs,key=lambda b:b.width*b.height)
results=[]
for row in json.loads((u.P/'screens.json').read_text()):
 if row['page']!='home':continue
 src=u.r.page_html('home',row['mode'],row['width'],row['height'],row['dark'],row['state'],row['full']);(u.P/(row['file']+'.html')).write_text(src);s=BeautifulSoup(src,'html.parser');tools=s.select_one('.adaptive-tools');panels=tools.select('.adaptive-tool-panel');assert len(panels)==2
 for i,p in enumerate(panels):
  p['id']='measure-panel-'+str(i);p.select_one('.adaptive-tool-heading')['id']='measure-heading-'+str(i);p.select_one('.adaptive-tool-caption')['id']='measure-caption-'+str(i)
 # Measure this actual component at the real column width; viewport pagination is irrelevant to its intrinsic rows.
 p=u.r.profile(row['mode'],row['width'],row['height']);width=(p['contentWidth']-20)/2 if row['width']>row['height'] and p['appw']>=600 and not row['full'] else p['contentWidth']
 css=s.style.text;component=str(tools);html='<style>'+css+f'html,body{{width:{width}px!important;height:auto!important;margin:0}}@page{{size:{width}px 1200px;margin:0}}</style><body class="'+('dark ' if row['dark'] else '')+'mode-'+('duo-open-portrait' if row['mode']=='duo-tabletop' else row['mode'])+'">'+component+'</body>'
 d=HTML(string=html,base_url=str(u.P)+'/',url_fetcher=fetch).render();a,b=box(d,'measure-panel-0'),box(d,'measure-panel-1');heads=[box(d,'measure-heading-'+str(i)) for i in range(2)];caps=[box(d,'measure-caption-'+str(i)) for i in range(2)];outer=lambda x:x.height+x.padding_top+x.padding_bottom+x.border_top_width+x.border_bottom_width
 assert abs(outer(a)-outer(b))<1
 assert abs(heads[0].position_y-heads[1].position_y)<1 and abs(caps[0].position_y-caps[1].position_y)<1
 assert outer(a)<=94,(row['file'],outer(a));assert abs(outer(caps[0])-outer(caps[1]))<1
 if tools.select('[data-location]'):assert outer(caps[1])>=44
 results.append({'file':row['file'],'panelHeight':round(outer(a),2),'headingRowsAligned':True,'captionRowsAligned':True,'adaptiveHeight':True})
(u.P/'HOME-TOOLS-ALIGNMENT.json').write_text(json.dumps({'method':'actual component markup and CSS in offline WeasyPrint; no browser paint','results':results},ensure_ascii=False,indent=2));print('PASS adaptive height and row alignment',len(results),'home states')
