# 历象 R14 QA 工作区

## 资产
- `docs/R14-QA-MATRIX.md`：188 状态矩阵（来自 `screens.json` SHA `ea505be157c6…`）；初始全 NOT RUN。
- `qa/E2E-SCENARIOS.md`：全局 E2E 16 场景。
- `scripts/r14-build.sh`：模拟器 Debug 构建，产物/日志在 `.qa/`。
- `scripts/r14-sim-qa.sh`：uninstall→install→launch→8s→截图，写 `qa/evidence/<label>.{png,txt}`。
- `scripts/r14-matrix-lint.py`：校验 188 行/顺序/状态计数。
- `scripts/r14-device-matrix.sh`：列出可用模拟器；不伪造 Duo 姿态。

## 原则
- 只测已实现页面；设计 PNG 只用于对照，不等于原生 PASS。
- 结果只能是 PASS / FAIL / NOT RUN；未实现、真机不可得、权限不可控 → NOT RUN，附原因。
- 每条证据：截图 + 设备/运行时 + commit/build + 步骤；失败另留 console/log。
- 不 merge/不发布/不提审；不改产品代码。

## 常用命令
```bash
cd work/lixiang-r14
bash scripts/r14-build.sh
bash scripts/r14-sim-qa.sh --app .qa/DerivedData/Build/Products/Debug-iphonesimulator/Lixiang.app \
  --device Lixiang-iPhone17Pro --label home-phone-light -- -LixiangScreen home
python3 scripts/r14-matrix-lint.py
bash scripts/r14-device-matrix.sh
```
- 启动参数以实现 `docs/DEV_WORKFLOW.md` 为准；`--` 后的参数原样传给 app。
- Duo 六姿态/Tabletop 不是六个 `simctl` 设备；需 XCUITest/真实姿态；否则 NOT RUN。
