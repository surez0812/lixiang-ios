import json,logging
from bs4 import BeautifulSoup
from weasyprint import HTML
from render_designs import fetch
import review_r13 as u
logging.getLogger('weasyprint').setLevel(logging.ERROR)
def walk(b):
 b=getattr(b,'_box',b);yield b
 for x in getattr(b,'children',[]):yield from walk(x)
def box(doc,id):
 xs=[b for b in walk(doc.pages[0]._page_box) if getattr(b,'element',None) is not None and b.element.get('id')==id];assert xs,id;replaced=[b for b in xs if 'Replaced' in type(b).__name__];return replaced[0] if replaced else max(xs,key=lambda b:b.width*b.height)
def render(s,w,h):return HTML(string=str(s).replace('</style>',f'@page{{size:{w}px {h}px;margin:0}}</style>',1),base_url=str(u.P)+'/',url_fetcher=fetch).render()
results=[]
for mode in u.COMPACT:
 print('Checking',mode,flush=True)
 _,w,h,dark=next(m for m in u.r.MODES if m[0]==mode);s=BeautifulSoup((u.P/f'home-{mode}.html').read_text(),'html.parser');s.select_one('.home-tools')['id']='measure-tools';s.select_one('.tool-title img')['id']='measure-icon';s.select_one('.tool-title h3')['id']='measure-title';s.select_one('.compact-weather h3')['id']='measure-weather';doc=render(s,w,h);icon=box(doc,'measure-icon');title=box(doc,'measure-title');weather=box(doc,'measure-weather');tools=box(doc,'measure-tools');assert abs((icon.position_y+icon.height/2)-(title.position_y+title.height/2))<3;assert weather.height<=30;assert abs(tools.height-112)<2,(mode,tools.height);results.append({'mode':mode,'iconAndTitleSameRow':True,'weatherTitleSingleLine':True,'toolHeight':tools.height})
for mode in ['duo-closed-portrait','duo-closed-landscape']:
 _,w,h,dark=next(m for m in u.r.MODES if m[0]==mode);s=BeautifulSoup((u.P/f'folklore-detail-{mode}.html').read_text(),'html.parser');s.select_one('.native-event-head')['id']='measure-header';s.select_one('.article-frame')['id']='measure-web';doc=render(s,w,h);head=box(doc,'measure-header');web=box(doc,'measure-web');cw=u.r.profile(mode,w,h)['contentWidth'];assert abs(web.width-cw)<3,(mode,web.width,cw);outer=head.height+head.padding_top+head.padding_bottom+head.border_top_width+head.border_bottom_width;assert outer<140,(mode,outer);assert web.position_y>=head.position_y+outer-2;results.append({'mode':mode,'compactHeaderHeight':outer,'webWidth':web.width,'availableWidth':cw,'verticalLayout':True})
(u.P/'R13-TARGET-LAYOUT.json').write_text(json.dumps({'method':'Full HTML offline WeasyPrint; no browser paint','results':results},ensure_ascii=False,indent=2));print('PASS compact tool rows and vertical full-width article layouts')
