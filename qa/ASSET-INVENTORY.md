# 素材清单核对（PM → QA）

- 2026-11-14｜**最终口径以本文件为准**

## 1. candidates（`App/Resources/SeasonalArt/candidates/`）
- 实际 **39 个 webp**：**24 节气 + 14 节日 + 1 test**
- **可用生产资产 = 38**（24+14）；`test-lichun.webp` 为风格测试，不用于页面
- 全部 16:9 1024×576，**≤120KB**（最大 72.1KB）；无覆盖 winter
- 之前口述「46 张」是**生成调用次数**（含重跑），不是唯一资产数；以 **38 可用/39 文件**为准

## 2. 根目录 SeasonalArt（既有）
- **48 个 webp** = 24 节气 × light/dark（1500×1880 等）
- 唯一超限：`term-daxue-light.webp` 207,196B → **已压缩至 ≤120KB**（原文件备份 `term-daxue-light.orig.webp`）；其余均 ≤120KB
- 新候选不覆盖这些既有文件；新老两套并存，接入前由 dev/designer 决定替换

## 3. 生成记录
- 模型 wanx2.1-t2i-plus，1024×1365，seed 20261111；**55 次调用，实际 ¥11.0**（预算余 ¥40）
- `params.json` SHA `c9b7…`；`converted.json` SHA `b4a4…`；`usage-log.csv` SHA `4f9…`（以实际输出为准）
- `selection.md`（含下元/祭祖补充）SHA 见报

## 4. 下一步
- 首选 8 张 + 新增 2 张交 QA 视觉复核
- **不直接接 App**；12 条 hero 验收前仍 `pending-design`
- 需要时再补 24 节气 light/dark 统一重制（另立项，不在本批）

## 5. QA 待修 3 张（已重跑）
- fest-laba：大碗腊八粥居中，PASS
- fest-xiezao：灶台+茶壶+糖瓜，PASS（无春联/伪文字）
- term-dashu：夏日庭院+西瓜，PASS（无签名）
- 复检请只看：`fest-laba.webp` `fest-xiezao.webp` `term-dashu.webp` + 新增 `fest-xiayuan.webp` `fest-jizu.webp` + `term-daxue-light.webp`（root 115,952B）

## 6. Key 来源核对（Sure 要求）
- **图片生成全程只用 `/Users/surezhang/.dashscope/image.env`**（普通 API key；首选 env）
- 未使用 token plan/top plan（`~/.config/ghostmaps/token-plan.env` 的 key 指纹不同，未用于 wanx）
- 指纹核对（仅 SHA256 前 8 位，不打印 key）：image.env=`1466df81`、fallback=`2ca9424a`、token-plan=`6a8ab3f4`；三者不同
- usage-log 已增加 `key_source` 列，只记 env 路径
- 后续补图/重跑仅用图片 env；文案/经典语录任务才用 token plan

## 7. yulanpen 补充（2026-11-14）
- 新增 `fest-yulanpen.webp`（暮色河灯，无文字/人物/宗教场所），12.9KB
- candidates **40 文件 = 39 可用（24 节气 + 15 节日）+ 1 test**
- 总调用 **56 次、实际 ¥11.2**
- 12 条 hero 映射见 `qa/CONTENT-HERO-MAP.md`

## 8. QA 复审修正（2026-11-14）
- alt 修正 5 条（按画面实际）：dongzhi 暖黄灯笼、chunjie 三盏红灯笼、qingming 垂柳、xiezao 灶台茶壶橘子、jizu 窗下白菊
- `fest-yulanpen` 重跑：荷塘白莲/暮色（不复用中元河灯），90.8KB
- 总调用 **57 次、¥11.4**
- 12 条映射更新：`qa/CONTENT-HERO-MAP.md`

## 9. delta 修正（2026-11-14）
- dongzhi alt →「冬至，暖黄陶罐（温酒器）」；yulanpen alt →「盂兰盆，荷塘白莲」（不重跑，bytes/SHA 不变）
- 总数/花费不变：39 可用 +1 test；57 次、¥11.4

## 10. 多模型 A/B（2026-11-14）
- 图片模型 API 单价：wanx2.1-t2i-plus ¥0.2；wan2.2-t2i-plus ¥0.2；wan2.2-t2i-flash ¥0.14；wan2.5-t2i-preview ¥0.2；wan2.6-t2i ¥0.2（本 key 400 不可用）；wan2.7-image ¥0.2 / pro ¥0.5
- 端午 A/B：wan2.1 ×1、wan2.2 ×3、wan2.5 ×2；6 次 ¥1.2
- 选中 wan2.5-t2i-preview（整船+裹叶捆绳粽子）；累计 83 次 ¥16.6
