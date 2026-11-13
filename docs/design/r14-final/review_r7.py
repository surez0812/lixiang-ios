from pathlib import Path
import json, html, re, shutil
import build_suite as b
P=Path(__file__).resolve().parent
D=json.loads((P/'calendar-fixture.json').read_text())
BASE_CONTENT=b.content
BASE_HERO=b.hero
BASE_MONTH=b.month
b.PAGES['daily']='今日经文'
def tabs(active,mode,side=False):
 names=[('home','calendar','日历'),('folklore','suishi','岁时'),('countdown','countdown','倒计日'),('settings','settings','设置')]
 return ''.join('<a class="tab '+('active' if page==active else '')+'" href="'+b.link(page,mode)+'" aria-label="'+name+'">'+(P/('assets/tab-icons/tab-'+asset+'.svg')).read_text()+name+'</a>' for page,asset,name in names)
b.tabs=tabs

b.MODES=[(n,466 if n=='duo-closed-portrait' else 678 if n=='duo-closed-landscape' else 669 if n=='duo-open-portrait' else 951 if n in ['duo-open-landscape','duo-tabletop','duo-tent'] else w,678 if n=='duo-closed-portrait' else 466 if n=='duo-closed-landscape' else 951 if n=='duo-open-portrait' else 669 if n in ['duo-open-landscape','duo-tabletop','duo-tent'] else h,d) for n,w,h,d in b.MODES]
COPY={
'嫁娶':('举行婚礼或缔结婚姻的礼仪。','本日列为宜，表示传统历书将其归入适宜事项；安排仍需双方同意、场地与行程配合。'),
'开光':('为宗教造像等举行特定仪式。','本日列为宜；它有明确的宗教语境，不等于为普通物品做清洁或开封。'),
'出行':('离开常住地，远行或办理外出的事项。','本日列为宜；出发前仍应检查天气、交通与身体状况。'),
'出火':('旧俗中移出或迁移神位、香火。','本日列为宜；与日常点火、消防作业不同。'),
'拆卸':('拆除建筑、旧构件等。','本日列为宜；实际施工以专业评估、许可与现场安全为准。'),
'修造':('修建或修缮房屋建筑。','本日列为宜；排期仍应结合工期、噪声规定与施工条件。'),
'动土':('建筑工程开始时的破土事项。','本日列为宜；与普通盆栽翻土不同，工程须符合许可及安全要求。'),
'入宅':('迁入新居并开始居住。','本日列为宜；可作为民俗排期参考，同时确认交房、搬运与入住条件。'),
'移徙':('搬家、迁移住所。','本日列为宜；与入宅有交叠，更强调搬迁行为本身。'),
'安床':('安装或调整寝床的位置。','本日列为宜；实际布置以稳固、动线与睡眠舒适为先。'),
'上梁':('传统木构建筑安装主要梁木的工序。','本日列为宜；不是所有装修都属于上梁，结构作业由专业人员判断。'),
'开市':('店铺开业、复业等商业开张事项。','本日列为宜；经营安排仍需结合手续、人员与市场情况。'),
'交易':('买卖、交换等交易事项。','本日列为宜；黄历不判断价格与回报，条款和实际风险须另行审查。'),
'立券':('订立契约、凭据。','本日列为宜；签署前应理解合同内容，必要时取得专业意见。'),
'栽种':('播种或栽植作物、树木。','本日列为宜；物候、温湿度、植物习性决定实际是否适合。'),
'祈福':('通过特定礼仪表达祝愿。','本日列为忌，是旧历书的事项分类；不表示今天不能心怀善意或表达祝福。'),
'祭祀':('祭祖或祭神等礼仪。','本日列为忌；与日常追思不同。遵循自家习惯，尊重参与者意愿。'),
'伐木':('砍伐树木。','本日列为忌；是否可作业仍须看许可、生态规定与安全条件。'),
'掘井':('开挖水井。','本日列为忌；地质、水源与施工许可须由专业人员评估。'),
'作灶':('建造或安装传统灶台。','本日列为忌；不是指不能做饭。燃气、电气设施由合格人员处理。'),
'谢土':('工程结束后，旧俗中酬谢土地的礼仪。','本日列为忌；它是礼仪名称，不是工程验收或清运。')}
FIELDS=[
('值神',D['zhiShen']+' · '+D['zhiShenType'],'值神是黄历给每天轮值神名的分类。今天为天牢，传统归为黑道；应与具体事项一起阅读，不能仅凭黑道二字判断一整天。'),
('冲煞','冲'+D['chong']+' · 煞'+D['sha'],'“冲”是地支相对关系；今日寅申相冲，标记为冲猴。“煞北”是传统方位记号；不表示属猴者或北方必会发生不利事情。'),
('纳音',D['nayin'],'松柏木是庚寅、辛卯在六十甲子纳音体系中的名称，用来记录与归类干支；不是人的身体材质，也不单独决定当天宜忌。'),
('建除十二神',D['jianchu']+'日','建除十二神按建、除、满、平、定、执、破、危、成、收、开、闭循环。今日为平日，传统取平顺、平整之意；仍需逐项查看本日宜忌。'),
('彭祖百忌','；'.join(D['pengzu']),'前句针对庚日，后句针对寅日，是依干支流传的传统禁忌口诀。保留原文便于查阅；“不祭祀”与今天忌项对应，不能据此推断实际后果。'),
('今日胎神',D['taishen'],'这是旧俗中对碓磨、炉灶及屋外正北方的方位记号，常与搬动、施工的民俗避忌有关；它不提供孕期医学判断。'),
('今日星宿',D['xiu']+'宿 · '+D['xiuLuck'],'角宿是二十八宿之一；这里显示传统宿名及其黄历分类，供历法文化阅读，不等同于个人星座或天象观测预报。'),
('吉神宜趋',' · '.join(D['jishen']),'列出历书为今天配属的吉神名称；“宜趋”表示旧俗倾向采用的分类。多个神名并不相加成为确定的结果，须与当天事项一并阅读。'),
('凶神宜忌',' · '.join(D['xiongsha']),'列出历书为今天配属的凶神名称；“宜忌”在此是提醒留意的旧俗分类，不是对现实灾害的预测。')]

def hero(mode):
 s=BASE_HERO(mode).replace('class="card hero"', 'class="card hero" data-day-url="'+b.link('day',mode)+'"')
 s=s.replace('<div class="hero-art">',f'<a class="hero-art" href="{b.link("day",mode)}" aria-label="查看今日单日详情">').replace('</span></div><div class="hero-copy">','</span></a><div class="hero-copy">')
 s=s.replace('<h2>2026',f'<a href="{b.link("day",mode)}" aria-label="查看今日单日详情"><h2>2026').replace('丙午年</small>','丙午年</small></a>')
 s=s.replace('<div class="quote">',f'<a class="quote" href="{b.link("daily",mode)}" aria-label="阅读今日经文解释与分享卡">').replace('《道德经》第八章 · 王弼本</small></div>','《道德经》第八章 · 王弼本　读解释与分享 ›</small></a>')
 return s

def month(mode):
 s=BASE_MONTH()
 s=re.sub(r'<div class="cell ([^"]*)">(\d+)(.*?)</div>',lambda m:f'<a class="cell {m[1]}" href="{b.link("day",mode)}?date=2026-11-{int(m[2]):02d}" data-date="2026-11-{int(m[2]):02d}" aria-label="11月{m[2]}日，查看单日详情">{m[2]}{m[3]}</a>',s)
 return s

def teaser(mode):
 return f'''<a href="{b.link('almanac',mode)}" class="card almanac-teaser" style="display:block"><div class="teaser-head"><div><div class="eyebrow">庚寅日 · 平日 · 松柏木</div><h2>今日黄历</h2></div><span class="crest">历</span></div><div class="yi-ji"><b class="green">宜</b><p>嫁娶　出行　修造　入宅</p><b class="red">忌</b><p>祈福　祭祀　伐木　作灶</p></div><div class="teaser-footer"><span>全项宜忌 · 十二时辰 · 罗盘</span><span class="red">展开今日 ›</span></div></a>'''

def daily():
 read='''<article class="card daily-reading"><div class="eyebrow">每日一句 · 道经</div><h1>像水一样，<br>温柔而有力量</h1><div class="quote"><p>上善若水，<br>水善利万物而不争。</p><small>《道德经》第八章 · 王弼本</small></div><div class="divider"></div><h3>这句话在说什么</h3><p>水滋养万物，不急着争夺位置。今天试着少一点比较，把心力放在自己能做的事上。</p><h3 style="margin-top:20px">把这句话放进今天</h3><p>认真听完一次对话，再表达自己的想法。温和，也可以有清楚的边界。</p><div class="divider"></div><small>先读解释，再把喜欢的一句分享出去。</small></article>'''
 poster='''<section class="card share-section"><div class="row"><h2>今日分享卡</h2><span class="pill">含二维码</span></div><article id="daily-poster" class="poster"><img class="poster-art" src="assets/winter.webp" alt="冬日节气插画"><div class="poster-copy"><div class="eyebrow">历象 · 立冬</div><p class="serif">上善若水，<br>水善利万物而不争。</p><small>《道德经》第八章 · 王弼本</small><div class="divider"></div><div class="row"><span>2026.11.12<br><small>农历十月初四</small></span><img src="assets/qr-appstore.png" width="70" height="70" alt="历象 App 下载二维码"></div></div></article><div class="share-actions"><button class="primary" id="share-daily">分享今日卡片</button><button class="secondary" id="save-daily">保存图片</button></div><small id="share-status" role="status"></small></section>'''
 return read,poster

def almanac():
 lead=b.feature('今日黄历','2026年11月12日 · 星期四','<div class="rounddate">十二</div><small>农历十月初四 · 丙午年 己亥月 庚寅日</small>')
 lead+='''<section class="card eras"><div class="eyebrow">三种纪元 · 同一天</div><div class="era-row"><span>黄帝纪元</span><b>4723 年</b></div><div class="era-row"><span>道历纪元</span><b>4723 年</b></div><div class="era-row"><span>佛历纪元</span><b>2570 年</b></div><small>黄帝纪元采用团队公历年＋2697口径；道、佛历依 LunarSwift。</small></section>'''
 lead+='<section class="card"><div class="row"><h2>今日宜忌</h2><span class="pill">逐项可读</span></div><div class="controlbar"><div><b>白话全解</b><small style="display:block">每一项，连同今天的含义一起读</small></div><button class="switch" id="plain-toggle" role="switch" aria-label="白话全解" aria-checked="true"></button></div>'
 for kind,cls in [('yi','green'),('ji','red')]:
  lead+=f'<div class="activity-heading {cls}">{"宜" if kind=="yi" else "忌"} · {len(D[kind])} 项</div>'
  for term in D[kind]:
   meaning,usage=COPY[term]
   lead+=f'<div class="activity-row" data-term="{term}"><b class="{cls}">{term}</b><div class="plain-explain"><p>{meaning}</p><p>{usage}</p></div></div>'
 lead+='</section><section class="card"><h2>读懂今日的历法</h2>'
 for name,val,explain in FIELDS:
  lead+=f'<section class="term-row" data-field="{name}"><small>{name}</small><h3>{val}</h3><p class="plain-explain">{explain}</p></section>'
 lead+='</section>'
 # The full compass is part of this page, with all controls kept local.
 c1,c2=BASE_CONTENT('compass','phone-light')
 from bs4 import BeautifulSoup
 legend=BeautifulSoup(c2,'html.parser')
 for node,value in zip(legend.select('[data-direction]'),D['directions']+['正北 · 四正']):node.string=value
 c2=str(legend)
 lead+='<section class="card integrated-compass" id="almanac-compass"><div class="eyebrow">今日黄历 · 方位</div>'+c1+c2+'</section>'
 detail='<section class="card hours-panel"><div class="row"><div><div class="eyebrow">一日十二辰 · 各有次序</div><h2>把一天，慢慢展开</h2></div></div><p class="hint">十二时辰在同一列表中，上下滑动查看。时段按北京时间。</p><div class="hours-list">'
 for i,t in enumerate(D.get('hours',[])):
  time='23:00—01:00' if i==0 else f'{i*2-1:02d}:00—{i*2+1:02d}:00'
  detail+=f'<article class="hour-row" data-hour="{i}" id="hour-{i}"><div class="row"><h3>{t["branch"]}时　<small>{time}</small></h3><span class="pill">{t["luck"]}</span></div><p class="hour-meta">{t["gz"]} · {t["god"]} · 冲{t["chong"]} · 煞{t["sha"]}</p><div class="yi-ji"><b class="green">宜</b><p>{"　".join(t["yi"]) or "无"}</p><b class="red">忌</b><p>{"　".join(t["ji"]) or "无"}</p></div></article>'
 detail+='</div></section><p class="hint">传统黄历内容供文化参考，安排事情也请结合现实条件。</p>'
 return lead,detail

def content(page,mode,state=''):
 if page in ['home','day']:
  if mode.startswith('ipad-'):
   if 'landscape' in mode:
    return '<div class="overview-day"><div>'+hero(mode)+b.shortcuts(mode)+'</div><div>'+teaser(mode)+'<div class="overview-support">'+b.seasons(mode)+'</div></div></div>',month(mode)
   return hero(mode)+b.shortcuts(mode),'<div class="portrait-daygrid"><div class="calendar-column">'+month(mode)+'</div><div>'+teaser(mode)+'</div><div>'+b.seasons(mode)+'</div></div>'
  if page=='home':return hero(mode),month(mode)
  return hero(mode)+b.shortcuts(mode),teaser(mode)+b.seasons(mode)
 if page=='daily':return daily()
 if page=='almanac':return almanac()
 return BASE_CONTENT(page,mode,state)
b.content=content
BASE_COMPASS=b.compass
def compass():
 markup=BASE_COMPASS()
 from bs4 import BeautifulSoup
 import math
 soup=BeautifulSoup(markup,'html.parser')
 degrees={'正北':0,'东北':45,'正东':90,'东南':135,'正南':180,'西南':225,'正西':270,'西北':315}
 for pin,direction in zip(soup.select('.pin'),D['directions']):
  a=math.radians(degrees[direction]);pin['style']=f'left:{50+30*math.sin(a)}%;top:{50-30*math.cos(a)}%'
 soup.select_one('.sha-sector').replace_with(BeautifulSoup('<svg class="sha-map" viewBox="0 0 100 100" aria-label="煞北"><path d="M50 50 L37 10 A42 42 0 0 1 63 10 Z" fill="#A43C29" fill-opacity="0.09"/></svg>','html.parser'))
 return str(soup)
b.compass=compass

b.CSS+='''
.hero-art{display:block}.quote{display:block}.yi-ji{grid-template-columns:30px minmax(0,1fr);align-items:center;gap:10px 12px}.yi-ji b{font:600 16px/1.6 "PingFang SC",sans-serif;text-align:center}.yi-ji p{font-size:14px;line-height:1.8}.overview-support{grid-template-columns:minmax(0,1fr) minmax(0,1fr);gap:16px;align-items:stretch}.overview-support .card{margin-bottom:0;padding:15px}.overview-support h2{font-size:19px}.overview-support p{font-size:12px}.overview-support .pill{font-size:9px;padding:3px 6px}.wide.page-home .workspace,.wide.page-day .workspace{grid-template-columns:minmax(0,1fr) minmax(260px,.72fr)}body:not(.page-home):not(.page-day) .overview-support{grid-template-columns:1fr}.era-row{padding:9px 0;border-bottom:1px solid var(--line);display:flex;justify-content:space-between}.eras small{display:block;margin-top:12px;font-size:10px}.activity-heading{font-size:17px;font-weight:600;padding:14px 0 5px}.activity-row{padding:12px 0;border-bottom:1px solid var(--line)}.activity-row>b{font-size:15px}.activity-row .plain-explain{border:0;padding:6px 0 0}.activity-row p+p{margin-top:5px}.term-row{padding:17px 0;border-bottom:1px solid var(--line)}.term-row h3{font-size:16px;font-weight:500;margin-top:4px}.term-row .plain-explain{border:0;padding-bottom:0}.hours-panel{padding:20px}.hours-list{max-height:calc(var(--h) - 320px);min-height:250px;overflow-y:auto;overscroll-behavior:contain}.hour-row{padding:20px 0;border-bottom:1px solid var(--line)}.hour-row:first-child{padding-top:8px}.hour-meta{font-size:11px;color:var(--muted);margin-top:7px}.hour-row .yi-ji{margin-top:12px}.fullscroll .hours-list{max-height:none;overflow:visible}.integrated-compass .compass-lead{display:block!important}.integrated-compass h1{font-size:25px}.integrated-compass .compass-stage{width:100%;max-width:380px}.integrated-compass>.card{border:0;padding:0;margin:12px 0;box-shadow:none}.daily-reading h1{font-size:30px}.daily-reading>p{font-size:14px;line-height:1.9;margin-top:10px}.poster{border:1px solid var(--line);border-radius:20px;overflow:hidden;margin:18px 0;background:var(--paper)}.poster-art{width:100%;height:260px;display:block;object-fit:cover;object-position:center 40%}.poster-copy{padding:20px}.poster-copy>.serif{font-size:25px;line-height:1.6;margin:12px 0}.poster-copy .row{font-size:12px}.poster-copy .row img{background:white;padding:3px;flex-shrink:0}.share-actions{display:flex;gap:10px;margin-bottom:10px}.share-actions button{flex:1;min-height:44px}.daily-reading .quote p{font-size:23px}.wide .daily-reading{position:sticky;top:0}.duo .side{padding-top:64px;width:84px}.duo .workspace{width:calc(var(--w) - 84px)}.duo .workspace{padding:18px 16px 24px}.duo .hero-art{height:155px}.duo .hero-copy h2{font-size:17px}.duo .quote p{font-size:19px}.duo .side .glass{font-size:20px}.duo .side small{writing-mode:initial;font-size:10px;letter-spacing:0;text-align:center}.duo .side .destinations{gap:8px}.duo .side .tab{font-size:10px;min-height:56px}.duo.page-home .workspace{grid-template-columns:minmax(0,1fr) minmax(0,1fr)}.duo:not(.wide):not(.tabletop).page-home .workspace{display:block}.duo:not(.wide):not(.tabletop) .workspace{display:block}.duo:not(.wide):not(.tabletop) .workspace>.lead,.duo:not(.wide):not(.tabletop) .workspace>.detail{overflow:visible}.duo.tabletop .workspace>.lead,.duo.tabletop .workspace>.detail{overflow:auto}.duo.tabletop .workspace{grid-template-rows:calc((var(--h) - 68px)/2) 32px minmax(0,1fr)}.duo.tabletop .lead .hero{height:auto;display:block}.duo.tabletop .lead .hero-art{height:140px}.duo.tabletop .lead .hero-copy{padding:0 18px 18px;margin-top:-25px}.duo.tabletop .lead .shortcut{display:none}.page-home:not(.wide):not(.portrait):not(.duo) .hero-art{height:155px}.page-home:not(.wide):not(.portrait):not(.duo) .quote{padding:12px}.page-home:not(.wide):not(.portrait):not(.duo) .quote p{font-size:19px}.page-home:not(.wide):not(.portrait):not(.duo) .month-grid .cell{height:39px}.page-home:not(.wide):not(.portrait):not(.duo) .month{padding:16px}.page-home:not(.wide):not(.portrait):not(.duo) .month h2{font-size:21px;margin-bottom:8px}.page-home:not(.wide):not(.portrait):not(.duo) .month .legend{font-size:9px}.tab svg{display:block;width:24px;height:24px;margin:0 auto 4px}.tab i{font-size:0}.side .tab svg{width:23px;height:23px}.fullscroll .poster-art{height:300px}
@media print{.device{break-inside:avoid}.card{break-inside:avoid}}
'''
b.CSS+='.compass-stage .dial{left:4%;top:4%}.compass-center{left:36%;top:36%;width:28%;height:28%}.sha-map{position:absolute;left:0;top:0;width:100%;height:100%}.pin{display:flex;align-items:center;justify-content:center}.segmented button{display:block;min-height:42px;line-height:20px;min-width:110px}.shortcut .card{display:block}.poster-copy .row img{width:70px!important;height:70px!important;max-width:70px;flex-shrink:0}.poster-copy .row span{flex:1}.shortcut img{width:30px;height:30px;object-fit:contain}.hero-art:after{pointer-events:none}.page-home .hero{cursor:pointer}'
b.CSS+='@media(min-width:740px){body.page-home:not(.duo).wide .workspace{grid-template-columns:minmax(0,1fr) 300px}}.duo .side .tab{width:60px}.month-grid .cell{display:block}.month-grid .dot{position:absolute;bottom:2px;left:50%;margin:0}.month-grid .ann-star{right:0;top:1px}'
b.JS=b.JS.replace("['正南','正南','东南','正东','东南','正南 · 四正']", "['西北','正东','西南','正南','东北','正北 · 四正']").replace("[[180,30],[180,23],[135,30],[90,30],[135,20]]", "[[315,30],[90,30],[225,30],[180,30],[45,30]]")
# Prototype navigation preserves independent links and selected-date identity.
b.JS+='''
const selectedDate=new URLSearchParams(location.search).get('date');if(selectedDate){root.dataset.selectedDate=selectedDate;let note=document.createElement('p');note.className='hint';note.textContent='所选日期：'+selectedDate+' · 此原型的黄历与经文内容为11月12日样本';q('.workspace').prepend(note)}
if(document.body.classList.contains('page-home')&&MODE_IS_IPAD){qa('[data-date]').forEach(a=>a.onclick=e=>{e.preventDefault();root.dataset.selectedDate=a.dataset.date;qa('[data-date]').forEach(x=>x.classList.toggle('selected',x===a));toast('已选 '+a.dataset.date+'，右侧显示当日详情；当前数据为11月12日样本')})}
qa('[data-day-url]').forEach(card=>card.onclick=e=>{if(!e.target.closest('a,button'))location.href=card.dataset.dayUrl});let shareDaily=q('#share-daily');if(shareDaily)shareDaily.onclick=async()=>{try{let blob=await (await fetch('daily-share-poster.png')).blob();let file=new File([blob],'历象-今日经文.png',{type:'image/png'});if(navigator.canShare&&navigator.canShare({files:[file]})){await navigator.share({title:'历象 · 今日经文',files:[file]});q('#share-status').textContent='已打开图片分享'}else{q('#save-daily').click();q('#share-status').textContent='已保存含二维码的卡片，可从相册分享'}}catch(e){q('#share-status').textContent='请使用保存图片；iOS接入原生图片分享，见交付规格'}};let saveDaily=q('#save-daily');if(saveDaily)saveDaily.onclick=()=>{q('#share-status').textContent='可下载本轮交付的完整分享卡PNG；iOS使用ImageRenderer导出卡片';let a=document.createElement('a');a.href='daily-share-poster.png';a.download='历象-今日经文.png';a.click()};
'''
BASE_HTML=b.page_html
def page_html(page,mode,w,h,dark=False,state='',full=False):
 return BASE_HTML(page,mode,w,h,dark,state,full).replace('MODE_IS_IPAD','true' if mode.startswith('ipad-') else 'false')
b.page_html=page_html

def generate():
 rows=[]
 for page in b.PAGES:
  if page=='compass':continue
  for mode,w,h,dark in b.MODES:
   name=f'{page}-{mode}'
   (P/(name+'.html')).write_text(page_html(page,mode,w,h,dark))
   rows.append(dict(page=page,mode=mode,width=w,height=h,dark=dark,file=name))
 for page,height in [('almanac',12000),('daily',1650),('day',1500)]:
  name=f'{page}-phone-light-full';(P/(name+'.html')).write_text(page_html(page,'phone-light',375,height,False,full=True));rows.append(dict(page=page,mode='phone-light',width=375,height=height,dark=False,file=name,full=True))
 # Keep legacy compass routes pointing to the integrated page.
 for mode,w,h,dark in b.MODES:
  (P/f'compass-{mode}.html').write_text('<meta charset="utf-8"><meta http-equiv="refresh" content="0;url=almanac-'+mode+'.html#almanac-compass"><a href="almanac-'+mode+'.html#almanac-compass">前往黄历内的罗盘</a>')
 (P/'screens.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2))
 (P/'COPY.json').write_text(json.dumps({'activities':COPY,'fields':FIELDS},ensure_ascii=False,indent=2))
 return rows
if __name__=='__main__':print('Generated',len(generate()),'HTML designs; no browser invoked.')
