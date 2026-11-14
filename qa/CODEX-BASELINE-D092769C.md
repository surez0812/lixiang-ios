# Codex 基线 d092769c 完整报告归档

- 报告：`P1/shots/codex-en-d092769c/REPORT.md`
- 桥：`RESULT-CODEX-BASELINE-D092769C.md` / `ACK-CODEX-BASELINE-D092769C.md`
- 结果：**PARTIAL / NOT ACCEPTED AS FULL RELEASE**
- 基线：d092769c，1.0(13)；4 台指定模拟器卸载→安装→首启；安装身份逐文件核验。
- 证据：144 PNG + CSV/JSON/console/route observations 保留；矩阵不改。
- **矩阵保持 100 PASS / 33 FAIL / 55 NOT RUN；REACHED / 注入不记 PASS。**

## 关键限制
### 启动
- 8s 完整 Home 仅 iPhone16Pro / iPad Pro13 portrait；mini 8s 白屏、12s 准备中、22s Home；Duo ClosedPortrait 8s 准备中、12/22s Home。
- 未证明所有设备 8s Home；mini 首个 App 日志约命令后 10.06s，content.ready +6.01s，需拆分 simctl/宿主与 App 链路。

### 12 launch targets（REACHED ≠ 业务验收）
- iPhone16Pro：初轮 11/12@8s，最终 12/12；countdownDetail 22s 真实生日/84天。
- mini：追加 22s 12/12；folkloreDetail 为真实谢灶锁定页，不是正式正文。
- iPad portrait：10/12@22s；countdownDetail 后续横屏 60s 真实生日；**folkloreDetail 落 SpringBoard，原因未确认**。
- Duo ClosedLandscape：**9/12@22s**；tab4 准备中；compass/daily 仍 Home。
- Duo OpenLandscape：**0/12@22s（均准备中）**；60s Home 出现，实际点击 5 个 rail Tab 成功；**7 个详情不追认 PASS**。
- Duo PartiallyOpen：**0/12@22s（多白屏）**；桌面启动最终 Home；普通 launch 90s timeout/无进程，**详情不能 PASS**。

### 其他
- 基线 JISI 祭祀 en 运行时 `— (blocked: religious term)`，基线 FAIL；followup 64cad8d2 已单独 PASS（版本分开，不修基线结论）。
- 原生通知 166-169：无真机，NOT RUN；注入 settingsReturn denied→authorized 仅模拟，不记原生 PASS。
- Tabletop/Tent：旧 24 目标口径；矩阵实际 **28 行（14 对）NOT RUN**。Tabletop 按约定=Partially Open+rotation，非“无入口”；Tent≡Closed Landscape。
- 离线/重试/loading 仅注入 UI；正式内容/素材/签库/长图缺口仍未关闭。

## 设备状态
- 4 台基线模拟器已 shutdown，数据保留；QA-iPhone 导出任务完成、App 终止、模拟器 booted、窗口释放。
- 不在本机继续操作这些设备；后续新任务用新任务 ID/不可变包。

## 矩阵
- 100 PASS / 33 FAIL / 55 NOT RUN；不因本报告改任何行。
