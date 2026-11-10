# LixiangCalendarCore（骨架）

历象的历法**领域层**。当前只有骨架占位，**不含产品逻辑**。

计划中的分层（实现阶段落地，详见内部交接文档 `tech/03`/`tech/04`）：

```
Domain/     LocalDate / LunarDate / AlmanacDay / Festival / Holiday / Anniversary 等值类型
Engine/     CalendarEngine 协议 + LunarSwiftEngine（唯一 import LunarSwift 的地方）
Holiday/    HolidayData 覆盖层（随包 JSON + 校验；官方通知年度更新）
Content/    dateRule → unlockDate（UTC+8）、regionalDates、内容缓存规则
Cache/      MonthCache / DayDetailCache（actor）
```

约束：
- 只依赖 `Foundation` + `LunarSwift`（MIT）；不 import UIKit/AVFoundation；
- 对外只暴露 `Sendable` 值类型；库的 `NSObject` 对象不跨 actor；
- 禁止调用 `HolidayUtil.fix(names:data:)`（会改库内 static 状态）。

```bash
swift build   # 需要网络解析 LunarSwift 1.1.9
swift test
```
