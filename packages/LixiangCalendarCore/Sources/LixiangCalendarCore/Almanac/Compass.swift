import Foundation

/// 五神（P2 罗盘 UI 用；数据来自 AlmanacDay.positions）
public enum Deity: String, CaseIterable, Codable, Sendable, Identifiable {
    case xi, fu, cai, yangGui, yinGui
    public var id: String { rawValue }
    public var title: String {
        switch self {
        case .xi: return "喜神"
        case .fu: return "福神"
        case .cai: return "财神"
        case .yangGui: return "阳贵"
        case .yinGui: return "阴贵"
        }
    }
    public var symbol: String {
        switch self {
        case .xi: return "heart"
        case .fu: return "sun.max"
        case .cai: return "yensign.circle"
        case .yangGui: return "arrow.up.circle"
        case .yinGui: return "arrow.down.circle"
        }
    }
    /// 各神可能方位（D1 UI-NOTES §1.2 / 实测集合）
    public var allowedDirections: Set<CompassDirection> {
        switch self {
        case .xi: return [.northeast, .northwest, .southwest, .southeast, .south]
        case .fu: return [.northeast, .north, .southwest, .northwest, .southeast]
        case .cai: return [.north, .east, .south, .northeast, .southwest]
        case .yangGui, .yinGui: return Set(CompassDirection.allCases)
        }
    }
}

public struct CompassEntry: Identifiable, Hashable, Sendable {
    public var deity: Deity
    public var direction: CompassDirection
    public var id: String { deity.rawValue }
}

public struct CompassLayout: Hashable, Sendable {
    /// 本日方位正常的神（画针）
    public var present: [CompassEntry]
    /// 缺位的神（图例显示「本日不在此位」，盘上不画针）
    public var missing: [Deity]
    /// 煞方（仅四正；可能 nil）
    public var sha: CompassDirection?
}

public enum CompassBuilder {
    /// hidden 仅供 DEBUG 缺位演示/防御性校验（数据异常时不画错角度）
    public static func layout(for day: AlmanacDay, hidden: Set<Deity> = []) -> CompassLayout {
        let pairs: [(Deity, CompassDirection)] = [
            (.xi, day.positions.xi), (.fu, day.positions.fu), (.cai, day.positions.cai),
            (.yangGui, day.positions.yangGui), (.yinGui, day.positions.yinGui)
        ]
        var present: [CompassEntry] = []
        var missing: [Deity] = []
        for (deity, direction) in pairs {
            let allowed = deity.allowedDirections.contains(direction)
            if hidden.contains(deity) || !allowed {
                missing.append(deity)
            } else {
                present.append(CompassEntry(deity: deity, direction: direction))
            }
        }
        let sha = day.sha.flatMap { direction -> CompassDirection? in
            // 煞方仅四正
            [.north, .south, .east, .west].contains(direction) ? direction : nil
        }
        return CompassLayout(present: present, missing: missing, sha: sha)
    }
}
