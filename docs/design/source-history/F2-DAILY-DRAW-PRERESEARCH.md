# F2 每日一签 · 技术预研（结论：全本地固化，不调 AI）

> 参考 GitHub 方向：签种/签语数据 JSON 化 + 本地随机/日期确定 + 动画；手机不调 AI API。不落地代码，等 design。

## 1) 结论
- **签种与签语全部固化进 App 资源 JSON**（随包，无网络、无 AI 调用、无隐私/审核风险）
- 每日一签按**北京日期确定性映射**（date seed → 签），同一天多次打开一致；支持「再求一签」限次（如 1 次/日）
- 内容为**传统文化签文（公版/自撰）**，避免预测/恐吓/医疗财运断言；页面加免责「民俗文化参考，非预测」

## 2) 资源结构（建议）
```json
{
  "version": 1,
  "source": "历象编辑部整理（公版签诗改写）",
  "signTypes": [
    {"id":"guanyin","title":"观音灵签","count":100,"enabled":true},
    {"id":"luzu","title":"吕祖灵签","count":100,"enabled":false}
  ],
  "signs": [
    {"id":"guanyin-001","type":"guanyin","no":1,"level":"上上",
     "title":"钟离成道","poem":["开天辟地作良缘","日吉时良万物全","若得此签非小可","人行忠正帝王宣"],
     "explain":"…60–120字白话…","advice":"…20–40字行动建议…","keywords":["事业","姻缘"]}
  ]
}
```
- 字段：`id/type/no/level/title/poem[4]/explain/advice/keywords`；`level`（上上/上/中/下）只做文化标签，不恐吓
- 资源：`App/Resources/Divination/signs-guanyin.json`（100 条）、索引文件 `daily-draw-index.json`（365 天 → 签 id）
- 图片：可选签筒/签文卡背景（1–2 张 webp，<200KB）

## 3) 读取与排序
- `DailyDrawStore`：加载 JSON（懒加载、失败回退内置 5 条）、`sign(for date)`：先查 365 index，缺日哈希（`epochDay % signs.count`）
- 记录「今日已求」`UserDefaults`；「再求」限 1 次，记录抽签历史（可选）
- 无网络调用；无 AI key

## 4) 动画建议
- 签筒轻摇（Reduce Motion→静态）→ 签文卡翻转/上滑；总时长 ≤900ms；不做「随机抖动」欺骗感
- 分享：复用现有 ShareCardRenderer（1080×1350 JPEG + QR）
- a11y：签文标题/四句/解释顺序朗读；摇一摇仅装饰

## 5) 工作量/风险
- App：0.5–1d（store + 页面 + 动画）+ 内容 100 条（PM/编辑 1–2d）
- 风险：签文质量/合规（不预测）；避免「上上签」诱导消费；审核可能问询→免责文案前置
