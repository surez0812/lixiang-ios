import Foundation
import CoreMotion
import Combine

/// 设备朝向（真机：deviceMotion yaw；模拟器无传感器 → 静态「北朝上」）
@MainActor
final class HeadingProvider: ObservableObject {
    @Published private(set) var yawDegrees: Double? = nil
    @Published private(set) var isAvailable = false
    @Published private(set) var needsCalibration = false

    private let motion = CMMotionManager()
    private var referenceAttitude: CMAttitude?

    func start() {
        guard motion.isDeviceMotionAvailable else { isAvailable = false; return }
        isAvailable = true
        motion.deviceMotionUpdateInterval = 1.0 / 30.0
        motion.startDeviceMotionUpdates(to: .main) { [weak self] motionData, _ in
            guard let self, let data = motionData else { return }
            if self.referenceAttitude == nil { self.referenceAttitude = data.attitude.copy() as? CMAttitude }
            guard let reference = self.referenceAttitude else { return }
            let current = data.attitude.copy() as! CMAttitude
            current.multiply(byInverseOf: reference)
            let yaw = current.yaw * 180.0 / .pi
            self.yawDegrees = yaw
            let accuracy = data.magneticField.accuracy
            self.needsCalibration = (accuracy == .uncalibrated)
        }
    }

    func stop() {
        motion.stopDeviceMotionUpdates()
        yawDegrees = nil
    }
}
