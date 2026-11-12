import Foundation

struct WeatherSnapshot: Codable, Equatable {
    var temperature: Double
    var code: Int
    var updatedAt: Date
    var city: String
}

enum WeatherState: Equatable {
    case idle, loading, loaded(WeatherSnapshot, cached: Bool), failed(String)
}

@MainActor
final class WeatherService: ObservableObject {
    @Published private(set) var state: WeatherState = .idle
    private let cacheKey = "weather.shanghai.v1"
    private let ttl: TimeInterval = 20 * 60

    func refresh(force: Bool = false) async {
        if let cached = loadCache(), !force, Date().timeIntervalSince(cached.updatedAt) < ttl {
            state = .loaded(cached, cached: true); return
        }
        state = .loading
        var comps = URLComponents(string: "https://api.open-meteo.com/v1/forecast")!
        comps.queryItems = [
            .init(name: "latitude", value: "31.2304"),
            .init(name: "longitude", value: "121.4737"),
            .init(name: "current", value: "temperature_2m,weather_code"),
            .init(name: "timezone", value: "Asia/Shanghai")
        ]
        do {
            var req = URLRequest(url: comps.url!); req.timeoutInterval = 8
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse, http.statusCode == 200 else { throw URLError(.badServerResponse) }
            struct R: Decodable { struct C: Decodable { let temperature_2m: Double; let weather_code: Int }; let current: C }
            let r = try JSONDecoder().decode(R.self, from: data)
            let snap = WeatherSnapshot(temperature: r.current.temperature_2m, code: r.current.weather_code, updatedAt: Date(), city: "上海")
            saveCache(snap)
            state = .loaded(snap, cached: false)
        } catch {
            if let cached = loadCache() { state = .loaded(cached, cached: true) }
            else { state = .failed("天气暂不可用") }
        }
    }

    /// 看门狗：10s 仍 loading → 失败态（缓存优先），避免无限 loading
    func timeoutIfLoading() {
        if case .loading = state {
            if let cached = loadCache() { state = .loaded(cached, cached: true) }
            else { state = .failed("天气暂不可用，请重试") }
        }
    }

    private func loadCache() -> WeatherSnapshot? {
        guard let d = UserDefaults.standard.data(forKey: cacheKey) else { return nil }
        return try? JSONDecoder().decode(WeatherSnapshot.self, from: d)
    }
    private func saveCache(_ s: WeatherSnapshot) {
        if let d = try? JSONEncoder().encode(s) { UserDefaults.standard.set(d, forKey: cacheKey) }
    }
}

enum WeatherCode {
    static func text(_ code: Int) -> String {
        switch code {
        case 0: return "晴"; case 1...3: return "多云"; case 45, 48: return "雾"
        case 51...57: return "毛毛雨"; case 61...67: return "雨"; case 71...77: return "雪"
        case 80...82: return "阵雨"; case 85, 86: return "阵雪"; case 95...99: return "雷雨"
        default: return "多云"
        }
    }
}
