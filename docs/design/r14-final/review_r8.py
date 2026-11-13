from pathlib import Path
import json,re,html,hashlib
from bs4 import BeautifulSoup
import review_r7 as prior
b=prior.b;P=Path(__file__).resolve().parent
BASE_CONTENT=prior.content;BASE_HERO=prior.hero
MODES=[('phone-light',375,930,False),('phone-dark',375,930,True),('ipad-portrait',834,1194,False),('ipad-portrait-dark',834,1194,True),('ipad-landscape',1194,834,False),('ipad-landscape-dark',1194,834,True),('duo-closed-portrait',466,678,False),('duo-tent',678,466,False),('duo-open-portrait',951,669,False),('duo-open-landscape',951,669,False),('duo-tabletop',466,678,False),('duo-splitview-left',951,669,False),('duo-splitview-right',951,669,False),('duo-inner-portrait-study',669,951,False)]
b.MODES=MODES
PAGES={k:v for k,v in b.PAGES.items() if k!='compass'}
PAGES.update({'folklore-detail':'岁时详情','countdown-detail':'纪念日详情','fortune':'每日一签'})
b.PAGES=PAGES
EVENTS=[{'id':'daily-kindness','days':0,'title':'静心行善','category':'民俗科仪','desc':'从一件小善事，开始今天。','date':'2026-11-12','version':'1','unread':False},{'id':'winter','days':10,'title':'小雪','category':'传统节日','desc':'看节令变化，读冬日习俗。','date':'2026-11-22','version':'1','unread':True},{'id':'xiayuan','days':11,'title':'下元节','category':'道历节日','desc':'读节日来由，了解传统习俗。','date':'2026-11-23','version':'1','unread':False}]
COUNTS=[{'id':'anniversary-today','days':0,'title':'结婚纪念日','date':'2026-11-12','calendar':'公历','repeat':'每年','time':'09:00'},{'id':'family-birthday','days':3,'title':'家人生日','date':'2026-11-15','calendar':'公历','repeat':'每年','time':'09:00'}]
FIXTURE={'date':'2026-11-12','time':'09:41','pillars':{'year':'丙午','month':'己亥','day':'庚寅','hour':'辛巳'},'events':EVENTS,'countdowns':COUNTS,'weather':'notDetermined','notification':'notDetermined'}
b.EVENTS=EVENTS

def url(page,mode,extra=''):return f'{page}-{mode}.html{extra}'
def profile(mode,w,h):
 split='splitview' in mode;left=mode.endswith('-left');appw=w/2 if split else w;appx=w/2 if split and not left else 0;duo=mode.startswith('duo-');edge='left' if split and left else 'right'
 return dict(duo=duo,split=split,edge=edge,appx=appx,appw=appw,apph=h,contentX=(appx+104 if duo and edge=='left' else appx+20),contentY=72 if duo else 104,contentWidth=appw-(124 if duo else 40),contentHeight=h-(94 if duo else 196),tabY=172 if mode=='duo-tent' else h-236 if mode in ['duo-closed-portrait','duo-tabletop'] else h-236,statusY=86 if mode in ['duo-closed-portrait','duo-tabletop'] else 34,statusVisible=mode!='duo-tent',backY=34 if mode=='duo-tent' else 174 if mode in ['duo-closed-portrait','duo-tabletop'] else 122)

def tabs(active,mode,side=False):
 names=[('home','calendar','日历'),('folklore','suishi','岁时'),('countdown','countdown','倒计日'),('settings','settings','设置')]
 out=''
 for page,asset,label in names:
  badge='<span class="tab-new-dot" data-badge="folklore" aria-label="有新解锁内容"></span>' if page=='folklore' else '<span class="tab-count-badge" data-badge="countdown"><i></i><b>0</b></span>' if page=='countdown' else ''
  out+=f'<a class="tab {"active" if page==active else ""}" href="{url(page,mode)}" aria-label="{label}" title="{label}">{(P/("assets/tab-icons/tab-"+asset+".svg")).read_text()}<span class="tab-title">{label}</span>{badge}</a>'
 return out
b.tabs=tabs

def hero(mode,include_matches=True):
 matches=''
 if include_matches:
  for e in EVENTS:
   if e['days']==0:matches+=f'<a class="today-match" data-today-event="{e["id"]}" href="{url("folklore-detail",mode,"?event="+e["id"])}"><span class="match-type">岁时 · 今日</span><b>{html.escape(e["title"])}</b><span>›</span></a>'
  for e in COUNTS:
   if e['days']==0:matches+=f'<a class="today-match" data-today-count="{e["id"]}" href="{url("countdown-detail",mode,"?id="+e["id"])}"><span class="match-type">纪念日 · 今日</span><b>{html.escape(e["title"])}</b><span>›</span></a>'
 if matches:matches='<div class="today-matches">'+matches+'</div>'
 art_height=390 if mode.startswith('ipad-portrait') else 270 if mode.startswith('ipad-landscape') else 155
 return f'''<section class="card hero" data-day-url="{url('day',mode)}"><a class="hero-art" style="height:{art_height}px" href="{url('day',mode)}" aria-label="查看今日单日详情"><span class="term">立冬 · 二候 地始冻</span></a><div class="hero-copy"><a href="{url('day',mode)}"><h2>2026年11月12日 · 星期四</h2><small>农历十月初四</small><p class="ganzhi" data-pillars="complete">丙午年　己亥月　庚寅日<br><span>巳时 · 辛巳时　09:41</span></p></a>{matches}<a class="quote" href="{url('daily',mode)}" aria-label="阅读今日经文解释与分享卡"><p>上善若水，<br>水善利万物而不争。</p><small>《道德经》第八章 · 王弼本　读解释与分享 ›</small></a></div></section>'''

def month(mode):
 dom=BeautifulSoup(prior.month(mode),'html.parser')
 for cell in dom.select('.cell'):
  mark=cell.select_one('.dot');star=cell.select_one('.ann-star')
  marks=dom.new_tag('span',attrs={'class':'calendar-marks','aria-hidden':'true'})
  if mark:marks.append(mark.extract())
  if star:marks.append(star.extract())
  cell.append(marks)
 return str(dom)

def weather(state='notDetermined'):
 if state=='authorized':return '<section class="card weather" id="weather-panel" data-weather="authorized"><div class="weather-sky">☁</div><div><h3>8° 多云</h3><p>上海 · 轻装添衣</p><small>已定位 · 今天 09:40 更新</small></div></section>'
 if state=='loading':return '<section class="card weather" id="weather-panel" data-weather="loading"><div><h3>正在找今天的天气…</h3><p>已允许定位，正在获取所在城市。</p></div><span class="loading-dot"></span></section>'
 if state=='denied':return '<section class="card weather" id="weather-panel" data-weather="denied"><div><h3>天气，等你选择一座城</h3><p>定位尚未开启。你仍可继续使用历象。</p><button class="secondary" data-location="settings">前往设置</button></div></section>'
 if state=='error':return '<section class="card weather" id="weather-panel" data-weather="error"><div><h3>天气暂时没有送达</h3><p>城市已找到，稍后再试一次。</p><button class="secondary" data-location="retry">重新获取</button></div></section>'
 return '<section class="card weather" id="weather-panel" data-weather="notDetermined"><div><div class="eyebrow">你所在的城市，也有今日气象</div><h3>开启定位，看看今天的天气</h3><p>仅在使用时获取位置，用于显示所在城市天气。</p><button class="secondary" data-location="request">使用当前位置</button><small>暂不开启，也可以继续使用其他功能。</small></div></section>'

def shortcuts(mode,state='notDetermined'):
 return f'<div class="day-support"><a class="card fortune-entry" href="{url("fortune",mode)}"><img src="assets/fortune-cup.png" alt="暖竹签筒"><div><h3>每日一签</h3><small>静心，问今日　›</small></div></a>{weather(state)}</div>'
b.shortcuts=shortcuts

def folklore_list(mode):
 lead=b.feature('岁时有约','未到来的日子，也值得期待。','<h2>小雪 · 新内容已解锁</h2><small>还有10天，先读一段冬日故事。</small>')
 lead+='<div class="segmented">'+''.join(f'<button data-category="{t}" class="{"active" if i==0 else ""}">{t}</button>' for i,t in enumerate(['全部','传统节日','道历节日','佛历节日','民俗科仪']))+'</div>'
 detail=''
 for e in EVENTS:
  if e['days']<0:continue
  unlocked=e['days']<=10;label='今日' if e['days']==0 else '还有 '+str(e['days'])+' 天';target=url('folklore-detail',mode,'?event='+e['id']) if unlocked else '#'
  detail+=f'<a class="card event" id="{e["id"]}" data-category="{e["category"]}" href="{target}" {"data-locked-event" if not unlocked else "data-open-event"}="{e["id"]}"><div class="event-date"><small>11月</small><b>{e["date"][-2:]}</b><small>{label}</small></div><div class="event-content"><div class="row"><h3>{e["title"]}</h3><span class="{"unlock" if unlocked else "lock"}">{"新解锁" if e["unread"] else "已解锁" if unlocked else "未解锁"}</span></div><p>{e["desc"]}</p><span class="pill">{e["category"]}</span></div><span>›</span></a>'
 return lead,detail

def article_body(event_id='winter'):
 if event_id=='daily-kindness':
  title='把善意，放进今天';intro='不必等一个特别的时刻。整理一处小角落，认真回应一句话，也可以是今天的小小仪式。';sections=[('先把心安顿下来','找一个安静的位置，把手边的事暂时放下。给自己三次缓慢呼吸的时间。'),('做一件具体的小事','从自己能做到的事开始：扶稳一扇门，听完一次倾诉，或把公共空间整理干净。'),('把这份善意带回日常','不必记录成绩，也无需追求回报。明天想起时，再做一件小事。')]
 else:
  title='小雪将至，把日子过暖';intro='“小雪”说的是节令里的寒意渐深，并不意味着每个地方都会下雪。窗边添一件衣，桌上留一盏暖茶，冬天就有了亲切的样子。';sections=[('读懂这个节令','小雪是二十四节气之一，接续立冬，标志着天气进一步转冷。南北各地的气候不同，习俗也各有来处。'),('冬日里的家常习俗','有些地方会在此时腌菜、晒鱼干、做糍粑，为冬日储备风味。选择熟悉的一样，和家人聊一聊它的来历。'),('给今天留一个小仪式','整理一处冬衣收纳；为家人添一杯热饮；在傍晚散步时，留意树影与风声的变化。')]
 return '<article class="web-article" data-owner="web"><img class="web-hero" src="assets/winter.webp" alt="冬日庭院、雪意与灯笼"><div class="web-prose"><p class="web-kicker">一段来由 · 一点日常</p><h2>'+title+'</h2><p class="web-intro">'+intro+'</p>'+''.join('<section><h3>'+a+'</h3><p>'+c+'</p></section>' for a,c in sections)+'<aside class="web-note">各地习俗不尽相同，可以选择适合自己、愿意参与的方式。</aside><footer><h3>延伸阅读</h3><p>二十四节气与地方民俗资料。此页为设计样本，正式发布时由编辑补充具体来源及链接。</p><small>内容样本 · 更新于2026年11月12日</small></footer></div></article>'

def folklore_detail(mode,state=''):
 e=EVENTS[0] if state=='today' else EVENTS[1]
 lead=f'<section class="card native-event-head" data-owner="native"><span class="pill">{e["category"]}</span><h1>{e["title"]}</h1><p>2026年11月{e["date"][-2:]}日</p><div class="row"><span class="unlock">{"今日" if e["days"]==0 else "还有10天"} · 已解锁</span><button class="secondary" data-share-event="{e["id"]}">分享</button></div></section>'
 if state=='loading':detail='<section class="card article-state" data-owner="native"><h2>正在打开这段岁时…</h2><div class="skeleton"></div></section>'
 elif state=='offline':detail='<section class="card article-state" data-owner="native"><h2>先把这段岁时留在这里</h2><p>网络暂时没有连接，恢复后就能阅读正文。</p><button class="secondary" data-retry-article>重新加载</button></section>'
 elif state=='cached':detail='<p class="hint" data-owner="native">当前阅读已保存的内容，联网后将检查更新。</p>'+article_body(e['id'])
 else:detail=article_body(e['id'])
 return lead,detail

def countdown_list(mode):
 lead=b.feature('把重要的日子，放在心上','今天，也值得好好纪念。','<h2>结婚纪念日 · 就是今天</h2>')+f'<button class="primary" data-new-count>记下一个日子</button>'
 detail='<div id="countdown-list">'
 for e in COUNTS:
  detail+=f'<a class="card count-item" href="{url("countdown-detail",mode,"?id="+e["id"])}"><div class="row"><h2>{e["title"]}</h2><span class="count-days">{"今天" if e["days"]==0 else str(e["days"])+"天后"}</span></div><p>{e["date"]} · {e["calendar"]} · {e["repeat"]}</p><small>提醒 {e["time"]}　·　App内提醒已开启　›</small></a>'
 return lead,detail+'</div><section class="card"><h3>提醒按你的选择到来</h3><p class="hint">允许通知后，历象会在设定的时间提醒你。暂不允许，也会在App内展示临近的日子。</p></section>'

def count_form():return '<section class="card"><h2>记下一个日子</h2><form id="anniversary-form" class="form"><label>名称<input name="title" value="家人生日" required></label><label>日期<input name="date" type="date" value="2026-11-15" required></label><label>历法<select name="calendar"><option>公历</option><option>农历</option></select></label><label>重复<select name="repeat"><option>每年</option><option>不重复</option></select></label><label>提醒时间<input name="time" type="time" value="09:00" required></label><p class="hint">保存后，你可以选择是否开启系统通知；App内提醒始终保留。</p><button class="primary">保存纪念日</button></form></section>'

def count_detail(mode,state=''):
 e=COUNTS[0] if state=='today' else COUNTS[1]
 lead='<section class="card count-feature" data-owner="native"><div class="eyebrow">记住一个日子，也记住一份心意</div><h1 data-count-title>'+e['title']+'</h1><div class="bigcount" data-count-days>'+('就是今天' if e['days']==0 else str(e['days'])+' <small>天后</small>')+'</div><p data-count-date>'+e['date']+' · 公历</p><small>每年重复</small></section>'
 if state=='new':return lead,count_form()
 status='系统通知已开启 · 提醒已安排' if state=='allowed' else '系统通知未开启 · App内仍会提醒' if state=='denied' else 'App内提醒已开启'
 detail='<section class="card"><h2>这一份提醒</h2><div class="list-row"><span>提醒时间</span><b>09:00</b></div><div class="list-row"><span>重复</span><b>每年</b></div><p class="permission-status" id="notification-status">'+status+'</p><button class="primary" data-notification="explain">'+('管理提醒' if state=='allowed' else '前往设置' if state=='denied' else '开启系统提醒')+'</button><p class="hint">拒绝通知不会删除纪念日，也不会关闭App内提醒。</p></section><section class="card"><h3>让每一次相聚，有一点期待</h3><p class="hint">距离十天以内，倒计日tab会显示临近天数。当天也会出现在今日Hero里。</p></section>'
 if state=='preprompt':detail=notification_explanation()
 if state=='system-prompt':detail=system_prompt('notification')
 return lead,detail

def notification_explanation():return '<section class="card permission-intro"><div class="eyebrow">日子已记下</div><h2>让提醒，在你需要时到来</h2><p>允许通知后，即使没有打开历象，也能收到你设定的纪念日提醒。</p><button class="primary" data-notification="request">开启系统提醒</button><button class="secondary" data-notification="later">暂时只在App内提醒</button></section>'
def system_prompt(kind):
 location=kind=='location';title='“历象”想使用您的位置' if location else '“历象”想给您发送通知';body='您的位置将用于显示所在城市的天气。' if location else '通知可能包括提醒、声音和标记。您可以在设置中配置。'
 return f'<section class="card system-prompt" role="group" aria-label="系统权限弹窗示意"><h3>{title}</h3><p>{body}</p><div><button data-permission="{kind}" data-result="allowed">{"使用App时允许" if location else "允许"}</button><button data-permission="{kind}" data-result="denied">不允许</button></div></section>'

# Approved motion core is reused verbatim; only the responsive host changes.
fortune_html=(P/'approved-r7/fortune-demo.html').read_text()
FORTUNE_CORE=re.search(r'<script>([\s\S]*?)</script>',fortune_html)[1]
FORTUNE_CSS=re.search(r'<style>([\s\S]*?)</style>',fortune_html)[1]
fortune_dom=BeautifulSoup(fortune_html,'html.parser')
STAGE=str(fortune_dom.select_one('.stage'));RESULT=str(fortune_dom.select_one('.result'))
SIGN=json.loads((P/'assets/fortune-samples.json').read_text())['signs'];SIGN=next(x for x in SIGN if x['no']==36)
def fortune(mode,state=''):
 lead='<section class="fortune-heading"><div class="eyebrow">给心，留一点空</div><h1>每日一签</h1><p>先安静片刻，再与今天相遇。</p></section>'
 result=BeautifulSoup(RESULT,'html.parser');result.select_one('#sign-no').string='第36签 · 上上';result.select_one('#sign-title').string=SIGN['title'];result.select_one('#poem').clear()
 for i,line in enumerate(SIGN['poem']):
  if i:result.select_one('#poem').append(result.new_tag('br'))
  result.select_one('#poem').append(line)
 result.select_one('#explain').string=SIGN['explain'];result.select_one('#advice').string=SIGN['advice']
 detail='<section class="fortune-host" data-final-motion="r7"><div class="fortune-visual"><div class="figure-scale">'+STAGE+'</div>'+str(result)+'</div><div class="fortune-actions"><button class="primary" id="draw">轻摇，遇见今日一签</button><button class="secondary" id="skip">跳过动画</button><p class="hint">同一天，保留同一结果。</p></div></section>'
 return lead,detail

def content(page,mode,state=''):
 if page in ['home','day']:
  weather_state=state.replace('weather-','') if state.startswith('weather-') else 'notDetermined'
  if mode.startswith('ipad-'):
   if 'landscape' in mode:
    return '<div class="overview-day"><div>'+hero(mode,state!='no-matches')+'</div><div>'+prior.teaser(mode)+'<div class="overview-support">'+b.seasons(mode)+'</div></div></div>',month(mode)+'<div class="ipad-compact-tools">'+shortcuts(mode,weather_state)+'</div>'
   return hero(mode,state!='no-matches'),'<div class="portrait-daygrid"><div class="calendar-column">'+month(mode)+'</div><div>'+prior.teaser(mode)+shortcuts(mode,weather_state)+'</div><div>'+b.seasons(mode)+'</div></div>'
  if page=='home':return hero(mode,state!='no-matches'),month(mode)
  return hero(mode,state!='no-matches')+shortcuts(mode,weather_state),prior.teaser(mode)+b.seasons(mode)
 if page=='folklore':return folklore_list(mode)
 if page=='folklore-detail':return folklore_detail(mode,state)
 if page=='countdown':return countdown_list(mode)
 if page=='countdown-detail':return count_detail(mode,state)
 if page=='fortune':return fortune(mode,state)
 if page=='settings':
  lead,detail=BASE_CONTENT(page,mode,state);lead=lead.replace('id="pref-summary"','id="brand-summary"').replace('每日一句 · 道经','每日一句 · 唤心')
  return lead,detail
 return BASE_CONTENT(page,mode,state)
b.content=content

CSS='''
.hero-copy{padding-bottom:16px}.ganzhi{font-size:12px;line-height:1.7;color:var(--muted);margin-top:5px}.ganzhi span{font-size:11px}.today-matches{margin-top:11px;border-top:1px solid var(--line)}.today-match{display:flex;align-items:center;gap:8px;font-size:12px;min-height:44px;border-bottom:1px solid var(--line)}.today-match b{font-size:12px;flex:1;font-weight:500}.match-type{font-size:10px;color:var(--red)}.hero .quote{margin-top:12px;padding:12px 14px}.hero .quote p{font-size:19px}.calendar-marks{display:flex;align-items:center;justify-content:center;gap:3px;position:absolute;left:0;right:0;bottom:3px;height:7px;pointer-events:none}.month-grid .cell{height:51px!important;padding-top:3px;line-height:1.4}.month-grid .cell small{font-size:9px;line-height:1.5;white-space:nowrap}.month-grid .calendar-marks .dot{position:static!important;display:block;width:3px;height:3px;margin:0!important}.month-grid .calendar-marks .ann-star{position:static!important;font-size:8px;line-height:7px}.tab{position:relative}.tab-new-dot{position:absolute;right:22%;top:5px;width:6px;height:6px;border-radius:50%;background:#C94430;border:1px solid var(--paper)}.tab-count-badge{position:absolute;right:9%;top:2px;min-width:20px;height:15px;padding:0 4px;display:flex;align-items:center;justify-content:center;gap:2px;background:var(--paper);border:1px solid #C94430;border-radius:10px;color:#C94430;font-size:9px;line-height:13px}.tab-count-badge i{width:3px;height:3px;border-radius:50%;background:#C94430}.tab-count-badge b{font-size:9px;font-weight:600}.day-support{display:grid;gap:12px;margin-bottom:15px}.day-support>.card{margin:0}.fortune-entry{display:flex;gap:14px;align-items:center}.fortune-entry img{width:25px;height:56px;object-fit:contain}.weather{display:flex;gap:14px;align-items:center}.weather h3{font-size:15px}.weather p{font-size:12px;color:var(--muted);margin:7px 0}.weather small{display:block;font-size:10px;margin-top:8px}.weather .secondary{font-size:12px;padding:8px 13px;min-height:40px}.weather-sky{font-size:30px;color:var(--gold)}.overview-support{display:block!important}.overview-support .card{margin-bottom:14px}.wide.page-home .hero-art,.wide.page-day .hero-art{height:270px!important}.overview-day .hero-art{height:270px!important}.wide.page-home .overview-day,.wide.page-day .overview-day{grid-template-columns:1.12fr 1fr}.wide.page-home .workspace,.wide.page-day .workspace{grid-template-columns:minmax(0,1fr) 300px!important}.native-event-head h1{margin:15px 0 8px}.native-event-head>p{font-size:14px;color:var(--muted);margin-bottom:18px}.web-article{border:1px solid var(--line);border-radius:24px;background:var(--paper);overflow:hidden}.web-hero{display:block;width:100%;height:260px;object-fit:cover;object-position:center 45%}.web-prose{padding:24px}.web-kicker{font-size:10px;color:var(--muted);letter-spacing:.12em}.web-prose h2{font-size:28px;margin:12px 0 18px}.web-prose p{font-size:15px;line-height:1.9;color:var(--ink)}.web-prose .web-intro{font-size:16px}.web-prose section{margin-top:25px}.web-prose h3{font-size:18px;font-family:"Songti SC",serif;margin-bottom:9px}.web-note{padding:16px;background:var(--wash);border-radius:16px;font-size:12px;line-height:1.9;margin-top:25px;color:var(--muted)}.web-prose footer{border-top:1px solid var(--line);padding-top:20px;margin-top:25px}.web-prose footer p,.web-prose footer small{font-size:11px;color:var(--muted)}.article-frame{width:100%;height:100%;min-height:550px;border:0;display:block;background:var(--paper);border-radius:24px}.article-state p{margin:16px 0;color:var(--muted);font-size:14px}.skeleton{height:180px;border-radius:16px;background:linear-gradient(100deg,var(--wash),var(--paper),var(--wash));margin-top:20px}.count-item{display:block}.count-item h2{font-size:22px}.count-item p{font-size:12px;color:var(--muted);margin:12px 0}.count-days{font-size:18px;color:var(--red)}.permission-status{padding:13px 0;color:var(--muted);font-size:13px}.permission-intro p{margin:20px 0;font-size:14px;line-height:1.9}.permission-intro button{width:100%;margin-top:10px}.system-prompt{text-align:center;background:var(--paper);padding:25px;max-width:360px;margin:30px auto}.system-prompt p{font-size:13px;margin:14px 0 22px}.system-prompt button{display:block;width:100%;height:44px;color:#007AFF;border:0;border-top:1px solid var(--line);background:transparent}.system-prompt button:first-child{font-weight:600}.loading-dot{width:18px;height:18px;border:2px solid var(--line);border-top-color:var(--red);border-radius:50%}.r8-app{position:absolute;top:0;height:var(--h);width:var(--appw);left:var(--appx);overflow:hidden;background:var(--bg)}.duo .side,.duo .status,.duo .top,.duo .tabs{display:none}.duo .workspace{position:absolute;left:var(--cx);top:72px;width:var(--cw);height:calc(var(--h) - 94px);padding:0!important;display:block!important;overflow:auto}.duo .workspace>.lead,.duo .workspace>.detail{overflow:visible!important}.duo.duo-wide .workspace{display:grid!important;grid-template-columns:minmax(0,1fr) minmax(0,1fr);gap:18px}.duo.duo-wide .workspace>.lead,.duo.duo-wide .workspace>.detail{overflow:auto!important;min-height:0}.duo .workspace>.lead:empty{display:none}.duo-header{position:absolute;left:var(--cx);top:22px;right:104px;display:flex;gap:10px;align-items:center}.duo-back{position:absolute;right:27px;top:var(--backy);width:44px;height:44px;z-index:18}.edge-left .duo-back{left:27px;right:auto}.duo-header h3{font-family:"Songti SC",serif;font-size:21px}.duo-header .glass{height:36px;width:36px;min-width:36px;font-size:22px}.floating-tabs{position:absolute;width:50px;height:212px;top:var(--taby);right:23px;border:1px solid var(--line);border-radius:30px;padding:4px;display:flex;flex-direction:column;align-items:center;background:var(--glass);box-shadow:inset 0 1px 2px #fff9,0 7px 20px #5038190c;backdrop-filter:blur(18px);z-index:20}.floating-tabs .tab{width:42px;height:50px;min-height:50px;border-radius:24px;padding:12px 8px;display:block}.floating-tabs .tab.active{background:var(--wash);color:var(--red)}.floating-tabs .tab-title{display:none}.floating-tabs svg{width:25px;height:25px;margin:0}.floating-tabs .tab-new-dot{right:3px;top:5px}.floating-tabs .tab-count-badge{right:-5px;top:0;height:14px}.duo.edge-left .floating-tabs{left:23px;right:auto}.duo-status{position:absolute;right:24px;top:var(--statusy);width:47px;text-align:center;z-index:15}.duo-status time{display:block;font-size:15px;font-weight:700;line-height:20px}.duo-status svg{width:47px;height:44px}.edge-left .duo-status{left:24px;right:auto}.split-companion{position:absolute;top:0;bottom:0;left:var(--neighborx);width:50%;background:#E7E5E0;display:flex;align-items:center;justify-content:center;color:#847D72;font-size:16px;border-inline-start:1px solid #CEC9C0}.review-only{font:12px/1.8 -apple-system,sans-serif;max-width:900px;padding:16px;margin:auto;color:#79634D}.review-controls{display:flex;gap:14px;align-items:center;flex-wrap:wrap}.review-controls input[type=range]{width:240px}.r8-device{position:relative;width:var(--w);height:var(--h);overflow:hidden}.fullscroll .r8-device{height:auto}.fullscroll .r8-app{position:relative;height:auto;overflow:visible}.fullscroll .workspace{position:relative!important;height:auto!important;overflow:visible!important;top:auto;left:auto;width:auto;margin:0;padding:10px 20px 20px!important;display:block!important}.fullscroll .tabs{position:relative;bottom:auto;margin-top:20px}.page-folklore-detail .detail{height:100%}.page-folklore-detail .workspace{grid-template-columns:minmax(220px,.65fr) minmax(0,1.8fr)}.page-folklore-detail:not(.wide):not(.duo-wide) .detail{height:auto}.page-folklore-detail .native-event-head{position:relative}.duo .hero-art{height:155px}.duo .hero-copy h2{font-size:17px}.duo .hero .quote p{font-size:19px}
'''
# Scope the approved motion styles to the new host, with no timeline changes.
CSS+=re.sub(r'(^|})([^{}]+)\{',lambda m:m[1]+','.join('.page-fortune '+x.strip() for x in m[2].split(','))+'{',FORTUNE_CSS[FORTUNE_CSS.index('.stage{'):FORTUNE_CSS.index('.review{')])
CSS+='''
.fortune-heading{text-align:center;margin:2px 0 15px}.fortune-heading h1{font-size:30px}.fortune-heading p{font-size:13px;color:var(--muted);margin-top:8px}.fortune-host{position:relative;display:flex;flex-direction:column;height:100%;min-height:450px}.fortune-visual{position:relative;flex:1;min-height:320px;overflow:hidden;background:radial-gradient(ellipse,#F8E3B888,transparent 65%);border-radius:26px}.figure-scale{position:absolute;left:50%;top:50%;width:300px;height:430px;transform:translate(-50%,-50%) scale(var(--figure-scale,1));transform-origin:center}.fortune-host .stage{position:absolute;left:0;top:0;width:300px;height:430px;margin:0}.fortune-host .result{pointer-events:auto;left:3%;top:10px;right:3%;bottom:auto;width:auto;max-width:380px;height:calc(100% - 20px);margin-inline:auto;overflow:auto;border-radius:20px}.fortune-host .result img{width:100%;height:100%;min-height:500px}.fortune-host .result-copy{padding:42px 32px;text-align:center;min-height:500px}.fortune-host .result-copy h2{font-size:25px}.fortune-host .poem{font-size:21px;line-height:1.85}.fortune-host .explain{font-size:14px;line-height:1.9}.fortune-actions{padding:15px 0 0;display:flex;gap:10px;flex-wrap:wrap;justify-content:center}.fortune-actions .primary{width:auto;flex:1;min-width:190px}.fortune-actions .secondary{min-height:48px}.fortune-actions .hint{width:100%;text-align:center;padding:0;margin:0}.page-fortune .workspace{display:flex!important;flex-direction:column;overflow:hidden!important}.page-fortune .lead{overflow:visible!important;flex:none}.page-fortune .detail{flex:1;min-height:0;overflow:hidden!important}.page-fortune .fortune-host{min-height:0}.page-fortune .fortune-visual{min-height:0}.page-fortune .heading{margin:0}.page-fortune .fortune-heading{margin-top:0}.page-fortune .r8-app .workspace{grid-template-columns:1fr!important}.wide.page-fortune .workspace{display:grid!important;grid-template-columns:minmax(220px,.75fr) minmax(0,1.4fr)!important;gap:32px;align-items:stretch}.wide.page-fortune .lead{align-self:center}.wide.page-fortune .detail{height:100%}.duo.duo-wide.page-fortune .workspace{display:grid!important;grid-template-columns:minmax(160px,.65fr) minmax(0,1.4fr)!important}.page-fortune .result-copy small,.page-fortune .result-copy h2,.page-fortune .poem,.page-fortune .explain{color:#4D3927}.page-fortune .result-copy h2{color:#9A3924}.page-fortune .result-copy{position:relative}.native-event-head .secondary{min-height:44px}.web-article h2,.web-article h3{overflow-wrap:anywhere}@media(prefers-reduced-motion:reduce){.stage,.result{transition:none}}
'''
CSS+=' .portrait .lead .hero{height:390px;grid-template-columns:42% 58%}.portrait .lead .hero-art{height:390px}.r8-banner{display:flex;height:390px}.r8-banner .hero-art{width:42%;height:390px;flex:none}.r8-banner .hero-copy{width:58%;margin:0;padding:20px;align-self:center}.page-folklore-detail:not(.wide):not(.duo-wide) .workspace{display:flex!important;flex-direction:column;overflow:hidden!important}.page-folklore-detail:not(.wide):not(.duo-wide) .lead{flex:none;overflow:visible!important}.page-folklore-detail:not(.wide):not(.duo-wide) .detail{flex:1;min-height:0;height:auto;overflow:hidden!important}.page-folklore-detail .article-frame{height:100%;min-height:0}.ipad-summary .card{padding:14px;margin-bottom:12px}.ipad-summary .weather p{font-size:11px}.ipad-summary .weather small{font-size:9px}.ipad-summary .weather .secondary{min-height:36px;padding:6px 11px}.ipad-compact-tools .weather .eyebrow,.ipad-compact-tools .weather small,.ipad-compact-tools .weather p{display:none}.ipad-compact-tools .card{padding:12px;margin:0}.ipad-compact-tools .day-support{gap:10px;margin-top:12px}.ipad-compact-tools .fortune-entry img{height:38px;width:17px}.ipad-compact-tools .weather h3{font-size:12px}.ipad-compact-tools .weather .secondary{min-height:36px;margin-top:8px;padding:6px 10px}'
b.CSS+=CSS

STATUS_SVG='''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 47 44" aria-hidden="true"><path d="M5 31 A20 20 0 1 1 42 31" fill="none" stroke="#34C759" stroke-width="3.2" stroke-linecap="round"/><path d="M12 22 Q23.5 10 35 22 M17 27 Q23.5 20 30 27" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round"/><circle cx="23.5" cy="31" r="2.1" fill="currentColor"/><path d="M25 0 21 8h4l-2 6 7-9h-5l2-5" fill="#8B8B8E"/><g fill="#B5B5BA"><circle cx="14" cy="40" r="1.6"/><circle cx="20" cy="42" r="1.6"/><circle cx="27" cy="42" r="1.6"/><circle cx="33" cy="40" r="1.6"/></g></svg>'''

JS='''
const R8=Object.freeze({unlocked:d=>d>=0&&d<=10,near:d=>d>=0&&d<=10,notificationEffect:(status)=>status==='authorized'?'schedule':'inAppOnly'});window.R8Rules=R8;
const REVIEW_EVENTS=EVENT_DATA,REVIEW_COUNTS=COUNT_DATA;
function savedCount(){try{let value=JSON.parse(localStorage.getItem('r8-countdown-saved')||'null');if(!value)return null;let day=null;if(value.calendar==='公历'&&/^\d{4}-\d{2}-\d{2}$/.test(value.date)){let t=Date.parse(value.date+'T00:00:00Z'),today=Date.parse('2026-11-12T00:00:00Z');if(value.repeat==='每年'&&t<today){let parts=value.date.split('-');let year=2026;t=Date.UTC(year,+parts[1]-1,+parts[2]);if(t<today)t=Date.UTC(year+1,+parts[1]-1,+parts[2])}day=Math.round((t-today)/86400000)}return {...value,id:'demo-saved',days:day}}catch(e){return null}}
function escaped(t){return String(t).replace(/[&<>"']/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c]))}
function presentSavedCount(){let value=savedCount();if(!value)return;let list=q('#countdown-list');if(list&&!q('#saved-count-item'))list.insertAdjacentHTML('afterbegin','<a class="card count-item" id="saved-count-item" href="'+COUNT_DETAIL_URL+'?id=demo-saved"><h2>'+escaped(value.title)+'</h2><p>'+escaped(value.date)+' · '+escaped(value.calendar)+'</p><small>App内提醒已开启 · '+escaped(value.time)+'</small></a>');let matches=q('.today-matches');if(value.days===0&&matches&&!q('[data-saved-count-hero]'))matches.insertAdjacentHTML('beforeend','<a class="today-match" data-saved-count-hero href="'+COUNT_DETAIL_URL+'?id=demo-saved"><span class="match-type">纪念日 · 今日</span><b>'+escaped(value.title)+'</b><span>›</span></a>')}

function refreshBadges(){let read=JSON.parse(localStorage.getItem('r8-read-events')||'[]');let unread=REVIEW_EVENTS.some(e=>R8.unlocked(e.days)&&e.unread&&!read.includes(e.id+'@'+e.version));qa('[data-badge="folklore"]').forEach(x=>x.style.display=unread?'block':'none');let close=[...REVIEW_COUNTS,...(savedCount()?[savedCount()]:[])].filter(e=>e.days!==null&&R8.near(e.days));let days=close.length?Math.min(...close.map(e=>e.days)):null;qa('[data-badge="countdown"]').forEach(x=>{x.style.display=days===null?'none':'flex';if(days!==null)x.querySelector('b').textContent=days});}
let pageParams=new URLSearchParams(location.search),eid=pageParams.get('event')||'winter';if(PAGE_NAME==='folklore-detail'){let event=REVIEW_EVENTS.find(e=>e.id===eid);if(event&&R8.unlocked(event.days)){let head=q('.native-event-head');if(head){head.querySelector('h1').textContent=event.title;head.querySelector('[data-event-date]').textContent=event.date.replace(/^(\d{4})-(\d{2})-(\d{2})$/,(_,y,m,d)=>y+'年'+Number(m)+'月'+Number(d)+'日');head.querySelector('.pill').textContent=event.category;head.querySelector('.unlock').textContent=(event.days===0?'今日':'还有'+event.days+'天')+' · 已解锁'}let frame=q('.article-frame');if(frame){frame.src='webpages/'+event.id+'.html';frame.addEventListener('load',()=>{try{frame.contentDocument.documentElement.dataset.theme=document.body.classList.contains('dark')?'dark':'light'}catch(e){}let read=JSON.parse(localStorage.getItem('r8-read-events')||'[]');let key=event.id+'@'+event.version;if(!read.includes(key)){read.push(key);localStorage.setItem('r8-read-events',JSON.stringify(read))}refreshBadges()})}}}refreshBadges();if(window.addEventListener)window.addEventListener('pageshow',refreshBadges);
qa('[data-locked-event]').forEach(a=>a.onclick=e=>{e.preventDefault();modal('<h2>再等一天，就能打开这段岁时</h2><p class="hint">正文在节日前10天解锁。</p>')});qa('[data-open-event]').forEach(a=>a.onclick=()=>{});
function showWeather(state){let n=q('#weather-panel');if(n)n.outerHTML=WEATHER_MARKUPS[state];bindWeather()}
function bindWeather(){qa('[data-location]').forEach(btn=>btn.onclick=()=>{let action=btn.dataset.location;if(action==='settings'){modal('<h2>在系统设置中开启定位</h2><p class="hint">进入“设置 › 历象 › 位置”，选择“使用App期间”。</p>');return}if(action==='retry'){showWeather('loading');setTimeout(()=>showWeather('authorized'),500);return}modal(LOCATION_PROMPT)})};bindWeather();let storedLocation=localStorage.getItem('r8-location');if(q('#weather-panel')&&storedLocation)showWeather(storedLocation);
function showNotificationIntro(){let status=localStorage.getItem('r8-notification')||INITIAL_NOTIFICATION;if(status==='denied'){modal('<h2>App内仍会提醒你</h2><p class="hint">系统通知未开启。如果希望在App外收到提醒，可以前往系统设置。</p><button class="primary" data-notification="settings">前往设置</button>')}else if(status==='authorized'){modal('<h2>系统通知已开启</h2><p class="hint">可以在纪念日里修改提醒时间，或前往系统设置管理权限。</p>')}else{modal(NOTIFICATION_INTRO)}}qa('[data-notification="explain"]').forEach(b=>b.onclick=showNotificationIntro);
function saveCount(form){let v=Object.fromEntries(new FormData(form));localStorage.setItem('r8-countdown-saved',JSON.stringify(v));presentSavedCount();refreshBadges();let status=localStorage.getItem('r8-notification')||'notDetermined';if(status==='authorized'){localStorage.setItem('r8-reminder-demo',JSON.stringify({date:v.date,time:v.time,effect:'schedule',nativeScheduled:false}));modal('<h2>日子已记下</h2><p class="hint">系统通知已开启，提醒已安排。</p>')}else if(status==='denied'){modal('<h2>日子已记下</h2><p class="hint">系统通知未开启，App内仍会提醒。</p>')}else{showNotificationIntro()}}let af=q('#anniversary-form');if(af)af.onsubmit=e=>{e.preventDefault();saveCount(af)};qa('[data-new-count]').forEach(b=>b.onclick=()=>{modal(COUNTDOWN_FORM);let f=q('#anniversary-form');f.onsubmit=e=>{e.preventDefault();saveCount(f)}});
document.addEventListener('click',e=>{let n=e.target.closest('[data-notification]');if(n){if(n.dataset.notification==='request'){modal(NOTIFICATION_PROMPT)}if(n.dataset.notification==='settings'){modal('<h2>在系统设置中管理通知</h2><p class="hint">进入“设置 › 历象 › 通知”，开启“允许通知”。</p>')}if(n.dataset.notification==='later'){q('.modal').classList.remove('open');let status=q('#notification-status');if(status)status.textContent='App内提醒已开启；你可以稍后开启系统通知'}}let p=e.target.closest('[data-permission]');if(p){let allowed=p.dataset.result==='allowed';if(p.dataset.permission==='location'){localStorage.setItem('r8-location',allowed?'authorized':'denied');q('.modal').classList.remove('open');showWeather(allowed?'loading':'denied');if(allowed)setTimeout(()=>showWeather('authorized'),500)}else{let status=allowed?'authorized':'denied';localStorage.setItem('r8-notification',status);if(allowed&&localStorage.getItem('r8-countdown-saved'))localStorage.setItem('r8-reminder-demo',JSON.stringify({effect:'schedule',nativeScheduled:false}));q('.modal').classList.remove('open');let label=q('#notification-status');if(label)label.textContent=allowed?'系统通知已开启 · 提醒已安排':'系统通知未开启 · App内仍会提醒'}}});
let cid=pageParams.get('id');if(PAGE_NAME==='countdown-detail'&&cid){let count=cid==='demo-saved'?savedCount():REVIEW_COUNTS.find(e=>e.id===cid);if(count){q('[data-count-title]').textContent=count.title;q('[data-count-days]').textContent=count.days===null?'已记下':count.days===0?'就是今天':count.days+' 天后';q('[data-count-date]').textContent=count.date+' · '+count.calendar}}presentSavedCount();
qa('[data-retry-article]').forEach(b=>b.onclick=()=>location.href=FOLKLORE_DETAIL_URL);qa('[data-share-event]').forEach(b=>b.onclick=()=>modal('<h2>把这段岁时，分享给关心的人</h2><p class="hint">把喜欢的一段岁时，留给关心的人。</p>'));
'''

BASE_JS=b.JS.replace('请使用保存图片；iOS接入原生图片分享，见交付规格','暂时无法打开分享，可以先保存图片。').replace('可下载本轮交付的完整分享卡PNG；iOS使用ImageRenderer导出卡片','图片已准备好，保存后可以从相册分享。').replace('午时 · 11:00—13:00','巳时 · 09:00—11:00').replace("['东北','东南','正南','正北','西南','正南 · 四正']","['西南','正东','西北','东北','正南','正东 · 四正']").replace('[[45,30],[135,30],[180,30],[0,30],[225,30]]','[[225,30],[90,30],[315,30],[45,30],[180,30]]').replace("let hourly=b.dataset.compassMode==='hour';", "let hourly=b.dataset.compassMode==='hour';if(q('.sha-map'))q('.sha-map').style.transform=hourly?'rotate(90deg)':'none';")
# Preserve old utility, settings and almanac logic, but own the new route states.
def scripts(page,mode,state=''):
 s=BASE_JS.replace('EVENTS',json.dumps(EVENTS,ensure_ascii=False)).replace('REMOTE',json.dumps(b.remote_card('remote-loaded'),ensure_ascii=False)).replace('COUNT_FORM',json.dumps(b.count_form(),ensure_ascii=False)).replace('RESULTS',json.dumps('',ensure_ascii=False)).replace('DAY_URL',json.dumps(url('day',mode))).replace('MODE_IS_IPAD','true' if mode.startswith('ipad-') else 'false')
 extra=JS.replace('EVENT_DATA',json.dumps(EVENTS,ensure_ascii=False)).replace('COUNT_DATA',json.dumps(COUNTS,ensure_ascii=False)).replace('PAGE_NAME',json.dumps(page)).replace('WEATHER_MARKUPS',json.dumps({k:weather(k) for k in ['notDetermined','loading','authorized','denied','error']},ensure_ascii=False)).replace('LOCATION_PROMPT',json.dumps(system_prompt('location'),ensure_ascii=False)).replace('NOTIFICATION_INTRO',json.dumps(notification_explanation(),ensure_ascii=False)).replace('NOTIFICATION_PROMPT',json.dumps(system_prompt('notification'),ensure_ascii=False)).replace('COUNTDOWN_FORM',json.dumps(count_form(),ensure_ascii=False)).replace('FOLKLORE_DETAIL_URL',json.dumps(url('folklore-detail',mode))).replace('COUNT_DETAIL_URL',json.dumps(url('countdown-detail',mode)))
 if page=='fortune':
  extra+='\n'+FORTUNE_CORE+'''\nfunction resizeFortune(){let box=document.querySelector('.fortune-visual');if(!box)return;let s=Math.min(box.clientWidth/300,box.clientHeight/430);box.style.setProperty('--figure-scale',Math.max(.1,s));}new ResizeObserver(resizeFortune).observe(document.querySelector('.fortune-visual'));resizeFortune();'''
 if state=='weather-system-prompt':extra+='\nmodal('+json.dumps(system_prompt('location'),ensure_ascii=False)+');'
 elif state.startswith('weather-'):extra+='\nshowWeather('+json.dumps(state.replace('weather-',''))+');requestAnimationFrame(()=>document.querySelector(\"#weather-panel\")?.scrollIntoView({block:\"start\"}));'
 return s+'\n'+extra.replace('INITIAL_NOTIFICATION',json.dumps('authorized' if state=='allowed' else 'denied' if state=='denied' else 'notDetermined'))

def page_html(page,mode,w,h,dark=False,state='',full=False):
 prof=profile(mode,w,h);duo=prof['duo'];wide=prof['appw']>=740 and w>h;innerwide=duo and prof['appw']>=600 and w>h
 cls=('dark ' if dark else '')+('duo ' if duo else '')+('duo-wide ' if innerwide else '')+('wide ' if wide and not duo else '')+('portrait ' if mode.startswith('ipad-portrait') else '')+('fullscroll ' if full else '')+('edge-left ' if prof['edge']=='left' else '')+'page-'+page
 active='folklore' if page.startswith('folklore') else 'countdown' if page.startswith('countdown') else page if page=='settings' else 'home'
 lead,detail=content(page,mode,state)
 if page=='folklore-detail' and state not in ['offline','loading']:
  event='daily-kindness' if state=='today' else 'winter';detail=('<p class="hint">当前阅读已保存的内容，联网后将检查更新。</p>' if state=='cached' else '')+f'<iframe class="article-frame" src="webpages/{event}.html" title="岁时文章正文" data-owner="web"></iframe>'
 if page=='fortune':lead=lead.replace('fortune-heading','fortune-heading heading')
 if duo:
  back='' if page in ['home','folklore','countdown','settings'] else f'<a class="glass duo-back" href="{url("folklore" if page=="folklore-detail" else "countdown" if page=="countdown-detail" else "day" if page in ["almanac","fortune","daily"] else "home",mode)}" aria-label="返回">‹</a>'
  top=f'<header class="duo-header"><h3>{"历象" if page in ["home","day"] else PAGES[page]}</h3></header>{back}'
  nav='<nav class="floating-tabs" aria-label="主导航">'+tabs(active,mode,True)+'</nav>'
  status='<div class="duo-status" aria-label="模拟系统状态"><time>09:41</time>'+STATUS_SVG+'</div>' if prof['statusVisible'] else ''
 else:
  top=f'<div class="status"><span>9:41</span><span>●●●　▰</span></div><header class="top"><a class="glass" href="{url("home",mode)}" aria-label="返回">‹</a><h3>{"历象" if page in ["home","day"] else PAGES[page]}</h3><span style="width:42px"></span></header>'
  nav='<nav class="tabs" aria-label="主导航">'+tabs(active,mode)+'</nav>';status=''
 modal='<div class="modal" role="dialog" aria-modal="true"><section class="card"><button class="glass close" id="close-modal" aria-label="关闭">×</button><div id="modal-body"></div></section></div><div class="toast" role="status"></div>'
 app=f'<div class="r8-app">{top}<main class="workspace"><section class="lead">{lead}</section><section class="detail">{detail}</section></main>{nav}{status}{modal}</div>'
 neighbor='<aside class="split-companion" aria-label="另一App示意">另一 App</aside>' if prof['split'] else ''
 controls='<section class="review-only"><div class="review-controls"><button id="replay">回到待机</button><label><input id="reduce" type="checkbox"> 减少动态效果</label><label>逐帧审阅 <input id="timeline" type="range" min="0" max="1450" value="0"></label><span id="time-label">0ms</span><span class="phase">待机</span></div><p>R7定稿时序与素材保持不变；本轮仅适配容器与操作位置。</p></section>' if page=='fortune' else ''
 notice='<p class="review-only">设计原型：数据固定为2026-11-12样本；定位与通知弹窗为状态演示，不会申请本机权限。Duo状态区为根据用户截图绘制的设计参照。</p>'
 variables=f'--w:{w}px;--h:{h}px;--appw:{prof["appw"]}px;--appx:{prof["appx"]}px;--cx:{prof["contentX"]-prof["appx"]}px;--cw:{prof["contentWidth"]}px;--taby:{prof["tabY"]}px;--statusy:{prof["statusY"]}px;--backy:{prof["backY"]}px;--neighborx:{"0" if mode.endswith("right") else "50%"};'
 return '<!doctype html><html lang="zh-CN"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>历象 · '+PAGES[page]+'</title><style>:root{'+variables+'}'+b.CSS+'</style><body class="'+cls+'"><div class="r8-device device">'+neighbor+app+'</div>'+controls+notice+'<script>'+scripts(page,mode,state)+'</script></body></html>'

def generate():
 rows=[]
 for page in PAGES:
  for mode,w,h,dark in MODES:
   name=f'{page}-{mode}';(P/(name+'.html')).write_text(page_html(page,mode,w,h,dark));rows.append(dict(page=page,mode=mode,width=w,height=h,dark=dark,file=name,state=''))
 states=[('home','no-matches')]+[('day',x) for x in ['weather-system-prompt','weather-loading','weather-authorized','weather-denied','weather-error']]+[('folklore-detail',x) for x in ['today','loading','offline','cached']]+[('countdown-detail',x) for x in ['today','new','preprompt','system-prompt','allowed','denied']]+[('fortune','result')]
 for page,state in states:
  name=f'{page}-phone-light-{state}';(P/(name+'.html')).write_text(page_html(page,'phone-light',375,930,False,state));rows.append(dict(page=page,mode='phone-light',width=375,height=930,dark=False,file=name,state=state))
 for mode,w,h,dark in MODES:
  if mode=='phone-light':continue
  name=f'fortune-{mode}-result';(P/(name+'.html')).write_text(page_html('fortune',mode,w,h,dark,'result'));rows.append(dict(page='fortune',mode=mode,width=w,height=h,dark=dark,file=name,state='result'))
 for page,height in [('almanac',12000),('daily',1650),('day',2300),('folklore-detail',2400)]:
  name=f'{page}-phone-light-full';(P/(name+'.html')).write_text(page_html(page,'phone-light',375,height,False,full=True));rows.append(dict(page=page,mode='phone-light',width=375,height=height,dark=False,file=name,state='',full=True))
 # Old compass links redirect into the Almanac child section.
 for mode,w,h,dark in MODES:(P/f'compass-{mode}.html').write_text(f'<meta charset="utf-8"><meta http-equiv="refresh" content="0;url={url("almanac",mode)}#almanac-compass">')
 # Fortune result specimens open the approved final state, without changing draw behavior.
 for row in rows:
  if row['page']=='fortune' and row['state']=='result':
   f=P/(row['file']+'.html');f.write_text(f.read_text().replace('</script>','\nrenderAt(1450);</script>'))
 (P/'screens.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2));(P/'R8-Fixtures.json').write_text(json.dumps(FIXTURE,ensure_ascii=False,indent=2))
 return rows
if __name__=='__main__':print('Generated',len(generate()),'R8 HTML designs')
