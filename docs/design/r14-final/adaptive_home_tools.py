from bs4 import BeautifulSoup

def install(r):
 base_html=r.page_html
 panel_style='display:flex!important;flex-direction:column;flex:1 1 0;min-width:0;gap:2px!important;padding:8px!important;height:auto!important;min-height:0!important;align-items:stretch!important;justify-content:flex-start!important;'
 cloud='<span class="adaptive-weather-icon" aria-hidden="true">☁</span>'
 def weather(state='notDetermined'):
  if state=='authorized':body='<span class="adaptive-tool-caption">上海 · 8° 多云</span>'
  elif state=='loading':body='<span class="adaptive-tool-caption" role="status">正在定位城市…</span>'
  else:
   action,label=('settings','去设置 ›') if state=='denied' else ('retry','重试 ›') if state=='error' else ('request','开启定位 ›')
   body=f'<button class="adaptive-tool-caption adaptive-tool-action" data-location="{action}">{label}</button>'
  return f'<section class="card weather adaptive-tool-panel adaptive-weather" id="weather-panel" data-weather="{state}" style="{panel_style}"><div class="adaptive-tool-heading">{cloud}<h3>今日天气</h3></div>{body}</section>'
 def shortcuts(mode,state='notDetermined'):
  return f'<div class="home-tools day-support adaptive-tools" style="display:flex!important;align-items:stretch;gap:12px;height:auto!important;min-height:0!important;margin-bottom:0!important"><a class="card fortune-entry adaptive-tool-panel" href="{r.link("fortune",mode)}" style="{panel_style}"><div class="adaptive-tool-heading"><img src="assets/fortune-cup.png" alt="" aria-hidden="true" style="width:24px!important;height:24px!important;object-fit:contain"><h3>每日一签</h3></div><span class="adaptive-tool-caption">静心，问今日 ›</span></a>{weather(state)}</div>'
 r.shortcuts=shortcuts;r.b.shortcuts=shortcuts;r.old.weather=weather
 css='''
.adaptive-tools .adaptive-tool-heading{flex:0 0 auto;display:flex;align-items:center;justify-content:center;gap:8px;min-height:26px;width:auto;align-self:stretch;margin:0}.adaptive-tools .adaptive-tool-heading h3{font-size:14px!important;font-weight:600;line-height:22px;margin:0;white-space:nowrap}.adaptive-tools .adaptive-tool-heading h3:before{display:none!important;content:none!important}.adaptive-tool-heading>svg,.adaptive-tool-heading>img,.adaptive-tool-heading>.adaptive-weather-icon{flex:none;width:24px;height:24px;color:var(--gold)}.adaptive-tools .adaptive-tool-caption{flex:1 0 auto;display:flex;align-items:center;justify-content:center;min-height:0;width:auto;align-self:stretch;font-size:11px!important;line-height:1.5;text-align:center;color:var(--muted);margin:0;padding:0 2px;border:0;background:transparent;box-sizing:border-box}.adaptive-tools .adaptive-weather-icon{display:grid;place-items:center;font-size:23px;line-height:24px}.adaptive-tools .adaptive-tool-action{min-height:44px;cursor:pointer;color:var(--ink);border:1px solid var(--line);border-radius:22px;background:var(--paper);padding:0 8px}.adaptive-tools+.almanac-teaser{margin-top:16px!important}
'''
 r.b.CSS+=css
 def page_html(page,mode,w,h,dark=False,state='',full=False):
  html=base_html(page,mode,w,h,dark,state,full)
  if page!='home':return html
  soup=BeautifulSoup(html,'html.parser');tools=soup.select_one('.adaptive-tools');tools['style']='display:flex!important;align-items:stretch;gap:12px;height:auto!important;min-height:0!important;margin-bottom:0!important;position:static!important;top:auto!important;left:auto!important;width:auto!important;'
  # Let only the existing home column redistribute space; no fixed tool track remains.
  classes=soup.body.get('class',[])
  if ('wide' in classes or 'duo-wide' in classes) and not full:
   stack=soup.select_one('.home-stack');stack['style']='display:grid!important;position:relative;height:100%;grid-template-rows:minmax(0,1fr) auto!important;gap:12px!important;min-height:0;'
   hero=stack.select_one('.hero');hero['style']='position:relative;left:auto;top:auto;width:100%;height:auto;min-height:0;margin:0;display:flex;flex-direction:column;'
  result=str(soup)
  if mode=='duo-tabletop':
   result=result.replace(' data-device-mode="duo-tabletop" data-layout-family="duo-open-portrait"','').replace('<body ','<body data-device-mode="duo-tabletop" data-layout-family="duo-open-portrait" ',1)
  return result
 r.page_html=page_html
 return weather,shortcuts
