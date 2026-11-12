#!/bin/bash
# 每日一句入库：校验 PASS 才替换 App 资源并记批次日志
# 用法: ingest-daily-verses.sh <tradition: dao|buddhist|confucian|quanshan> <batch.json>
set -euo pipefail
TRAD="${1:?tradition}"; BATCH="${2:?batch json}"
cd "$(dirname "$0")/../.."
SHA=$(shasum -a 256 "$BATCH" | awk '{print $1}')
N=$(python3 -c "import json;print(len(json.load(open('$BATCH'))))")
echo "batch=$BATCH sha256=$SHA count=$N"
python3 scripts/content/validate-daily-verses.py "$BATCH" 365 || { echo "REJECTED: validation failed"; exit 1; }
cp "$BATCH" "App/Resources/PlainLanguage/daily-classics/${TRAD}-365.json"
mkdir -p docs
LOG="docs/CONTENT-INGEST-LOG.csv"
[ -f "$LOG" ] || echo "time,tradition,file,sha256,count" > "$LOG"
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ),$TRAD,$(basename "$BATCH"),$SHA,$N" >> "$LOG"
echo "INGESTED -> App/Resources/PlainLanguage/daily-classics/${TRAD}-365.json"
tail -3 "$LOG"
