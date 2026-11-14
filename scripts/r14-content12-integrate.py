#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""受控接入 12 条岁时正文到 App 资源。

背景：曾发生 loader 导出示例覆盖 PM 正式内容的事故。本脚本只做显式、可审计的接入：
  - 默认 dry-run，不写文件
  - 只接受 reviewStatus == "approved" 的条目
  - 12 个 id 必须齐全
  - 写入前备份旧文件
  - 输出新旧 SHA / approved 列表，供 commit message 引用

用法：
  python3 scripts/r14-content12-integrate.py \
      --source qa/content/events-12.json \
      --approved dongzhi,qingming,... \
      [--apply]
"""
import argparse
import hashlib
import json
import shutil
import sys
from pathlib import Path

EXPECTED = {
    "dongzhi", "qingming", "chunjie", "zhongqiu", "xiayuan", "zhongyuan",
    "laba", "yulanpen", "xiezao", "jizu", "shangsi", "chongyang",
}
TARGET = Path("App/Resources/Content/events.json")


def sha(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--source", default="qa/content/events-12.json")
    ap.add_argument("--approved", required=True,
                    help="逗号分隔的 approved id；必须与 source 中 reviewStatus=approved 一致")
    ap.add_argument("--apply", action="store_true", help="实际写入；缺省 dry-run")
    args = ap.parse_args()

    src = Path(args.source)
    if not src.exists():
        print(f"source missing: {src}")
        return 2
    data = json.loads(src.read_text(encoding="utf-8"))
    items = data.get("items", data) if isinstance(data, dict) else data
    ids = {it.get("id") for it in items}
    if ids != EXPECTED:
        print(f"id mismatch: missing={sorted(EXPECTED - ids)} extra={sorted(ids - EXPECTED)}")
        return 3

    approved = [x.strip() for x in args.approved.split(",") if x.strip()]
    if set(approved) != EXPECTED:
        print(f"approved list must cover all 12 ids; got {len(set(approved))}/12")
        return 4
    bad = [it["id"] for it in items if it.get("id") in approved and it.get("reviewStatus") != "approved"]
    if bad:
        print(f"refuse: approved list contains non-approved items: {bad}")
        return 5

    out = {"version": 1, "items": items}
    text = json.dumps(out, ensure_ascii=False, indent=2) + "\n"
    print(f"source={src} sha256={sha(src)}")
    print(f"target={TARGET} exists={TARGET.exists()} sha256={sha(TARGET) if TARGET.exists() else '-'}")
    print(f"approved={len(set(approved))}/12 items={len(items)}")
    if not args.apply:
        print("dry-run: pass --apply to write")
        return 0

    if TARGET.exists():
        backup = TARGET.with_suffix(".json.bak-" + sha(TARGET)[:8])
        shutil.copy2(TARGET, backup)
        print(f"backup={backup}")
    TARGET.parent.mkdir(parents=True, exist_ok=True)
    TARGET.write_text(text, encoding="utf-8")
    print(f"written={TARGET} sha256={sha(TARGET)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
