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
    /// 共享设备身份：Duo 由 nativeBounds（外屏 1398×2034 / 内屏 2007×2853）或 model 判定；
    /// 姿态（开合/横竖）只由内容/scene 几何决定，身份不参与姿态判断。
    @MainActor
    enum R14DeviceIdentity {
        static var isDuo: Bool {
            let b = UIScreen.main.nativeBounds.size
            let pairs: [(CGFloat, CGFloat)] = [(1398, 2034), (2007, 2853)]
            for (a, c) in pairs {
                if (abs(b.width - a) <= 2 && abs(b.height - c) <= 2) || (abs(b.width - c) <= 2 && abs(b.height - a) <= 2) { return true }
            }
            return UIDevice.current.model.localizedCaseInsensitiveContains("Duo")
        }
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
        let landscape = size.width > size.height
        let shortSide = min(size.width, size.height)
        if isDuo {
            // 姿态只由当前内容/scene 几何决定；设备身份只回答“是不是 Duo”。
            // 内屏可用短边 ≥600（867×635）→ Open；外屏闭合（606×432）→ Closed。
            if landscape { return shortSide >= 600 ? .duoOpenLandscape : .duoClosedLandscape }
            return shortSide >= 600 ? .duoOpenPortrait : .duoClosedPortrait
        }
        switch idiom {
        case .pad:
            return landscape ? .iPadLandscape : .iPadPortrait
        default:
            return .phonePortrait   // 普通 iPhone 仅竖屏
        }
    }
}

/// iPhone 仅 portrait；iPad 全方向；Duo 放行横竖（按屏幕尺寸识别，不误伤普通 iPhone）。
final class R14AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .pad { return .all }
        let size = window?.windowScene?.screen.bounds.size ?? UIScreen.main.bounds.size
        let duo = R14DevicePolicy.isDuo(size: size) || R14DevicePolicy.R14DeviceIdentity.isDuo
        #if DEBUG
        print("LXDUO orientationMask size=\(size) native=\(UIScreen.main.nativeBounds.size) duo=\(duo)")
        #endif
        if duo { return .allButUpsideDown }
        return .portrait
    }
}
