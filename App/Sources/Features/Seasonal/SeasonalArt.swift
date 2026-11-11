import SwiftUI
import LixiangCalendarCore

struct SolarTermArt: Decodable, Identifiable {
    var slug: String
    var zh: String
    var date: String
    var season: String
    var id: String { slug }
}

/// 24 节气插画：按当前节气取图（明/暗自适应），本地资源 + 内存缓存
@MainActor
enum SeasonalArtStore {
    static let shared = SeasonalArtStoreImpl()
}

@MainActor
final class SeasonalArtStoreImpl {
    private(set) var index: [SolarTermArt] = []
    private var nameToSlug: [String: String] = [:]
    private var cache = NSCache<NSString, UIImage>()

    init() { load() }

    private func load() {
        guard let url = Bundle.main.url(forResource: "index", withExtension: "json")
                ?? Bundle.main.url(forResource: "index", withExtension: "json", subdirectory: "SeasonalArt"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([SolarTermArt].self, from: data) else { return }
        index = decoded
        for e in decoded { nameToSlug[e.zh] = e.slug; nameToSlug[e.slug] = e.slug }
    }

    func slug(forChineseTerm name: String) -> String? { nameToSlug[name] }
    func entry(slug: String) -> SolarTermArt? { index.first { $0.slug == slug } }

    /// 当前节气：当日是节气则直接取；否则向前回看 16 天取最近节气
    func currentTerm(for date: LocalDate, engine: any CalendarEngine) -> String? {
        var d = date
        for _ in 0..<17 {
            if let term = engine.almanac(d, hour: 12).solarTerm, !term.isEmpty { return term }
            d = d.adding(days: -1)
        }
        return nil
    }

    func image(slug: String, dark: Bool) -> UIImage? {
        let key = "\(slug)-\(dark ? "dark" : "light")" as NSString
        if let hit = cache.object(forKey: key) { return hit }
        guard let url = Bundle.main.url(forResource: "term-\(slug)-\(dark ? "dark" : "light")", withExtension: "webp")
                ?? Bundle.main.url(forResource: "term-\(slug)-\(dark ? "dark" : "light")", withExtension: "webp", subdirectory: "SeasonalArt"),
              let image = UIImage(contentsOfFile: url.path) else { return nil }
        cache.setObject(image, forKey: key)
        return image
    }
}

struct SolarTermArtView: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    @Environment(\.colorScheme) private var colorScheme
    var date: LocalDate
    var maxHeight: CGFloat
    var showLabel: Bool = true

    private var term: String? { SeasonalArtStore.shared.currentTerm(for: date, engine: state.engine) }
    private var image: UIImage? {
        guard let term, let slug = SeasonalArtStore.shared.slug(forChineseTerm: term) else { return nil }
        return SeasonalArtStore.shared.image(slug: slug, dark: colorScheme == .dark)
    }

    var body: some View {
        Group {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: maxHeight)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .overlay(alignment: .bottomLeading) {
                        if showLabel { Text(term ?? "")
                            .d1Font(11, weight: .semibold)
                            .foregroundStyle(theme.onAccent)
                            .padding(.horizontal, 10).padding(.vertical, 5)
                            .background(theme.accent.opacity(0.85), in: Capsule())
                            .padding(8)
                        }
                    }
                    .accessibilityLabel("节气插画：\(term ?? "")")
            } else {
                LinearGradient(colors: [theme.soft, theme.bg], startPoint: .top, endPoint: .bottom)
                    .frame(height: maxHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 22))
                    .accessibilityHidden(true)
            }
        }
    }
}
