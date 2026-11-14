# 当前交付 checksum 清单 preverify（83b4fa98）

- 清单：`P1/R14-CURRENT-SHA256SUMS`
- 最新 SHA：`3ab50f93270d69709a444ede647d53b300e2b292954dd9290652566076fcd593`；此前 `d34a3903…`/`654648f9…` 作废。
- QA 执行 `shasum -a 256 -c`：**全部 OK**
  - clean tar `2d4ab7d0…`
  - source bundle `e68a0763…`
  - matrix `0e5b4998…`
  - FINAL-STATUS `a12c1fa3…`（更新后）
  - DEFECT-CLOSURE-LOG `e1e220ec…`
- 清单不再包含 `R14-DELIVERY-INDEX.md` 自身；INDEX §14 引用新 SHA。
- 矩阵 lint：188 行、100/33/55 通过。
- 仅交付清单核验；矩阵不变、不代表 UI/188 PASS；不碰设备/不发布。

- 再次刷新（2026-11-14 10:56）：清单 SHA `3ab50f93…`，`shasum -c` 全部 OK；FINAL-STATUS 更新为 `a12c1fa3…`；INDEX §14 同步。
