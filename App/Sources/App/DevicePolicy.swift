import SwiftUI
import UIKit

/// R14 设备/画布政策：iPhone 仅竖屏；iPad 横竖；Duo 六姿态（Tabletop 复用 OpenPortrait）；Splitview 排除。
enum R14Canvas: String, CaseIterable {
    case phonePortrait = "phone-portrait"
    case iPadPortrait = "ipad-portrait"
    case iPadLandscape = "ipad-landscape"
    case duoClosedPortrait = "duo-closed-portrait"
    case duoClosedLandscape = "duo-closed-landscape"
    case duoTent = "duo-tent"
    case duoOpenPortrait = "duo-open-portrait"
    case duoOpenLandscape = "duo-open-landscape"
    case duoTabletop = "duo-tabletop"

    /// Tabletop 与 OpenPortrait 共享布局/状态
    var sharedLayout: R14Canvas {
        self == .duoTabletop ? .duoOpenPortrait : self
    }
    var isWide: Bool {
        switch sharedLayout {
        case .iPadLandscape, .duoOpenLandscape, .duoClosedLandscape, .duoTent: return true
        default: return false
        }
    }
}

enum R14DevicePolicy {
    static let splitViewExcluded = true   // v1.0 不实现 Split View/Stage Manager 特化

    static func canvas(size: CGSize, idiom: UIUserInterfaceIdiom, isDuo: Bool = false) -> R14Canvas {
        let short = min(size.width, size.height)
        let landscape = size.width > size.height
        if isDuo || short >= 600 && short <= 700 && (abs(size.width-669)<2 || abs(size.height-669)<2 || abs(size.width-678)<2) {
            // 设计画布识别：Duo 669/678 组
            if size.width == 669 && size.height == 951 { return .duoOpenPortrait }
            if size.width == 951 && size.height == 669 { return .duoOpenLandscape }
            if size.width == 678 && size.height == 466 { return .duoTent }
            if size.width == 466 && size.height == 678 { return .duoClosedPortrait }
            if size.width == 678 { return .duoClosedLandscape }
            return size.width > size.height ? .duoOpenLandscape : .duoOpenPortrait
        }
        switch idiom {
        case .pad:
            return landscape ? .iPadLandscape : .iPadPortrait
        default:
            return .phonePortrait   // 普通 iPhone 仅竖屏
        }
    }
}

/// iPhone 仅 portrait；iPad 全方向。Duo/Split 特化在 R14DevicePolicy 内声明排除。
final class R14AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad { return .all }
        return .portrait
    }
}
