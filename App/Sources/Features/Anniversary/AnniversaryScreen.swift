import SwiftUI

struct AnniversaryScreen: View {
    @Environment(\.d1) private var theme
    var body: some View {
        VStack(spacing: 12) {
            Spacer()
            Image(systemName: "heart.text.square").font(.system(size: 40)).foregroundStyle(theme.accent)
            Text("还没有纪念日").font(D1Theme.serif(22)).foregroundStyle(theme.ink)
            Text("记一个日子，之后会在这一天提醒你\n（创建流程 P2）")
                .font(.system(size: 11)).foregroundStyle(theme.ink3).multilineTextAlignment(.center)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(ScreenBackground())
        .navigationTitle("纪念日")
    }
}
