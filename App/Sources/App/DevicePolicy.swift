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

    /// Duo 屏幕点尺寸（外屏 466×678 / 内屏 669×951，随姿态互换）；用于设备识别（不依赖 UIDevice）
    /// 旋转前 window 尺寸仍是竖屏，用 nativeBounds（Duo 外屏 1398×2034 / 内屏 2007×2853）兜底识别。
    static func isDuoNative(screen: UIScreen) -> Bool {
        let b = screen.nativeBounds.size
        let pairs: [(CGFloat, CGFloat)] = [(1398, 2034), (2007, 2853)]
        for (a, c) in pairs {
            if (abs(b.width - a) <= 2 && abs(b.height - c) <= 2) || (abs(b.width - c) <= 2 && abs(b.height - a) <= 2) { return true }
        }
        return UIDevice.current.model.localizedCaseInsensitiveContains("Duo")
    }

    static func isDuo(size: CGSize) -> Bool {
        let w = size.width, h = size.height
        let pairs: [(CGFloat, CGFloat)] = [(466, 678), (669, 951)]
        for (a, b) in pairs {
            if (abs(w - a) <= 10 && abs(h - b) <= 10) || (abs(w - b) <= 10 && abs(h - a) <= 10) { return true }
        }
        return false
    }

    /// Open Landscape 右侧 rail：Duo 横屏且短边 ≥600（951×669）；Closed Landscape 678×466 仍用底部栏
    static func isDuoOpenLandscape(size: CGSize) -> Bool {
        isDuo(size: size) && size.width > size.height && min(size.width, size.height) >= 600
    }

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
            if isDuo {
                if size.width == 669 && size.height == 951 { return .duoOpenPortrait }
                if size.width == 951 && size.height == 669 { return .duoOpenLandscape }
                if size.width == 678 && size.height == 466 { return .duoTent }
                if size.width == 466 && size.height == 678 { return .duoClosedPortrait }
                return size.width > size.height ? .duoOpenLandscape : .duoOpenPortrait
            }
            return .phonePortrait   // 普通 iPhone 仅竖屏
        }
    }
}

/// iPhone 仅 portrait；iPad 全方向；Duo 放行横竖（按屏幕尺寸识别，不误伤普通 iPhone）。
final class R14AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad { return .all }
        let size = window?.windowScene?.screen.bounds.size ?? UIScreen.main.bounds.size
        let duo = R14DevicePolicy.isDuo(size: size) || R14DevicePolicy.isDuoNative(screen: window?.windowScene?.screen ?? .main)
        #if DEBUG
        print("LXDUO orientationMask size=\(size) native=\(UIScreen.main.nativeBounds.size) duo=\(duo)")
        #endif
        if duo { return .allButUpsideDown }
        return .portrait
    }
}
