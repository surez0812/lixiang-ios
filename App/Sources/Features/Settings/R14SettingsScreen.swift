import SwiftUI
import LixiangCalendarCore

/// R14 设置（按 settings-phone-light）：红品牌卡 + 外观/历法 + 经典偏好卡 + 下方管理项。
struct R14SettingsScreen: View {
    @EnvironmentObject private var state: AppState
    @Environment(\.d1) private var theme

    private var versionText: String {
        let v = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let b = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "—"
        return "\(v) (build \(b))"
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 16) {
                brandCard
                groupCard {
                    rowDivider
                    HStack { Text("主题").d1Font(15).foregroundStyle(theme.ink); Spacer(); Menu {
                        ForEach(AppTheme.allCases) { t in Button(t.title) { state.theme = t } }
                    } label: {
                        HStack(spacing: 4) { Text(state.theme.title).d1Font(14).foregroundStyle(theme.ink3); Image(systemName: "chevron.down").font(.system(size: 10)) }
                    }
                    }
                    divider
                    Toggle(isOn: $state.showTaoCalendar) { Text("显示道历").d1Font(15).foregroundStyle(theme.ink) }.tint(theme.accentStrong)
                    divider
                    Toggle(isOn: $state.showFotoCalendar) { Text("显示佛历").d1Font(15).foregroundStyle(theme.ink) }.tint(theme.accentStrong)
                } header: { Text("外观与历法显示") }
                classicsCard
                groupCard {
                    NavigationLink { GlossaryScreen() } label: { linkRow("术语解释", "全部白话术语") }.buttonStyle(.plain)
                    divider
                    NavigationLink { AboutScreen() } label: { linkRow("关于历象 · 隐私 · 条款 · 支持", "") }.buttonStyle(.plain)
                    divider
                    linkRow("版本", versionText)
                } header: { Text("关于") }
                Text("无需账号 · 数据只在本机 · 传统历法民俗参考，不构成宗教劝诱或预测。")
                    .d1Font(11).foregroundStyle(theme.ink3).lineSpacing(4)
            }
            .padding(.horizontal, 18)
            .padding(.top, 10)
            .padding(.bottom, 140)
        }
        .background(ScreenBackground())
    }

    private var brandCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("历象 · 把日子过成风景").d1Font(10, weight: .semibold).tracking(1.6).foregroundStyle(.white.opacity(0.8))
            Text("让历象，更像你").d1SerifFont(30).foregroundStyle(.white)
            Text("熟悉的颜色，喜欢的经典。").d1Font(13).foregroundStyle(.white.opacity(0.85))
            Text("每日一句 · 唤心").d1SerifFont(20).foregroundStyle(.white).padding(.top, 4)
            Text("四类经典，选择你的日常阅读。").d1Font(12).foregroundStyle(.white.opacity(0.8))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(colors: [Color.r14RedDeep, Color.r14Red], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 24, style: .continuous)
        )
    }

    private func groupCard<Content: View>(@ViewBuilder content: () -> Content, @ViewBuilder header: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            header().d1Font(11, weight: .semibold).foregroundStyle(theme.ink3)
            VStack(alignment: .leading, spacing: 0) { content() }
                .padding(.horizontal, 16)
                .padding(.vertical, 6)
                .background(theme.paper, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).strokeBorder(theme.line, lineWidth: 1))
        }
    }

    private var divider: some View { Divider().overlay(theme.line) }
    private var rowDivider: some View { EmptyView() }

    private func linkRow(_ title: String, _ detail: String) -> some View {
        HStack {
            Text(title).d1Font(15).foregroundStyle(theme.ink)
            Spacer()
            if !detail.isEmpty { Text(detail).d1Font(12).foregroundStyle(theme.ink3) }
            Image(systemName: "chevron.right").font(.system(size: 11, weight: .semibold)).foregroundStyle(theme.ink3)
        }
        .frame(minHeight: 48)
    }

    private var classicsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("每日一句 · 经典偏好").d1Font(11, weight: .semibold).foregroundStyle(theme.ink3)
            Text("今天，想读哪一种？").d1SerifFont(26).foregroundStyle(theme.ink)
            ForEach(DailyClassic.allCases) { c in
                classicRow(c)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(theme.paper, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).strokeBorder(theme.line, lineWidth: 1))
    }

    private func classicRow(_ c: DailyClassic) -> some View {
        let selected = state.dailyClassic == c.rawValue
        return Button {
            state.dailyClassic = c.rawValue
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: iconName(c))
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(selected ? theme.accentStrong : theme.ink3)
                    .frame(width: 30, height: 30)
                    .padding(4)
                    .background((selected ? theme.soft : theme.bg1), in: Circle())
                VStack(alignment: .leading, spacing: 3) {
                    Text(c.title).d1Font(16, weight: .semibold).foregroundStyle(theme.ink)
                    Text(blurb(c)).d1Font(12).foregroundStyle(theme.ink3)
                }
                Spacer(minLength: 0)
                if selected { Image(systemName: "checkmark.circle.fill").foregroundStyle(theme.accentStrong) }
            }
            .padding(12)
            .background(selected ? theme.soft : .clear, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 16, style: .continuous).strokeBorder(selected ? theme.accentStrong : theme.line, lineWidth: selected ? 1.5 : 1))
        }
        .buttonStyle(.plain)
        .disabled(!DailyClassicsStore.shared.hasContent(c))
        .opacity(DailyClassicsStore.shared.hasContent(c) ? 1 : 0.5)
    }

    private func iconName(_ c: DailyClassic) -> String {
        switch c {
        case .dao: return "drop"
        case .buddhist: return "circle.dotted"
        case .confucian: return "book.closed"
        case .quanshan: return "hand.raised"
        }
    }
    private func blurb(_ c: DailyClassic) -> String {
        switch c {
        case .dao: return "自然与从容，体会日常的分寸。"
        case .buddhist: return "观照与觉察，留一刻安静。"
        case .confucian: return "修身与相处，把道理放进生活。"
        case .quanshan: return "善念与善行，从身边小事开始。"
        }
    }
}
