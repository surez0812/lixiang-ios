from pathlib import Path
import json,hashlib,re
from PIL import Image
P=Path(__file__).resolve().parent;rows=json.loads((P/'screens.json').read_text());modes={a['mode'] for a in rows};assert len(rows)==188 and len(modes)==12
assert not any(x.startswith('phone-landscape') or 'splitview' in x for x in modes)
assert not list(P.glob('*phone-landscape*.html')) and not list(P.glob('*phone-landscape*.png'))
results=[]
for row in rows:
 if row['mode']!='duo-tabletop':continue
 assert (row['width'],row['height'])==(669,951)
 name=row['file'];other=name.replace('duo-tabletop','duo-open-portrait');tablet=(P/(name+'.html')).read_text();canonical=tablet.replace('data-device-mode="duo-tabletop" data-layout-family="duo-open-portrait" ','').replace('duo-tabletop','duo-open-portrait');assert canonical==(P/(other+'.html')).read_text(),name
 assert (P/(name+'.png')).read_bytes()==(P/(other+'.png')).read_bytes();assert Image.open(P/(name+'.png')).size==(2007,2853)
 results.append({'page':name,'logicalSize':[669,951],'pixelSize':[2007,2853],'htmlSameLayout':True,'pngIdenticalToOpenPortrait':True})
(P/'R14-MODE-VALIDATION.json').write_text(json.dumps({'modes':sorted(modes),'screenCount':188,'phonePortraitOnly':True,'splitviewAbsent':True,'tabletopChecks':results},ensure_ascii=False,indent=2));print('PASS mode removal and all14 tabletop states identical to Open Portrait')
