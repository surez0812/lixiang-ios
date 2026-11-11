import SwiftUI
import LixiangCalendarCore

struct SettingsScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                group("外观") {
                    NavigationLink {
                        ThemeSelectScreen()
                    } label: {
                        settingRow("主题", value: state.theme.title, chevron: true)
                    }
                    .buttonStyle(.plain)
                    Toggle(isOn: $state.showVernacular) {
                        Text("黄历白话").d1Font(12).foregroundStyle(theme.ink)
                    }
                    .tint(theme.accent)
                }
                group("提醒") {
                    settingRow("倒计日提醒", value: "在倒计日页管理", chevron: false)
                }
                group("数据与关于") {
                    settingRow("数据来源与许可", value: "LunarSwift 1.1.9 · MIT", chevron: false)
                    settingRow("隐私政策", value: "P2 接入", chevron: false)
                    settingRow("版本", value: "1.0 (P1)", chevron: false)
                }
                Text("无需账号 · 数据只在本机")
                    .d1Font(10).foregroundStyle(theme.ink3)
                    .padding(.top, 4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(ScreenBackground())
        .navigationTitle("设置")
    }

    private func group<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionLabel(text: title)
            D1Card(padding: 4) {
                VStack(spacing: 0) { content() }
            }
        }
    }

    private func settingRow(_ title: String, value: String, chevron: Bool) -> some View {
        HStack {
            Text(title).d1Font(12).foregroundStyle(theme.ink)
            Spacer()
            Text(value).d1Font(11).foregroundStyle(theme.ink3)
            if chevron { Image(systemName: "chevron.right").d1Font(10).foregroundStyle(theme.ink3) }
        }
        .padding(.horizontal, 12).padding(.vertical, 12)
    }
}

struct ThemeSelectScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(AppTheme.allCases) { option in
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) { state.setTheme(option) }
                } label: {
                    HStack {
                        Text(option == .system ? "跟随系统（默认）" : option.title)
                            .d1Font(13).foregroundStyle(theme.ink)
                        Spacer()
                        if state.theme == option {
                            Image(systemName: "checkmark").d1Font(12, weight: .semibold)
                                .foregroundStyle(theme.accentStrong)
                        }
                    }
                    .padding(.horizontal, 16).padding(.vertical, 14)
                }
                .buttonStyle(.plain)
                D1Divider().padding(.leading, 16)
            }
            Text("「跟随系统」随 iOS 外观自动切换；手动选择后保持所选。")
                .d1Font(10).foregroundStyle(theme.ink3)
                .padding(16)
            Spacer()
        }
        .background(ScreenBackground())
        .navigationTitle("主题")
        .navigationBarTitleDisplayMode(.inline)
    }
}
