# 12 条岁时正文接入 Runbook（审批后执行）

前提（全部满足才执行）：
1. Codex 桥结果：`ALL_12_APPROVED=true`（xiayuan v3 复审通过 + v2 的 11 条）
2. PM 将 `qa/content/events-12.json` 12 条 `reviewStatus` 改为 `"approved"`，给新 SHA
3. QA 对“approved 后文件”做 delta/preverify，确认 12/12 approved、无 draft
4. 当前基线包不被替换；本次产出新 followup immutable 包

## 1. 校验 approved 文件
```bash
cd /Users/surezhang/work/ZhaoYao/work/lixiang-r14
shasum -a 256 qa/content/events-12.json
python3 - <<'PY'
import json
items=json.load(open('qa/content/events-12.json'))['items']
bad=[i['id'] for i in items if i.get('reviewStatus')!='approved' or i.get('version')!=1]
print('approved',len(items)-len(bad),'bad',bad)
assert not bad
PY
```

## 2. 受控接入（默认 dry-run）
```bash
python3 scripts/r14-content12-integrate.py \
  --source qa/content/events-12.json \
  --approved dongzhi,qingming,chunjie,zhongqiu,xiayuan,zhongyuan,laba,yulanpen,xiezao,jizu,shangsi,chongyang
# 检查输出后：
python3 scripts/r14-content12-integrate.py ... --apply
```
脚本会备份旧 `App/Resources/Content/events.json`，并拒绝非 approved。

## 3. 构建与验证
- `xcodegen generate --spec project.yml`
- `xcodebuild build/test`（LixiangTests）
- 新包命名：`Lixiang-R14-1.0-13-content-<commit8>-debug-simulator.tar.gz`，记录 tar/binary SHA
- QA 抽检 12 条终态：日期、teaser、sections、sources、hero pending、unlockOffset、无占位；清单页可见、详情可读（approved 才 markRead）
- 内容缺口行 85-90/163/174 **仍需**对应 UI 证据（不能只因接入就 PASS）；hero 仍 pending-design，不宣称图片资产完成

## 4. 回滚
- 若失败：用脚本生成的 `events.json.bak-<sha8>` 恢复，重新构建；不删除旧包。

## 5. 边界
不发布/不提审/不合并；不改 188 矩阵的 PASS 行；旧包保留。
