# xiayuan delta pre-verify（新 SHA 63722767）

- 新：`qa/content/events-12.json` SHA `63722767cd73e17b2c5d3011c768799168a554afd4a8a75b56174f2fecb589b2`
- 旧 v3：SHA `8ed1868238ba8ba2d73b6c58c46e536d6db0617bcd7a2289a29e7fca99ed06e5`
- 12 条 draft；只审 xiayuan delta。

## 1. xiayuan 变化（PASS）
- 删除“放河灯”及 sections 残留；新 customs 为「祭水官、祈福、解厄等传统信仰活动；传统信仰民俗说法，并非客观效果；不涉宗教劝诱/不作吉凶预测」。
- intro 保留「三元节」、祭水官/解厄/修斋，并限定传统信仰民俗说法。
- teaser 18 字；hero pending-design；license original+licenseNote；sources 2 个 Wikipedia 具体条目（下元節/道教）；unlockOffset 10。
- xiayuan item 内全文扫描“放河灯”=0。

## 2. 其余 11 条（PASS 不变）
- 与 Codex v3 快照逐条 JSON 比较：**仅 xiayuan 变化，其余 11 条完全相同**。
- 注：events-12 全文件仍有 3 处“放河灯”，位于 zhongyuan/yulanpen（属其他 11 条且未改、Codex v3 已 APPROVE）；若要求全文件无该词，必须另改这两条并重审，不能算本次 xiayuan delta。
- 11 条不再改审；如后续被改则 FAIL。

## 3. 来源/边界
- xiayuan 来源仍为 Wikipedia 下元節/道教；QA Mac 网络仍不能打开 Wikipedia（环境限制），10/15、三元节、祭水官、解厄的支撑沿用 Codex v3 已核对（其唯一 REJECT 点为放河灯，已删除）；不放河灯后无新增未证细节。
- 边界：传统信仰限定、非客观效果、不涉宗教劝诱/预测；未见医疗/吉凶承诺。

## 4. 结论
- **xiayuan delta pre-verify PASS（仅 xiayuan）**；其余 11 条不变。
- 任务可移出 HOLD 交 Codex 复审；**内容行仍 NOT RUN**，等 12/12 approved + 受控接入。
- 全文件“放河灯”3 处为 zhongyuan/yulanpen 既有已批准内容，需 PM/Codex 决定是否另改。
