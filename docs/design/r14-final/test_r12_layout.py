import json
from bs4 import BeautifulSoup
import review_r12 as u
r=u.r;P=u.P;checks=[]
assert not list(P.glob('*splitview*.html'))
for mode,w,h,dark in r.MODES:
 p=r.profile(mode,w,h);assert p['contentY']==(12 if p['duo'] else 36)
 for state in ['', '-hour']:
  s=BeautifulSoup((P/f'compass-{mode}{state}.html').read_text(),'html.parser');style=s.style.text
  assert s.select_one('.workspace>.lead') and s.select_one('.workspace>.detail .compass-board')
  assert len(s.select('.compass-board .pin'))==5 and s.select_one('img.dial')
  assert '--ch:'+str(p['contentHeight'])+'px' in style
  assert 'const q=s=>document.querySelector(s)' in s.script.text and 'function r11SetCompass' in s.script.text
  assert 'R8.unlocked' not in s.script.text and not s.select('.r8-app')
  assert len(s.select('[data-r11-compass]'))==2
 a=BeautifulSoup((P/f'almanac-{mode}.html').read_text(),'html.parser')
 assert not a.select('.rounddate,.almanac-main .main-compass-link')
 group=a.select_one('.bar-controls');assert group and len(group.select('a'))==2 and group.select_one('[data-r11-compass-link]')
 if mode=='duo-open-landscape':assert a.select_one('body.side-duo') and a.select_one('nav.floating-tabs') and not a.select('nav.tabs')
 checks.append({'mode':mode,'topGap':p['contentY'],'compassSelfContained':True,'initialCompassMarkupVisibleWithoutScript':True,'adjacentFloatingControls':True,'largeDateRemoved':True})
(P/'R12-LAYOUT-TESTS.json').write_text(json.dumps({'checks':checks,'splitviewRemoved':True,'scope':'source structure; no browser execution'},ensure_ascii=False,indent=2));print('PASS R12 layout structure,14 modes; no splitview')
