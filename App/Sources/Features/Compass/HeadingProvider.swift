import Foundation
import CoreLocation
import Combine

/// 罗盘基准：真北优先（CLLocationManager.trueHeading）→ 磁北（badge 标注）→ 静态；不伪造角度。
@MainActor
final class HeadingProvider: NSObject, ObservableObject {
    enum Basis: Equatable { case trueNorth(Double), magnetic(Double), needsCalibration, unavailable }

    @Published private(set) var basis: Basis = .unavailable
    @Published private(set) var authorized = false

    private let manager = CLLocationManager()

    var isAvailable: Bool {
        if case .trueNorth = basis { return true }
        if case .magnetic = basis { return true }
        return false
    }
    var isMagneticOnly: Bool { if case .magnetic = basis { return true }; return false }
    var needsCalibration: Bool { basis == .needsCalibration }
    /// 盘面反向旋转角度（仅真北/磁北有效）
    var angle: Double? {
        switch basis {
        case .trueNorth(let a), .magnetic(let a): return a
        default: return nil
        }
    }
    var statusText: String {
        switch basis {
        case .trueNorth: return "基准：真北（设备朝向已接入）"
        case .magnetic: return "基准：磁北（未授权真北，使用磁北）"
        case .needsCalibration: return "罗盘需校准：请按「8」字晃动设备"
        case .unavailable: return "北朝上（无传感器/未授权）"
        }
    }

    func start() {
        guard CLLocationManager.headingAvailable() else { basis = .unavailable; return }
        manager.delegate = self
        manager.headingFilter = 1
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        manager.startUpdatingHeading()
    }

    func stop() {
        manager.stopUpdatingHeading()
    }

    private func apply(accuracy: Double, trueHeading: Double, magneticHeading: Double) {
        guard accuracy >= 0 else { basis = .needsCalibration; return }
        if authorized, trueHeading >= 0 {
            basis = .trueNorth(trueHeading)
        } else if magneticHeading >= 0 {
            basis = .magnetic(magneticHeading)
        } else {
            basis = .unavailable
        }
    }
}

extension HeadingProvider: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            self.authorized = (status == .authorizedWhenInUse || status == .authorizedAlways)
            if !self.authorized, case .trueNorth = self.basis {
                self.basis = .needsCalibration
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let accuracy = newHeading.headingAccuracy
        let trueHeading = newHeading.trueHeading
        let magneticHeading = newHeading.magneticHeading
        Task { @MainActor in self.apply(accuracy: accuracy, trueHeading: trueHeading, magneticHeading: magneticHeading) }
    }
}
