# Codex interim findings（d092769c）— QA 记录

- 来源：Codex `Documents/Codex/2026-11-13/task/lixiang-en-d092769c/FINDINGS.md`；仅记录观察，**不改矩阵 PASS/FAIL**。
- 矩阵保持：**100 PASS / 33 FAIL / 55 NOT RUN**。

## 1. 祭祀 en 运行时 FAIL（d092769c）
- d092769c 实机 `PlainTermSheet` 显示 `— (blocked: religious term)`；属运行时 en 占位。
- followup `64cad8d2` 已修复；QA pre-verify（静态+QA 机 UI）显示祭祀/造庙 zh+en 中性无占位；**仍需 Codex 桥任务独立复验**，不能在桥结果前写成全量通过。

## 2. iPhone16Pro 12 launch targets
- 12 个目标最终均到真实页；countdownDetail 8s 仍 loading，22s 显示真实生日/84 天，无占位。
- 记录为“到达但启动延迟”，不改变冷启动/矩阵结论。

## 3. 10 词条弹层实测
- 除祭祀 en 外其余 9 个语义正常。
- 仅覆盖这 10 个词，**不等于 450 terms 全审**；QA 静态扫描显示 898 条合并 entries 精确占位=0，但 UI 覆盖仍有限。

## 4. mini 冷装启动
- 8s 白屏、12s 准备中、22s 完整 Home；首个应用日志约 10.06s，App `content.ready` +6005ms。
- 需区分 simctl/宿主启动延迟与 App 准备；**8s 体验目标未满足**，记录为环境/启动限制，未判定代码 bug。
- QA 机（0B71AEF4）8s Home 完整，仅本机/该包结果，不能外推全设备。

## 5. 桥状态
- Codex jisi 文件夹 STATUS 仍写「HOLD 等 QA pre-verify」为过期信息。
- QA 已于 08:03 完成 pre-verify 并移出 HOLD；当前 `inbox/` 有 jisi-en、daily-export、content-12 三个任务，均引用 QA 文件；请 Codex 重新扫描。
- HOLD 目录为空；矩阵/启动/权限/长图状态不变。

## 6. mini 22s 追加（Codex）
- 12/12 targets 均到真实页面；folkloreDetail 为真实谢灶锁定页，正式正文未覆盖。
- 375pt daily 首屏文字无横向溢出。
- 仅“路由到达”，**不等于正式内容/188 PASS**。
- 注入态：离线 banner、failed 重试、loading、auto-retry 恢复均有 22s 运行时截图。
- 通知 preprompt / denied toggle=0 / settingsReturn authorized toggle=1 仅**注入模拟**，非真机原生。
- 记录：不改变 164/166-169/170-174 的 NOT RUN 结论。

## 7. iPad post identity
- `mismatches: []`；binary `d7632436…` 与 d092 一致 → 之前 dev 残留 launch 未覆盖文件。
- iPad cold/routes/landscape/countdown 正在测，Duo 随后；未完成前不并入 PASS。

## 8. 桥状态
- 当前 `outbox/` 空；`static-review-v2` / `content-v2` / `daily-export` 仍排队。
- QA 未操作设备；矩阵保持 100/33/55。

## 9. Duo cold interim（duo-cold/results.json）
- 卸载重装后 fresh-home：8s 时 `content.ready` 尚未到；events 显示 process start ~5.4s、content.ready 8.65s、home.appear 8.68s → 8s 样本预计仍 loading/未完成。
- 12s、22s 截图已生成；需等 Codex 判读是否为“完成/完整”，当前不判 PASS/FAIL。
- layout 日志：`isDuo=true landscape=false shortSide=382 ... canvas=duo-closed-portrait rail=false`，Duo 身份识别正常。
- 未最终判 PASS/FAIL；矩阵不改（100/33/55）；等 Codex 完整报告。

## 10. Duo Closed Landscape tab0 interim（jsonl）
- `isDuo=true landscape=true shortSide=432 native=(1398,2034) scene=(678,466) geo=594x432 canvas=duo-closed-landscape rail=false`
- `content.ready 2475ms`、`home.appear 2503ms`；process start≈4.2s，总约 6.7s。
- **该次未卸载重装，不是 fresh-install**；不能与 duo-cold 混写。
- 仅记录布局/rail=false 与本次就绪时间，不判 PASS；等 Codex 完整判读。
- 矩阵不变 100/33/55。

## 11. 外部限制补记（Codex SESSION-NOTES）
- 真机 Sure iPhone unavailable；无 physical device → 166-169 原生通知权限保持 NOT RUN；注入模拟不能代替。
- 冷启动：Codex 只独占 4 台指定模拟器串行，机器仍有其他 booted 模拟器/进程；**非全机隔离性能基准**；8s 采样有完整 Home 不等于首帧 t≤8.000s 精确证明。
- `0B71AEF4` 为 Codex 0810 导出窗口；Codex 当前记录只用 4 台，若暂不用则保持暂停，等 Lead 释放。

## 12. Duo Closed Landscape tab0–3 22s 截图（interim）
- Codex 已抓 **tab0–3** 的 22s 截图，均 `canvas=duo-closed-landscape rail=false` 类布局。
- **tab4 仅 jsonl，未出 results/截图**。
- 这是 **Closed Landscape 姿态采样**，不是 OpenPortrait / Tabletop / Tent；也未逐页判读完成。
- 4/5 tabs 22s 截图存在、tab4 未完成；不判 PASS/FAIL，矩阵不变 100/33/55；等 Codex 完整结果逐行评估。

## 13. Duo Closed Landscape 10/12 cases（interim）
- 已扩到 10 cases：tab0–4 + almanac/compass/daily/fortune/selection，均 22s 截图。
- 缺 folkloreDetail/countdownDetail 等 route，未完成 12 targets。
- 布局均 `rail=false` 类（Closed Landscape 采样）。
- **未判 PASS**；等 Codex 完整结果再逐行评估；矩阵不变 100/33/55。

## 14. clean 候选 83b4fa98 smoke（R14-QA-iPhone）
- 设备 `0B71AEF4`；安装+启动成功，10s 进程运行；未擦数据。
- 截图 `P1/shots/r14-clean-candidate-smoke.png`；**文件 SHA256 `94067d9cbbef0bb2c5f99ecfe36cd4aa878789b7cc30050df6ffc05d30523a67`**（此前 91475fd2 为预览归一化副本，不是文件 hash）；1206×2622。
- 画面 Home 可见：Hero/日期/黄历卡/底部 Tab，无白屏。
- 仅“包可启动 smoke”，不是 UI/188 PASS；矩阵不变 100/33/55。

## 15. Duo 姿态约定更新（Sure 2026-11-14 10:45）
- Tabletop = Device Hub `Partially Open`（橙色折叠/AX Partially Open）+ 旋转；不是无入口，必须单独测，不能 OpenPortrait 替代。
- Tent ≡ Closed Landscape；可复用 Closed 证据但报告须写“按约定等同”，不称独立测。
- 约定 `qa/DEVICE-POSE-CONVENTIONS.md`；截图 `P1/shots/duo-tabletop-devicehub-user.webp` SHA `07961e7e…`（882×1324）。
- `EXTERNAL-BLOCKERS` 已不再以“无入口”阻塞；28 行/额外状态在逐行证据前仍 NOT RUN；映射表 `qa/DUO-POSE-MAPPING.md`，不先改 PASS。
- 矩阵仍 100/33/55。

## 16. Tabletop design=OpenPortrait（Sure 确认）
- Tabletop 物理姿态 = Partially Open+rotation；**design = Duo OpenPortrait**（669×951 画布）；按 OpenPortrait 设计/布局验收。
- 记录：`physical=Tabletop(PartiallyOpen+rotation) design=OpenPortrait`；不得以普通 OpenPortrait 物理姿态替代。
- `DEVICE-POSE-CONVENTIONS`/`DUO-POSE-MAPPING`/`EXTERNAL-BLOCKERS` 已更新；statuses 仍 NOT RUN；Tent≡Closed 不变；矩阵 100/33/55 不变。
