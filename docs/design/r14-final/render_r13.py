import json,sys,io
from PIL import Image,ImageDraw
from bs4 import BeautifulSoup
import review_r13 as update
import render_r12 as prev
from render_designs import fragment as BASE_FRAGMENT,text
r=update.r;P=r.P;renderer=prev.renderer
renderer.r=r;renderer.prior.r=r
OLD_NAV=renderer.nav
CURRENT_MODE='';CURRENT_PAGE=''
def fragment(markup,w,dark=False):return BASE_FRAGMENT('<div class="mode-'+CURRENT_MODE+' page-'+CURRENT_PAGE+' has-back">'+markup+'</div>',w,dark)
renderer.fragment=fragment;renderer.prior.fragment=fragment

def nav(im,row,p,c):
 if row['page']=='almanac' and not p['duo']:
  rects=OLD_NAV(im,dict(row,page='daily'),p,c);x=p['contentX']+p['contentWidth']-8-104;y=p['contentY']+8;d=ImageDraw.Draw(im);d.rounded_rectangle((x*2,y*2,(x+104)*2,(y+44)*2),radius=44,fill=c['paper'],outline=c['line'],width=2);text(im,x+52,y+22,'值神罗盘',14,c['ink'],anchor='mm');return rects
 return OLD_NAV(im,row,p,c)
renderer.nav=nav

def result_markup(mode):
 _,detail=r.content('fortune',mode,'result');s=BeautifulSoup(detail,'html.parser');copy=str(s.select_one('.result-copy'));g=update.fortune_geometry(mode);cls='page-fortune'+(' compact-reading' if g['compactReading'] else '')+(' short-reading' if g['shortReading'] else '')
 if mode.startswith('phone-landscape'):
  # Measure text with its real legacy ancestor rules; release only the viewport height for intrinsic sizing.
  copy=copy.replace('class="result-copy"','class="result-copy" style="height:auto!important;max-height:none!important"')
  copy='<section class="fortune-host" style="display:block!important;height:auto!important">'+copy+'</section>'
 return '<div class="mode-'+mode+' '+cls+'" style="'+update.fortune_vars(mode,*next(m[1:3] for m in r.MODES if m[0]==mode))+'">'+copy+'</div>'

def render_fortune(row):
 im,p,c=renderer.shell(row);g=update.fortune_geometry(row['mode'],row['width'],row['height']);x=p['contentX'];y=p['contentY'];tx,ty,tw,th=g['title'];bx,by,bw,bh=g['board'];vh=g['visualHeight'];lead,_=r.content('fortune',row['mode'],row.get('state',''))
 renderer.prior.paste_fragment(im,'<div style="height:'+str(th)+'px">'+lead+'</div>',x+tx,y+ty,tw,th,row['dark'])
 intrinsic=None
 if row.get('state')=='result':
  width=g['copyWidth'];paper=Image.open(P/'assets/fortune-paper.png').convert('RGBA').resize((round(width*2),round(vh*2)),Image.Resampling.LANCZOS);px=x+bx+(bw-width)/2;py=y+by;im.paste(paper,(round(px*2),round(py*2)),paper)
  a=BASE_FRAGMENT(result_markup(row['mode']),width,False);intrinsic=a.height/2
  assert intrinsic<=vh+2,(row['mode'],intrinsic,vh)
  # Fragment background is the same warm paper family; the real HTML retains the image backdrop.
  a=a.convert('RGBA');pixels=a.load()
  for yy in range(a.height):
   for xx in range(a.width):
    if pixels[xx,yy][:3] in [(255,248,236),(255,252,245),(255,255,255)]:pixels[xx,yy]=(255,248,236,0)
  im.paste(a,(round(px*2),round((py+(vh-intrinsic)/2)*2)),a)
 else:
  scale=min(bw/300,vh/430);a=renderer.prior.FIGURE.resize((round(600*scale),round(860*scale)),Image.Resampling.LANCZOS);im.paste(a,(round((x+bx+(bw-300*scale)/2)*2),round((y+by+(vh-430*scale)/2)*2)),a)
 d=ImageDraw.Draw(im);ay=y+by+vh+8;ax=x+bx;skip=90;buttonw=bw-skip-10
 d.rounded_rectangle((ax*2,ay*2,(ax+buttonw)*2,(ay+44)*2),radius=44,fill=c['red']);text(im,ax+buttonw/2,ay+22,'收好今日一签' if row.get('state')=='result' else '轻摇，遇见今日一签',12,c['bg'],anchor='mm')
 d.rounded_rectangle(((ax+buttonw+10)*2,ay*2,(ax+bw)*2,(ay+44)*2),radius=44,fill=c['paper'],outline=c['line'],width=2);text(im,ax+bw-skip/2,ay+22,'跳过动画',12,c['ink'],anchor='mm');text(im,ax+bw/2,ay+57,'同一天，保留同一结果。',10,c['muted'],anchor='mm');rects=nav(im,row,p,c)
 if p['duo']:im=im.resize((row['width']*3,row['height']*3),Image.Resampling.LANCZOS)
 im.save(P/(row['file']+'.png'))
 return dict(file=row['file']+'.png',method='offline design composition',browserScreenshot=False,pixelSize=list(im.size),contentRect=[x,y,p['contentWidth'],p['contentHeight']],navigationTargets=rects,sideGap=p['sideGap'],motion={'visual':[x+bx,y+by,bw,vh],'actions':[ax,ay,bw,44],'stageSize':[300,430],'approvedCoreUnchanged':True},titleRect=[x+tx,y+ty,tw,th],titlePersistent=True,resultIntrinsicHeight=intrinsic,resultViewportHeight=vh,resultHasInternalScroll=False)

def render(row):
 global CURRENT_MODE,CURRENT_PAGE
 CURRENT_MODE=row['mode'];CURRENT_PAGE=row['page'];prev.CURRENT_MODE=CURRENT_MODE;prev.CURRENT_PAGE=CURRENT_PAGE
 if row['page']=='fortune':return render_fortune(row)
 mode=row['mode'];p=r.profile(mode,row['width'],row['height']);dark=row['dark']
 if row['page']=='home' and mode=='duo-closed-landscape':
  im,p,c=renderer.shell(row);x,y,cw,ch=[p[k] for k in ['contentX','contentY','contentWidth','contentHeight']];ww=(cw-20)/2;th=112;target=ch-th-12;hero=r.hero(mode);s=BeautifulSoup(hero,'html.parser');s.select_one('.hero-art')['style']='height:90px!important;min-height:0!important;flex:none!important';base=fragment(str(s),ww,dark).height/2;s.select_one('.hero-art')['style']=f'height:{max(40,90+target-base)}px!important;min-height:0!important;flex:none!important';renderer.prior.paste_fragment(im,str(s),x,y,ww,target,dark);renderer.prior.paste_fragment(im,r.shortcuts(mode),x,y+ch-th,ww,th,dark);_,detail=r.content('home',mode);renderer.prior.paste_fragment(im,detail,x+ww+20,y,ww,ch,dark);rects=nav(im,row,p,c);im=im.resize((row['width']*3,row['height']*3),Image.Resampling.LANCZOS);im.save(P/(row['file']+'.png'));return dict(file=row['file']+'.png',method='offline design composition',browserScreenshot=False,pixelSize=list(im.size),contentRect=[x,y,cw,ch],navigationTargets=rects,sideGap=p['sideGap'],motion=None,toolsRect=[x,y+ch-th,ww,th])
 if row['page']=='folklore-detail' and mode in ['duo-closed-portrait','duo-closed-landscape']:
  im,p,c=renderer.shell(row);x,y,cw,ch=[p[k] for k in ['contentX','contentY','contentWidth','contentHeight']];lead,detail=r.content(row['page'],mode,row.get('state',''));hh=renderer.prior.paste_fragment(im,lead,x,y,cw,ch,dark);renderer.prior.paste_fragment(im,detail,x,y+hh+12,cw,max(1,ch-hh-12),dark);rects=nav(im,row,p,c);im=im.resize((row['width']*3,row['height']*3),Image.Resampling.LANCZOS);im.save(P/(row['file']+'.png'));return dict(file=row['file']+'.png',method='offline design composition',browserScreenshot=False,pixelSize=list(im.size),contentRect=[x,y,cw,ch],navigationTargets=rects,sideGap=p['sideGap'],motion=None,articleViewport=[x,y+hh+12,cw,ch-hh-12],headerHeight=hh,articleUsesFullContentWidth=True)
 return prev.render(row)
if __name__=='__main__':
 rows=json.loads((P/'screens.json').read_text());names=sys.argv[1:]
 if names:rows=[a for a in rows if a['file'] in names]
 out={}
 for i,row in enumerate(rows):
  a=render(row);out[a['file']]=a
  if names or (i+1)%14==0:print(row['file'],flush=True)
  (P/'R13-RENDER-PROVENANCE.json').write_text(json.dumps(list(out.values()),ensure_ascii=False,indent=2))
