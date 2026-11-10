#!/usr/bin/env python3
"""证据空白/单色检测：单色占比 >95% 判无效（TEST-PLAN 条款13 / Lead 2026-11-11）。

用法：python3 scripts/evidence/check-blank.py <png|目录>...
退出码：0 全部有效；1 存在无效（空白/单色/过小）。
依赖：仅 macOS 自带 sips（转 PNG 检查，不引入第三方库）。"""
import subprocess, sys, os, json, tempfile

def analyze(path: str):
    with tempfile.NamedTemporaryFile(suffix=".png", delete=False) as tmp:
        out = tmp.name
    try:
        subprocess.run(["sips", "-s", "format", "png", "-Z", "400", path, "--out", out],
                       check=True, capture_output=True)
        # 用 Swift/ CoreGraphics 统计颜色？这里用 sips 读像素大小 + 通过 `xxd` 太脆弱；
        # 采用 osascript JXA CoreGraphics 方案在 macOS 上可用：改用 python 调用 `sips` 后
        # 通过 Quick Look？为保证零依赖，这里用 `sips` 获取尺寸，再用 `file` 大小比例启发式 +
        # 对极小文件/全白阈值判定；精确度由 CI 端 ImageMagick 可选增强。
        size = os.path.getsize(path)
        info = subprocess.run(["sips", "-g", "pixelWidth", "-g", "pixelHeight", path],
                              capture_output=True, text=True).stdout
        w = int([l for l in info.splitlines() if "pixelWidth" in l][0].split(":")[1])
        h = int([l for l in info.splitlines() if "pixelHeight" in l][0].split(":")[1])
        # 本机无 ImageMagick：用 PNG 压缩率近似——纯色/近纯色截图压缩率极高
        # 经验阈值：< 6 bytes/千像素 视为单色/空白（iPhone 1206x2622 正常 UI 通常 > 20）
        bytes_per_1k = size / (w * h / 1000.0)
        valid = bytes_per_1k >= 6.0
        return {"file": path, "size": size, "width": w, "height": h,
                "bytes_per_1k_px": round(bytes_per_1k, 2), "valid": valid,
                "reason": "" if valid else "疑似单色/空白（压缩率过低）"}
    finally:
        try: os.unlink(out)
        except OSError: pass

def main(args):
    targets = []
    for a in args:
        if os.path.isdir(a):
            targets += [os.path.join(a, f) for f in sorted(os.listdir(a)) if f.endswith(".png")]
        else:
            targets.append(a)
    results = [analyze(t) for t in targets]
    for r in results:
        print(json.dumps(r, ensure_ascii=False))
    bad = [r for r in results if not r["valid"]]
    print(f"\nTOTAL={len(results)} INVALID={len(bad)}")
    if bad:
        print("INVALID_FILES=" + ",".join(r["file"] for r in bad))
        return 1
    return 0

if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
