import LunarSwift
import Foundation

/// 道历/佛历年份与节日（展示层；经 ReligionDisplay 过滤改名，不出 raw key）
public struct ReligionYearInfo: Hashable, Sendable {
    public var year: Int
    public var yearInChinese: String
    public var festivals: [String]
    public init(year: Int, yearInChinese: String, festivals: [String]) {
        self.year = year; self.yearInChinese = yearInChinese; self.festivals = festivals
    }
}

public extension LunarSwiftEngine {
    /// 道历：Tao.year / 节日（ReligionDisplay.taoName 过滤 hidden）
    func taoInfo(for date: LocalDate) -> ReligionYearInfo? {
        let solar = Solar.fromYmdHms(year: date.year, month: date.month, day: date.day, hour: 12, minute: 0, second: 0)
        let tao = Tao.fromLunar(lunar: solar.lunar)
        let names = tao.festivals.compactMap { ReligionDisplay.taoName($0.name) }
        return ReligionYearInfo(year: tao.year, yearInChinese: tao.yearInChinese, festivals: names)
    }

    /// 佛历：Foto.year / 节日（ReligionDisplay.fotoName 过滤 hidden；`result` 不展示）
    func fotoInfo(for date: LocalDate) -> ReligionYearInfo? {
        let solar = Solar.fromYmdHms(year: date.year, month: date.month, day: date.day, hour: 12, minute: 0, second: 0)
        let foto = Foto.fromLunar(lunar: solar.lunar)
        let names = foto.festivals.compactMap { ReligionDisplay.fotoName($0.name) }
        return ReligionYearInfo(year: foto.year, yearInChinese: foto.yearInChinese, festivals: names)
    }
}
