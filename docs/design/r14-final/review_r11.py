import json,math,re
from datetime import date,timedelta
from bs4 import BeautifulSoup
import review_r10 as prior
r=prior.r;P=r.P
BASE_CONTENT=r.content;BASE_HTML=r.page_html
r.PAGES['almanac']='黄历';r.PAGES['compass']='罗盘'
DATA=json.loads((P/'calendar-fixture.json').read_text())
DIRECTIONS={'北':0,'正北':0,'东北':45,'东':90,'正东':90,'东南':135,'南':180,'正南':180,'西南':225,'西':270,'正西':270,'西北':315}
ICON='<svg viewBox="0 0 24 24" width="21" height="21" fill="none" stroke="currentColor" stroke-width="1.7"><circle cx="12" cy="12" r="9"/><path d="m15.5 8.5-2 5-5 2 2-5z"/></svg>'
def compass(mode,state=''):
 hourly=state=='hour';h=DATA['hours'][5];directions=h['directions'] if hourly else DATA['directions'];sha=h['sha'] if hourly else DATA['sha']
 lead='<section class="compass-intro"><div class="eyebrow">方位随日期与时辰展开</div><h1>罗盘</h1><p data-date-label="selected">2026年11月12日</p><div class="compass-switch" role="group" aria-label="方位维度"><button data-r11-compass="day" aria-pressed="'+str(not hourly).lower()+'" class="'+('active' if not hourly else '')+'">日方位</button><button data-r11-compass="hour" aria-pressed="'+str(hourly).lower()+'" class="'+('active' if hourly else '')+'">时方位</button></div><label class="hour-choice" '+('' if hourly else 'hidden')+'>选择时辰<select id="compass-hour">'+''.join(f'<option value="{i}" {"selected" if i==5 else ""}>{x["branch"]}时 · {x["gz"]}</option>' for i,x in enumerate(DATA['hours']))+'</select></label><p class="hint" id="r11-compass-context">'+('巳时 · 09:00—11:00' if hourly else '所选日期的日方位')+'</p></section>'
 s=BeautifulSoup(r.b.compass(),'html.parser');stage=s.select_one('.compass-stage')
 dims=next(x for x in r.MODES if x[0]==mode);prof=r.profile(mode,dims[1],dims[2]);pane=(prof['contentWidth']-20)/2 if prof['appw']>=600 and dims[1]>dims[2] else prof['contentWidth'];size=min(300,max(160,pane-38));stage['style']=f'width:{size}px!important;height:{size}px!important;max-width:100%;'
 for i,(pin,direction) in enumerate(zip(stage.select('.pin'),directions)):
  rad=math.radians(DIRECTIONS[direction]);radius=29 if i%2==0 else 35;pin['style']=f'left:{50+radius*math.sin(rad)}%;top:{50-radius*math.cos(rad)}%'
 sector=stage.select_one('.sha-sector,.sha-map');sector['data-r11-sector']='';sector['style']=f'transform:rotate({DIRECTIONS[sha]}deg)'
 legend='<div class="compass-legend">'+''.join(f'<div class="list-row"><span>{name}</span><b data-r11-direction="{i}">{d}</b></div>' for i,(name,d) in enumerate(zip(['喜神','财神','福神','阳贵','阴贵'],directions)))+f'<div class="list-row"><span>煞方</span><b data-r11-sha>{sha}</b></div></div>'
 return lead,'<section class="card compass-board">'+str(s)+legend+'<p class="hint">固定北向图 · 上方为正北</p></section>'
def content(page,mode,state=''):
 if page=='compass':return compass(mode,state)
 lead,detail=BASE_CONTENT(page,mode,state)
 if page=='almanac':
  lead=lead.replace('读懂今日的历法','历法说明').replace('今日黄历','黄历').replace('今日宜忌','宜忌').replace('今日','当日')
  detail=detail.replace('今日','当日').replace('今天','这一天')
  lead=lead.replace('今天','这一天')
  s=BeautifulSoup(lead,'html.parser');main=s.select_one('.almanac-main');a=main.select_one('.main-compass-link');a.clear();a.append(BeautifulSoup(ICON,'html.parser'));a.append('罗盘');a['aria-label']='打开所选日期的罗盘';a['class']=['main-compass-link','compass-action'];a['data-r11-compass-link']=''
  for decor in main.select('.decor'):decor['aria-hidden']='true'
  for p in main.select('.leadcopy'):p['data-almanac-date']=''
  for h1 in main.select('h1'):h1.string='黄历'
  nav=s.new_tag('nav',attrs={'class':'date-stepper','aria-label':'切换黄历日期'})
  for step,label in [(-1,'‹ 前一天'),(1,'后一天 ›')]:
   a=s.new_tag('a',attrs={'href':r.link('almanac',mode,'?date='+('2026-11-11' if step<0 else '2026-11-13')),'data-date-step':str(step)});a.string=label;nav.append(a)
  main.append(nav)
  for h2 in s.select('h2'):
   if h2.text=='历法说明':
    card=h2.find_parent('section',class_='card');card['class']=card.get('class',[])+['calendar-fields']
    for term in card.select('.term-row'):term['class'].append('calendar-field')
  if state in ['previous','next']:
   s.select_one('#matched-festival-slot').clear()
   day='11' if state=='previous' else '13';date_label=s.select_one('[data-almanac-date]')
   if date_label:date_label.string='2026年11月'+day+'日'
   s.select_one('.rounddate').string=day
  lead=str(s)
 return lead,detail
r.content=content;r.b.content=content
r.b.CSS+='''
.almanac-main{display:block!important;isolation:isolate}.almanac-main .decor{pointer-events:none!important;z-index:-1}.almanac-main h1{padding-right:100px!important}.almanac-main .compass-action{position:absolute;top:18px;right:18px;z-index:8;pointer-events:auto!important;min-width:88px;min-height:44px;display:flex;gap:7px;align-items:center;justify-content:center;background:#fff8ec!important;color:#7c2f20!important;border:1px solid #fff9!important;box-shadow:0 3px 10px #421d231b;padding:8px 14px;border-radius:24px;font-size:14px;font-weight:600}.compass-action svg{flex:none}.date-stepper{display:flex;gap:12px;justify-content:space-between;border-top:1px solid #ffffff40;padding-top:15px;margin-top:18px}.date-stepper>a{display:flex;align-items:center;justify-content:center;flex:1;min-height:44px;border:1px solid #ffffff55;border-radius:16px;background:#ffffff14;font-size:13px;color:inherit}.date-stepper>a:focus-visible,.compass-action:focus-visible{outline:3px solid #f5cb79;outline-offset:3px}
.plain-off .calendar-fields .calendar-field{padding:10px 0;display:grid;grid-template-columns:minmax(70px,.32fr) minmax(0,1fr);gap:12px;align-items:start}.plain-off .calendar-fields .calendar-field h3{margin:0;font-size:14px;line-height:1.7}.plain-off .calendar-fields .calendar-field small{font-size:12px;line-height:1.8}.plain-off .calendar-fields .plain-explain{display:none!important}
.compass-intro{padding:62px 18px 16px}.compass-intro>p{margin:8px 0}.compass-switch{display:flex;background:var(--wash);padding:4px;border-radius:22px;margin-top:18px;gap:4px}.compass-switch button{flex:1;min-height:44px;border:0;background:transparent;border-radius:18px;color:var(--muted);font-size:14px}.compass-switch button.active{background:var(--red);color:var(--bg)}.hour-choice{display:flex;align-items:center;gap:10px;font-size:12px;margin:14px 0}.hour-choice[hidden]{display:none!important}.hour-choice select{flex:1;min-width:0;min-height:44px;border:1px solid var(--line);border-radius:14px;background:var(--paper);color:var(--ink);padding:8px}.compass-board{padding:18px}.compass-board .compass-stage{width:100%;max-width:430px;margin:auto;aspect-ratio:1;height:auto;overflow:visible}.compass-board .list-row{min-height:44px;padding:10px 0}.compass-board .hint{text-align:center}.page-compass.wide .workspace,.page-compass.duo-wide .workspace{display:grid!important;grid-template-columns:minmax(180px,.7fr) minmax(0,1.3fr);gap:20px;overflow:hidden!important}.page-compass.wide .workspace>section,.page-compass.duo-wide .workspace>section{height:100%;min-height:0;overflow:auto!important}
'''
SCRIPT='''
function r11DateKey(value){if(!/^\\d{4}-\\d{2}-\\d{2}$/.test(value||''))return '2026-11-12';let d=new Date(value+'T12:00:00Z');return Number.isNaN(d.valueOf())?'2026-11-12':d.toISOString().slice(0,10)}
function r11ShiftDate(value,delta){let d=new Date(value+'T12:00:00Z');d.setUTCDate(d.getUTCDate()+delta);return d.toISOString().slice(0,10)}
const r11Date=r11DateKey(new URLSearchParams(location.search).get('date')||R11_DEFAULT_DATE);const r11DateObject=new Date(r11Date+'T12:00:00Z');const r11DateLabel=new Intl.DateTimeFormat('zh-CN',{year:'numeric',month:'long',day:'numeric',weekday:'long',timeZone:'UTC'}).format(r11DateObject);
qa('[data-date-step]').forEach(a=>{a.href=R11_ALMANAC_URL+'?date='+r11ShiftDate(r11Date,Number(a.dataset.dateStep));});
qa('p[data-almanac-date],p[data-date-label="selected"]').forEach(n=>{if(n.childElementCount===0)n.textContent=r11DateLabel;});
qa('[data-r11-compass-link]').forEach(a=>a.href=R11_COMPASS_URL+'?date='+r11Date);
if(document.body.classList.contains('page-compass')){q('.floating-back').href=R11_ALMANAC_URL+'?date='+r11Date;}
if(document.body.classList.contains('page-almanac')){let dateNumber=q('.almanac-main .rounddate');if(dateNumber)dateNumber.textContent=Number(r11Date.slice(-2));}
const r11CompassData=R11_COMPASS_DATA;const r11Bearing={北:0,正北:0,东北:45,东:90,正东:90,东南:135,南:180,正南:180,西南:225,西:270,正西:270,西北:315};
function r11SetCompass(mode){const hourly=mode==='hour';qa('[data-r11-compass]').forEach(b=>{b.classList.toggle('active',b.dataset.r11Compass===mode);b.setAttribute('aria-pressed',String(b.dataset.r11Compass===mode));});let select=q('#compass-hour');if(!select)return;const data=hourly?r11CompassData.hours[Number(select.value)]:r11CompassData;let chooser=q('.hour-choice');chooser.hidden=!hourly;q('#r11-compass-context').textContent=hourly?data.branch+'时 · '+data.gz:'所选日期的日方位';qa('[data-r11-direction]').forEach((n,i)=>n.textContent=data.directions[i]);q('[data-r11-sha]').textContent=data.sha;qa('.compass-board .pin').forEach((pin,i)=>{const angle=r11Bearing[data.directions[i]]*Math.PI/180;const radius=i%2===0?29:35;pin.style.left=(50+radius*Math.sin(angle))+'%';pin.style.top=(50-radius*Math.cos(angle))+'%';});q('.compass-board [data-r11-sector]').style.transform='rotate('+r11Bearing[data.sha]+'deg)';}
qa('[data-r11-compass]').forEach(b=>b.onclick=()=>r11SetCompass(b.dataset.r11Compass));if(q('#compass-hour'))q('#compass-hour').onchange=()=>r11SetCompass('hour');
'''
def page_html(page,mode,w,h,dark=False,state='',full=False):
 s=BASE_HTML(page,mode,w,h,dark,state,full)
 if state in ['previous','next']:
  selected='2026-11-11' if state=='previous' else '2026-11-13'
  s=s.replace("let selectedAlmanacDate=new URLSearchParams(location.search).get('date')||\"2026-11-12\"","let selectedAlmanacDate=new URLSearchParams(location.search).get('date')||"+json.dumps(selected))
 if page in ['almanac','compass']:s=s.replace('历象 · 黄历详情','历象 · 黄历').replace('历象 · 今日罗盘','历象 · 罗盘')
 script=SCRIPT.replace('R11_DEFAULT_DATE',json.dumps('2026-11-11' if state=='previous' else '2026-11-13' if state in ['next','no-festival'] else '2026-11-22' if state=='winter' else '2026-11-12')).replace('R11_ALMANAC_URL',json.dumps(r.link('almanac',mode))).replace('R11_COMPASS_URL',json.dumps(r.link('compass',mode))).replace('R11_COMPASS_DATA',json.dumps(DATA,ensure_ascii=False))
 # The earlier compass routing hook is superseded by the explicit dated links above.
 return s.replace('</script>','\n'+script+'</script>')
r.page_html=page_html
if __name__=='__main__':
 rows=r.generate()
 for mode,w,h,dark in r.MODES:
  name='compass-'+mode+'-hour';(P/(name+'.html')).write_text(page_html('compass',mode,w,h,dark,'hour'));rows.append(dict(page='compass',mode=mode,width=w,height=h,dark=dark,state='hour',full=False,file=name))
 for state in ['previous','next']:
  name='almanac-phone-light-'+state;(P/(name+'.html')).write_text(page_html('almanac','phone-light',375,930,False,state));rows.append(dict(page='almanac',mode='phone-light',width=375,height=930,dark=False,state=state,full=False,file=name))
 (P/'screens.json').write_text(json.dumps(rows,ensure_ascii=False,indent=2));print('Generated',len(rows),'R11 screens')
