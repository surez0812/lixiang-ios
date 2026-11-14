# 季节素材抽检/覆盖清单（与 UI-001 分开）

- 路径：`App/Resources/SeasonalArt/`
- 当前包内：
  - 根目录 48 张 WebP（24 节气 × light/dark），1500×1880，约 4.14MB；命名 `term-<slug>-{light,dark}.webp`。
  - `candidates/` **39 个 WebP**：24 节气 16:9 1024×576 + 14 节日 + 1 test；产品 38。
- **计数/费用**：复检后 candidates **40 个文件 = 产品39 + test1**；24节气+15节日；花费 ¥11.4/57次。此前 37/46 口径作废。
- 根目录终稿 `term-daxue-light.webp` **207,196B > 120KB**；仍在包内则记 asset spec 缺陷，压图后需新 SHA，不能因旧图放过。
- 视觉抽检见 `qa/ASSET-QA-ALIYUN.md`：33 PASS / 3 待修（laba/xiezao/dashu）/ 1 test 排除。
- 候选/终稿均未接入 `index.json` 之外的正式 UI 映射；不当作内容/UI PASS。

## 覆盖核对
| 类别 | 应有 | 现有 | 缺口 |
|---|---:|---:|---|
| 24 节气（终稿 light/dark） | 48 | 48 | 0（root daxue-light 已压至115,952B） |
| 24 节气候选 16:9 | 24 | 24 | 0 |
| 节日候选 | 14 | 14 | 0（含补 xiayuan/jizu） |
| 测试样张 | — | 1 test-lichun | 非产品素材 |
| PM 首批 | 39 产品 | 39 | 0；46/37 旧口径作废 |

## 抽检规则（不在 UI-001 混入）
- 逐张：文件可解码、无 alpha/透明边、16:9 或终稿 1500×1880、≤120KB（或批准上限）、无文字/水印/裁切。
- 映射：24 节气 slug/中文/index；节日 slug；light/dark 成对。
- 输出 SHA256/尺寸/体积表；异常单独列，不修改文件。

## 复检清单
- 见 `qa/ASSET-ALIYUN-RECHECK.md`：laba/xiezao/dashu、补下元/祭祖、root daxue 压图；通过前不接 App。

## 复检结果
- 6 项复检全部 PASS（laba/xiezao/dashu/xiayuan/jizu + root daxue-light 115,952B）；详见 `qa/ASSET-QA-ALIYUN.md` 复检 v2。

## 12 hero 映射
- candidates 40=39 可用（24节气+15节日）+test；hero 映射见 `qa/CONTENT-HERO-MAP.md`；视觉复核见 `qa/CONTENT-HERO-QA.md`，delta 见 `qa/CONTENT-HERO-RECHECK.md`。
