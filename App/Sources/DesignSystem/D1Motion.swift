import SwiftUI
import UIKit

/// M-1 Reduce Motion：系统开启「减弱动态效果」时统一关闭动画（含 tab 切换/展开/D1-rich 微动效）。
enum D1Motion {
    static var reduceMotion: Bool { UIAccessibility.isReduceMotionEnabled }
    static func animation(_ animation: Animation, reduceMotion: Bool? = nil) -> Animation? {
        (reduceMotion ?? Self.reduceMotion) ? nil : animation
    }
    static func withAnimation(_ animation: Animation = .easeInOut(duration: 0.2), _ body: () -> Void) {
        SwiftUI.withAnimation(Self.animation(animation), body)
    }
}
