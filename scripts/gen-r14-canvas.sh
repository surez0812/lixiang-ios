#!/bin/bash
# R14 12 画布矩阵（只读设计工作树）
set -euo pipefail
D=/Users/surezhang/work/ZhaoYao/work/lixiang-design-handoff-20261113/docs/design/r14-final
OUT=docs/R14-CANVAS-MATRIX.csv
pages="home almanac compass daily fortune folklore folklore-detail selection countdown countdown-detail settings"
modes="phone-light phone-dark ipad-portrait ipad-portrait-dark ipad-landscape ipad-landscape-dark duo-closed-portrait duo-closed-landscape duo-tent duo-open-portrait duo-open-landscape duo-tabletop"
{ echo "page,$(echo $modes | tr ' ' ',')"
for p in $pages; do row="$p"; for m in $modes; do [ -f "$D/$p-$m.png" ] && row="$row,✓" || row="$row,-"; done; echo "$row"; done; } > "$OUT"
echo "wrote $OUT"; column -s, -t "$OUT" | head -14
