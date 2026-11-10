import Foundation
import LixiangCalendarCore

/// DEBUG 启动参数（Release 不解析；见 docs/DEV_WORKFLOW.md §6）
struct DebugOptions {
    var screen: String?
    var date: LocalDate?
    var theme: String?
    var contentID: String?
    var language: String?

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
