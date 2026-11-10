import SwiftUI
import LixiangCalendarCore

struct SourceLicenseScreen: View {
    @Environment(\.d1) private var theme
    let slug: String
    let entry: ManifestEntry?
    let item: ContentItem?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text("来源与许可").font(D1Theme.serif(26)).foregroundStyle(theme.ink)
                D1Card {
                    VStack(alignment: .leading, spacing: 6) {
                        row("内容版本", entry?.contentVersion ?? "—")
                        row("更新于", entry?.updatedAt.prefix(10).description ?? "—")
                        row("正文许可", item?.license ?? "—")
                    }
                }
                D1Card {
                    VStack(alignment: .leading, spacing: 8) {
                        SectionLabel(text: "条目来源")
                        if let sources = item?.sources, !sources.isEmpty {
                            ForEach(sources, id: \.title) { source in
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("\(source.kind) · \(source.title)").font(.system(size: 12)).foregroundStyle(theme.ink)
                                    if let note = source.note {
                                        Text(note).font(.system(size: 10)).foregroundStyle(theme.ink3)
                                    }
                                }
                            }
                        } else {
                            Text("来源信息待内容团队补充（P2 真内容接入）").font(.system(size: 11)).foregroundStyle(theme.ink3)
                        }
                    }
                }
                D1Card {
                    VStack(alignment: .leading, spacing: 6) {
                        SectionLabel(text: "说明")
                        Text("内容为原创整理；古籍只引公有领域文本并注明版本。不复刻原文，图片须登记许可，无来源不明图片。")
                            .font(.system(size: 11)).foregroundStyle(theme.ink2)
                        Text("反馈与更正：support@zhaoyao.xin")
                            .font(.system(size: 10)).foregroundStyle(theme.ink3)
                    }
                }
            }
            .padding(.horizontal, 16).padding(.vertical, 12)
        }
        .background(ScreenBackground())
        .navigationTitle("来源与许可")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func row(_ title: String, _ value: String) -> some View {
        HStack {
            Text(title).font(.system(size: 11)).foregroundStyle(theme.ink3)
            Spacer()
            Text(value).font(.system(size: 11)).foregroundStyle(theme.ink)
        }
    }
}
