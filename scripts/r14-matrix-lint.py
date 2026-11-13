#!/usr/bin/env python3
"""Validate R14 188-state matrix against screens.json and report status counts."""
import json, re, sys, pathlib
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
print('rows=',len(rows),'status_tokens=',counts)
if bad: print('FAIL:',bad); sys.exit(1)
print('PASS: 188 matrix rows present')
