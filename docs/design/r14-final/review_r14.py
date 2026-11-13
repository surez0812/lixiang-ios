import json
import review_r13 as previous
r=previous.r;P=r.P
BASE_HTML=r.page_html;BASE_PROFILE=r.profile
fortune_geometry=previous.fortune_geometry
r.MODES[:]=[(mode,669,951,dark) if mode=='duo-tabletop' else (mode,w,h,dark) for mode,w,h,dark in r.MODES if not mode.startswith('phone-landscape')]
r.b.MODES=r.MODES

def profile(mode,w,h):return BASE_PROFILE('duo-open-portrait' if mode=='duo-tabletop' else mode,w,h)
r.profile=profile;r.old.profile=profile

def page_html(page,mode,w,h,dark=False,state='',full=False):
 if mode!='duo-tabletop':return BASE_HTML(page,mode,w,h,dark,state,full)
 # One shared layout family; only local navigation filenames identify the tabletop variant.
 html=BASE_HTML(page,'duo-open-portrait',669,951,dark,state,full)
 for suffix in ['-hour.html','-result.html','-plain-off.html','-full.html','.html']:
  html=html.replace('duo-open-portrait'+suffix,'duo-tabletop'+suffix)
 return html.replace('<body ','<body data-device-mode="duo-tabletop" data-layout-family="duo-open-portrait" ',1)
r.page_html=page_html
from adaptive_home_tools import install
install(r)
if __name__=='__main__':
 rows=r.generate()
 for mode,w,h,dark in r.MODES:
  name='compass-'+mode+'-hour';(P/(name+'.html')).write_text(page_html('compass',mode,w,h,dark,'hour'));rows.append(dict(page='compass',mode=mode,width=w,height=h,dark=dark,state='hour',full=False,file=name))
 for state in ['previous','next']:
  name='almanac-phone-light-'+state;(P/(name+'.html')).write_text(page_html('almanac','phone-light',375,930,False,state));rows.append(dict(page='almanac',mode='phone-light',width=375,height=930,dark=False,state=state,full=False,file=name))
 (P/'screens.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2));print('Generated',len(rows),'R14 screens;',len(r.MODES),'modes; iPhone portrait only')
