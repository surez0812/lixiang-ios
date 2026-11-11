import Foundation
import LixiangCalendarCore

/// DEBUG 启动参数（Release 不解析；见 docs/DEV_WORKFLOW.md §6）
struct DebugOptions {
    var screen: String?
    var date: LocalDate?
    var theme: String?
    var contentID: String?
    var language: String?
    var hour: Int?
    var hiddenDeities: Set<Deity> = []
    var network: String?          // normal | offline | error | slow
    var cacheState: String?       // primed | empty
    var typeScale: Double?        // 1.0 ... 2.0（Dynamic Type 注入）
    var contentVersion: String?   // mock 版本覆盖
    var emptyIndex: Bool = false  // F5 空态
    var expandPast: Bool = false  // F5 已过组默认展开
    var deepLink: String?          // -LixiangDeepLink lixiang://ceremony/xiezao
    var seedCountdown: Bool = false // -LixiangSeedCountdown 1

    static func parse(_ arguments: [String] = ProcessInfo.processInfo.arguments) -> DebugOptions {
        #if DEBUG
        var options = DebugOptions()
        var i = 0
        while i < arguments.count {
            let arg = arguments[i]
            func next() -> String? { i + 1 < arguments.count ? arguments[i + 1] : nil }
            switch arg {
            case "-LixiangScreen": options.screen = next()
            case "-LixiangDebugDate": options.date = next().flatMap(LocalDate.init)
            case "-LixiangTheme": options.theme = next()
            case "-LixiangContentID": options.contentID = next()
            case "-LixiangDebugHour": options.hour = next().flatMap(Int.init)
            case "-LixiangNetwork": options.network = next()
            case "-LixiangCacheState": options.cacheState = next()
            case "-LixiangTypeScale": options.typeScale = next().flatMap(Double.init)
            case "-LixiangContentVersion": options.contentVersion = next()
            case "-LixiangEmptyIndex": options.emptyIndex = next() == "1"
            case "-LixiangExpandPast": options.expandPast = next() == "1"
            case "-LixiangDeepLink": options.deepLink = next()
            case "-LixiangSeedCountdown": options.seedCountdown = next() == "1"
            case "-LixiangDebugHideDeity":
                let raw = next() ?? ""
                options.hiddenDeities = Set(raw.split(separator: ",").compactMap { Deity(rawValue: String($0).trimmingCharacters(in: .whitespaces)) })
            case "-LixiangLang": options.language = next()
            default: break
            }
            i += 1
        }
        return options
        #else
        return DebugOptions()
        #endif
    }
}
