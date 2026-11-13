import Foundation
import CryptoKit

// Local-only reference store. Preserve the selected result across content updates.
struct DailyDrawStore {
    struct Catalog: Decodable {
        let contentVersion: String
        let signs: [FortuneSign]
    }
    let catalog: Catalog
    var defaults: UserDefaults = .standard

    func sign(for date: Date) -> FortuneSign? {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        formatter.dateFormat = "yyyy-MM-dd"
        let day = formatter.string(from: date)
        let key = "lixiang-draw-" + day
        if let saved = defaults.data(forKey: key), let sign = try? JSONDecoder().decode(FortuneSign.self, from: saved) {
            return sign
        }
        let signs = catalog.signs.sorted { $0.id < $1.id }
        guard !signs.isEmpty else { return nil }
        let seed = day + "|lixiang-v1|" + catalog.contentVersion
        let bytes = Array(SHA256.hash(data: Data(seed.utf8))).prefix(8)
        let value = bytes.reduce(UInt64(0)) { ($0 << 8) | UInt64($1) }
        let result = signs[Int(value % UInt64(signs.count))]
        if let data = try? JSONEncoder().encode(result) { defaults.set(data, forKey: key) }
        return result
    }
}
