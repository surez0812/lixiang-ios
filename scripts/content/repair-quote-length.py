#!/usr/bin/env python3
"""仅修复 quote 超长（8–48）：按句读切分选完整句，保留 title/meaning/action 语义对齐；重复 quote 只报告不自动替换。
用法: repair-quote-length.py <batch.json> <out.json>"""
import json,re,sys

def clen(s): return len(re.sub(r"\s","",s or ""))
def trim(q, lo=8, hi=48):
    if lo<=clen(q)<=hi: return q
    parts=re.split(r"(?<=[。！？；])", q)
    parts=[p for p in parts if clen(p)>=lo]
    out=""
    for p in parts:
        if clen(out)+clen(p)<=hi: out+=p
        else: break
    if lo<=clen(out)<=hi: return out.strip()
    for p in parts:
        if lo<=clen(p)<=hi: return p.strip()
    return q

def main(src,dst):
    d=json.load(open(src)); fixed=0; left=[]
    for x in d:
        q=x.get("quote","")
        if not 8<=clen(q)<=48:
            nq=trim(q)
            if 8<=clen(nq)<=48: x["quote"]=nq; fixed+=1
            else: left.append((x.get("date"),clen(q)))
    uniq=len({x.get("quote") for x in d})
    json.dump(d,open(dst,"w"),ensure_ascii=False,indent=1)
    print(f"fixed={fixed} still_bad_len={len(left)} uniq_quotes={uniq}/{len(d)} out={dst}")
    for t in left[:5]: print("UNFIXED",t)

if __name__=="__main__": main(sys.argv[1],sys.argv[2])
