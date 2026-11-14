# 12 条内容 v2 pre-verify（4e799ea7）

- 对象：`qa/content/events-12.json` SHA `4e799ea78eb91b483fb4eb0d526c8c5d5e2c5f3281a4245386c93771d13129a7`；12 draft。
- QA 设备：无（仅静态/URL 检查；未碰锁定机）。
- **结论：pre-verify 未通过；任务保持 HOLD。**

## 1. 结构（PASS）
- envelope version=1；12 ids 与计划一致。
- 每条 sections≥2、license=original、licenseNote 非空、hero.status=pending-design、unlockOffset=10；全部 draft。
- hero 字段含 path/alt/aspect=16:9/maxBytes=122880；**pending-design 不作为已有图**。

## 2. 来源（FAIL）
- 每条 2 sources；第 1 条为维基具体条目（标题+entry URL，如 `zh.wikipedia.org/wiki/冬至`），第 2 条仍为**机构首页**：
  - cma.gov.cn / gov.cn / ihchina.cn / wenming.cn（无文章级路径）。
- 机构首页 HTTP 200，但**不满足“具体文章/条目且能支撑该条内容”**；与 Codex 上次 REJECT 理由同类。
- 维基具体条目 URL 在 QA 网络环境 curl 超时（环境限制，不断言全局不可用），未取得 200。
- 因此 source pre-verify FAIL，不能放桥复审。

## 3. license/hero（PASS）
- 12/12 license=original + licenseNote；无 public-domain。
- 12/12 hero pending-design、unlockOffset=10。

## 4. 措辞/红线
- xiayuan/yulanpen/xiezao/jizu sections 相对旧版已变化；其他 8 条 sections 未变。
- 红线扫描：祈福/赏月/预测等命中均在“传统习俗/不作预测”文化说明语境，无医疗指令/宗教劝诱/吉凶承诺。
- **teaser 长度**：xiayuan=26 字，超过 QA 用例 15–23 上限 → 需修订。

## 5. 与旧版差异
- SHA a77aaba1 → 4e799ea7。
- 新增/修改：每条 sources 2（但第2仍主页）、license original+licenseNote、hero pending-design、unlockOffset=10；xiayuan/yulanpen/xiezao/jizu 正文措辞变化；其余正文大体不变。

## 6. 结论
- **结构/许可/hero 声明/大多措辞通过；来源不达标（机构首页），xiayuan teaser 超长**。
- 任务不移动出 HOLD；等 PM 将第 2 来源改为具体文章/条目并修 teaser 后，重新 pre-verify。
- 内容缺口行 85-90/163/174 仍 NOT RUN；矩阵不变 100/33/55。
