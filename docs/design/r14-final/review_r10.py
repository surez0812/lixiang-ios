import json
from bs4 import BeautifulSoup
import review_r9 as r
P=r.P
BASE_CONTENT=r.content
BASE_HTML=r.page_html
r.PAGES['compass']='今日罗盘'

def compass(mode):
 lead,_=r.almanac(mode);s=BeautifulSoup(lead,'html.parser');c=s.select_one('.integrated-compass');c.extract()
 for n in c.select('.segmented,[data-compass-mode]'):n.decompose()
 c['class']=['card','day-compass'];c.attrs.pop('id',None)
 for n in c.select('h1'):
  n.decompose()
 return '<div class="compass-intro"><div class="eyebrow">只看这一天的方位</div><h1>今日罗盘</h1></div>',str(c)

def content(page,mode,state=''):
 if page=='compass':return compass(mode)
 lead,detail=BASE_CONTENT(page,mode,state)
 if page=='almanac':
  s=BeautifulSoup(lead,'html.parser');main=s.select_one('.feature');main['class']=main.get('class',[])+['almanac-main']
  eras=s.select_one('.eras');eras.name='div';eras['class']=['main-eras'];main.append(eras.extract())
  slot=s.select_one('#matched-festival-slot');main.append(slot.extract())
  c=s.select_one('.integrated-compass')
  if c:c.decompose()
  a=s.new_tag('a',attrs={'class':'main-compass-link','href':r.link('compass',mode),'aria-label':'查看当日罗盘'});a.string='◎ 今日罗盘 ›';main.insert(0,a)
  lead=str(s)
 elif page=='folklore':
  s=BeautifulSoup(lead,'html.parser');s.select_one('.segmented')['class']=['segmented','compact-filters'];lead=str(s)
 elif page=='countdown':
  lead='<div class="anniversary-intro" style="padding-bottom:20px">'+lead+'</div>'
 elif page=='folklore-detail':
  s=BeautifulSoup(lead,'html.parser');head=s.select_one('.native-event-head');head['class'].append('event-heading-compact')
  head.find('p',recursive=False)['data-event-date']=''
  intro=s.new_tag('p',attrs={'class':'event-deck'});intro.string='读一段来由，留一个属于今天的小仪式。';head.select_one('h1').insert_after(intro);lead=str(s)
 return lead,detail
r.content=content;r.b.content=content
CSS='''
/* R10 controls remain separate from the paper content. */
.anniversary-intro>[data-new-count]{height:48px!important;min-height:48px!important;padding:0 18px!important;display:flex!important;align-items:center!important;justify-content:center!important;line-height:20px!important}.page-countdown .workspace>.lead{padding-bottom:0!important}.hours-list{max-height:none!important;overflow:visible!important}
.compact-filters{display:flex!important;flex-wrap:nowrap!important;gap:6px!important;overflow-x:auto!important;overflow-y:hidden!important;padding:4px 0 8px!important;margin:12px 0!important;scrollbar-width:none;min-height:48px;align-items:center}
.compact-filters button{flex:0 0 auto!important;min-width:0!important;width:auto!important;min-height:44px!important;font-size:12px!important;padding:9px 13px!important;white-space:nowrap!important;line-height:20px!important}
.home-tools .fortune-entry,.home-tools .compact-weather{align-items:center!important;text-align:center!important;justify-content:center!important}.home-tools .compact-weather p{text-align:center}.home-tools .secondary{max-width:180px!important}.home-tools>.card{box-sizing:border-box!important;min-height:156px!important;padding:14px!important}.home-tools .fortune-entry img{height:42px!important}.home-tools .fortune-entry h3{margin:0}.home-tools{margin-bottom:0!important}
.page-home.wide .home-stack,.page-home.duo-wide .home-stack{height:100%;display:grid;grid-template-rows:minmax(0,1fr) 156px;gap:16px;min-height:0}
.page-home.wide .home-stack>.hero,.page-home.duo-wide .home-stack>.hero{margin:0!important;min-height:0;display:flex;flex-direction:column}
.page-home.wide .hero-art,.page-home.duo-wide .hero-art{flex:1 1 auto;min-height:90px;height:auto!important;max-height:270px}
.page-home.wide .hero-copy,.page-home.duo-wide .hero-copy{flex:none;padding-bottom:14px}
.page-home.wide .home-tools,.page-home.duo-wide .home-tools{height:156px;min-height:156px}
.page-home.wide .workspace>.lead,.page-home.duo-wide .workspace>.lead{height:100%;min-height:0;overflow:auto!important;padding-bottom:0;box-sizing:border-box}
.event-heading-compact{padding:62px 20px 18px!important;margin-bottom:12px!important}.event-heading-compact h1{font-size:30px!important;line-height:1.15!important;margin:9px 0!important}.event-heading-compact>p{margin:6px 0!important;font-size:12px!important}.event-heading-compact .event-deck{font-size:13px!important;line-height:1.7!important}.event-heading-compact .row{margin-top:12px}.event-heading-compact .secondary{min-height:44px;padding:8px 17px}
.page-folklore-detail .article-frame{min-height:0!important}.page-folklore-detail .workspace>.lead{flex:0 0 auto!important}.page-folklore-detail .workspace>.detail{min-height:0!important;flex:1 1 auto!important}
.page-daily.wide .workspace,.page-daily.duo-wide .workspace{display:grid!important;grid-template-columns:minmax(0,1fr) minmax(0,1.05fr)!important;gap:20px;overflow:hidden!important}
.page-daily.wide .workspace>section,.page-daily.duo-wide .workspace>section{height:100%;min-height:0;overflow-y:auto!important}
.almanac-main{position:relative}.almanac-main h1{padding-right:106px;font-size:29px}.main-compass-link{position:absolute;right:18px;top:20px;min-height:44px;display:flex;align-items:center;padding:8px 13px;border:1px solid #ffffff66;border-radius:24px;background:#ffffff18;font-size:12px;color:#fff}
.almanac-main .rounddate{font-size:54px!important;margin:13px 0!important}.main-eras{margin-top:18px;padding-top:15px;border-top:1px solid #ffffff40}.main-eras .eyebrow{display:none}.main-eras .era-row{border:0;padding:5px 0;font-size:12px}.main-eras .era-row span{color:inherit}.main-eras .era-row b{font-size:13px}
.almanac-main .matched-festivals{background:transparent!important;color:inherit!important;border:0!important;border-radius:0!important;padding:14px 0 0!important;margin:12px 0 0!important;border-top:1px solid #ffffff40!important;box-shadow:none}.almanac-main .matched-festivals h2{font-size:18px;color:inherit}.almanac-main .matched-festivals .eyebrow{display:none}.almanac-main .matched-event-list>a{min-height:44px;padding:9px 0;color:inherit;border-color:#ffffff40}.almanac-main .matched-event-list small{color:inherit;opacity:.8}
.page-almanac.wide .workspace,.page-almanac.duo-wide .workspace{height:var(--ch)!important;min-height:0;overflow:hidden!important;align-items:stretch;grid-template-rows:minmax(0,1fr)!important}
.page-almanac.wide .workspace>.lead,.page-almanac.wide .workspace>.detail,.page-almanac.duo-wide .workspace>.lead,.page-almanac.duo-wide .workspace>.detail{height:100%!important;max-height:100%;min-height:0!important;overflow-x:hidden!important;overflow-y:auto!important;overscroll-behavior-y:contain;box-sizing:border-box;padding-bottom:18px}
.page-countdown .workspace>.lead{padding-bottom:0!important}.page-countdown:not(.wide):not(.duo-wide) .workspace>.detail{margin-top:0!important}.page-compass .workspace{overflow:auto!important}.day-compass .segmented{display:none!important}.compass-intro{padding:60px 20px 18px}.compass-intro h1{font-size:28px}.day-compass{padding:20px}
'''
r.b.CSS+=CSS

def page_html(page,mode,w,h,dark=False,state='',full=False):
 s=BASE_HTML(page,mode,w,h,dark,state,full).replace("q('.workspace').prepend(note)","q('.workspace>.lead').append(note)")
 if page=='folklore-detail' and state=='today':s=s.replace("get('event')||'winter'","get('event')||'daily-kindness'")
 if page=='compass':s=s.replace('class="floating-back" href="'+r.link('home',mode)+'"','class="floating-back" href="'+r.link('almanac',mode)+'"')
 extra="const r10Date=new URLSearchParams(location.search).get('date');if(r10Date){const target=document.querySelector('.main-compass-link')||"+("document.querySelector('.floating-back')" if page=='compass' else "null")+";if(target)target.href+='?date='+encodeURIComponent(r10Date);}"
 return s.replace('</script>','\n'+extra+'</script>')
r.page_html=page_html
if __name__=='__main__':print('Generated',len(r.generate()),'R10 screens')
