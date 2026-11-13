import json,hashlib,re,subprocess
from pathlib import Path
from bs4 import BeautifulSoup
from PIL import Image
import review_r14 as update
r=update.r
P=r.P;results=[]
def check(name,ok):
 assert ok,name
 results.append({'check':name,'passed':True})
rows=json.loads((P/'screens.json').read_text())
check('188 screen states and 12 modes',len(rows)==188 and len(r.MODES)==12)
check('No independent daily-detail route',not list(P.glob('day-*.html')) and 'day' not in r.PAGES)
for mode,w,h,dark in r.MODES:
 s=BeautifulSoup((P/f'home-{mode}.html').read_text(),'html.parser');nav=s.select_one('nav')
 check(mode+' five tabs',len(nav.select('a.tab'))==5 and any('selection-' in a['href'] for a in nav.select('a.tab')))
 check(mode+' month routes to almanac',all(a['href'].startswith('almanac-') for a in s.select('.month-grid a[data-date]')) and len(s.select('.month-grid a[data-date]'))>=28)
 check(mode+' no navigation title containers',not s.select('header.top,header.duo-header'))
 stack=s.select_one('.home-stack');check(mode+' home order',stack and stack.select_one('.hero') and stack.select_one('.home-tools') and s.select_one('.almanac-teaser') and not stack.select('.season-card'))
 check(mode+' hero links + fade',len(s.select('.today-match'))==2 and bool(s.select_one('.hero-fade')) and not s.select('.crest'))
 a=BeautifulSoup((P/f'almanac-{mode}-plain-off.html').read_text(),'html.parser')
 check(mode+' compact yi ji',len(a.select('.activities-summary>.summary-item'))==2 and len(a.select('.activity-row'))==21 and 'plain-off' in a.select_one('.device')['class'] and 'plain-off' not in a.select_one('.r8-app')['class'])
 check(mode+' eras merged',len(a.select('.era-row'))==2 and '黄帝纪元 · 道历纪元' in a.text)
 check(mode+' matched events',len(a.select('[data-matched-event]'))==1 and a.select_one('[data-matched-event]')['data-matched-event']=='daily-kindness')
 for page in r.PAGES:
  html=(P/f'{page}-{mode}.html').read_text();scripts=BeautifulSoup(html,'html.parser').select('script');js='\n'.join(x.text for x in scripts);proc=subprocess.run(['node','--check'],input=js,text=True,capture_output=True);check(page+' '+mode+' JavaScript parses',proc.returncode==0)
check('No festival panel on unmatched date',not BeautifulSoup((P/'almanac-phone-light-no-festival.html').read_text(),'html.parser').select('.matched-festivals'))
check('Selected winter festival',r.matched_events('2026-11-22')[0]['id']=='winter' and not r.matched_events('2026-11-13'))
check('Unequal calendar years stay separate',r.era_rows(4723,4724,2570).count('class="era-row"')==3)
for theme in ['light','dark']:
 im=Image.open(P/f'assets/hero-fade-{theme}.png');check(theme+' alpha endpoints',im.getpixel((0,0))[3]==0 and im.getpixel((0,255))[3]==255)
check('Correct new portrait reference',Image.open(P/'references/duo_open_portrait.png').size==(2007,2853))
for mode in ['duo-open-portrait','duo-tabletop']:
 a=next(v for v in r.MODES if v[0]==mode);check(mode+' top status bottom tabs',r.profile(*a[:3])['horizontal'])
for mode in ['duo-closed-landscape','duo-open-landscape','duo-tent']:
 a=next(v for v in r.MODES if v[0]==mode);p=r.profile(*a[:3]);check(mode+' sidebar gap 8pt',p['sideGap']==8)
manifest=json.loads((P/'ApprovedMotionManifest.json').read_text())
for item in manifest['files']:
 check('Frozen '+item['path'],hashlib.sha256((P/item['path']).read_bytes()).hexdigest()==item['approvedSHA256'])
check('Frozen core unchanged',hashlib.sha256((P/'ApprovedFortuneCore.js').read_bytes()).hexdigest()==manifest['scriptSHA256'])
(P/'R14-VALIDATION.json').write_text(json.dumps({'kind':'source and offline geometry checks; no browser or simulator execution','checks':results},ensure_ascii=False,indent=2))
print('PASS',len(results))
