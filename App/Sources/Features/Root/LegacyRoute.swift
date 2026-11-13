import Foundation
import LixiangCalendarCore

/// 兼容旧页面（Month/Day/Content 等）的路由枚举；R14 根使用 R14Route。
enum Route: Hashable {
    case day(LocalDate)
    case content(String)
    case compass(LocalDate)
    case sourceLicense(String)
    case notFound(String)
    case glossary
    case explain(String)
    case about
    case privacy(String)
    case dailyVerseSample
}
