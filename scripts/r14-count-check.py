#!/usr/bin/env python3
"""Assert matrix page counts equal screens.json counts; write R14-QA-COUNT-CHECK.md."""
import json, re, collections, pathlib, sys
ROOT=pathlib.Path(__file__).resolve().parents[1]
SCREENS=ROOT.parent/'lixiang-design-handoff-20261113/docs/design/r14-final/screens.json'
MATRIX=ROOT/'docs/R14-QA-MATRIX.md'
OUT=ROOT/'docs/R14-QA-COUNT-CHECK.md'
s=json.loads(SCREENS.read_text())
expected=collections.Counter(x['page'] for x in s)
rows=[l for l in MATRIX.read_text().splitlines() if re.match(r'^\| \d+ \|', l)]
actual=collections.Counter()
for l in rows:
    parts=[p.strip() for p in l.strip('|').split('|')]
    actual[parts[1].split()[0]] += 1
pages=list(dict.fromkeys(x['page'] for x in s))
lines=['# R14 页面计数对照（screens.json vs QA 矩阵）','',
       f'- 权威源：`{SCREENS}`','- 矩阵：`{MATRIX}`','',
       '| 页面 | screens.json | 矩阵行数 | 一致 |','|---|---:|---:|---|']
ok=len(rows)==len(s)
for p in pages:
    same=expected[p]==actual[p]
    ok=ok and same
    lines.append(f'| {p} | {expected[p]} | {actual[p]} | {"✅" if same else "❌"} |')
lines.append(f'| **合计** | **{sum(expected.values())}** | **{len(rows)}** | {"✅" if ok else "❌"} |')
lines += ['','## 规则','- 不合并 folklore/folklore-detail、countdown/countdown-detail；不把详情页重复计入根页。','- 矩阵只由 `scripts/r14-matrix-gen.py` 从 screens.json 生成；本检查失败即阻断 QA 交付。']
OUT.write_text('\n'.join(lines)+'\n')
print(f'rows={len(rows)} expected={sum(expected.values())} ok={ok}')
print(dict(expected)); print(dict(actual))
sys.exit(0 if ok else 1)
