import SwiftUI

// Native counterpart of the design prototype; not wired into the shipping app.
enum LixiangThemeMode: String, CaseIterable, Identifiable {
    case system = "跟随系统"
    case light = "亮色"
    case dark = "暗色"
    var id: String { rawValue }
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
}

struct ThemeSelectionRow: View {
    @Binding var selection: LixiangThemeMode
    var body: some View {
        Menu {
            Picker("主题", selection: $selection) {
                ForEach(LixiangThemeMode.allCases) { mode in
                    Text(mode.rawValue).tag(mode)
                }
            }
        } label: {
            HStack {
                Text("主题").foregroundStyle(.primary)
                Spacer()
                Text(selection.rawValue).foregroundStyle(.secondary)
                Image(systemName: "chevron.down").font(.caption).foregroundStyle(.secondary)
            }
            .font(.body)
            .frame(minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("主题，\(selection.rawValue)")
    }
}
