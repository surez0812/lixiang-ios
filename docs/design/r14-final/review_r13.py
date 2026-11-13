import json
from bs4 import BeautifulSoup
import review_r12 as previous
r=previous.r;P=r.P
BASE_CONTENT=r.content;BASE_HTML=r.page_html;BASE_SHORTCUTS=r.shortcuts
COMPACT=['phone-light','phone-dark','duo-closed-portrait','duo-closed-landscape']
SIDE_FORTUNE=['ipad-landscape','ipad-landscape-dark','duo-closed-landscape','duo-open-landscape','duo-tent']

def fortune_geometry(mode,w=None,h=None):
 if w is None:_,w,h,_=next(m for m in r.MODES if m[0]==mode)
 p=r.profile(mode,w,h);cw=p['contentWidth'];available=p['contentHeight']-p['overlayInsetBottom'];side=mode in SIDE_FORTUNE;phone_wide=mode.startswith('phone-landscape');actions=64 if phone_wide else 72
 if side:
  lw=max(150,cw*.28);bw=cw-lw-20;vh=available-actions;title=[0,max(0,(vh-112)/2),lw,112];board=[lw+20,0,bw,available]
 else:
  th=40 if phone_wide else 88;title=[0,0,cw,th];gap=6 if phone_wide else 12;board=[0,th+gap,cw,available-th-gap];vh=board[3]-actions
 short=vh<240;compact=vh<430
 return dict(side=side,title=title,board=board,visualHeight=vh,actionsHeight=actions,compactReading=compact,shortReading=short,bodyFont=10.5 if short else 12.5 if compact else 13 if vh<500 else 14,poemFont=14 if short else 19 if compact else 20 if vh<500 else 22,titleFont=19 if short else 25 if compact else 28,padding=6 if short else 16 if compact else 18,copyWidth=min(board[2],620 if phone_wide else 540 if compact else 430))
def fortune_vars(mode,w,h):
 g=fortune_geometry(mode,w,h);t=g['title'];b=g['board']
 return ''.join(f'--ft-{name}:{value}px;' for name,value in dict(tx=t[0],ty=t[1],tw=t[2],th=t[3],bx=b[0],by=b[1],bw=b[2],bh=b[3],vh=g['visualHeight'],ah=g['actionsHeight'],body=g['bodyFont'],poem=g['poemFont'],title=g['titleFont'],pad=g['padding'],copy=g['copyWidth']).items())
def shortcuts(mode,state='notDetermined'):
 markup=BASE_SHORTCUTS(mode,state)
 if mode not in COMPACT:return markup
 s=BeautifulSoup(markup,'html.parser');entry=s.select_one('.fortune-entry');row=s.new_tag('div',attrs={'class':'tool-title'});row.append(entry.select_one('img').extract());row.append(entry.select_one('h3').extract());entry.insert(0,row)
 return str(s).replace('开启定位，看看<br/>所在城市的天气','开启定位，查看天气').replace('开启定位，看看<br>所在城市的天气','开启定位，查看天气')
r.shortcuts=shortcuts;r.b.shortcuts=shortcuts

def content(page,mode,state=''):
 lead,detail=BASE_CONTENT(page,mode,state)
 if page=='fortune':
  s=BeautifulSoup(detail,'html.parser');copy=s.select_one('.result-copy');heading=s.new_tag('div',attrs={'class':'result-heading'})
  heading.append(copy.select_one('#sign-no').extract());heading.append(copy.select_one('#sign-title').extract())
  reading=s.new_tag('div',attrs={'class':'result-reading'});reading.append(copy.select_one('#poem').extract());explain=copy.select_one('.explain').extract()
  for br in explain.select('br'):br.decompose()
  for label in list(explain.select('b')):
   para=label.find_next_sibling('p');section=s.new_tag('section');section.append(label.extract())
   if para:section.append(para.extract())
   explain.append(section)
  reading.append(explain);copy.clear();copy.append(heading);copy.append(reading);detail=str(s)
 elif page=='folklore-detail' and mode in ['duo-closed-portrait','duo-closed-landscape']:
  s=BeautifulSoup(lead,'html.parser');head=s.select_one('.native-event-head');row=head.select_one('.row')
  if row:
   for node in list(row.children):head.append(node.extract())
   row.decompose()
  lead=str(s)
 return lead,detail
r.content=content;r.b.content=content
CSS='''

.mode-duo-closed-portrait .event-heading-compact,.mode-duo-closed-landscape .event-heading-compact{grid-template-columns:minmax(0,1fr) 84px!important}.mode-duo-closed-portrait .event-heading-compact .secondary,.mode-duo-closed-landscape .event-heading-compact .secondary{width:84px;min-width:0;white-space:nowrap}.mode-duo-closed-portrait .event-heading-compact>.pill,.mode-duo-closed-landscape .event-heading-compact>.pill{justify-self:end;max-width:84px;white-space:nowrap}

.mode-duo-closed-landscape .home-stack>.hero>.hero-art{height:auto!important;min-height:48px!important;max-height:none!important;flex:1 1 0}.mode-duo-closed-landscape .hero-copy{padding:0 13px 12px!important}.mode-duo-closed-landscape .hero-copy h2{font-size:15px!important;line-height:1.4}.mode-duo-closed-landscape .ganzhi{font-size:10px;line-height:1.5}.mode-duo-closed-landscape .hero .quote{padding:8px 10px;margin-top:8px}.mode-duo-closed-landscape .hero .quote p{font-size:16px;line-height:1.45}.mode-duo-closed-landscape .hero .quote small{font-size:8px}

.page-fortune .r8-app .workspace{display:block!important;overflow:hidden!important;padding:0!important}.page-fortune .r8-app .workspace>.lead{position:absolute!important;left:var(--ft-tx)!important;top:var(--ft-ty)!important;width:var(--ft-tw)!important;height:var(--ft-th)!important}.page-fortune .r8-app .workspace>.detail{position:absolute!important;left:var(--ft-bx)!important;top:var(--ft-by)!important;width:var(--ft-bw)!important;height:var(--ft-bh)!important}

.page-fortune.short-reading .result-copy{display:grid!important;grid-template-columns:minmax(0,.43fr) minmax(0,.57fr);grid-template-rows:auto auto;align-content:center;gap:4px 14px}.page-fortune.short-reading .result-reading{display:contents!important}.page-fortune.short-reading .result-heading{grid-column:1;grid-row:1}.page-fortune.short-reading .poem{grid-column:1;grid-row:2}.page-fortune.short-reading .explain{grid-column:2;grid-row:1/3}

.mode-phone-landscape.page-fortune .fortune-heading .eyebrow,.mode-phone-landscape.page-fortune .fortune-heading p,.mode-phone-landscape-dark.page-fortune .fortune-heading .eyebrow,.mode-phone-landscape-dark.page-fortune .fortune-heading p{display:none}.mode-phone-landscape.page-fortune .fortune-heading h1,.mode-phone-landscape-dark.page-fortune .fortune-heading h1{font-size:24px}.mode-phone-landscape.page-fortune .fortune-actions,.mode-phone-landscape-dark.page-fortune .fortune-actions{padding-top:4px!important;gap:2px 10px}.mode-phone-landscape.page-fortune .fortune-actions .hint,.mode-phone-landscape-dark.page-fortune .fortune-actions .hint{font-size:9px;line-height:12px}

.home-tools .fortune-entry .tool-title img{height:28px!important;width:14px!important}.mode-phone-light .home-tools>.card,.mode-phone-dark .home-tools>.card,.mode-duo-closed-portrait .home-tools>.card,.mode-duo-closed-landscape .home-tools>.card{justify-content:flex-start!important}.mode-phone-light .compact-weather,.mode-phone-dark .compact-weather,.mode-duo-closed-portrait .compact-weather,.mode-duo-closed-landscape .compact-weather{gap:2px!important}.mode-phone-light .compact-weather h3,.mode-phone-dark .compact-weather h3,.mode-duo-closed-portrait .compact-weather h3,.mode-duo-closed-landscape .compact-weather h3{min-height:28px}.mode-phone-light .compact-weather p,.mode-phone-dark .compact-weather p,.mode-duo-closed-portrait .compact-weather p,.mode-duo-closed-landscape .compact-weather p{line-height:1.2!important}

.tool-title{width:100%;flex:none}.tool-title img,.tool-title h3{flex:none!important}.tool-title h3{white-space:nowrap!important}.mode-phone-light .compact-weather h3,.mode-phone-dark .compact-weather h3,.mode-duo-closed-portrait .compact-weather h3,.mode-duo-closed-landscape .compact-weather h3{width:100%;white-space:nowrap}.compact-weather h3:before{flex:none}

.page-fortune.short-reading .result-reading{margin-top:6px!important;gap:12px!important}

.page-almanac:not(.duo) .bar-controls{width:calc(var(--cw) - 16px);justify-content:space-between;pointer-events:none}.page-almanac:not(.duo) .bar-controls>a{pointer-events:auto}.page-almanac:not(.duo) .bar-action[data-r11-compass-link]{width:auto;min-width:104px;padding:0 14px;border-radius:24px;font-size:14px;font-weight:600}.page-almanac:not(.duo) .almanac-main h1{padding-left:52px!important;padding-right:108px!important}
.mode-phone-light .home-tools>.card,.mode-phone-dark .home-tools>.card,.mode-duo-closed-portrait .home-tools>.card,.mode-duo-closed-landscape .home-tools>.card{height:112px!important;min-height:112px!important;padding:10px!important;gap:4px!important}.mode-phone-light .home-tools,.mode-phone-dark .home-tools,.mode-duo-closed-portrait .home-tools,.mode-duo-closed-landscape .home-tools{height:112px!important;min-height:112px!important}.tool-title{display:flex;align-items:center;justify-content:center;gap:8px;min-height:28px}.tool-title img{height:28px!important;width:14px!important}.tool-title h3{font-size:14px!important;line-height:1.5}.mode-phone-light .compact-weather h3,.mode-phone-dark .compact-weather h3,.mode-duo-closed-portrait .compact-weather h3,.mode-duo-closed-landscape .compact-weather h3{display:flex;align-items:center;justify-content:center;gap:8px;font-size:14px}.mode-phone-light .compact-weather h3:before,.mode-phone-dark .compact-weather h3:before,.mode-duo-closed-portrait .compact-weather h3:before,.mode-duo-closed-landscape .compact-weather h3:before{content:'☁';font-size:23px;color:var(--gold)}.mode-phone-light .compact-weather>.weather-symbol,.mode-phone-dark .compact-weather>.weather-symbol,.mode-duo-closed-portrait .compact-weather>.weather-symbol,.mode-duo-closed-landscape .compact-weather>.weather-symbol{display:none}.mode-phone-light .compact-weather p,.mode-phone-dark .compact-weather p,.mode-duo-closed-portrait .compact-weather p,.mode-duo-closed-landscape .compact-weather p{font-size:10px;line-height:1.4}.mode-phone-light .compact-weather .secondary,.mode-phone-dark .compact-weather .secondary,.mode-duo-closed-portrait .compact-weather .secondary,.mode-duo-closed-landscape .compact-weather .secondary{min-height:44px;padding:6px 12px;font-size:11px}.mode-phone-light .home-tools+.almanac-teaser,.mode-phone-dark .home-tools+.almanac-teaser,.mode-duo-closed-portrait .home-tools+.almanac-teaser{margin-top:16px!important}
.mode-duo-closed-landscape .home-stack{grid-template-rows:minmax(0,1fr) 112px!important;gap:12px!important}.mode-duo-closed-landscape .today-matches{display:grid!important;grid-template-columns:minmax(0,1fr) minmax(0,1fr);gap:6px}.mode-duo-closed-landscape .today-match{display:grid;grid-template-columns:minmax(0,1fr) 9px;gap:0;min-width:0;min-height:40px;padding:5px 7px}.mode-duo-closed-landscape .match-type{grid-column:1;font-size:8px}.mode-duo-closed-landscape .today-match b{grid-column:1;font-size:10px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.mode-duo-closed-landscape .today-match>span:last-child{grid-column:2;grid-row:1/3}.mode-duo-closed-landscape .compact-filters{flex-wrap:wrap!important;overflow:visible!important}.mode-duo-closed-landscape .compact-filters button{flex:none!important}
.mode-duo-closed-portrait.page-folklore-detail .r8-app .workspace,.mode-duo-closed-landscape.page-folklore-detail .r8-app .workspace{display:flex!important;flex-direction:column!important;gap:12px;overflow:hidden!important;padding-bottom:0!important}.mode-duo-closed-portrait.page-folklore-detail .workspace>.lead,.mode-duo-closed-landscape.page-folklore-detail .workspace>.lead{flex:none!important;height:auto!important;overflow:visible!important}.mode-duo-closed-portrait.page-folklore-detail .workspace>.detail,.mode-duo-closed-landscape.page-folklore-detail .workspace>.detail{flex:1!important;width:100%;height:auto!important;min-height:0!important;display:flex!important;flex-direction:column;overflow:hidden!important}.mode-duo-closed-portrait.page-folklore-detail .article-frame,.mode-duo-closed-landscape.page-folklore-detail .article-frame{width:100%!important;height:100%!important;flex:1;min-height:0!important}.mode-duo-closed-portrait .event-heading-compact,.mode-duo-closed-landscape .event-heading-compact{display:grid;grid-template-columns:minmax(0,1fr) auto;gap:6px 12px;align-items:center;padding:14px!important;margin:0!important}.mode-duo-closed-portrait .event-heading-compact .event-deck,.mode-duo-closed-landscape .event-heading-compact .event-deck{display:none}.mode-duo-closed-portrait .event-heading-compact h1,.mode-duo-closed-landscape .event-heading-compact h1{grid-column:1;grid-row:1;font-size:24px!important;line-height:1.3!important;margin:0!important}.mode-duo-closed-portrait .event-heading-compact>.pill,.mode-duo-closed-landscape .event-heading-compact>.pill{grid-column:2;grid-row:1}.mode-duo-closed-portrait .event-heading-compact>[data-event-date],.mode-duo-closed-landscape .event-heading-compact>[data-event-date]{grid-column:1;grid-row:2;margin:0!important;font-size:11px}.mode-duo-closed-portrait .event-heading-compact>.row,.mode-duo-closed-landscape .event-heading-compact>.row{display:contents}.mode-duo-closed-portrait .event-heading-compact .unlock,.mode-duo-closed-landscape .event-heading-compact .unlock{grid-column:1;grid-row:3;font-size:10px}.mode-duo-closed-portrait .event-heading-compact .secondary,.mode-duo-closed-landscape .event-heading-compact .secondary{grid-column:2;grid-row:2/4;min-height:44px;padding:6px 14px}
.page-fortune .workspace{display:block!important;overflow:hidden!important;padding:0!important}.page-fortune .workspace>.lead{position:absolute!important;left:var(--ft-tx)!important;top:var(--ft-ty)!important;width:var(--ft-tw)!important;height:var(--ft-th)!important;overflow:visible!important}.page-fortune .workspace>.detail{position:absolute!important;left:var(--ft-bx)!important;top:var(--ft-by)!important;width:var(--ft-bw)!important;height:var(--ft-bh)!important;overflow:hidden!important;min-height:0!important}.page-fortune .fortune-heading{height:100%;display:flex;flex-direction:column;align-items:center;justify-content:center;text-align:center!important;margin:0!important;padding:0!important;opacity:1!important}.page-fortune .fortune-heading h1{font-size:28px}.page-fortune .fortune-heading p{font-size:12px;line-height:1.65;margin-top:6px}.page-fortune .fortune-heading .eyebrow{font-size:10px;margin-bottom:5px}.motion-heading-sentinel{display:none!important}.page-fortune .fortune-host{height:100%!important;min-height:0!important;display:grid!important;grid-template-rows:minmax(0,1fr) var(--ft-ah);gap:0}.page-fortune .fortune-visual{height:var(--ft-vh)!important;min-height:0!important;overflow:hidden!important}.page-fortune .fortune-actions{height:var(--ft-ah);padding:8px 0 0!important;gap:6px 10px;align-content:start}.page-fortune .fortune-actions button{min-height:44px!important;height:44px!important;padding:8px 12px;font-size:12px}.page-fortune .fortune-actions .primary{min-width:0}.page-fortune .fortune-actions .hint{font-size:10px;line-height:14px}.page-fortune .fortune-host .result{position:absolute!important;inset:0!important;width:100%!important;height:100%!important;max-width:none!important;overflow:visible!important;border:0!important;padding:0!important;box-shadow:none!important;background:none!important}.page-fortune .result>img{position:absolute;left:50%;top:0;width:var(--ft-copy)!important;max-width:100%;height:100%!important;object-fit:fill;transform:translateX(-50%);border-radius:24px}.page-fortune .result-copy{position:relative!important;width:var(--ft-copy)!important;max-width:100%;height:100%;margin:0 auto;padding:var(--ft-pad)!important;display:flex;flex-direction:column;justify-content:center;overflow:visible!important;color:#4D3927}.page-fortune .result-heading{text-align:center;flex:none}.page-fortune .result-heading small{font-size:11px;color:#79634d}.page-fortune .result-heading h2{font-size:var(--ft-title)!important;line-height:1.3;margin:5px 0 0;color:#9a3924}.page-fortune .result-reading{margin-top:12px}.page-fortune .result-reading .poem{font-size:var(--ft-poem)!important;line-height:1.5!important;text-align:center;margin:0 0 14px}.page-fortune .result-reading .explain{font-size:var(--ft-body)!important;line-height:1.55!important}.page-fortune .explain section+section{margin-top:12px}.page-fortune .explain p{margin:3px 0 0;line-height:1.55!important}.page-fortune.compact-reading .result-reading{display:grid;grid-template-columns:minmax(0,.43fr) minmax(0,.57fr);align-items:center;gap:16px}.page-fortune.compact-reading .result-reading .poem{margin:0}.page-fortune.compact-reading .explain section+section{margin-top:8px}.page-fortune.compact-reading .result-heading h2{margin-top:3px}
'''
CSS+='''
/* R13 short-phone fix: reset the inherited 500px copy minimum only on these canvases. */
.mode-phone-landscape.page-fortune .fortune-host .result-copy,.mode-phone-landscape-dark.page-fortune .fortune-host .result-copy{min-height:0!important;height:var(--ft-vh)!important;max-height:var(--ft-vh)!important;position:relative!important;top:auto!important;right:auto!important;bottom:auto!important;left:auto!important;transform:none!important;padding:4px!important;row-gap:2px!important}
'''
r.b.CSS+=CSS

def page_html(page,mode,w,h,dark=False,state='',full=False):
 s=BASE_HTML(page,mode,w,h,dark,state,full)
 if page=='home' and mode=='duo-closed-landscape':
  soup=BeautifulSoup(s,'html.parser');p=r.profile(mode,w,h);cw=p['contentWidth'];ch=p['contentHeight'];col=(cw-20)/2;workspace=soup.select_one('.workspace');workspace['style']='display:block!important;padding:0!important;overflow:hidden!important'
  for selector,left in [('.lead',0),('.detail',col+20)]:workspace.select_one(selector)['style']=f'position:absolute!important;left:{left}px!important;top:0!important;width:{col}px!important;height:{ch}px!important;overflow:auto!important'
  stack=soup.select_one('.home-stack');stack['style']=f'position:relative;height:{ch}px;display:block!important';stack.select_one('.hero')['style']=f'position:absolute;left:0;top:0;width:100%;height:{ch-124}px;margin:0;display:flex;flex-direction:column;min-height:0';stack.select_one('.home-tools')['style']=f'position:absolute;left:0;top:{ch-112}px;width:100%;height:112px!important;margin:0!important';s=str(soup)
 if page=='almanac' and not mode.startswith('duo-'):
  soup=BeautifulSoup(s,'html.parser');a=soup.select_one('[data-r11-compass-link]');a.clear();a.string='值神罗盘';a['aria-label']='值神罗盘';a['title']='值神罗盘';s=str(soup)
 if page=='fortune':
  soup=BeautifulSoup(s,'html.parser');g=fortune_geometry(mode,w,h);workspace=soup.select_one('.workspace');workspace['style']='display:block!important;overflow:hidden!important;padding:0!important';workspace['data-title-layout']='side' if g['side'] else 'stack'
  for selector,rect in [('.lead',g['title']),('.detail',g['board'])]:
   node=workspace.select_one(selector);x,y,rw,rh=rect;node['style']=f'position:absolute!important;left:{x}px!important;top:{y}px!important;width:{rw}px!important;height:{rh}px!important;overflow:hidden!important'
  heading=soup.select_one('.fortune-heading');heading['class']=[x for x in heading['class'] if x!='heading']+['persistent-fortune-title']
  # Keep the frozen core's nonvisual compatibility target separate from the page title.
  sentinel=soup.new_tag('span',attrs={'class':'heading motion-heading-sentinel','aria-hidden':'true','hidden':''});heading.insert_after(sentinel)
  if fortune_geometry(mode,w,h)['compactReading']:soup.body['class'].append('compact-reading')
  if fortune_geometry(mode,w,h)['shortReading']:soup.body['class'].append('short-reading')
  soup.style.string=':root{'+fortune_vars(mode,w,h)+'}'+soup.style.string
  s=str(soup)
 return s
r.page_html=page_html
if __name__=='__main__':
 rows=r.generate()
 for mode,w,h,dark in r.MODES:
  name='compass-'+mode+'-hour';(P/(name+'.html')).write_text(page_html('compass',mode,w,h,dark,'hour'));rows.append(dict(page='compass',mode=mode,width=w,height=h,dark=dark,state='hour',full=False,file=name))
 for state in ['previous','next']:
  name='almanac-phone-light-'+state;(P/(name+'.html')).write_text(page_html('almanac','phone-light',375,930,False,state));rows.append(dict(page='almanac',mode='phone-light',width=375,height=930,dark=False,state=state,full=False,file=name))
 (P/'screens.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2));print('Generated',len(rows),'R13 screens')
