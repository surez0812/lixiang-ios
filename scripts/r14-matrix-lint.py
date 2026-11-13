#!/usr/bin/env python3
"""Validate R14 188-state matrix against screens.json and report status counts."""
import json, re, sys, pathlib, collections
ROOT=pathlib.Path(__file__).resolve().parents[1]
screens=json.load(open(ROOT.parent/'lixiang-design-handoff-20261113/docs/design/r14-final/screens.json'))
md=(ROOT/'docs/R14-QA-MATRIX.md').read_text()
rows=[l for l in md.splitlines() if re.match(r'^\| \d+ \|',l)]
bad=[]
if len(rows)!=188: bad.append(f'rows={len(rows)} expected 188')
else:
    for i,x in enumerate(screens,1):
        if not rows[i-1].startswith(f'| {i} |'): bad.append(f'row {i} mismatch')
counts={k:md.count(f'**{k}**') for k in ['PASS','FAIL','NOT RUN']}
expected=collections.Counter(x['page'] for x in screens)
actual=collections.Counter()
for l in rows:
    parts=[p.strip() for p in l.strip('|').split('|')]
    actual[parts[1].split()[0]] += 1
if expected != actual:
    bad.append(f'page counts mismatch expected={dict(expected)} actual={dict(actual)}')
print('rows=',len(rows),'status_tokens=',counts)
print('page_counts=',dict(actual))
if bad: print('FAIL:',bad); sys.exit(1)
print('PASS: 188 matrix rows present')
