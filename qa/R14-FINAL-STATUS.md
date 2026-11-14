# R14 最终状态（2026-11-14 09:30）

> 更新：2026-11-14 10:45；static-review 链已全部关闭（限证据范围），但 188 全量验收仍未完成，不可发布/提审/合并。 矩阵以 `docs/R14-QA-MATRIX.md` 为准：**100 PASS / 33 FAIL / 55 NOT RUN**。

## 1. 包（不可变，旧包保留）

| 包 | tar SHA256 | binary SHA256 | commit | 用途/状态 |
|---|---|---|---|---|
| `Lixiang-R14-1.0-13-en-d092769c-debug-simulator.tar.gz` | `66b7cabcc1129ac5ca345ba75c226d75ecb160c51ca4136f315e529f0c88b7ba` | `d76324366300c70178a1c4618bf494eb499d4b8a2557a1081af70598b75fd29d` | `d092769c` | Codex 基线，PARTIAL/NOT ACCEPTED |
| `Lixiang-R14-1.0-13-jisi-en-64cad8d2-debug-simulator.tar.gz` | `58d3cdb999e3726fa8593f4850f40d5e5f5778135224b289106b8d4889894fc3` | `4d196dae5603188de49babc85b40bfdda86e4daa7fc7e471c39b527c996a52a6` | `64cad8d2` | JISI/造庙 en 修复；Codex PASS (bounded) |
| `Lixiang-R14-1.0-13-content12-r2-2516718c-debug-simulator.tar.gz` | `21ac9abdc7cb44f87848e2beb64322d56499864b0f0384bd9a1a18ea85f2425c` | `a2fd2c9aec9ac91ddde6c0f3afdcf02b60807ce1036f9e232571c874b98b3700` | `2516718c` | 12 approved 内容接入；QA 12 页抽检（past/footer 修复前） |
| `Lixiang-R14-1.0-13-pastdate-8e213b5c-debug-simulator.tar.gz` | `eefd3c0a2c3007a85427707c5d9ec9c6f83bf4a2e169d84d3e7b63d546be43b2` | `eb3d52d7d5d71af223f395722fb368e270c48a2385069f5a46b0f467f9f2340b` | `8e213b5c` | 过去日期可读 + 全部 sources；QA 抽检 PASS |
| `Lixiang-R14-1.0-13-staticcloseout-5509c8e4-debug-simulator.tar.gz` | `cdeed8b83cc622c9d861f1ef8cfa90d476e7817858e38ae8aa0fb507743c4616` | `b4b887ee1f6ce52c5d5d8071405d5522234d5d867a78675ca49f0faadbe86bbd` | `5509c8e4` | DynamicType/P1 转换 closeout；含测试 PlugIns，不作最终发布包 |
| `Lixiang-R14-1.0-13-clean-474b12c8-debug-simulator.tar.gz` | `7547f91cfe78aa932201d73b02986b2b25e698190bdef6018797ef4211faf792` | `c382c07b71653ff88d73ff0f719d22fe8b7f0498574dc5de5c4c176ee56f9d0d` | `474b12c8` | build-only 干净候选；无 PlugIns/xctest；未设备复测/未交 Codex |

## 2. 已关闭（缺陷，不等于矩阵行 PASS）
- mini Daily 右溢出
- 黄历 substring/双语 6 词 + §8/§9/§9.4 语义（450 terms 审计）
- Duo rail/route（旧包 b3d89116；最新姿态详情未全验）
- countdownDetail 重复 case/占位
- 祭祀/造庙 en 占位（followup 64cad8d2，Codex PASS bounded）
- Daily 导出 1080×1350 / SHA `d72ab323` / QR（QA+Codex 独立；导出包 183 files）
- 过去日期锁定（chongyang 10/18 可读）+ footer 全部 sources（QA 抽检 PASS）
- P1 通知 refresh / P2 prepare：Codex 静态 CLOSED；DynamicType fixedSize + P1 转换 UI 4/4 已修，**closeout 待 Codex**

## 3. 12 条内容
- Codex：`ALL_12_APPROVED=true`（editorial only，快照 `63722767`）
- 已受控接入：`events.json 79b80283`，12/12 approved；QA 12 页抽检（真实日期仅 chongyang/xiayuan 可读，其余未来锁定）
- **hero 仍 pending-design**；内容行 85-90/163/174 仍 **NOT RUN**（素材/完整 UI 未验收）
- 四季素材/完整签库仍需外部内容生产

## 4. Codex 基线关键限制
- Duo OpenLandscape：22s 12 targets 均准备中；60s Home + 5 rail tabs 实际点击成功；7 详情不追认 PASS
- Duo PartiallyOpen：22s 多白屏；桌面启动最终 Home；普通 launch 90s timeout/无进程，详情不 PASS
- Duo ClosedLandscape：9/12@22s；iPad folkloreDetail 落 SpringBoard 未查清
- 8s Home 仅 iPhone16/iPad；mini/Duo 未证明
- 原生通知/Tabletop/Tent NOT RUN

## 5. 外部阻塞（需 Sure/外部）
1. Device Hub Tabletop（PartiallyOpen+rotation）/Tent（≡ClosedLandscape）证据/窗口（28 行/14 对）
2. 真机原生通知（166-169）
3. 正式 hero/四季素材/完整签库
4. 长图目标口径（170-174）
5. Duo 未到达详情/PartiallyOpen 复验窗口

## 6. 边界
不发布、不提审、不合并；旧包不覆盖；REACHED/注入/文案通过都不等于矩阵 PASS。


## 7. 2026-11-14 10:45 更新

- **static-review 链全部关闭（限证据范围）**：
  - DynamicType 二次缩放 fixedSize CLOSED
  - forced fallback 实现/诊断 CLOSED；同次 log→截图 linkage CLOSED（三次团队运行；非密码学 attestation）
  - P1 通知 intent：desired=false/true 转换、手动关闭 1→0、重启持久化 CLOSED
  - prepare 代际 token CLOSED
  - 12 approved 内容回归、past readability CLOSED
  - **注意：static 关闭 ≠ 188/原生通知/全设备 PASS**
- 最新 build-only 干净候选：`Lixiang-R14-1.0-13-clean-83b4fa98-debug-simulator.tar.gz`
  - tar `2d4ab7d0…`、binary `748e32ac…`、commit `83b4fa98`（app code `6d6e14e6`）、1.0(13)
  - 无 PlugIns/xctest；events `79b80283`；QA 包身份 preverify PASS
- 矩阵仍 **100 PASS / 33 FAIL / 55 NOT RUN**
- 仍未闭合：Duo 未到达详情/PartiallyOpen、Tabletop/Tent 28 行（14 对）、166-169 真机通知、内容行 85-90/163/174（hero pending）、170-174 长图、四季素材/完整签库


## 8. 交付校验（2026-11-14 10:55）

- clean 候选 `clean-83b4fa98` 在 R14-QA-iPhone `0B71AEF4` 安装/启动成功，10s 后 Home 可见（1206×2622，无白屏）；仅启动 smoke，不是 UI/188 PASS。
- `P1/R14-CURRENT-SHA256SUMS`（`d34a3903…`）`shasum -c` 全部 OK。
- 源码 bundle `source-83b4fa98`（`e68a0763…`）`git bundle verify` okay；未 push/merge。
- 矩阵仍 100 PASS / 33 FAIL / 55 NOT RUN；剩余均为外部依赖。
