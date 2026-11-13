import json,sys
from PIL import Image,ImageDraw
import review_r9 as r
import render_r8 as prior
from render_designs import fragment,icon,text
P=r.P
prior.r=r

def shell(row):
 w,h,dark=row['width'],row['height'],row['dark'];p=r.profile(row['mode'],w,h)
 c=dict(bg='#211D19' if dark else '#FFF8EC',paper='#30281F' if dark else '#FFFCF5',ink='#F8ECD8' if dark else '#35291F',muted='#C9B69C' if dark else '#79634D',red='#FFAC88' if dark else '#A63D26',line='#69523B' if dark else '#E8D6BA',wash='#403326' if dark else '#F6E8D1')
 im=Image.new('RGB',(w*2,h*2),c['bg']);d=ImageDraw.Draw(im)
 if p['split']:
  nx=0 if p['appx'] else w/2;d.rectangle((nx*2,0,(nx+w/2)*2,h*2),fill='#E8E6E1');text(im,nx+w/4,h/2,'另一 App',18,'#8E877D',anchor='mm')
 if not p['duo']:text(im,22,12,'9:41',12,c['ink']);text(im,w-22,12,'●●●  ▰',11,c['ink'],anchor='rt')
 return im,p,c

def badge(im,page,x,y,c):
 d=ImageDraw.Draw(im)
 if page=='folklore':d.ellipse(((x-3)*2,(y-3)*2,(x+3)*2,(y+3)*2),fill='#FF3B30')
 if page=='countdown':
  d.rounded_rectangle(((x-9)*2,(y-9)*2,(x+9)*2,(y+9)*2),radius=18,fill='#FF3B30');text(im,x,y,'0',11,'#FFFFFF',anchor='mm')

def nav(im,row,p,c):
 d=ImageDraw.Draw(im);w,h=row['width'],row['height'];active='folklore' if row['page'].startswith('folklore') else 'countdown' if row['page'].startswith('countdown') else row['page'] if row['page'] in ['selection','settings'] else 'home';rects=[]
 if p['side']:
  xx=p['appx']+23 if p['edge']=='left' else p['appx']+p['appw']-73;yy=p['tabY'];d.rounded_rectangle((xx*2,yy*2,(xx+50)*2,(yy+252)*2),radius=50,fill=c['paper'],outline=c['line'],width=2)
  for i,(page,asset,label) in enumerate(r.TABS):
   cy=yy+27+i*49;color=c['red'] if page==active else c['ink']
   if page==active:d.rounded_rectangle(((xx+4)*2,(cy-23)*2,(xx+46)*2,(cy+23)*2),radius=40,fill=c['wash'])
   a=icon(asset,color,25);im.paste(a,(round((xx+12.5)*2),round((cy-12.5)*2)),a);badge(im,page,xx+40,cy-17,c);rects.append([xx+3,cy-24,44,48])
 else:
  tw=min(p['appw']-40,600);tx=p['appx']+(p['appw']-tw)/2;ty=h-84;d.rounded_rectangle((tx*2,ty*2,(tx+tw)*2,(ty+68)*2),radius=54,fill=c['paper'],outline=c['line'],width=2)
  for i,(page,asset,label) in enumerate(r.TABS):
   cx=tx+tw*(i+.5)/5;color=c['red'] if page==active else c['muted'];half=tw/10
   if page==active:d.rounded_rectangle(((cx-half+4)*2,(ty+5)*2,(cx+half-4)*2,(ty+63)*2),radius=40,fill=c['wash'])
   a=icon(asset,color);im.paste(a,(round((cx-12)*2),round((ty+10)*2)),a);text(im,cx,ty+49,label,11,color,anchor='mm');badge(im,page,cx+15,ty+10,c);rects.append([cx-half+3,ty+3,tw/5-6,62])
 if p['duo'] and p['statusVisible']:
  sx=p['appx']+p['appw']-140 if p['horizontal'] else p['appx']+24 if p['edge']=='left' else p['appx']+p['appw']-71;sy=p['statusY'];text(im,sx,sy+17,'09:41',15,c['ink'],anchor='lm') if p['horizontal'] else text(im,sx+23.5,sy,'09:41',15,c['ink'],anchor='mt');a=prior.svg_image(r.STATUS_SVG,47,44,c['ink']);im.paste(a,(round((sx+69 if p['horizontal'] else sx)*2),round((sy-4 if p['horizontal'] else sy+21)*2)),a)
 if row['page'] not in ['home','folklore','selection','countdown','settings']:
  bx=p['contentX']+8;by=p['contentY']+8;d.ellipse((bx*2,by*2,(bx+44)*2,(by+44)*2),fill=c['paper'],outline=c['line'],width=2);text(im,bx+22,by+22,'‹',25,c['ink'],anchor='mm')
 return rects

def render(row):
 im,p,c=shell(row);x,y,cw,ch=[p[k] for k in ['contentX','contentY','contentWidth','contentHeight']];wide=p['appw']>=600 and row['width']>row['height'];state=row.get('state','');dark=row['dark'];motion=None
 def put(markup,xx,yy,ww,maxh=None):
  if state=='plain-off':markup='<div class="plain-off">'+markup+'</div>'
  return prior.paste_fragment(im,markup,xx,yy,ww,maxh,dark)
 lead,detail=r.content(row['page'],row['mode'],state)
 if row['page'] not in ['home','folklore','selection','countdown','settings','fortune']:
  lead='<div class="has-back"><section class="lead">'+lead+'</section></div>'
 if dark:lead=lead.replace('hero-fade-light.png','hero-fade-dark.png')
 if row['page']=='fortune':motion=prior.fortune_layout(im,row,p,c,put)
 elif row.get('full'):
  yy=y
  for markup in [lead,detail]:yy+=put(markup,x,yy,cw)+15
  im=im.crop((0,0,im.width,min(im.height,round((yy+108)*2))));row=dict(row,height=im.height//2)
 elif wide:
  ww=(cw-20)/2;put(lead,x,y,ww,ch);put(detail,x+ww+20,y,ww,ch)
 else:
  hh=put(lead,x,y,cw,ch)
  if hh+15<ch:put(detail,x,y+hh+15,cw,ch-hh-15)
 targets=nav(im,row,p,c)
 if state in ['weather-system-prompt','system-prompt']:
  im=Image.alpha_composite(im.convert('RGBA'),Image.new('RGBA',im.size,(25,20,15,55))).convert('RGB');a=fragment(r.system_prompt('location' if state=='weather-system-prompt' else 'notification'),min(cw,300),dark);im.paste(a,(round((p['appx']+(p['appw']-a.width/2)/2)*2),round((row['height']-a.height/2))))
 if p['duo']:im=im.resize((row['width']*3,row['height']*3),Image.Resampling.LANCZOS)
 im.save(P/(row['file']+'.png'))
 return dict(file=row['file']+'.png',method='offline design composition using HTML fragments and original assets',browserScreenshot=False,pixelSize=list(im.size),contentRect=[x,y,cw,ch],navigationTargets=targets,sideGap=p['sideGap'],navigationTitleRow=False,motion=motion)
if __name__=='__main__':
 rows=json.loads((P/'screens.json').read_text());names=sys.argv[1:]
 if names:rows=[a for a in rows if a['file'] in names]
 out={a['file']:a for a in json.loads((P/'R9-RENDER-PROVENANCE.json').read_text())} if (P/'R9-RENDER-PROVENANCE.json').exists() else {}
 for i,row in enumerate(rows):
  a=render(row);out[a['file']]=a
  (P/'R9-RENDER-PROVENANCE.json').write_text(json.dumps(list(out.values()),ensure_ascii=False,indent=2))
  if names or (i+1)%14==0:print(row['file'],flush=True)
 (P/'R9-RENDER-PROVENANCE.json').write_text(json.dumps(list(out.values()),ensure_ascii=False,indent=2))
