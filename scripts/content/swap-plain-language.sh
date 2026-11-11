#!/bin/bash
# build 4 内容替换流程（PM 交最终 JSON 后执行）
# 用法：scripts/content/swap-plain-language.sh <最终JSON目录> [期望 SHA256SUMS sha]
set -euo pipefail
SRC="${1:?usage: swap-plain-language.sh <json-dir> [sha256sums-sha]}"
EXPECT="${2:-}"
cd "$(dirname "$0")/../.."
if [ -n "$EXPECT" ]; then
  actual=$(shasum -a 256 "$SRC/SHA256SUMS.txt" 2>/dev/null | awk '{print $1}')
  if [ "$actual" != "$EXPECT" ]; then echo "SHA MISMATCH: expected $EXPECT got $actual"; exit 1; fi
  echo "content SHA OK: $actual"
fi
cp "$SRC"/daodejing.json "$SRC"/yi-ji-mapping.json "$SRC"/explain-pages.json App/Resources/PlainLanguage/
[ -f "$SRC/app-strings.json" ] && cp "$SRC"/app-strings.json App/Resources/PlainLanguage/
python3 - <<'PY'
import json, hashlib, pathlib
base = pathlib.Path('App/Resources/PlainLanguage')
def n(name):
    p = base/name
    return len(json.load(open(p))) if p.exists() else -1
lines = ["# 白话/解释/道德经 内容包（build 4 · 最终版）","",
         f"- daodejing.json：{n('daodejing.json')} 章",
         f"- yi-ji-mapping.json：{n('yi-ji-mapping.json')} 条",
         f"- explain-pages.json：{n('explain-pages.json')} 页",
         f"- app-strings.json：{n('app-strings.json')} 条","",
         "SHA（替换时）："]
for name in ["daodejing.json","yi-ji-mapping.json","explain-pages.json","app-strings.json"]:
    p = base/name
    if p.exists():
        lines.append(f"- {name} {hashlib.sha256(p.read_bytes()).hexdigest()}")
(base/"PACK-NOTES.md").write_text("\n".join(lines)+"\n")
print("PACK-NOTES updated")
PY
echo "Now run: swift test (Core) + xcodebuild test CountdownLogic, then archive 1.0(4)"
