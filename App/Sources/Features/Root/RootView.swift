import SwiftUI
import LixiangCalendarCore

enum Route: Hashable {
    case day(LocalDate)
    case content(String)
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
                                }
                            }
                    }
                case 1:
                    NavigationStack(path: $festivalsPath) {
                        FestivalsScreen()
                            .navigationDestination(for: Route.self) { route in
                                switch route {
                                case .content(let id): ContentScreen(contentID: id)
                                default: EmptyView()
                                }
                            }
                    }
                case 2:
                    NavigationStack { AnniversaryScreen() }
                default:
                    NavigationStack { SettingsScreen() }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) { Color.clear.frame(height: 74) }

            D1TabBar(selected: $selectedTab)
        }
        .background(ScreenBackground())
        .onAppear(perform: applyDebugScreen)
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
        Item(title: "纪念日", outline: "heart", filled: "heart.fill"),
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
                        Text(item.title).font(.system(size: 10, weight: .medium))
                    }
                    .foregroundStyle(selected == index ? theme.accent : theme.ink3)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background {
                        if selected == index {
                            RoundedRectangle(cornerRadius: 14, style: .continuous).fill(theme.soft)
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
