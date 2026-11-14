# 主站 Admin 岁时工具 · 生产验收清单（PM）

- 2026-11-14｜验收人 calendar-pm（专用账号 `calendar_pm_admin`，凭据仅私信，不入文档/群）
- 前置：Lead 生产部署完成、ops 提供 URL + 凭据、账号已授 admin/editor 权限
- 不分享凭据；不测试包/不提审；只做 Admin 验收

## 1. 登录与权限
- [ ] 打开生产 URL，`/admin/heroes` 用 `calendar_pm_admin` 登录
- [ ] 确认角色为 admin（可编辑/审核）；非 admin 立即停并报 ops
- [ ] 401/403/跳 `/forbidden` → 记录截图与状态码

## 2. 43 坑完整性
- [ ] 列表 = **43**：24 节气 + 19 节日；清明双挂（`term-qingming` + `fest-qingming`）
- [ ] 逐项核对 slug 与 `qa/CONTENT-SLOTS-43.json` 一致；5 个预置已存在
- [ ] 缺项/重复/命名不符 → 记 blocker（不自行改数据）

## 3. Hero 生成（qwen-image-3.0-pro）
- [ ] 选 1 个坑（如 term-lichun），生成 1 张：1024×576、≤120KB、无文字/人物正脸/宗教场所
- [ ] 显示缩略图、SHA256、费用（¥0.25/张）；入库成功
- [ ] 记录：坑位、模型、耗时、费用、SHA、截图路径

## 4. Webpage 生成（qwen4-max-preview，light-only）
- [ ] 选 1 个坑（如 fest-duanwu），生成 1 篇；**无 dark**
- [ ] 校验：intro + 来由/风俗南北差异/日常小仪式；`sources ≥2` 且 https；无 note/sources/updatedAt 渲染；无 header hero
- [ ] 保存 draft / 预览 light 成功；记录 JSON SHA、HTML 预览截图、来源数

## 5. Usage / Key 安全
- [ ] 图片账：model/张数/¥（累计 ≤¥50）；文本账：token plan 单独记录
- [ ] 页面/日志无 key 明文；网络面板无 key 泄漏；凭据不入库
- [ ] 记录两账截图/导出

## 6. 结论模板
- 通过/阻塞（逐项 PASS/FAIL）；阻塞写：URL/账号角色/请求 ID/截图；不擅自改生产数据
- 结果报 Lead + superwebpm；验收后不发布/不提审
