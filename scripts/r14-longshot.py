#!/usr/bin/env python3
"""R14 长图拼接：读取 xcresult 导出的 long-<page>-NN.png 帧，按重叠区拼接并写 manifest。

用法：r14-longshot.py <attachments_dir> <out_dir>
不引入 App 依赖；仅本地使用 Pillow/numpy。
"""
import json, re, sys, hashlib
from pathlib import Path
import numpy as np
from PIL import Image

def load_frames(att_dir: Path):
    manifest = json.loads((att_dir / 'manifest.json').read_text())[0]['attachments']
    pages = {}
    for a in manifest:
        name = a.get('suggestedHumanReadableName', '')
        m = re.match(r'long-(.+?)-(\d+)_0_[0-9A-F-]+\.png', name)
        if not m:
            continue
        page, idx = m.group(1), int(m.group(2))
        pages.setdefault(page, []).append((idx, att_dir / a['exportedFileName']))
    return {p: [f for _, f in sorted(v)] for p, v in pages.items()}

def best_overlap(prev: Image.Image, nxt: Image.Image):
    a = np.asarray(prev.convert('RGB'), dtype=np.int16)
    b = np.asarray(nxt.convert('RGB'), dtype=np.int16)
    H = min(a.shape[0], b.shape[0])
    # 在中心 40% 宽度上比较，避免边缘渐变/滚动条噪声
    x0, x1 = int(a.shape[1]*0.3), int(a.shape[1]*0.7)
    best = (float('inf'), 0)
    for h in range(300, H - 200):
        diff = np.abs(a[-h:, x0:x1] - b[:h, x0:x1]).mean()
        # 惩罚过小的重叠，避免误判
        score = diff + max(0, 300 - h) * 0.05
        if score < best[0]:
            best = (score, h)
    return best[1]

def stitch(page: str, frames, out_dir: Path):
    imgs = [Image.open(f).convert('RGB') for f in frames]
    # 丢弃与前一帧相同的重复帧
    uniq = [imgs[0]]
    for im in imgs[1:]:
        if np.abs(np.asarray(im, dtype=np.int16) - np.asarray(uniq[-1], dtype=np.int16)).mean() > 0.5:
            uniq.append(im)
    imgs = uniq
    canvas = imgs[0]
    offsets = [0]
    for nxt in imgs[1:]:
        h = best_overlap(canvas, nxt)
        if h <= 0:
            h = int(canvas.height * 0.35)
        new = Image.new('RGB', (canvas.width, canvas.height + nxt.height - h), 'white')
        new.paste(canvas, (0, 0))
        new.paste(nxt.crop((0, h, nxt.width, nxt.height)), (0, canvas.height))
        canvas = new
        offsets.append(canvas.height - (nxt.height - h))
    out = out_dir / f'r14-{page}-long.png'
    out.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(out)
    data = {
        'page': page,
        'loadedAfterReady': True,
        'frames': [f.name for f in frames],
        'frameOffsets': offsets,
        'pixelWidth': canvas.width,
        'pixelHeight': canvas.height,
        'pointHeight': round(canvas.height / 3, 1),
        'sha256': hashlib.sha256(out.read_bytes()).hexdigest(),
        'stitchedImage': str(out),
    }
    (out_dir / f'r14-{page}-long.manifest.json').write_text(json.dumps(data, ensure_ascii=False, indent=1))
    return data

def main():
    att, out = Path(sys.argv[1]), Path(sys.argv[2])
    pages = load_frames(att)
    results = []
    for p, fs in pages.items():
        results.append(stitch(p, fs, out))
    (out / 'manifest.json').write_text(json.dumps({'pages': results}, ensure_ascii=False, indent=1))
    for r in results:
        print(f"{r['page']}: {r['pixelWidth']}x{r['pixelHeight']} px ({r['pointHeight']} pt), frames={len(r['frames'])}, sha={r['sha256'][:12]}…")

if __name__ == '__main__':
    main()
