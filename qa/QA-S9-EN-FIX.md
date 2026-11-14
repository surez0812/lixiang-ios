# §9 动作类 en 修复复测（d092769c）

- 包：tar `66b7cabcc…`；binary `d7632436…`；commit `d092769c`；仅 R14-QA-iPhone。
- 证据：`qa/evidence/qa-en-fix/`（捕捉/畋猎/求医/理发/探病/除夕/重阳节/金匮 实拍）。

## 重点 5 条 en（实拍）
- 捕捉：`Traditional term for fishing or catching small animals; a customary livelihood activity.`
- 畋猎：`Traditional term for hunting outdoors; a customary livelihood activity.`
- 求医：`Traditional term for seeking medical help and checkups; cultural note, not medical advice.`
- 理发：`Traditional term for cutting and grooming hair; a customary personal-care activity.`
- 探病：`Traditional term for visiting and checking on a sick person; a customary courtesy.`
- **均不再以 Go/See/Get/Visit 开头**，为名词/文化说明。

## 全量数据审计
- 合并 `panel-terms-v2/panel-terms/yi-ji-mapping` 共 450 terms；脚本检查 en 以 `Go / See / Get / Visit ` 开头：**0 条**。
- 除夕实拍：年夜饭/守岁文化说明，en cultural note；无祈使/医疗指令。
- 10 节日语义保持；纳音/神煞抽样金匮仍为分类说明（非活动建议）。

## 判定
- **语义修正实测通过**（en 动作类）。对应内容缺口行仍 **NOT RUN**，不自动 PASS。
- 矩阵不变 100 PASS/33 FAIL/55 NOT RUN。
