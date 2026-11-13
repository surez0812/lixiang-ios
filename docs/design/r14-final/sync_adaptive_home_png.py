import json,copy,shutil
from PIL import Image
from bs4 import BeautifulSoup
import review_r14 as u
import render_r13 as draw
P=u.P;r=u.r;renderer=draw.renderer
out={a['file']:a for a in json.loads((P/'R14-RENDER-PROVENANCE.json').read_text())}
for row in json.loads((P/'screens.json').read_text()):
 if row['page']!='home' or row['mode']=='duo-tabletop':continue
 mode=row['mode'];draw.CURRENT_MODE=mode;draw.CURRENT_PAGE='home';draw.prev.CURRENT_MODE=mode;draw.prev.CURRENT_PAGE='home';p=r.profile(mode,row['width'],row['height']);wide=row['width']>row['height'] and p['appw']>=600 and not row.get('full')
 if wide:
  im,p,c=renderer.shell(row);x,y,cw,ch=[p[k] for k in ['contentX','contentY','contentWidth','contentHeight']];available=ch-p['overlayInsetBottom'];col=(cw-20)/2;tools=r.shortcuts(mode);th=draw.fragment(tools,col,row['dark']).height/2;target=available-th-12
  hero=r.hero(mode);hero=hero.replace('hero-fade-light.png','hero-fade-dark.png') if row['dark'] else hero;s=BeautifulSoup(hero,'html.parser');art=s.select_one('.hero-art');art['style']='height:90px!important;min-height:0!important;flex:none!important';base=draw.fragment(str(s),col,row['dark']).height/2;art['style']=f'height:{max(40,90+target-base)}px!important;min-height:0!important;flex:none!important'
  renderer.prior.paste_fragment(im,str(s),x,y,col,target,row['dark']);renderer.prior.paste_fragment(im,tools,x,y+available-th,col,th,row['dark']);_,detail=r.content('home',mode,row.get('state',''));renderer.prior.paste_fragment(im,detail,x+col+20,y,col,available,row['dark']);nav=draw.nav(im,row,p,c)
  if p['duo']:im=im.resize((row['width']*3,row['height']*3),Image.Resampling.LANCZOS)
  im.save(P/(row['file']+'.png'));a=dict(file=row['file']+'.png',method='offline design composition',browserScreenshot=False,pixelSize=list(im.size),contentRect=[x,y,cw,ch],navigationTargets=nav,sideGap=p['sideGap'],motion=None,toolsRect=[x,y+available-th,col,th],toolsAdaptive=True)
 else:a=draw.render(row);a['toolsAdaptive']=True
 out[a['file']]=a
source='home-duo-open-portrait.png';target='home-duo-tabletop.png';shutil.copy2(P/source,P/target);a=copy.deepcopy(out[source]);a['file']=target;a['sharedLayoutFrom']=source;out[target]=a
(P/'R14-RENDER-PROVENANCE.json').write_text(json.dumps(list(out.values()),ensure_ascii=False,indent=2));print('Updated only17 home PNGs; other171 screen PNGs unchanged')
