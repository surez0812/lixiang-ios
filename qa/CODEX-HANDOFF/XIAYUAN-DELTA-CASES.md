# xiayuan delta preverify 用例（待 PM 新 SHA）

- 基线：`events-12.json` v3 SHA `8ed18682…`；Codex 11/12 APPROVE，仅 xiayuan REJECT。
- 目标：修正 xiayuan 放河灯来源缺口，不引入其他变更。

## 必查
1. **xiayuan diff 仅限相关字段**：customs/regionalDates/sources/sections；其余 11 条内容与 v3 逐字一致（除必要 JSON 格式）。
2. **删除/替换“放河灯”**：如保留，必须给出具体地区/日期来源；不得仅引下元节/道教总条目。
3. **传统信仰限定保留**：不写客观效果/吉凶承诺；保留 safety/尊重当地习俗。
4. sources 2 条具体条目可核；license=original+licenseNote；hero=pending-design；unlockOffset=10。
5. 12 条 teaser≤23；结构/sections≥2；reviewStatus 全 draft。
6. 若只是 xiayuan 修改，记录文件 SHA 与 v3 的 diff；不接入 App/资源。
7. 通过后才放桥复审；内容行仍 NOT RUN。
