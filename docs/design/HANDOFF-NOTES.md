# 给 dev 的接入备注（R14）

1. 先按 `TOKENS.md` / `tokens.json` 建 dynamic color + 字号 token；不要硬编码 light/dark hex。
2. 5 Tab（日历/岁时/择日/倒计日/设置）图标用 PDF vector（`assets/tab-icons` / `LixiangAssets.xcassets`），`template` 渲染；README 的“4 枚”是历史文字，selection 资产已存在。
3. Fortune 接入用 `ApprovedMotionManifest.json` + `AnimationTimeline.json` + 三张冻结图 + `ApprovedFortuneCore.js`；不得改动作数学/素材；原生五关键点验收。
4. 首页双卡按 `HOME-TOOLS-UPDATE.md` 自适应等高，禁止固定 112/156；90/63 仅为样例测量。
5. 普通 iPhone 只竖屏；iPad 横竖；Duo 六姿态（closed portrait/landscape、tent、open portrait/landscape、tabletop）；Split View 不在范围。
6. Tabletop 与 Open Portrait 共享 669×951 竖屏布局；Duo Open Landscape 状态/tab 在右侧浮动栏。
7. 无印章；Liquid Glass 仅导航/控制层；内容不铺玻璃；玻璃真实渲染需原生验证。
8. 188 屏 PNG 为离线设计合成，不得当作原生截图；QA 按 `SCREEN-VISUAL-CHECKLIST.csv` 逐条填原生截图与差异。
9. 视觉差异分级/必测项见 `VISUAL-ACCEPTANCE.md`；P0 清零后才可提“视觉 PASS 候选”。
10. 不 merge/不发布/不提审；权限、真实玻璃、WKWebView、动态字体、日历/时辰/农历算法由原生 + QA 验证。
