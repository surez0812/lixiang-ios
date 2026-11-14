# R14 1600 layoutfix PARTIAL 记录

HEAD：`cd9b8163f68e5e98f23819041c94de4b3d5ff2e8`

## 1) Duo OpenLandscape rail x — 已修（待真实 Duo 复验）
- Codex 实测：`LXRAIL frame=(867,401,50,252)`，scene 951 → right 34（设计 23，偏左 11）
- 根因：overlay topTrailing + 负 trailing padding 在安全区坐标中被夹取，safeRight 形成 double-count
- 修法：改为 `topLeading` + 显式局部 x：
  `x_local = geo.width + safeRight - width - right`
  → scene 951/geo867/safeRight84: `867+84-50-23 = 878`；全局 x=878，right=23
- DEBUG 日志：`LXRAIL … expectedX=<sceneW-width-23> geoOriginX=…` + `LXRAIL frame=<actual global>`
- 单元测试：`expectedX(951)=878`、`expectedX(1032)=959`
- **真实 Duo 复验 NOT RUN**；等待新包 targeted 看 `LXRAIL frame` 应为 (878,401,50,252)

## 2) iPad portrait/landscape/detail 比例 — PARTIAL（未修）
- Codex：字号/卡片/留白/article 纸面边框比例与设计仍有差
- 本轮只完成：portrait 单列、landscape 两栏、detail left-summary/right-article、宽屏 hero 340
- 未宣称整页 PASS；后续按设计 tokens 收敛

## 3) UI-001 iPad 三态 — PARTIAL（未认定 PASS）
- 本地 test 用短拖拽 mid + 滚动到静止 bottom，三图 SHA 不同
- Codex 认为仅 first/after-drag，缺真实溢出态 → 保持 PARTIAL，不冒充 PASS
- Duo 三态仍 NOT RUN

## 4) compact 胶囊压边
- 设计接受与否待产品/设计确认；本轮未改，1530 证据保留
