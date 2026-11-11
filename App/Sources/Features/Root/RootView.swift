import SwiftUI
import LixiangCalendarCore

enum Route: Hashable {
    case day(LocalDate)
    case content(String)
    case compass(LocalDate)
    case sourceLicense(String)
    case notFound(String)
    case glossary
    case explain(String)
    case about
    case privacy(String)
}

struct RootView: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme
    @State private var selectedTab = 0
    @State private var monthPath = NavigationPath()
    @State private var festivalsPath = NavigationPath()

    var body: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0:
                    NavigationStack(path: $monthPath) {
                        MonthScreen()
                            .navigationDestination(for: Route.self) { route in
                                switch route {
                                case .day(let date): DayDetailScreen(date: date)
                                case .content(let id): ContentScreen(contentID: id)
                                case .compass(let date): CompassScreen(date: date)
                                case .sourceLicense(let slug): SourceLicenseScreen(slug: slug, entry: nil, item: ContentFixtures.all.first { $0.id == slug })
                                case .notFound(let slug): NotFoundScreen(slug: slug)
                                case .glossary: GlossaryScreen()
                                case .explain(let term): ExplainPageView(page: state.plainLanguage.pages.first { $0.term == term } ?? ExplainPage(term: term, title: term, what: "", means: "", how: "", en: ""))
                                case .about: AboutScreen()
                                case .privacy(let resource): PrivacyScreen(title: resource == "privacy" ? "隐私政策" : (resource == "user-terms" ? "用户条款" : "支持"), resource: resource)
                                }
                            }
                    }
                case 1:
                    NavigationStack(path: $festivalsPath) {
                        FestivalsScreen(onOpenMonth: { selectedTab = 0 },
                                        onOpenAnniversary: { selectedTab = 2 })
                            .navigationDestination(for: Route.self) { route in
                                switch route {
                                case .content(let id): ContentScreen(contentID: id)
                                case .sourceLicense(let slug): SourceLicenseScreen(slug: slug, entry: nil, item: ContentFixtures.all.first { $0.id == slug })
                                case .notFound(let slug): NotFoundScreen(slug: slug)
                                case .glossary: GlossaryScreen()
                                case .explain(let term): ExplainPageView(page: state.plainLanguage.pages.first { $0.term == term } ?? ExplainPage(term: term, title: term, what: "", means: "", how: "", en: ""))
                                case .about: AboutScreen()
                                case .privacy(let resource): PrivacyScreen(title: resource == "privacy" ? "隐私政策" : (resource == "user-terms" ? "用户条款" : "支持"), resource: resource)
                                default: EmptyView()
                                }
                            }
                    }
                case 2:
                    NavigationStack { CountdownScreen() }
                default:
                    NavigationStack { SettingsScreen() }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 96) }

            D1TabBar(selected: $selectedTab)
        }
        .background(ScreenBackground())
        .onOpenURL { handleDeepLink($0) }
        .onAppear(perform: applyDebugScreen)
    }

    private func handleDeepLink(_ url: URL) {
        guard url.scheme == "lixiang", url.host == "ceremony" else { return }
        let slug = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        selectedTab = 1
        if ContentFixtures.all.contains(where: { $0.id == slug }) {
            // 未解锁/已解锁由 ContentScreen 按 UTC+8 判定；分享文案按状态脱敏
            festivalsPath = NavigationPath([Route.content(slug)])
        } else {
            festivalsPath = NavigationPath([Route.notFound(slug.isEmpty ? "unknown" : slug)])
        }
    }

    private func applyDebugScreen() {
        #if DEBUG
        let screen = state.debug.screen
        if screen == "festivals" { selectedTab = 1 }
        if screen == "anniversary" { selectedTab = 2 }
        if screen == "settings" { selectedTab = 3 }
        if screen == "day" {
            selectedTab = 0
            monthPath = NavigationPath([Route.day(state.today)])
        }
        if screen == "about" {
            selectedTab = 0
            monthPath = NavigationPath([Route.about])
        }
        if screen == "privacy" {
            selectedTab = 0
            monthPath = NavigationPath([Route.about, Route.privacy("privacy")])
        }
        if screen == "glossary" {
            selectedTab = 0
            monthPath = NavigationPath([Route.glossary])
        }
        if screen == "explain" {
            selectedTab = 0
            monthPath = NavigationPath([Route.glossary, Route.explain("zhishen")])
        }
        if screen == "compass" || screen == "compass-a11y" {
            selectedTab = 0
            monthPath = NavigationPath([Route.compass(state.today)])
        }
        if screen == "deeplink", let raw = state.debug.deepLink, let url = URL(string: raw) {
            handleDeepLink(url)
        }
        if screen == "source-license" {
            selectedTab = 1
            festivalsPath = NavigationPath([Route.content(state.debug.contentID ?? "xiezao"),
                                            Route.sourceLicense(state.debug.contentID ?? "xiezao")])
        }
        if screen == "locked" || screen == "content" {
            selectedTab = 1
            festivalsPath = NavigationPath([Route.content(state.debug.contentID ?? "xiezao")])
        }
        #endif
    }
}

/// D1 风格 tab bar：未激活 outline + ink3，激活实心/暖橘；线重一致（Lead 2026-11-11 验收）
struct D1TabBar: View {
    @Environment(\.d1) private var theme
    @Binding var selected: Int

    private struct Item {
        let title: String
        let outline: String
        let filled: String
    }

    private let items: [Item] = [
        Item(title: "月历", outline: "calendar", filled: "calendar"),
        Item(title: "民俗", outline: "book", filled: "book.fill"),
        Item(title: "倒计日", outline: "heart", filled: "heart.fill"),
        Item(title: "设置", outline: "slider.horizontal.3", filled: "slider.horizontal.3")
    ]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.offset) { index, item in
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) { selected = index }
                } label: {
                    VStack(spacing: 3) {
                        Image(systemName: selected == index ? item.filled : item.outline)
                            .font(.system(size: 18, weight: selected == index ? .semibold : .regular))
                            .symbolRenderingMode(.monochrome)
                        Text(item.title).d1Font(10, weight: .medium)
                    }
                    .foregroundStyle(selected == index ? theme.accent : theme.ink3)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background {
                        if selected == index {
                            Capsule().fill(LinearGradient(colors: [theme.accent.opacity(0.22), theme.red.opacity(0.16)], startPoint: .topLeading, endPoint: .bottomTrailing))
                        }
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(item.title)
                .accessibilityAddTraits(selected == index ? [.isSelected] : [])
            }
        }
        .padding(4)
        .background(theme.card, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(theme.line, lineWidth: 1))
        .padding(.horizontal, 16)
        .padding(.bottom, 6)
    }
}
