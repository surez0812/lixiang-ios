import json,sys
from PIL import Image,ImageDraw
import review_r12 as update
import render_r11 as legacy
from render_designs import fragment as BASE_FRAGMENT,icon,text
r=update.r;P=r.P;renderer=legacy.renderer
renderer.r=r;renderer.prior.r=r
OLD_NAV=renderer.nav
CURRENT_MODE='';CURRENT_PAGE=''
def fragment(markup,w,dark=False):return BASE_FRAGMENT('<div class="mode-'+CURRENT_MODE+' page-'+CURRENT_PAGE+' has-back">'+markup+'</div>',w,dark)
renderer.fragment=fragment;renderer.prior.fragment=fragment

def nav(im,row,p,c):
 original=row['page'];root='folklore' if original.startswith('folklore') else 'countdown' if original.startswith('countdown') else original if original in ['selection','settings'] else 'home'
 rects=OLD_NAV(im,dict(row,page=root),p,c)
 if original not in ['home','folklore','selection','countdown','settings']:
  d=ImageDraw.Draw(im);x=p['appx']+p['appw']-70 if p['side'] else p['contentX']+8;y=p['controlY'] if p['side'] else p['contentY']+8
  for i,kind in enumerate(['back','compass'] if original=='almanac' else ['back']):
   xx=x if p['side'] else x+i*52;yy=y+i*52 if p['side'] else y
   d.ellipse((xx*2,yy*2,(xx+44)*2,(yy+44)*2),fill=c['paper'],outline=c['line'],width=2)
   if kind=='back':text(im,xx+22,yy+22,'‹',25,c['ink'],anchor='mm')
   else:
    a=renderer.prior.svg_image(update.prev.ICON,23,23,c['ink']);im.paste(a,(round((xx+10.5)*2),round((yy+10.5)*2)),a)
 return rects
renderer.nav=nav

def render(row):
 global CURRENT_MODE,CURRENT_PAGE
 CURRENT_PAGE=row['page'];CURRENT_MODE=row['mode'];page=row['page'];mode=row['mode'];dark=row['dark'];p=r.profile(mode,row['width'],row['height']);oldcss=r.b.CSS
 if page=='compass':r.b.CSS=update.COMPASS_CSS
 try:
  if page=='home' and p['appw']>=600 and row['width']>row['height'] and not mode.startswith('phone-landscape'):
   im,p,c=renderer.shell(row);x,y,cw,ch=[p[k] for k in ['contentX','contentY','contentWidth','contentHeight']];usable=ch-p['overlayInsetBottom'];ww=(cw-20)/2;th=108 if mode=='duo-tent' else 156;gap=12 if mode=='duo-tent' else 16;target=usable-th-gap
   hero=r.hero(mode).replace('hero-fade-light.png','hero-fade-dark.png') if dark else r.hero(mode);s=update.BeautifulSoup(hero,'html.parser');art=s.select_one('.hero-art');art['style']='height:90px!important;min-height:0!important;flex:none!important';base=fragment(str(s),ww,dark).height/2;art['style']=f'height:{max(40,90+target-base)}px!important;min-height:0!important;flex:none!important'
   renderer.prior.paste_fragment(im,str(s),x,y,ww,target,dark);renderer.prior.paste_fragment(im,r.shortcuts(mode),x,y+usable-th,ww,th,dark)
   _,detail=r.content('home',mode,row.get('state',''));rightheight=renderer.prior.paste_fragment(im,detail,x+ww+20,y,ww,usable,dark);rects=nav(im,row,p,c)
   if p['duo']:im=im.resize((row['width']*3,row['height']*3),Image.Resampling.LANCZOS)
   im.save(P/(row['file']+'.png'))
   return dict(file=row['file']+'.png',method='offline design composition',browserScreenshot=False,pixelSize=list(im.size),contentRect=[x,y,cw,ch],navigationTargets=rects,sideGap=p['sideGap'],motion=None,toolsRect=[x,y+usable-th,ww,th],rightColumnContentHeight=rightheight,rightColumnViewportHeight=usable,tentMonthFits=rightheight<=usable if mode=='duo-tent' else None)
  original_profile=r.profile
  def safe_profile(mode,w,h):
   v=original_profile(mode,w,h);v['contentHeight']-=v['overlayInsetBottom'];return v
  r.profile=safe_profile
  try:result=renderer.render(row)
  finally:r.profile=original_profile
  result['overlayNavigation']=True;result['noExtraTopGap']=True;return result
 finally:r.b.CSS=oldcss
if __name__=='__main__':
 rows=json.loads((P/'screens.json').read_text());names=sys.argv[1:]
 if names:rows=[x for x in rows if x['file'] in names]
 out={}
 for i,row in enumerate(rows):
  a=render(row);out[a['file']]=a
  if names or (i+1)%14==0:print(row['file'],flush=True)
  (P/'R12-RENDER-PROVENANCE.json').write_text(json.dumps(list(out.values()),ensure_ascii=False,indent=2))
