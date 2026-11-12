import Foundation

public struct ContentIndexRow: Identifiable, Hashable, Sendable {
    public var id: String { "\(contentID)-\(regionID ?? "default")-\(date.iso)" }
    public var contentID: String
    public var regionID: String?
    public var regionLabel: String?
    public var title: String
    public var teaser: String
    public var date: LocalDate
    public var state: ContentState
    public var days: Int?
    /// solarTerm|traditional|ritual|tao|foto；nil=未知（回退传统）
    public var kind: String? = nil
}

/// 节俗索引：已过可回看 / 今日 / 即将到来 三组，按日期排序（FRD F5 + designer 复核）
public enum ContentIndexBuilder {
    public static func build(
        resolutions: [ContentResolution],
        now: LocalDate,
        pastWindowDays: Int = 366
    ) -> (past: [ContentIndexRow], today: [ContentIndexRow], upcoming: [ContentIndexRow]) {
        var past: [ContentIndexRow] = []
        var today: [ContentIndexRow] = []
        var upcoming: [ContentIndexRow] = []

        for resolution in resolutions {
            for region in resolution.regions {
                guard let dates = resolution.unlocks[region.id], !dates.isEmpty else { continue }
                let sorted = dates.sorted()
                let regionLabel = resolution.item.regionalDates == nil ? nil : region.label
                func row(_ date: LocalDate, _ state: ContentState, _ days: Int?) -> ContentIndexRow {
                    ContentIndexRow(contentID: resolution.item.id, regionID: region.id,
                                    regionLabel: regionLabel, title: resolution.item.title,
                                    teaser: resolution.item.teaser, date: date,
                                    state: state, days: days)
                }
                if sorted.contains(now) {
                    today.append(row(now, .unlocked, 0))
                    if let next = sorted.first(where: { $0 > now }) {
                        upcoming.append(row(next, .locked, now.daysBetween(next)))
                    }
                } else if let last = sorted.last(where: { $0 < now }), now.daysBetween(last) <= pastWindowDays {
                    past.append(row(last, .past, last.daysBetween(now)))
                    if let next = sorted.first(where: { $0 > now }) {
                        upcoming.append(row(next, .locked, now.daysBetween(next)))
                    }
                } else if let next = sorted.first(where: { $0 > now }) {
                    upcoming.append(row(next, .locked, now.daysBetween(next)))
                }
            }
        }
        return (
            past.sorted { $0.date > $1.date },
            today.sorted { $0.date < $1.date },
            upcoming.sorted { $0.date < $1.date }
        )
    }
}
