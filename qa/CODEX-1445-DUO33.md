# Codex 1445 Duo43 逐行结果归档

- 包：clean `38b34c5a`；证据 `handoff/codex-bridge/evidence/1445-clean38b34c5a-delivery/cases.csv`；归档 `archive/20261114-duo33/`。
- 43 行：**2 FAIL_UI / 16 PARTIAL / 25 NOT_RUN / 0 PASS_UI**；矩阵不改（100/33/55）。
- Open Portrait 12 targets 到达（selection route/tab 重复）；fortune 实际出完整结果，不批同日持久化；folklore 为锁定谢灶，不是正文验证。
- Open Landscape 5 Tab 实际点击到达；7 详情未完成。
- Closed Home compact FAIL（tools 空白/遮挡）；其它 Closed route/state NOT_RUN；旧失败不重复重试。
- Tabletop 当前 build NOT RUN；Tent≡Closed，继承 Closed scoped failure，不称独立测试。
- 2 FAIL_UI：row8 Closed home、row11 OpenLandscape home；16 PARTIAL 明细见 CSV；25 NOT_RUN。
- 不把 REACHED 当 PASS；不整批 DONE。

## 43 行 verdict（逐行）
$(cat /tmp/duo43.md)
