# 历象三屏修订 · 交付摘要（Codex）

## 交付物（全部在 `final-revision-codex/`）
- **任务计划**：`CODEX-TASK-PLAN.md`
- **逐条覆盖清单**：`CODEX-COVERAGE-CHECKLIST.md`
- **规格**：`CODEX-DELIVERY-SPEC.md`（D1 tokens / Liquid Glass / Duo / 动画 / 择日 / 动态高度）
- **文案**：`CODEX-COPY.md`（签语 10 条样例、择日、白话、节气、分享）
- **样张 PNG（26 张）**：
  - 首屏：`hero-light.png` `hero-dark.png`
  - 每日一句：`daily-light.png` `daily-dark.png` `daily-long.png`（动态高度示例）
  - 单日详情：`day-light.png` `day-dark.png` `day-full-light.png` `day-full-dark.png`
  - iPad 合并：`ipad-merged-landscape-{light,dark}.png` `ipad-merged-portrait-{light,dark}.png`
  - iPad 每日一句：`ipad-daily-landscape-{light,dark}.png` `ipad-daily-portrait-{light,dark}.png`
  - Duo 六姿态：`duo-poses.png`
  - 分享卡（仅亮色）：`share-light.png`
  - 每日一签：`qian-{idle,shake,result}-{light,dark}.png`
  - QR（无印章）：`qr-clean.png`
- **生成脚本**：`build_phone.py`、`build_ipad_duo.py`（可复跑）
- **清册**：`SHA256SUMS`（33 项）

## 关键落实
1. **删除所有印章**（Hero/每日一句/单日详情/分享卡均无印章）。
2. 首屏节气徽标按三候显示：`❄ 今日节气 · 立冬 · 一候 水始冰`。
3. iPad 合并：左单日多卡、可滑切日；右月历浮动固定、30 天+农历+节气/节日点+选中高亮。
4. 每日一句：玻璃导航只留返回+分享；经文卡动态高度（短/长两版）。
5. 单日详情：无 title/分享/提醒；三小卡一行；黄历精修；岁时下加择日。
6. Duo 六姿态：无 nav bar、导航右侧状态栏；横屏/tent 同 iPad；tabletop 上下分屏。
7. 每日一签：整屏 + idle/shake/result 关键帧 + 含义/影响/怎么用；本地固化、不调 AI API。
8. 分享卡仅亮色，QR 已重生成（无印章）。

## 剩余内容依赖
- 每日一签完整 100 条签语（本稿 10 条样例）→ PM 内容侧。
- 择日算法/数据（本稿 UI + 文案）。
- Duo 六姿态实机验收（本稿为设计示意，NOTRUN）。
- iPad/手机落地时按真机 pt 微调字号。

## 复跑
```
python3 build_phone.py
python3 build_ipad_duo.py
```
