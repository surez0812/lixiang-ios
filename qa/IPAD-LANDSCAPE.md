# iPad landscape 路由视觉对照（真实 XCUITest 旋转）

- 证据：`qa/evidence/ipad-landscape/r14-ipad-landscape-*-real.png`；真实 2752×2064。
- **HEAD 5e9f98d 后 5 页均与设计双列构图一致 → PASS。**

| 页面 | 矩阵行 | 结果 | 依据 |
|---|---:|---|---|
| almanac | 17 | **PASS** | 左 Hero+宜忌 / 右十二时辰列表 |
| compass | 125 | **PASS** | 左控件 / 右盘面+竖排 legend |
| daily | 77 | **PASS** | 左解释 / 右分享卡+双按钮 |
| fortune | 113 | **PASS** | 左标题 / 右签筒 / 底部全宽按钮+跳过 |
| selection | 65 | **PASS** | 左表单 / 右结果双列；未提交时为空态提示 |

- 旧 force-flag 截图的 FAIL 已作废；不 merge/发布/提审。

## Dark（新证据）
- 5 Tab dark PASS（行 6/30/66/42/54）：home/岁时/择日/倒计日/设置。
- 路由 dark：
  - almanac 行18 PASS（双列）
  - compass 行126 PASS（左控件/右盘+legend）
  - fortune 行114 PASS（左标题/右筒/底部全宽+跳过）
  - selection 行66 PASS（双列，空结果提示）
  - **daily 行78 PASS**：右列分享卡强制亮色 token，卡内文字可读；左列重复分享卡已移除。
- 证据：`qa/evidence/ipad-landscape-dark/`。
