import CryptoKit
import Foundation

/// 每日一签：本地 JSON、北京时间同日同签、不调 AI。
@MainActor
final class FortuneEngine: ObservableObject {
    @Published private(set) var package: FortunePackage?
    @Published private(set) var loadError: String?

    private let defaults: UserDefaults
    private let packageName: String
    private let cachePrefix = "fortune.draw.v1."

    nonisolated static let timeZone = TimeZone(identifier: "Asia/Shanghai") ?? .current

    init(defaults: UserDefaults = .standard, packageName: String = "fortune-samples") {
        self.defaults = defaults
        self.packageName = packageName
    }

    func load() {
        guard package == nil else { return }
        guard let url = Bundle.main.url(forResource: packageName, withExtension: "json") else {
            loadError = "签库文件缺失"
            return
        }
        do {
            let data = try Data(contentsOf: url)
            package = try JSONDecoder().decode(FortunePackage.self, from: data)
            loadError = nil
        } catch {
            loadError = "签库读取失败"
        }
    }

    /// 北京时间 yyyy-MM-dd
    nonisolated static func dayKey(for date: Date) -> String {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.timeZone = timeZone
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "yyyy-MM-dd"
        return f.string(from: date)
    }

    /// 确定性选签：SHA256(day|"lixiang-v1"|contentVersion) 前 8 字节 % 签数；结果按 id 排序后取。
    func sign(for date: Date) -> FortuneSign? {
        load()
        guard let package, !package.signs.isEmpty else { return nil }
        let key = Self.dayKey(for: date)
        if let cachedID = defaults.string(forKey: cachePrefix + key),
           let cached = package.signs.first(where: { $0.id == cachedID }) {
            return cached
        }
        guard let chosen = Self.pick(dayKey: key, contentVersion: package.contentVersion, signs: package.signs) else { return nil }
        defaults.set(chosen.id, forKey: cachePrefix + key)
        return chosen
    }

    func cachedSignID(for date: Date) -> String? {
        defaults.string(forKey: cachePrefix + Self.dayKey(for: date))
    }
}

extension FortuneEngine {
    /// 纯函数，便于单测：北京时间日键 + contentVersion → 固定签。
    nonisolated static func pick(dayKey: String, contentVersion: String, signs: [FortuneSign]) -> FortuneSign? {
        guard !signs.isEmpty else { return nil }
        let seed = dayKey + "|lixiang-v1|" + contentVersion
        let digest = SHA256.hash(data: Data(seed.utf8))
        var value: UInt64 = 0
        for byte in digest.prefix(8) { value = (value << 8) + UInt64(byte) }
        let sorted = signs.sorted { $0.id < $1.id }
        return sorted[Int(value % UInt64(sorted.count))]
    }
}
