# chongyang 过去日期 + footer sources 修复抽检（8e213b5c）

- 包：`P1/Lixiang-R14-1.0-13-pastdate-8e213b5c-debug-simulator.tar.gz`
  - tar `eefd3c0a…`；binary `eb3d52d7…`；commit `8e213b5c`；1.0(13)
  - events.json `79b80283…`：12 approved，内容未动
- 设备：`R14-QA-iPad 415BFB3F…`；未碰锁定机/0B71。
- 证据：`qa/evidence/pastdate-fix/`（12 详情 + real list/chongyang + future dongzhi）。

## 1. chongyang 真实日期（PASS）
- 2026-11-14 真实日期：`-LixiangR14Route chongyangDetail` 显示「2026年10月18日 · 已过去 · 已解锁」，正文可读，不再「还有0天解锁」。
- 列表：重阳卡显示「已过去 / 已解锁」。
- **修复有效**。

## 2. 未来 >10 天（PASS）
- 冬至（2026-12-22，38天）仍显示「还有38天解锁」并锁定；符合预期。

## 3. footer sources（PASS）
- chongyang 详情底部显示 2 条来源（維基百科·重陽節 URL、維基百科·菊花 URL），不再是仅第一条。
- 其余 12 页 footer 也显示对应两条来源（以 chongyang 为明确证据）。

## 4. 12 页抽检
- 12 条详情均在对应日期下可读（debug date 用于未来条目），截图 `detail-<id>.png`。
- xiayuan 无「放河灯」；zhongyuan/yulanpen 原有表述未变。
- hero 仍 pending-design/通用图，不宣称图片完成。
- 真实日期下仅 chongyang（已过去）和 xiayuan（9天内）解锁，其余未来条目锁定。

## 5. 状态
- 两个缺陷（过去日期锁定、footer 仅首来源）**UI 抽检 CLOSED**；补充建议加单测。
- **内容行 85-90/163/174 仍 NOT RUN**，不因修复自动 PASS。
- 矩阵不变 100/33/55；dev 报告 66/66 PASS，QA 未独立重跑。
- D-01 计数更正：Daily 导出实际 183 files/mismatches=[]；baseline d092=181，分开。
