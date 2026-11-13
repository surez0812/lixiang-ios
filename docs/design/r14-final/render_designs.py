from pathlib import Path
import json,io,re,logging,sys,hashlib
from PIL import Image,ImageDraw,ImageFont
from weasyprint import HTML,default_url_fetcher
import fitz,cairosvg
import review_r7 as r
b=r.b;P=r.P
logging.getLogger('weasyprint').setLevel(logging.ERROR)
SANS='/System/Library/Fonts/STHeiti Light.ttc';SERIF='/System/Library/Fonts/Supplemental/Songti.ttc'
def font(n,serif=False,scale=2):return ImageFont.truetype(SERIF if serif else SANS,round(n*scale),index=6 if serif else 0)
def text(im,x,y,s,size=14,color='#35291F',serif=False,anchor='lt',scale=2):ImageDraw.Draw(im).text((round(x*scale),round(y*scale)),s,font=font(size,serif,scale),fill=color,anchor=anchor)
def fetch(url,*args,**kwargs):
 if not url.startswith(('file:','data:')):raise ValueError('External fetch disabled')
 return default_url_fetcher(url,*args,**kwargs)
def fragment(markup,w,dark=False):
 key=hashlib.sha256((b.CSS+markup+str(w)+str(dark)).encode()).hexdigest();cache=P/'.render-cache';cache.mkdir(exist_ok=True);f=cache/(key+'.png')
 if f.exists():return Image.open(f).convert('RGB')
 css=b.CSS+'''@font-face{font-family:ReviewSans;src:url(file:///System/Library/Fonts/STHeiti%20Light.ttc)}@font-face{font-family:ReviewSerif;src:url(file:///System/Library/Fonts/Supplemental/Songti.ttc)}*{font-family:ReviewSans,sans-serif}h1,h2,.serif,.quote p{font-family:ReviewSerif,serif}html,body{width:auto!important;height:auto!important;margin:0;padding:0}.fragment{padding:0;display:flow-root}.card{break-inside:auto!important}.hero-art{display:block}.feature .decor{display:none}.glass{display:flex;width:42px;height:42px;justify-content:center;align-items:center}.month-grid .cell{display:block;position:relative}.hours-list{max-height:none;overflow:visible}.compass-stage{height:320px;aspect-ratio:auto}.shortcut{display:flex;gap:12px}.shortcut>*{display:block;width:calc(50% - 6px);min-width:0}.shortcut img{width:30px!important;height:30px!important;object-fit:contain}.ipad-banner{display:flex;height:245px}.ipad-banner .hero-art{width:45%;height:245px;flex:none}.ipad-banner .hero-copy{width:55%;margin:0;padding:22px;align-self:center}.yi-ji b{font-family:ReviewSans,sans-serif}.feature{min-height:190px}.share-actions{display:flex}.share-actions>*{width:50%}.poster-art{height:260px}.card:last-child{margin-bottom:0}.row>*{min-width:0}.hour-row{break-inside:avoid}.fragment>.row{padding-bottom:12px}'''
 css+=f':root{{--w:{w}px;--h:20000px}}@page{{size:{w}px 20000px;margin:0}}'
 src='<html><meta charset="utf-8"><style>'+css+'</style><body class="'+('dark' if dark else '')+'"><div id="fragment" class="fragment">'+markup+'</div></body></html>'
 doc=HTML(string=src,base_url=str(P)+'/',url_fetcher=fetch).render();boxes=[x for x in doc.pages[0]._page_box.descendants() if getattr(x,'element',None) is not None and x.element.get('id')=='fragment'];height=max(x.position_y+x.height+x.padding_bottom+x.margin_bottom for x in boxes)+2
 pdf=fitz.open(stream=doc.write_pdf(),filetype='pdf');pix=pdf[0].get_pixmap(matrix=fitz.Matrix(2*96/72,2*96/72),clip=fitz.Rect(0,0,w*.75,height*.75),alpha=False);im=Image.open(io.BytesIO(pix.tobytes('png'))).convert('RGB');im.save(f);return im

def icon(name,color,size=24,scale=2):
 s=(P/('assets/tab-icons/tab-'+name+'.svg')).read_text().replace('currentColor',color)
 return Image.open(io.BytesIO(cairosvg.svg2png(bytestring=s.encode(),output_width=round(size*scale),output_height=round(size*scale)))).convert('RGBA')

def shell(row):
 w,h,dark=row['width'],row['height'],row['dark'];duo=row['mode'].startswith('duo-');scale=3 if duo else 2
 bg='#211D19' if dark else '#FFF8EC';paper='#30281F' if dark else '#FFFCF5';ink='#F8ECD8' if dark else '#35291F';muted='#C9B69C' if dark else '#79634D';red='#FFAC88' if dark else '#A63D26';line='#69523B' if dark else '#E8D6BA'
 im=Image.new('RGB',(w*2,h*2),bg);d=ImageDraw.Draw(im)
 if not duo:
  text(im,22,12,'9:41',12,ink);text(im,w-22,12,'●●●  ▰',11,ink,anchor='rt')
  d.ellipse((40,88,124,172),fill=paper,outline=line,width=2);text(im,41,64,'‹',25,ink,anchor='mm')
  text(im,w/2,65,'历象' if row['page'] in ['home','day'] else b.PAGES[row['page']],20,ink,True,anchor='mm')
  x,y,cw,ch=20,104,w-40,h-196
 else:x,y,cw,ch=16,22,w-116,h-44
 active=row['page'] if row['page'] in ['folklore','countdown','settings'] else 'home'
 return im,(x,y,cw,ch),dict(bg=bg,paper=paper,ink=ink,muted=muted,red=red,line=line,duo=duo,active=active,scale=scale)

def put(im,markup,x,y,w,maxh=None,dark=False):
 art=fragment(markup,w,dark);hh=art.height/2
 if maxh is not None:art=art.crop((0,0,art.width,min(art.height,round(maxh*2))))
 im.paste(art,(round(x*2),round(y*2)))
 return hh

def render(row):
 im,(x,y,cw,ch),c=shell(row);p,m,dark=row['page'],row['mode'],row['dark'];full=row.get('full',False);wide='landscape' in m or m=='duo-tent';ipad=m.startswith('ipad-');gap=16
 blocks=[]
 def place(markup,xx,yy,ww,maxh=None):
  hh=put(im,markup,xx,yy,ww,maxh,dark);blocks.append([xx,yy,ww,hh]);return hh
 lead,detail=r.content(p,m)
 if full:
  yy=y
  for markup in [lead,detail]:yy+=place(markup,x,yy,cw)+15
  im=im.crop((0,0,im.width,min(im.height,round((yy+108)*2))));row=dict(row,height=im.height//2)
 elif ipad and p in ['home','day']:
  if wide:
   # Hero, day summary, and month occupy the full iPad canvas.
   a=round(cw*.34);z=round(cw*.29);mid=cw-a-z-gap*2
   place(r.hero(m)+b.shortcuts(m),x,y,a,ch)
   ty=y+place(r.teaser(m),x+a+gap,y,mid,ch)+16
   from bs4 import BeautifulSoup
   cards=BeautifulSoup(b.seasons(m),'html.parser').find_all('a',recursive=False)
   hw=(mid-gap)/2
   for j,card in enumerate(cards):place(str(card),x+a+gap+j*(hw+gap),ty,hw,ch-(ty-y))
   place(r.month(m),x+a+mid+gap*2,y,z,ch)
  else:
   # One broad visual banner, then balanced detail and calendar columns.
   banner=r.hero(m).replace('class="card hero"','class="card hero ipad-banner"')
   hh=place(banner,x,y,cw,330);ny=y+min(hh,330)+18;ww=(cw-gap)/2
   place(r.teaser(m)+b.seasons(m)+b.shortcuts(m),x,ny,ww,ch-(ny-y));place(r.month(m),x+ww+gap,ny,ww,ch-(ny-y))
 elif m=='duo-tabletop':
  half=h=row['height']/2;place(lead,x,y,cw,half-y-18);place(detail,x,half+22,cw,half-44)
 elif wide or (p in ['daily','almanac'] and cw>600):
  ww=(cw-gap)/2;place(lead,x,y,ww,ch);place(detail,x+ww+gap,y,ww,ch)
 else:
  hh=place(lead,x,y,cw,ch)
  if hh+15<ch:place(detail,x,y+hh+15,cw,ch-hh-15)
 # Navigation overlays are drawn after scrolling content.
 draw=ImageDraw.Draw(im)
 names=[('home','calendar','日历'),('folklore','suishi','岁时'),('countdown','countdown','倒计日'),('settings','settings','设置')]
 if c['duo']:
  railx=row['width']-84;draw.rectangle((railx*2,0,row['width']*2,row['height']*2),fill=c['paper']);draw.line((railx*2,0,railx*2,row['height']*2),fill=c['line'],width=2)
  text(im,railx+42,72,'9:41',11,c['muted'],anchor='mm');draw.ellipse(((railx+33)*2,94*2,(railx+51)*2,112*2),outline='#6B8C61',width=3);text(im,railx+42,151,'‹',26,c['ink'],anchor='mm')
  for i,(page,asset,label) in enumerate(names):
   yy=row['height']-280+i*65;selected=page==c['active'];color=c['red'] if selected else c['muted']
   if selected:draw.rounded_rectangle(((railx+10)*2,(yy-7)*2,(railx+74)*2,(yy+49)*2),radius=28,fill='#403326' if dark else '#F5E6CF')
   ico=icon(asset,color);im.paste(ico,((railx+30)*2,round(yy*2)),ico);text(im,railx+42,yy+34,label,10,color,anchor='mm')
 else:
  tw=min(cw,560);tx=(row['width']-tw)/2;ty=row['height']-82
  draw.rounded_rectangle((tx*2,ty*2,(tx+tw)*2,(ty+68)*2),radius=54,fill=c['paper'],outline=c['line'],width=2)
  for i,(page,asset,label) in enumerate(names):
   cx=tx+tw*(i+.5)/4;selected=page==c['active'];color=c['red'] if selected else c['muted']
   if selected:draw.rounded_rectangle(((cx-tw/8+5)*2,(ty+5)*2,(cx+tw/8-5)*2,(ty+63)*2),radius=40,fill='#403326' if dark else '#F5E6CF')
   ico=icon(asset,color);im.paste(ico,(round((cx-12)*2),round((ty+10)*2)),ico);text(im,cx,ty+49,label,11,color,anchor='mm')
 # All Duo exports use exact @3x source canvas sizes.
 if c['scale']==3:im=im.resize((row['width']*3,row['height']*3),Image.Resampling.LANCZOS)
 im.save(P/(row['file']+'.png'))
 return dict(file=row['file']+'.png',method='offline HTML fragment typesetting + deterministic image/vector composition',browserScreenshot=False,scale=c['scale'],logicalSize=[row['width'],row['height']],pixelSize=list(im.size),contentBlocks=blocks)

if __name__=='__main__':
 rows=json.loads((P/'screens.json').read_text());names=sys.argv[1:]
 if names:rows=[x for x in rows if x['file'] in names]
 out=[]
 for row in rows:
  out.append(render(row));print(row['file'],flush=True)
 prior=json.loads((P/'DESIGN-RENDER-PROVENANCE.json').read_text()) if (P/'DESIGN-RENDER-PROVENANCE.json').exists() else []
 merged={x['file']:x for x in prior}
 merged.update({x['file']:x for x in out})
 (P/'DESIGN-RENDER-PROVENANCE.json').write_text(json.dumps(list(merged.values()),ensure_ascii=False,indent=2))
