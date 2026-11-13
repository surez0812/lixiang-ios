from pathlib import Path
import json,re,html
from bs4 import BeautifulSoup
from PIL import Image
import review_r8 as old
b=old.b;P=Path(__file__).resolve().parent
MODES=[]
for mode,w,h,dark in old.MODES:
 if mode=='duo-inner-portrait-study':continue
 if mode=='duo-open-portrait':w,h=669,951
 if mode=='duo-tabletop':w,h=951,669
 MODES.append((mode,w,h,dark))
MODES.insert(7,('duo-closed-landscape',678,466,False))
PAGES={k:v for k,v in old.PAGES.items() if k!='day'};PAGES['home']='日历';PAGES['almanac']='黄历详情';b.MODES=MODES;b.PAGES=PAGES
EVENTS=old.EVENTS;COUNTS=old.COUNTS
fortune=old.fortune;SIGN=old.SIGN;STATUS_SVG=old.STATUS_SVG;system_prompt=old.system_prompt
TABS=[('home','calendar','日历'),('folklore','suishi','岁时'),('selection','selection','择日'),('countdown','countdown','倒计日'),('settings','settings','设置')]
# Shared vector family, matching the existing 28pt/1.8pt tab master.
(P/'assets/tab-icons/tab-selection.svg').write_text('<svg xmlns="http://www.w3.org/2000/svg" width="28" height="28" viewBox="0 0 28 28" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><rect x="4" y="6" width="20" height="18" rx="4"/><path d="M9 3.5v5M19 3.5v5M4 11h20M9 17l3.5 3.5L19 14"/></svg>')
for theme,rgb in [('light',(255,252,245)),('dark',(48,40,31))]:
 im=Image.new('RGBA',(4,256));pixels=im.load()
 for y in range(256):
  t=y/255;alpha=round(255*t*t*(3-2*t))
  for x in range(4):pixels[x,y]=(*rgb,alpha)
 im.save(P/f'assets/hero-fade-{theme}.png')

def link(page,mode,extra=''):return f'{"almanac" if page=="day" else page}-{mode}.html{extra}'
b.link=link;old.url=link

def profile(mode,w,h):
 split='splitview' in mode;edge='left' if mode.endswith('-left') else 'right';appw=w/2 if split else w;appx=w/2 if split and edge=='right' else 0;duo=mode.startswith('duo-');horizontal=not duo or mode in ['duo-open-portrait','duo-tabletop'];side=duo and not horizontal
 # Eight points between readable content and the floating side bar.
 cx=appx+(81 if side and edge=='left' else 20);cw=appw-(101 if side else 40)
 cy=82 if duo and horizontal else 20 if side else 48
 ch=h-cy-(100 if horizontal else 20)
 return dict(duo=duo,split=split,edge=edge,appx=appx,appw=appw,apph=h,horizontal=horizontal,side=side,contentX=cx,contentY=cy,contentWidth=cw,contentHeight=ch,tabY=h-268,statusY=24 if horizontal else 86 if mode=='duo-closed-portrait' else 34,statusVisible=mode not in ['duo-tent','duo-closed-landscape'],backY=cy+8,sideGap=8 if side else None)
old.profile=profile

def tabs(active,mode,side=False):
 out=''
 for page,asset,title in TABS:
  badge='<span class="tab-new-dot" data-badge="folklore" aria-label="有新解锁内容"></span>' if page=='folklore' else '<span class="tab-count-badge" data-badge="countdown"><b>0</b></span>' if page=='countdown' else ''
  out+=f'<a class="tab {"active" if page==active else ""}" href="{link(page,mode)}" aria-label="{title}" title="{title}">{(P/("assets/tab-icons/tab-"+asset+".svg")).read_text()}<span class="tab-title">{title}</span>{badge}</a>'
 return out
b.tabs=tabs

def hero(mode,include_matches=True):
 soup=BeautifulSoup(old.hero(mode,include_matches),'html.parser');card=soup.select_one('.hero');card.attrs.pop('data-day-url',None)
 art=soup.select_one('.hero-art');art.name='div';art.attrs.pop('href',None);art.attrs.pop('aria-label',None)
 fade=soup.new_tag('img',attrs={'class':'hero-fade','src':'assets/hero-fade-light.png','alt':''});art.append(fade)
 date_anchor=soup.select_one('.hero-copy>a:not(.quote)')
 if date_anchor:date_anchor.unwrap()
 for node in soup.select('.match-type'):
  node.string='今日岁时' if '岁时' in node.text else '今日纪念'
 return str(soup)

def month(mode):return old.month(mode).replace('day-'+mode+'.html','almanac-'+mode+'.html')

FULL_WEATHER=old.weather

def weather(state='notDetermined'):
 if state=='authorized':body='<div class="weather-symbol">☁</div><h3>8° 多云</h3><p>上海 · 轻装添衣</p>'
 elif state=='loading':body='<h3>今日天气</h3><p>正在定位城市…</p><span class="loading-dot"></span>'
 elif state=='denied':body='<h3>今日天气</h3><p>定位尚未开启</p><button class="secondary" data-location="settings">去设置</button>'
 elif state=='error':body='<h3>今日天气</h3><p>天气暂未载入</p><button class="secondary" data-location="retry">重试</button>'
 else:body='<h3>今日天气</h3><p>开启定位，看看<br>所在城市的天气</p><button class="secondary" data-location="request">开启定位</button>'
 return f'<section class="card weather compact-weather" id="weather-panel" data-weather="{state}">{body}</section>'
old.weather=weather

def shortcuts(mode,state='notDetermined'):
 return f'<div class="home-tools day-support" data-home-order="tools"><a class="card fortune-entry" href="{link("fortune",mode)}"><img src="assets/fortune-cup.png" alt="暖竹签筒"><h3>每日一签</h3><small>静心，问今日　›</small></a>{weather(state)}</div>'
b.shortcuts=shortcuts

def era_rows(huangdi,tao,foto):
 rows=[('黄帝纪元 · 道历纪元',huangdi)] if huangdi==tao else [('黄帝纪元',huangdi),('道历纪元',tao)]
 return ''.join(f'<div class="era-row"><span>{name}</span><b>{value} 年</b></div>' for name,value in rows+[('佛历纪元',foto)])

def matched_events(date):return [e for e in EVENTS if e['date']==date]
def matched_panel(mode,date):
 hits=matched_events(date)
 if not hits:return ''
 return '<section class="card matched-festivals" data-date="'+date+'"><div class="eyebrow">这一天的文化与习俗</div><h2>当日岁时</h2><div class="matched-event-list">'+''.join(f'<a href="{link("folklore-detail",mode,"?event="+e["id"])}" data-matched-event="{e["id"]}"><span><b>{html.escape(e["title"])}</b><small>{e["category"]}</small></span><span>›</span></a>' for e in hits)+'</div></section>'

def almanac(mode,state=''):
 lead,detail=old.prior.almanac();soup=BeautifulSoup(lead,'html.parser');eras=soup.select_one('.eras');eras.clear();eras.append(BeautifulSoup('<div class="eyebrow">历法纪年</div>'+era_rows(4723,old.prior.D['taoYear'],old.prior.D['fotoYear']),'html.parser'))
 card=soup.select_one('#plain-toggle').find_parent('section',class_='card');expanded=soup.new_tag('div',attrs={'class':'activities-expanded'})
 for node in list(card.select('.activity-heading,.activity-row')):expanded.append(node.extract())
 summary=BeautifulSoup('<div class="activities-summary" aria-label="宜忌摘要"><div class="summary-item"><b class="green">宜</b><p>'+'　'.join(old.prior.D['yi'])+'</p></div><div class="summary-item"><b class="red">忌</b><p>'+'　'.join(old.prior.D['ji'])+'</p></div></div>','html.parser')
 card.append(summary);card.append(expanded)
 date='2026-11-13' if state=='no-festival' else '2026-11-22' if state=='winter' else '2026-11-12'
 # The target date owns the match list; it is never a "nearest festival" recommendation.
 slot=soup.new_tag('div',attrs={'id':'matched-festival-slot'});slot.extend(BeautifulSoup(matched_panel(mode,date),'html.parser').contents);card.insert_after(slot)
 if state=='plain-off':soup.select_one('#plain-toggle')['aria-checked']='false'
 return str(soup),detail

BASE_CONTENT=old.content

def content(page,mode,state=''):
 if page=='home':
  weather_state=state.replace('weather-','') if state.startswith('weather-') else 'notDetermined'
  hero_markup=hero(mode,state!='no-matches');tools=shortcuts(mode,weather_state);teaser=old.prior.teaser(mode).replace('<span class="crest">历</span>','')
  dims=next((v for v in MODES if v[0]==mode),None)
  if dims and dims[1]>dims[2] and profile(mode,dims[1],dims[2])['appw']>=600:
   return '<div class="home-stack">'+hero_markup+tools+'</div>',teaser+month(mode)
  return '<div class="home-stack">'+hero_markup+tools+teaser+'</div>',month(mode)
 if page=='almanac':return almanac(mode,state)
 return BASE_CONTENT(page,mode,state)
b.content=content

CSS='''
.compact-weather .secondary{box-sizing:border-box!important;width:100%!important;max-width:100%!important;min-width:0!important;white-space:normal!important;justify-content:center!important}.home-tools>.card{overflow:hidden}.home-tools .fortune-entry small{font-size:11px}.has-back .lead>.card:first-child .eyebrow{padding-left:0}.horizontal-duo .tabs{margin-left:auto!important;margin-right:auto!important}

.top,.duo-header{display:none!important}.r8-app .workspace{position:absolute!important;left:var(--cx)!important;top:var(--cy)!important;width:var(--cw)!important;height:var(--ch)!important;padding:0!important;overflow:auto;display:block!important}.r8-app .workspace>.lead,.r8-app .workspace>.detail{overflow:visible!important}.page-home .workspace{display:block!important}.home-tools{display:grid!important;grid-template-columns:minmax(0,1fr) minmax(0,1fr);gap:12px;align-items:stretch}.home-tools>.card{margin:0;padding:16px;min-width:0;min-height:150px}.home-tools .fortune-entry{display:flex;flex-direction:column;align-items:flex-start;justify-content:center;gap:7px}.home-tools .fortune-entry img{height:47px;width:22px;object-fit:contain}.home-tools h3{font-size:15px}.home-tools .compact-weather{display:flex;flex-direction:column;align-items:flex-start;justify-content:center;gap:5px}.compact-weather p{font-size:12px;line-height:1.7;margin:0}.compact-weather .secondary{min-height:40px;font-size:12px;padding:8px 12px}.compact-weather .weather-symbol{font-size:26px;color:var(--gold)}.today-matches{display:flex;flex-wrap:wrap;gap:8px;border:0!important;margin-top:10px}.today-match{flex:1 1 126px;min-height:44px;border:0!important;padding:6px 8px;background:var(--wash);border-radius:14px;gap:5px}.today-match b{font-size:12px;white-space:nowrap}.today-match .match-type{font-size:9px;white-space:nowrap}.hero-art{position:relative;overflow:hidden}.hero-art:after{display:none!important}.hero-fade{position:absolute;display:block;left:0;bottom:-1px;width:100%!important;height:60%!important;object-fit:fill!important;pointer-events:none}.dark .hero-fade{content:url(assets/hero-fade-dark.png)}.hero-copy{margin-top:-26px}.hero-copy h2{position:relative}.tab{width:18.5%;padding:7px 4px}.tabs{max-width:600px}.tab svg{width:23px;height:23px}.tab-title{font-size:10px}.tab-count-badge{background:#FF3B30!important;color:#FFF!important;border:0!important;min-width:18px;height:18px;padding:0 5px;border-radius:10px;right:13%;top:2px;line-height:18px}.tab-count-badge b{font-size:11px;line-height:18px;font-weight:600}.tab-count-badge i{display:none!important}.floating-tabs{height:252px;top:var(--taby)}.floating-tabs .tab{height:48px;min-height:48px;width:44px;padding:11px 9px}.floating-tabs .tab-count-badge{top:0;right:-3px}.floating-back{position:absolute;left:calc(var(--cx) + 8px);top:calc(var(--cy) + 8px);width:44px;height:44px;z-index:25;border-radius:50%;display:grid;place-items:center;background:var(--glass);border:1px solid var(--line);backdrop-filter:blur(18px);box-shadow:inset 0 1px 1px #fff9,0 4px 14px #50381913;font-size:25px}.has-back .lead>.card:first-child,.has-back .lead>.feature:first-child{padding-top:64px}.has-back .lead>.native-event-head{padding-top:64px}.page-fortune.has-back .fortune-heading{padding-left:52px;padding-right:12px}.horizontal-duo .duo-status{top:24px;right:24px;left:auto;width:116px;display:flex;align-items:center;gap:9px}.horizontal-duo .duo-status time{width:60px;font-size:15px;white-space:nowrap}.horizontal-duo .duo-status svg{width:47px;height:44px;flex:none}.horizontal-duo .tabs{display:flex!important;bottom:16px;left:20px;right:20px;max-width:600px}.horizontal-duo .tab-title{display:block}.horizontal-duo .floating-tabs{display:none}.portrait .lead .hero,.r8-banner{display:block;height:auto}.portrait .lead .hero-art{height:220px}.portrait .lead .hero-copy{width:auto;margin-top:-26px;padding:0 18px 18px}.r8-app .hero-art{height:var(--hero-height)!important}.era-row span{max-width:75%;line-height:1.6}.activities-summary{display:none}.plain-off .activities-summary{display:block}.plain-off .activities-expanded{display:none}.summary-item{display:grid;grid-template-columns:28px minmax(0,1fr);gap:10px;align-items:start;margin:14px 0}.summary-item>b{font-size:16px;line-height:1.9;text-align:center}.summary-item p{font-size:14px;line-height:1.9;overflow-wrap:anywhere}.matched-event-list>a{display:flex;justify-content:space-between;gap:12px;align-items:center;min-height:64px;padding:12px 0;border-bottom:1px solid var(--line)}.matched-event-list>a:last-child{border-bottom:0}.matched-event-list small{display:block;font-size:11px;margin-top:3px}.matched-festivals h2{margin-bottom:8px}.page-home.duo-wide .workspace,.page-home.wide .workspace{display:grid!important;grid-template-columns:minmax(0,1.05fr) minmax(0,1fr)!important;gap:20px}.page-home.duo-wide .workspace>.lead,.page-home.duo-wide .workspace>.detail,.page-home.wide .workspace>.lead,.page-home.wide .workspace>.detail{overflow:auto!important}.page-home .almanac-teaser{margin-top:15px}.fullscroll .workspace{position:relative!important;left:auto!important;top:auto!important;width:auto!important;height:auto!important;padding:48px 20px 20px!important;display:block!important}.fullscroll .r8-app{position:relative;height:auto}.fullscroll .r8-device{height:auto}.fullscroll .floating-back{top:54px}.page-almanac.duo-wide .workspace,.page-almanac.wide .workspace{display:grid!important;grid-template-columns:minmax(0,1fr) minmax(0,1fr);gap:20px}.page-fortune .workspace{display:flex!important;flex-direction:column}.page-fortune.duo-wide .workspace,.page-fortune.wide .workspace{display:grid!important;grid-template-columns:minmax(160px,.65fr) minmax(0,1.4fr)!important;gap:24px}.page-fortune .detail{overflow:hidden!important;flex:1;min-height:0}.page-fortune .lead{flex:none}.page-folklore-detail .workspace{overflow:hidden!important;display:flex!important;flex-direction:column}.page-folklore-detail .detail{flex:1;min-height:0;overflow:hidden!important}.page-folklore-detail.duo-wide .workspace,.page-folklore-detail.wide .workspace{display:grid!important;grid-template-columns:minmax(220px,.65fr) minmax(0,1.8fr)!important;gap:20px}.page-home .month-grid .cell{height:51px!important}@media(prefers-reduced-transparency:reduce){.floating-back,.tabs,.floating-tabs{background:var(--paper)!important;backdrop-filter:none}}
'''
b.CSS+=CSS
# Calendar taps must always navigate, including iPad. Old swipe/date-selection behavior is retired.
old.BASE_JS=old.BASE_JS.replace('&&MODE_IS_IPAD','&&false')
SCRIPT='''
const R9_MATCHES=R9_EVENT_DATA;let selectedAlmanacDate=new URLSearchParams(location.search).get('date')||DEFAULT_MATCH_DATE;
let slot=document.getElementById('matched-festival-slot');if(slot){let events=R9_MATCHES.filter(e=>e.date===selectedAlmanacDate);slot.innerHTML=events.length?'<section class="card matched-festivals"><div class="eyebrow">'+selectedAlmanacDate+'</div><h2>当日岁时</h2><div class="matched-event-list">'+events.map(e=>'<a data-matched-event="'+e.id+'" href="'+FESTIVAL_DETAIL_URL+'?event='+e.id+'"><span><b>'+e.title+'</b><small>'+e.category+'</small></span><span>›</span></a>').join('')+'</div></section>':''}
qa('.hero-fade').forEach(im=>im.src=document.body.classList.contains('dark')?'assets/hero-fade-dark.png':'assets/hero-fade-light.png');
'''

def page_html(page,mode,w,h,dark=False,state='',full=False):
 prof=profile(mode,w,h);wide=prof['appw']>=600 and w>h;roots=['home','folklore','selection','countdown','settings'];back=page not in roots
 cls=('dark ' if dark else '')+('duo ' if prof['duo'] else '')+('duo-wide ' if wide and prof['duo'] else 'wide ' if wide else '')+('horizontal-duo ' if prof['duo'] and prof['horizontal'] else '')+('edge-left ' if prof['edge']=='left' else '')+('has-back ' if back else '')+('fullscroll ' if full else '')+'page-'+page
 lead,detail=content(page,mode,state)
 if dark:lead=lead.replace('hero-fade-light.png','hero-fade-dark.png')
 if page=='fortune':lead=lead.replace('fortune-heading','fortune-heading heading')
 if page=='folklore-detail' and state not in ['offline','loading']:
  detail=f'<iframe class="article-frame" src="webpages/{"daily-kindness" if state=="today" else "winter"}.html" title="岁时文章正文" data-owner="web"></iframe>'
 active='folklore' if page.startswith('folklore') else 'countdown' if page.startswith('countdown') else page if page in ['selection','settings'] else 'home'
 status=('<div class="duo-status" aria-label="模拟系统状态"><time>09:41</time>'+old.STATUS_SVG+'</div>') if prof['duo'] and prof['statusVisible'] else '<div class="status"><span>9:41</span><span>●●●　▰</span></div>' if not prof['duo'] else ''
 nav='<nav class="'+('tabs' if prof['horizontal'] else 'floating-tabs')+'" aria-label="主导航">'+tabs(active,mode,not prof['horizontal'])+'</nav>'
 parent='folklore' if page=='folklore-detail' else 'countdown' if page=='countdown-detail' else 'home'
 controls=f'<a class="floating-back" href="{link(parent,mode)}" aria-label="返回">‹</a>' if back else ''
 body=f'<div class="r8-app">{status}<main class="workspace"><section class="lead">{lead}</section><section class="detail">{detail}</section></main>{controls}{nav}<div class="modal" role="dialog" aria-modal="true"><section class="card"><button class="glass close" id="close-modal" aria-label="关闭">×</button><div id="modal-body"></div></section></div><div class="toast" role="status"></div></div>'
 neighbor='<aside class="split-companion" aria-label="另一App示意">另一 App</aside>' if prof['split'] else ''
 review='<section class="review-only"><div class="review-controls"><button id="replay">回到待机</button><label><input id="reduce" type="checkbox">减少动态效果</label><input id="timeline" type="range" min="0" max="1450" value="0"><span id="time-label">0ms</span><span class="phase">待机</span></div></section>' if page=='fortune' else ''
 variables=f'--w:{w}px;--h:{h}px;--appw:{prof["appw"]}px;--appx:{prof["appx"]}px;--cx:{prof["contentX"]-prof["appx"]}px;--cw:{prof["contentWidth"]}px;--cy:{prof["contentY"]}px;--ch:{prof["contentHeight"]}px;--taby:{prof["tabY"]}px;--statusy:{prof["statusY"]}px;--hero-height:{270 if mode.startswith("ipad-landscape") else 210 if mode.startswith("ipad-portrait") else 155}px;--neighborx:{"0" if mode.endswith("right") else "50%"};'
 script=old.scripts(page,mode,state)+'\n'+SCRIPT.replace('R9_EVENT_DATA',json.dumps(EVENTS,ensure_ascii=False)).replace('DEFAULT_MATCH_DATE',json.dumps('2026-11-13' if state=='no-festival' else '2026-11-22' if state=='winter' else '2026-11-12')).replace('FESTIVAL_DETAIL_URL',json.dumps(link('folklore-detail',mode)))

 if page=='fortune' and state=='result':script+='\nrenderAt(1450);'
 return '<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>历象 · '+PAGES[page]+'</title><style>:root{'+variables+'}'+b.CSS+'</style><body class="'+cls+'"><div class="r8-device device'+(' plain-off' if state=='plain-off' else '')+'">'+neighbor+body+'</div>'+review+'<p class="review-only">设计原型：数据为2026-11-12样本；权限及系统栏为示意，未运行真实系统接口。</p><script>'+script+'</script></body></html>'

def generate():
 rows=[]
 def add(page,mode,w,h,dark,state='',full=False):
  name=f'{page}-{mode}'+('-'+state if state else '')+('-full' if full else '')
  (P/(name+'.html')).write_text(page_html(page,mode,w,h,dark,state,full));rows.append(dict(page=page,mode=mode,width=w,height=h,dark=dark,file=name,state=state,full=full))
 for page in PAGES:
  for mode,w,h,dark in MODES:add(page,mode,w,h,dark)
 for mode,w,h,dark in MODES:
  add('fortune',mode,w,h,dark,'result');add('almanac',mode,w,h,dark,'plain-off')
 for page,state in [('home','no-matches'),('home','weather-authorized'),('home','weather-denied'),('home','weather-loading'),('almanac','no-festival'),('almanac','winter'),('folklore-detail','today'),('folklore-detail','offline'),('countdown-detail','new'),('countdown-detail','preprompt'),('countdown-detail','system-prompt'),('countdown-detail','allowed'),('countdown-detail','denied')]:add(page,'phone-light',375,930,False,state)
 for page,h,state in [('home',2500,''),('almanac',12000,''),('almanac',6500,'plain-off'),('daily',1650,''),('folklore-detail',2400,'')]:add(page,'phone-light',375,h,False,state,True)
 (P/'screens.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2));return rows
if __name__=='__main__':print('Generated',len(generate()),'R9 screens')
