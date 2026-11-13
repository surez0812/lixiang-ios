# R8 逐条覆盖 · 2026-11-13

本轮以用户最新意见为准。保留 ../codex-review-v6/（R7）及所有更早交付，不覆盖历史验收材料。此前黄历、经文与无印章等约束继续有效。

| 用户本轮意见 | 本轮结果 | 直接审核入口 |
|---|---|---|
| phone-landscape不做 | 普通iPhone仅竖屏；Duo姿态尺寸单列 | 设备矩阵；无phone-landscape交付 |
| Hero天干地支完整 | 年/月/日三柱完整显示，另列当前巳时辛巳时与09:41样本时间 | home-phone-light.png |
| 今日岁时项可直达详情 | 今日命中行独立链接，进入岁时tab并打开准确活动；无命中不显示空行 | Hero；folklore-detail；home-phone-light-no-matches.html |
| 今日倒计日可直达详情 | 今日命中行直达对应id的纪念日详情，倒计日tab选中 | countdown-detail-phone-light-today.html |
| 月历点与文字重叠 | 51pt单元，文字底37.5pt，标记轨道从41pt开始；点和纪念星共用独立轨道 | home-ipad-landscape.png；几何检查 |
| 岁时解锁红点 | 0–10天内且有未读新内容时显示；成功加载该版本正文后才标为已读 | badge-states.png；R8-FLOW-TESTS.json |
| 倒计日十天内红点＋数字 | 0–10天内显示红点＋最近剩余天数，0表示今天；不是事项数量 | badge-states.png；倒计日详情 |
| 天气权限等待状态 | 未询问、系统弹窗示意、定位中、已允许、拒绝、天气失败均有设计；拒绝不阻断其他功能 | weather-states.png；各状态HTML |
| iPad横屏Hero加高、更多节气图 | 插画从180pt加至270pt；Hero纵向更完整 | home-ipad-landscape.png |
| iPad岁时／择日上下排列 | 按本轮意见改为上下排列；替换R7并排方案 | home-ipad-landscape.png |
| 解锁岁时后的详情页 | 新增全设备详情；native负责摘要和状态，网页负责正文 | folklore-detail各设备；native-web-boundary.jpg |
| 网页模板及设备适配 | 模板HTML、CSS、JSON schema/sample、渲染器与编辑提示词；提供两篇本地内容样本 | templates/；webpages/；Duo与iPad详情 |
| 首次倒计日notification流程 | 先保存记录，再解释用途；用户选择开启才进入系统授权。拒绝／稍后保留App内提醒；允许才产生排期意图 | notification-flow.jpg；iOS权限参考文件 |
| 每日一签定稿，全设备适配 | 素材、1450ms时序、筒口遮挡、核心脚本冻结；14种布局均有待机/结果稿和可播放HTML | fortune-adaptation.jpg；各设备fortune原型 |
| 设置标题换为唤心 | 顶部品牌改“每日一句 · 唤心”；四类经典偏好保留 | settings各设备 |
| Duo参考Device Hub原图与skill | 原始像素逐张核对；分离状态簇＋浮动tab，无整条实色侧栏；短横向隐藏状态簇 | index.html原图对照；Duo-REFERENCE-REVIEW.md |

设计稿和原型均已覆盖上述条目。原生通知、定位、WKWebView和Duo实际运行尚未接入或验证；不能把结构检查等同于App功能验收。动画是本轮唯一已由用户明确“定稿”的设计，其他页面继续等待用户审核。
