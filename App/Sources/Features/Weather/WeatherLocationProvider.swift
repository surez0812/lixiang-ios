import CoreLocation
import Foundation

/// 天气定位：只在用户动作后请求；拒绝/受限不阻断核心；从系统设置返回重新读取授权。
@MainActor
final class WeatherLocationProvider: NSObject, ObservableObject, CLLocationManagerDelegate {
    enum Authorization: Equatable { case notDetermined, denied, restricted, authorized }

    @Published private(set) var authorization: Authorization = .notDetermined
    @Published private(set) var coordinate: CLLocationCoordinate2D?
    @Published private(set) var city: String?
    @Published private(set) var locating = false
    @Published private(set) var locationError: String?

    private let manager = CLLocationManager()

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
        refreshAuthorization()
    }

    func refreshAuthorization() {
        authorization = Self.map(manager.authorizationStatus)
        if authorization == .notDetermined {
            coordinate = nil
            city = nil
        }
    }

    /// 仅由显式用户动作调用。
    func requestLocation() {
        refreshAuthorization()
        switch authorization {
        case .notDetermined:
            locating = true
            locationError = nil
            manager.requestWhenInUseAuthorization()
        case .authorized:
            locating = true
            locationError = nil
            manager.requestLocation()
        case .denied, .restricted:
            locationError = "定位权限未开启，可到系统设置中允许。"
        }
    }

    private static func map(_ status: CLAuthorizationStatus) -> Authorization {
        switch status {
        case .notDetermined: return .notDetermined
        case .restricted: return .restricted
        case .denied: return .denied
        case .authorizedWhenInUse, .authorizedAlways: return .authorized
        @unknown default: return .notDetermined
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            self.authorization = Self.map(status)
            if self.authorization == .authorized, self.locating {
                self.manager.requestLocation()
            } else if self.authorization != .authorized {
                self.locating = false
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let loc = locations.last else { return }
        Task { @MainActor in
            self.coordinate = loc.coordinate
            self.locating = false
            self.locationError = nil
            CLGeocoder().reverseGeocodeLocation(loc) { [weak self] marks, _ in
                Task { @MainActor in
                    guard let self else { return }
                    let locality = marks?.first?.locality ?? marks?.first?.administrativeArea
                    self.city = locality
                }
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            self.locating = false
            self.locationError = "定位失败，请重试或检查系统设置。"
        }
    }
}
