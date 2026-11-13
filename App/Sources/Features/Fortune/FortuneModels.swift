import Foundation

struct FortuneSignType: Codable, Hashable {
    let id: String
    let title: String
    let enabled: Bool
}

struct FortuneSign: Codable, Identifiable, Hashable {
    let id: String
    let type: String
    let no: Int
    let level: String
    let title: String
    let poem: [String]
    let explain: String
    let advice: String
    let keywords: [String]
}

struct FortunePackage: Codable {
    let version: Int
    let contentVersion: String
    let datePolicy: String
    let source: String
    let signTypes: [FortuneSignType]
    let signs: [FortuneSign]
}
