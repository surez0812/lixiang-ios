# R14 QA 初始化交付（2026-11-13）

- **矩阵**：`docs/R14-QA-MATRIX.md`（188 行，来自 `screens.json` SHA `ea505be157c6…`；PASS 0 / FAIL 0 / NOT RUN 188）。
- **E2E**：`qa/E2E-SCENARIOS.md`（16 组：启动/返回/重复点击、切 Tab、旋转/折叠/tabletop/tent、权限拒绝/取消/设置返回、无网/失败、长文/动态字号/VoiceOver、日时/跨日、分享取消/失败、同日同签）。
- **脚本**：
  - `scripts/r14-build.sh`（模拟器 Debug，`.qa/` 产物）
  - `scripts/r14-sim-qa.sh`（uninstall→install→launch→8s→截图+manifest）
  - `scripts/r14-device-matrix.sh`（列出可用设备；Duo 姿态不伪造）
  - `scripts/r14-matrix-lint.py`（188 行/顺序/计数校验）
- **证据目录**：`qa/evidence/`（当前空；每条截图 <label>.png + <label>.txt）。
- **当前状态**：全部 NOT RUN；未测未就绪页面，不以设计 PNG/HTML 代替原生结果。真机不可得项保持 NOT RUN。
- **环境备注**：当前独立 shell 对 Xcode/SwiftPM 全局缓存无写权限，构建脚本未执行；脚本已把 DerivedData/SourcePackages 指向仓库 `.qa/`，需在开发机正常环境跑。
- 不 merge/不发布/不提审；不写产品代码。
