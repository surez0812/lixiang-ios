import SwiftUI

struct ShareSheetView: View {
    let data: Data?
    var body: some View {
        VStack(spacing: 12) {
            if let data {
                ShareLink(item: ShareableJPEG(data: data),
                          preview: SharePreview("历象 · 今日", image: Image(uiImage: UIImage(data: data) ?? UIImage()))) {
                    Label("分享今日卡", systemImage: "square.and.arrow.up")
                }
                Text("1080×1350 JPEG · 含 App QR").d1Font(10).foregroundStyle(.secondary)
            } else { Text("生成中…") }
        }
        .padding(24)
        .presentationDetents([.height(200)])
    }
}
