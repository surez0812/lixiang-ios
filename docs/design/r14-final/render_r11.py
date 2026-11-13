import json,sys
import review_r11 as update
import render_r9 as renderer
r=update.r;P=r.P
renderer.r=r;renderer.prior.r=r
BASE_RENDER=renderer.render

def render(row):
 if row['page']=='home':
  p=r.profile(row['mode'],row['width'],row['height'])
  if p['appw']>=600 and row['width']>row['height']:
   im,p,c=renderer.shell(row);x,y,cw,ch=[p[k] for k in ['contentX','contentY','contentWidth','contentHeight']];ww=(cw-20)/2
   hero=r.hero(row['mode']);hero=hero.replace('hero-fade-light.png','hero-fade-dark.png') if row['dark'] else hero;s=update.BeautifulSoup(hero,'html.parser');art=s.select_one('.hero-art');art['style']='height:90px!important;min-height:0!important;flex:none!important'
   base=renderer.fragment(str(s),ww,row['dark']).height/2;target=ch-172;art['style']=f'height:{max(40,90+target-base)}px!important;min-height:0!important;flex:none!important'
   renderer.prior.paste_fragment(im,str(s),x,y,ww,target,row['dark']);renderer.prior.paste_fragment(im,r.shortcuts(row['mode']),x,y+ch-156,ww,156,row['dark'])
   _,detail=r.content('home',row['mode'],row.get('state',''));renderer.prior.paste_fragment(im,detail,x+ww+20,y,ww,ch,row['dark']);targets=renderer.nav(im,row,p,c)
   if p['duo']:im=im.resize((row['width']*3,row['height']*3),renderer.Image.Resampling.LANCZOS)
   im.save(P/(row['file']+'.png'))
   return dict(file=row['file']+'.png',method='offline design composition',browserScreenshot=False,pixelSize=list(im.size),contentRect=[x,y,cw,ch],navigationTargets=targets,sideGap=p['sideGap'],navigationTitleRow=False,motion=None,toolsRect=[x,y+ch-156,ww,156],toolsFullyWithinContent=True)
 a=BASE_RENDER(row)
 if row['page']=='almanac' and row['width']>row['height']:
  a['scrollDesign']={'outer':'fixed','left':'full-height independent scroll','right':'full-height independent scroll'}
 return a
if __name__=='__main__':
 rows=json.loads((P/'screens.json').read_text());names=sys.argv[1:]
 if names:rows=[a for a in rows if a['file'] in names]
 out={}
 for i,row in enumerate(rows):
  a=render(row);out[a['file']]=a
  if (i+1)%14==0 or names:print(row['file'],flush=True)
  (P/'R11-RENDER-PROVENANCE.json').write_text(json.dumps(list(out.values()),ensure_ascii=False,indent=2))
