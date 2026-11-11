#!/bin/bash
# 图标入库：designer 全家桶 -> AppIcon.appiconset（等 Sure 选型后由 designer 给 1024 PNG/暗色变体）
# 用法：scripts/assets/ingest-appicon.sh <source-1024x1024.png> [dark-1024.png]
set -euo pipefail
SRC="${1:?usage: ingest-appicon.sh <source-1024.png> [dark-1024.png]}"
DARK="${2:-}"
OUT="App/Resources/Assets.xcassets/AppIcon.appiconset"
mkdir -p "$OUT"
# iOS 需要的切片（含 120/152：绕过 App Store 上传校验）
declare -a SPECS=(
  "20 2 40 iphone" "20 3 60 iphone" "29 2 58 iphone" "29 3 87 iphone"
  "40 2 80 iphone" "40 3 120 iphone" "60 2 120 iphone" "60 3 180 iphone"
  "76 2 152 ipad" "83.5 2 167 ipad" "1024 1 1024 ios-marketing"
)
for spec in "${SPECS[@]}"; do
  read -r pt scale px idiom <<<"$spec"
  file="icon-${px}.png"
  sips -z "$px" "$px" "$SRC" --out "$OUT/$file" >/dev/null
  echo "  written $file"
done
if [ -n "$DARK" ]; then sips -z 1024 1024 "$DARK" --out "$OUT/icon-dark-1024.png" >/dev/null; fi
cat > "$OUT/Contents.json" <<JSON
{
  "images" : [
    { "filename" : "icon-40.png", "idiom" : "iphone", "scale" : "2x", "size" : "20x20" },
    { "filename" : "icon-60.png", "idiom" : "iphone", "scale" : "3x", "size" : "20x20" },
    { "filename" : "icon-58.png", "idiom" : "iphone", "scale" : "2x", "size" : "29x29" },
    { "filename" : "icon-87.png", "idiom" : "iphone", "scale" : "3x", "size" : "29x29" },
    { "filename" : "icon-80.png", "idiom" : "iphone", "scale" : "2x", "size" : "40x40" },
    { "filename" : "icon-120.png", "idiom" : "iphone", "scale" : "3x", "size" : "40x40" },
    { "filename" : "icon-120.png", "idiom" : "iphone", "scale" : "2x", "size" : "60x60" },
    { "filename" : "icon-180.png", "idiom" : "iphone", "scale" : "3x", "size" : "60x60" },
    { "filename" : "icon-152.png", "idiom" : "ipad", "scale" : "2x", "size" : "76x76" },
    { "filename" : "icon-167.png", "idiom" : "ipad", "scale" : "2x", "size" : "83.5x83.5" },
    { "filename" : "icon-1024.png", "idiom" : "ios-marketing", "scale" : "1x", "size" : "1024x1024" }
  ],
  "info" : { "author" : "xcode", "version" : 1 }
}
JSON
echo "AppIcon written to $OUT；下一步：xcodegen generate + 构建，再 archive/export"
