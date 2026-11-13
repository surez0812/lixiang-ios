import SwiftUI
import LixiangCalendarCore

/// 首页天气卡：未询问/定位中/就绪/拒绝受限/定位失败/天气失败 六态；只在用户动作后请求。
struct HomeWeatherCard: View {
    @Environment(\.d1) private var theme
    @Environment(\.openURL) private var openURL
    @StateObject private var location = WeatherLocationProvider()
    @StateObject private var service = WeatherService()

    var body: some View {
        D1Card(padding: 12) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Image(systemName: icon).d1Font(22).foregroundStyle(theme.accentStrong)
                    Text("今日天气").d1Font(14, weight: .semibold).foregroundStyle(theme.ink)
                }
                content
            }
            .frame(maxWidth: .infinity, minHeight: 98, alignment: .topLeading)
        }
        .onAppear {
            location.refreshAuthorization()
            #if DEBUG
            if ProcessInfo.processInfo.arguments.contains("-LixiangWeatherAuto") { location.requestLocation() }
            #endif
        }
        .onChange(of: location.authorization) { _, new in
            guard new == .authorized, let c = location.coordinate else { return }
            Task { await service.refresh(coordinate: c.latitude, lng: c.longitude, city: location.city) }
        }
        .onChange(of: location.coordinate?.latitude) { _, _ in
            guard let c = location.coordinate else { return }
            Task { await service.refresh(coordinate: c.latitude, lng: c.longitude, city: location.city) }
        }
    }

    @ViewBuilder private var content: some View {
        switch location.authorization {
        case .notDetermined:
            action("开启定位") { location.requestLocation() }
        case .denied, .restricted:
            action("去设置开启") {
                if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) }
            }
            Text("定位未开启，不影响其他功能").d1Font(10).foregroundStyle(theme.ink3)
        case .authorized:
            if location.locating {
                HStack(spacing: 8) { ProgressView().controlSize(.small); Text("定位中…").d1Font(11).foregroundStyle(theme.ink2) }
                    .frame(maxWidth: .infinity, minHeight: 44)
            } else if let error = location.locationError {
                action("重新定位") { location.requestLocation() }
                Text(error).d1Font(10).foregroundStyle(theme.ink3).lineLimit(2)
            } else {
                weatherBody
            }
        }
    }

    @ViewBuilder private var weatherBody: some View {
        switch service.state {
        case .idle, .loading:
            HStack(spacing: 8) { ProgressView().controlSize(.small); Text("天气加载中…").d1Font(11).foregroundStyle(theme.ink2) }
                .frame(maxWidth: .infinity, minHeight: 44)
        case .loaded(let snap, let cached):
            HStack(alignment: .firstTextBaseline, spacing: 6) {
                Text("\(Int(snap.temperature.rounded()))°").d1SerifFont(26).foregroundStyle(theme.ink)
                Text(WeatherCode.text(snap.code)).d1Font(13).foregroundStyle(theme.ink2)
                Spacer()
            }
            HStack(spacing: 6) {
                Text("\(snap.city)\(cached ? " · 缓存" : "")").d1Font(10).foregroundStyle(theme.ink3)
                Spacer()
                Button("刷新") { refresh() }.d1Font(10, weight: .semibold).foregroundStyle(theme.accentStrong)
                    .frame(minHeight: 32)
            }
        case .failed(let message):
            action("重试") { refresh() }
            Text(message).d1Font(10).foregroundStyle(theme.ink3).lineLimit(2)
        }
    }

    private func refresh() {
        guard let c = location.coordinate else { location.requestLocation(); return }
        Task { await service.refresh(force: true, coordinate: c.latitude, lng: c.longitude, city: location.city) }
    }

    private func action(_ title: String, _ run: @escaping () -> Void) -> some View {
        Button(title, action: run)
            .d1Font(11, weight: .semibold).foregroundStyle(theme.ink)
            .frame(maxWidth: .infinity, minHeight: 44)
            .overlay(RoundedRectangle(cornerRadius: 22).strokeBorder(theme.line, lineWidth: 1))
    }

    private var icon: String {
        if case .loaded(let snap, _) = service.state {
            switch snap.code {
            case 0: return "sun.max.fill"
            case 1...3: return "cloud.sun.fill"
            case 45, 48: return "cloud.fog.fill"
            case 51...67, 80...82: return "cloud.rain.fill"
            case 71...77, 85, 86: return "cloud.snow.fill"
            case 95...99: return "cloud.bolt.rain.fill"
            default: return "cloud.sun.fill"
            }
        }
        return "cloud.sun.fill"
    }
}
