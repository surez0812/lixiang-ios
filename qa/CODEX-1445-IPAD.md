# Codex 1445 iPad/compact/dark 结果归档

- 包：clean `38b34c5a`（tar `36d20ef2…`、binary `b4ddbe8e…`）。
- 结果：**PARTIAL + FAIL_UI**；独立 runtime 层；矩阵不改。
- 证据：`handoff/codex-bridge/evidence/1445-clean38b34c5a-delivery/`；归档 `archive/20261114-realcompact-ipad-dark/`。
- **矩阵 100/33/55 不改。**

## 发现
- **Duo Closed Landscape**：自动 compact 生效，但 tools 异常空白高度/标题操作贴底/被胶囊遮挡 → FAIL_UI；旧失败 build 不重复重试，1530 修复另测。
- **iPad portrait 1032×1376 light**：实际 `width>=744` 选两栏，最终原稿 portrait 为全宽竖排 → FAIL_UI；下方大空白。截图 `ipad-portrait-light-home.png`。
- **iPad landscape light/dark**：两栏但顶部内容压缩、下方大空白，相对原稿需调 sizing/spacing；截图 `ipad-landscape-{light,dark}-home.png`；未做完整 token/font 匹配。
- **iPad dark portrait**：仍错误两栏；完整 dark 原稿对照未完成。
- **Detail**：iPad landscape dark 点击真实 chongyang；hero 16:9/source 容器/正常 alt 可见，但整体 header/hero 与最终左摘要/右文章 composition 不符 → 整体布局 FAIL_UI；截图 `ipad-landscape-dark-chongyang.png`。
- **UI-001 三态**：实际拖动未产生可辨滚动位移；重复相同图不能称 first/mid/end → 三态 PARTIAL；捕获态未见明显全宽底带，不整体 PASS。
- **末项**：真实月历末项点击打开 2026-12-06 黄历 → 仅 scoped 通过，不推广。
- iPad OS18.6，无 native Liquid Glass；Duo OS27.2。
