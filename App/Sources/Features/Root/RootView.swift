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
        rootBody
            .overlay(alignment: .top) {
                #if DEBUG
                Text("DEBUG BUILD · screen=\(state.debug.screen ?? "-") · terms=\(state.debug.expandTerms ? "1":"0") · classic=\(state.dailyClassic)")
                    .d1Font(8, weight: .bold).foregroundStyle(.white)
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(.red, in: Capsule()).padding(.top, 2)
                #endif
            }
    }

    private var rootBody: some View {
        ZStack(alignment: .bottom) {
            Group {
                switch selectedTab {
                case 0:
                    NavigationStack(path: $monthPath) {
                        MonthScreen()
                            .navigationDestination(for: Route.self) { route in
                                switch route {
                                case .day(let date): DayPagerScreen(initial: date)
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
                Button { D1Motion.withAnimation(.easeInOut(duration: 0.15)) { selected = index } } label: {
                    VStack(spacing: 3) {
                        if selected == index {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(theme.accent)
                                .frame(width: 34, height: 30)
                                .overlay(Image(systemName: item.filled)
                                    .d1Font(15, weight: .semibold)
                                    .foregroundStyle(theme.cream))
                        } else {
                            Image(systemName: item.outline)
                                .d1Font(18, weight: .regular)
                                .foregroundStyle(theme.ink3)
                                .frame(height: 30)
                        }
                        Text(item.title)
                            .d1Font(10, weight: .medium)
                            .foregroundStyle(selected == index ? theme.ink : theme.ink3)
                    }
                    .frame(maxWidth: .infinity, minHeight: 52)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel(item.title)
                .accessibilityAddTraits(selected == index ? [.isSelected] : [])
            }
        }
        .frame(height: 60)
        .background(theme.paper, in: Capsule())
        .overlay(Capsule().strokeBorder(theme.line.opacity(0.7), lineWidth: 0.8))
        .shadow(color: .black.opacity(0.16), radius: 20, y: 10)
        .padding(.horizontal, 18)
        .padding(.bottom, 8)
    }
}
