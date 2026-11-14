# R14 外部阻塞 / 待协助（终版同步）

- 基线包：`d092769c`（tar `66b7cabcc…`，binary `d7632436…`，1.0(13)）。
- 完整请求见 `handover/calendar-20261111/dev-evidence/P1/R14-EXTERNAL-REQUESTS.md`。

## 1. Duo Tabletop / Tent（28 行 / 14 对）
- **已确认约定**（Sure 2026-11-14 10:45，见 `qa/DEVICE-POSE-CONVENTIONS.md`）：
  - **Tabletop 物理姿态 = Partially Open（AX/橙色折叠图标）+ 旋转**；无独立 “Tabletop” 按钮，必须单独测物理姿态。
  - **Tabletop design = OpenPortrait**（669×951 画布，Sure 确认）；按 OpenPortrait 设计/布局验收，记录 physical/design 两字段。
  - **Tabletop 设计映射 = OpenPortrait**（“Tabletop=OpenPortrait” 正确）；Tabletop 行按 OpenPortrait 设计/布局验收，物理姿态仍是 Partially Open+rotation。
  - **Tent ≡ Closed Landscape**（Device Hub 无明确 Tent）；可复用 Closed Landscape 结果，报告写“按约定等同”，不称独立测过。
- 28 行在逐行证据/复用映射完成前仍保持 **NOT RUN**；不再以“无入口”阻塞。
- 参考截图：`P1/shots/duo-tabletop-devicehub-user.webp`（`07961e7e…`）。

## 2. 正式内容 12 条 + 四季素材 + 完整签库
- 12 条岁时正文、春/夏/秋素材、全量签库未交付；示例稿/内容准备中不得 PASS。
- 对应行 85-90/163/164/174 保持 **NOT RUN/内容缺口**。

## 3. 真机通知权限（166-169）
- 模拟器无 notifications privacy service；原生系统弹窗尝试失败，**未记 PASS**。
- 需真机或可注入系统权限环境，完成 pre-prompt→系统允许/拒绝→设置返回重读四态。
- 注入模拟仅关闭 UI 同步缺陷，不等同原生通过。

## 4. 长图验收口径（170-174）
- 设计目标：Home 2500pt、Almanac 12000/6500pt、Daily 1650pt、Folklore 2400pt。
- 当前实测：home≈1473、almanac≈2293、daily≈1955、folklore≈874pt；均有内容/接缝/高度不达项。
- 需 PM/设计确认验收口径；未达标前保持 **NOT RUN**，不用首屏冒充。

## 5. Duo 最新基线复测
- 4 台设备 shutdown 数据保留；需协调重启后按姿态串行复测最新包；旧包结果保留，不混写。

## 6. Codex SESSION-NOTES（2026-11-14）
1. **真机 Sure iPhone unavailable，无已连接 physical device** → 原生真机通知权限 **166-169 保持 NOT RUN**；注入模拟不能代替原生。
2. Codex 仅独占 4 台指定模拟器串行；机器上仍有团队其他 booted 模拟器/进程，**冷启动不是全机隔离性能基准**；8s 采样有完整 Home **不代表首帧 t≤8.000s 的精确证明**。
3. `0B71AEF4` 是为 Codex 0810 导出验证准备的窗口，但 Codex 当前记录只用 4 台；**若暂不用，保持暂停**，等 Lead 确认释放后再恢复 QA 使用。

## 7. QA 复核（姿态约定）
- Tabletop/Tent 约定与截图 SHA `07961e7e…` 已核对；Tabletop 不再按“无入口”阻塞，必须单独测；Tent 仅按约定复用 Closed Landscape。
- 逐行证据/映射前仍 NOT RUN；矩阵不变。
