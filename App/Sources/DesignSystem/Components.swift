import SwiftUI

struct D1Card<Content: View>: View {
    @Environment(\.d1) private var theme
    var padding: CGFloat = 16
    @ViewBuilder var content: Content
    var body: some View {
        content
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.card, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).strokeBorder(theme.line, lineWidth: 1))
    }
}

struct D1Chip: View {
    @Environment(\.d1) private var theme
    enum Tone { case accent, jade, neutral, strong }
    var text: String
    var tone: Tone = .neutral
    var body: some View {
        Text(text)
            .font(.system(size: 11, weight: .semibold))
            .foregroundStyle(foreground)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(background, in: Capsule())
    }
    private var foreground: Color {
        switch tone {
        case .accent, .jade, .strong: return theme.onAccent
        case .neutral: return theme.ink2
        }
    }
    private var background: Color {
        switch tone {
        case .accent: return theme.accent
        case .jade: return theme.jade
        case .strong: return theme.accentStrong
        case .neutral: return theme.soft
        }
    }
}

struct SectionLabel: View {
    @Environment(\.d1) private var theme
    var text: String
    var body: some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .tracking(1.6)
            .foregroundStyle(theme.ink3)
    }
}

struct D1Divider: View {
    @Environment(\.d1) private var theme
    var body: some View { Rectangle().fill(theme.line).frame(height: 1) }
}

struct ScreenBackground: View {
    @Environment(\.d1) private var theme
    var body: some View { theme.bg.ignoresSafeArea() }
}
