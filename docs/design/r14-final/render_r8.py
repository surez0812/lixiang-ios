from pathlib import Path
import io,json,math,sys,logging
from PIL import Image,ImageDraw
import cairosvg
from bs4 import BeautifulSoup
import review_r8 as r
from render_designs import fragment,icon,text,font
P=r.P

def figure():
 stage=Image.new('RGBA',(600,860));cup=Image.open(P/'assets/fortune-cup.png').convert('RGBA');stick=Image.open(P/'assets/fortune-stick.png').convert('RGBA')
 def paste(im,a,rect):
  x,y,w,h=rect;im.alpha_composite(a.resize((round(w*2),round(h*2)),Image.Resampling.LANCZOS),(round(x*2),round(y*2)))
 paste(stage,cup,[99,165,103,230]);sticks=Image.new('RGBA',stage.size)
 for x,h,angle in [(132,205,-2),(141,217,-1),(157,209,1),(166,198,2)]:
  lay=Image.new('RGBA',stage.size);paste(lay,stick,[x,320-h,9,h]);lay=lay.rotate(-angle,Image.Resampling.BICUBIC,center=((x+4.5)*2,(320-h*.1)*2));sticks.alpha_composite(lay)
 paste(sticks,stick,[145,95,10,225]);alpha=sticks.getchannel('A');ImageDraw.Draw(alpha).rectangle((0,384,600,860),fill=0);sticks.putalpha(alpha);stage.alpha_composite(sticks)
 front=cup.resize((206,460),Image.Resampling.LANCZOS);alpha=front.getchannel('A');ImageDraw.Draw(alpha).rectangle((0,0,206,round(460*.12)),fill=0);front.putalpha(alpha);stage.alpha_composite(front,(198,330));return stage
FIGURE=figure()

def svg_image(svg,w,h,color='#35291F'):
 return Image.open(io.BytesIO(cairosvg.svg2png(bytestring=svg.replace('currentColor',color).encode(),output_width=round(w*2),output_height=round(h*2)))).convert('RGBA')

def shell(row):
 w,h,dark=row['width'],row['height'],row['dark'];prof=r.profile(row['mode'],w,h)
 colors=dict(bg='#211D19' if dark else '#FFF8EC',paper='#30281F' if dark else '#FFFCF5',ink='#F8ECD8' if dark else '#35291F',muted='#C9B69C' if dark else '#79634D',red='#FFAC88' if dark else '#A63D26',line='#69523B' if dark else '#E8D6BA',wash='#403326' if dark else '#F6E8D1')
 im=Image.new('RGB',(w*2,h*2),colors['bg']);d=ImageDraw.Draw(im)
 if prof['split']:
  nx=0 if prof['appx'] else w/2;d.rectangle((nx*2,0,(nx+w/2)*2,h*2),fill='#E8E6E1');text(im,nx+w/4,h/2,'另一 App',18,'#8E877D',anchor='mm');d.line((w,0,w,h*2),fill='#CCC7BD',width=2)
 if not prof['duo']:
  text(im,22,12,'9:41',12,colors['ink']);text(im,w-22,12,'●●●  ▰',11,colors['ink'],anchor='rt');d.ellipse((40,88,124,172),fill=colors['paper'],outline=colors['line'],width=2);text(im,41,64,'‹',25,colors['ink'],anchor='mm');text(im,w/2,65,'历象' if row['page'] in ['home','day'] else r.PAGES[row['page']],20,colors['ink'],True,anchor='mm')
 else:
  headerx=prof['contentX'];title='历象' if row['page'] in ['home','day'] else r.PAGES[row['page']]
  if row['page'] not in ['home','folklore','countdown','settings']:
   bx=prof['appx']+27 if prof['edge']=='left' else prof['appx']+prof['appw']-71;by=prof['backY']
   d.ellipse((round(bx*2),round(by*2),round((bx+44)*2),round((by+44)*2)),fill=colors['paper'],outline=colors['line'],width=2);text(im,bx+22,by+22,'‹',25,colors['ink'],anchor='mm')
  text(im,headerx,32,title,21,colors['ink'],True)
 return im,prof,colors

def paste_fragment(im,markup,x,y,w,maxh=None,dark=False):
 a=fragment(markup,w,dark);height=a.height/2
 if maxh is not None:a=a.crop((0,0,a.width,max(1,min(a.height,round(maxh*2)))))
 im.paste(a,(round(x*2),round(y*2)));return height

def nav(im,row,prof,c):
 d=ImageDraw.Draw(im);w,h=row['width'],row['height'];active='folklore' if row['page'].startswith('folklore') else 'countdown' if row['page'].startswith('countdown') else 'settings' if row['page']=='settings' else 'home';rects=[]
 names=[('home','calendar','日历'),('folklore','suishi','岁时'),('countdown','countdown','倒计日'),('settings','settings','设置')]
 if prof['duo']:
  xx=prof['appx']+23 if prof['edge']=='left' else prof['appx']+prof['appw']-73;yy=prof['tabY']
  box=(round(xx*2),round(yy*2),round((xx+50)*2),round((yy+212)*2));d.rounded_rectangle(box,radius=58,fill=c['paper'],outline=c['line'],width=2);d.arc((box[0]+3,box[1]+3,box[2]-3,box[1]+102),180,360,fill='#FFFFFF',width=2)
  for i,(page,asset,label) in enumerate(names):
   cy=yy+29+i*51;selected=page==active;color=c['red'] if selected else c['ink']
   if selected:d.rounded_rectangle((round((xx+4)*2),round((cy-24)*2),round((xx+46)*2),round((cy+24)*2)),radius=44,fill=c['wash'])
   a=icon(asset,color,25);im.paste(a,(round((xx+12.5)*2),round((cy-12.5)*2)),a);rects.append([xx+3,cy-25,44,50]);badge(im,page,xx+38,cy-18,c)
  if prof['statusVisible']:
   sx=prof['appx']+24 if prof['edge']=='left' else prof['appx']+prof['appw']-71;sy=prof['statusY'];text(im,sx+23.5,sy,'09:41',15,c['ink'],anchor='mt');a=svg_image(r.STATUS_SVG,47,44,c['ink']);im.paste(a,(round(sx*2),round((sy+21)*2)),a)
 else:
  tw=min(w-40,560);tx=(w-tw)/2;ty=h-82;d.rounded_rectangle((round(tx*2),round(ty*2),round((tx+tw)*2),round((ty+68)*2)),radius=54,fill=c['paper'],outline=c['line'],width=2)
  for i,(page,asset,label) in enumerate(names):
   cx=tx+tw*(i+.5)/4;selected=page==active;color=c['red'] if selected else c['muted']
   if selected:d.rounded_rectangle((round((cx-tw/8+5)*2),round((ty+5)*2),round((cx+tw/8-5)*2),round((ty+63)*2)),radius=40,fill=c['wash'])
   a=icon(asset,color);im.paste(a,(round((cx-12)*2),round((ty+10)*2)),a);text(im,cx,ty+49,label,11,color,anchor='mm');rects.append([cx-tw/8+3,ty+3,tw/4-6,62]);badge(im,page,cx+17,ty+10,c)
 return rects

def badge(im,page,x,y,c):
 d=ImageDraw.Draw(im)
 if page=='folklore':d.ellipse((round((x-3)*2),round((y-3)*2),round((x+3)*2),round((y+3)*2)),fill='#C94430',outline=c['paper'],width=2)
 if page=='countdown':
  d.rounded_rectangle((round((x-9)*2),round((y-6)*2),round((x+11)*2),round((y+7)*2)),radius=12,fill=c['paper'],outline='#C94430',width=2);d.ellipse((round((x-6)*2),round((y-1)*2),round((x-3)*2),round((y+2)*2)),fill='#C94430');text(im,x+3,y+.5,'0',9,'#C94430',anchor='mm')

def fortune_layout(im,row,prof,c,put):
 x,y,cw,ch=prof['contentX'],prof['contentY'],prof['contentWidth'],prof['contentHeight'];wide=prof['appw']>=600 and row['width']>row['height'];lead,_=r.fortune(row['mode'],row.get('state',''))
 if wide:
  lw=cw*.31;put(lead,x,y+ch*.28,lw,ch*.4);vx=x+lw+24;vy=y;vw=cw-lw-24;vh=ch-98
 else:
  hh=put(lead,x,y,cw,108);vx=x;vy=y+min(hh,108)+8;vw=cw;vh=ch-(vy-y)-100
 vh=max(100,vh)
 if row.get('state')=='result':
  markup='<article class="card" style="padding:28px 24px;background:var(--paper)"><div class="eyebrow">第36签 · 上上</div><h2 style="text-align:center;color:var(--red)">'+r.SIGN['title']+'</h2><p class="serif" style="font-size:21px;line-height:1.85;text-align:center;margin:20px 0">'+'<br>'.join(r.SIGN['poem'])+'</p><div class="divider"></div><h3>签意</h3><p style="font-size:14px;line-height:1.9;margin:10px 0 20px">'+r.SIGN['explain']+'</p><h3>今日可做</h3><p style="font-size:14px;line-height:1.9;margin-top:10px">'+r.SIGN['advice']+'</p></article>'
  ww=min(380,vw);put(markup,vx+(vw-ww)/2,vy,ww,vh)
 else:
  scale=min(vw/300,vh/430);art=FIGURE.resize((round(600*scale),round(860*scale)),Image.Resampling.LANCZOS);im.paste(art,(round((vx+(vw-300*scale)/2)*2),round((vy+(vh-430*scale)/2)*2)),art)
 d=ImageDraw.Draw(im);by=vy+vh+16;skipw=90;bw=vw-skipw-10
 d.rounded_rectangle((round(vx*2),round(by*2),round((vx+bw)*2),round((by+48)*2)),radius=48,fill=c['red']);text(im,vx+bw/2,by+24,'收好今日一签' if row.get('state')=='result' else '轻摇，遇见今日一签',13,c['bg'],anchor='mm')
 d.rounded_rectangle((round((vx+bw+10)*2),round(by*2),round((vx+vw)*2),round((by+48)*2)),radius=44,fill=c['paper'],outline=c['line'],width=2);text(im,vx+vw-skipw/2,by+24,'跳过动画',12,c['ink'],anchor='mm');text(im,vx+vw/2,by+67,'同一天，保留同一结果。',10,c['muted'],anchor='mm')
 return dict(visual=[vx,vy,vw,vh],actions=[vx,by,vw,48],stageSize=[300,430],approvedCoreUnchanged=True)

def render(row):
 im,prof,c=shell(row);p,m,dark=row['page'],row['mode'],row['dark'];x,y,cw,ch=[prof[k] for k in ['contentX','contentY','contentWidth','contentHeight']];wide=prof['appw']>=600 and row['width']>row['height'];blocks=[]
 def put(markup,xx,yy,ww,maxh=None):
  hh=paste_fragment(im,markup,xx,yy,ww,maxh,dark);blocks.append([xx,yy,ww,hh,maxh]);return hh
 lead,detail=r.content(p,m,row.get('state',''));motion=None
 if p=='fortune':motion=fortune_layout(im,row,prof,c,put)
 elif row.get('full'):
  yy=y
  for markup in [lead,detail]:yy+=put(markup,x,yy,cw)+15
  im=im.crop((0,0,im.width,min(im.height,round((yy+108)*2))));row=dict(row,height=im.height//2)
 elif row.get('state','').startswith('weather-'):
  put(r.weather(row['state'].replace('weather-','')),x,y,cw,ch);put(r.prior.teaser(m),x,y+230,cw,ch-230)
 elif m.startswith('ipad-') and p in ['home','day']:
  if wide:
   left=round(cw*.37);right=round(cw*.28);mid=cw-left-right-32
   put(r.hero(m),x,y,left,ch)
   put('<div class="ipad-summary">'+r.prior.teaser(m)+r.b.seasons(m)+'</div>',x+left+16,y,mid,ch)
   put(r.month(m)+'<div class="ipad-compact-tools">'+r.shortcuts(m)+'</div>',x+left+mid+32,y,right,ch)
  else:
   banner=r.hero(m).replace('card hero','card hero r8-banner');hh=put(banner,x,y,cw,395);ny=y+min(hh,395)+18;ww=(cw-16)/2
   put(r.prior.teaser(m)+r.b.seasons(m),x,ny,ww,ch-(ny-y));put(r.month(m),x+ww+16,ny,ww,ch-(ny-y))
 elif p=='folklore-detail':
  if wide:
   lw=cw*.3;put(lead,x,y,lw,ch);put(detail,x+lw+22,y,cw-lw-22,ch)
  else:
   hh=put(lead,x,y,cw,ch);put(detail,x,y+hh+14,cw,max(1,ch-hh-14))
 elif wide:
  ww=(cw-18)/2;put(lead,x,y,ww,ch);put(detail,x+ww+18,y,ww,ch)
 else:
  hh=put(lead,x,y,cw,ch)
  if hh+15<ch:put(detail,x,y+hh+15,cw,ch-hh-15)
 buttons=nav(im,row,prof,c)
 if row.get('state') in ['weather-system-prompt','system-prompt']:
  shade=Image.new('RGBA',im.size,(25,20,15,55));im=Image.alpha_composite(im.convert('RGBA'),shade).convert('RGB')
  prompt=fragment(r.system_prompt('location' if row['state']=='weather-system-prompt' else 'notification'),min(cw,300),dark)
  px=prof['appx']+(prof['appw']-prompt.width/2)/2;py=(row['height']-prompt.height/2)/2
  im.paste(prompt,(round(px*2),round(py*2)))
 scale=3 if prof['duo'] else 2
 if scale==3:im=im.resize((row['width']*3,row['height']*3),Image.Resampling.LANCZOS)
 im.save(P/(row['file']+'.png'))
 return dict(file=row['file']+'.png',method='offline HTML fragment typesetting + original image assets/vector composition',browserScreenshot=False,pixelSize=list(im.size),logicalCanvas=[row['width'],row['height']],appViewport=[prof['appx'],0,prof['appw'],row['height']],contentRect=[x,y,cw,ch],navigationTargets=buttons,motion=motion,sourceReference='DuoReferenceManifest.json' if prof['duo'] else None)

if __name__=='__main__':
 rows=json.loads((P/'screens.json').read_text());names=sys.argv[1:]
 if names:rows=[x for x in rows if x['file'] in names]
 out={x['file']:x for x in json.loads((P/'R8-RENDER-PROVENANCE.json').read_text())} if (P/'R8-RENDER-PROVENANCE.json').exists() else {}
 for i,row in enumerate(rows):
  item=render(row);out[item['file']]=item
  if names or (i+1)%14==0:print(row['file'],flush=True)
 (P/'R8-RENDER-PROVENANCE.json').write_text(json.dumps(list(out.values()),ensure_ascii=False,indent=2))
