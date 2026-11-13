from pathlib import Path
import json,re,hashlib
from urllib.parse import urlsplit,unquote
from bs4 import BeautifulSoup
from PIL import Image
P=Path(__file__).resolve().parent
rows=json.loads((P/'screens.json').read_text());provenance={v['file']:v for v in json.loads((P/'R14-RENDER-PROVENANCE.json').read_text())};fail=[]
for row in rows:
 name=row['file'];p=P/(name+'.png')
 if not p.exists():fail.append('Missing '+str(p));continue
 size=Image.open(p).size;sc=3 if row['mode'].startswith('duo-') else 2
 if size[0]!=row['width']*sc:fail.append('Width '+name)
 prov=provenance.get(name+'.png')
 if not prov or prov['pixelSize']!=list(size):fail.append('Provenance '+name)
 if prov:
  for x,y,w,h in prov['navigationTargets']:
   if min(w,h)<44 or x<0 or x+w>row['width'] or y<0 or y+h>size[1]/sc:fail.append('Navigation bounds '+name)
  if prov.get('motion'):
   x,y,w,h=prov['motion']['actions']
   if min(w,h)<44 or y+h>row['height']:fail.append('Fortune action '+name)
 for a in BeautifulSoup((P/(name+'.html')).read_text(),'html.parser').select('[href],[src]'):
  url=a.get('href') or a.get('src')
  if not url or url.startswith(('#','http:','https:','data:','mailto:','javascript:')):continue
  target=P/unquote(urlsplit(url).path)
  if not target.exists():fail.append(name+': '+url)
assert not fail,'\n'.join(fail)
report={'screenCount':len(rows),'pngCount':len(provenance),'localLinks':'PASS','navigationTargetsMin44pt':'PASS','fortuneActionsWithinCanvas':'PASS','imageProvenance':'PASS','nativeApp':'UNVERIFIED','browserPaint':'UNVERIFIED','pngMethod':'offline design composition'}
(P/'R14-DELIVERY-VALIDATION.json').write_text(json.dumps(report,ensure_ascii=False,indent=2));print(report)
