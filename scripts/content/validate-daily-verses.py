#!/usr/bin/env python3
"""每日一句内容校验（DAILY-VERSE-SCHEMA）。用法: validate-daily-verses.py <file.json> [--expect 365]"""
import json, re, sys, hashlib

def clen(s): return len(re.sub(r"\s", "", s or ""))

def main(path, expect=365):
    d = json.load(open(path))
    n = len(d)
    errs, warns = [], []
    need = ["date","tradition","classic","chapter","source","quote","title","meaning","action"]
    for i,x in enumerate(d):
        for k in need:
            if k not in x or x[k] in (None, ""): errs.append(f"#{i} missing/empty {k}")
        for k in ("quote","title","meaning","action"):
            s = x.get(k,"") or ""
            if re.search(r"\*\*|^#|`|<[^>]+>|zh[:：]|en[:：]", s): errs.append(f"#{i} {k} markdown/prefix")
        t=clen(x.get("title",""))
        if not (8 <= t <= 16): errs.append(f"#{i} title len {t} (8-16)")
        m=clen(x.get("meaning",""))
        if not (110 <= m <= 160): errs.append(f"#{i} meaning len {m} (110-160)")
        q=clen(x.get("quote",""))
        if not (4 <= q <= 48): errs.append(f"#{i} quote len {q} (4-48)")
        a=clen(x.get("action",""))
        if not (30 <= a <= 60): errs.append(f"#{i} action len {a} (30-60)")
    dates=[x.get("date") for x in d]; quotes=[x.get("quote") for x in d]
    if len(set(dates))!=n: errs.append(f"date duplicates: {n-len(set(dates))}")
    if len(set(quotes))!=len(quotes): errs.append(f"quote dups: {len(quotes)-len(set(quotes))}")
    if n != expect: errs.append(f"count {n} != expected {expect}")
    print(f"file={path}")
    print(f"sha256={hashlib.sha256(open(path,'rb').read()).hexdigest()}")
    print(f"count={n} uniq_dates={len(set(dates))} uniq_quotes={len(set(quotes))}")
    fill=sum(1 for x in d if "静心" in ((x.get("title") or "")+(x.get("meaning") or "")))
    low=0
    for x in d:
        q=re.sub(r"[^\u4e00-\u9fff]","",x.get("quote",""))
        m=re.sub(r"[^\u4e00-\u9fff]","",(x.get("meaning") or "")+(x.get("title") or ""))
        qb={q[i:i+2] for i in range(max(0,len(q)-1))}
        if qb:
            hit=sum(1 for g in qb if g in m)
            if hit/max(1,len(qb)) < 0.15: low+=1
    print(f"template_filler_静心={fill} low_overlap_quote_meaning={low}")
    print(f"errors={len(errs)} warnings={len(warns)}")
    for e in errs[:12]: print("ERR", e)
    if len(errs)>12: print(f"... {len(errs)-12} more errors")
    for w in warns[:5]: print("WARN", w)
    print("RESULT:", "PASS" if not errs else "FAIL")
    return 0 if not errs else 1

if __name__ == "__main__":
    f=sys.argv[1]; exp=int(sys.argv[2]) if len(sys.argv)>2 else 365
    sys.exit(main(f, exp))
