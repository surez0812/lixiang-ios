import SwiftUI
import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins
import UniformTypeIdentifiers
import LixiangCalendarCore

/// 分享卡：1080×1350 JPEG（360×450 @3x）+ App QR 220px
struct ShareableJPEG: Transferable {
    let data: Data
    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .jpeg) { $0.data }
    }
}

enum ShareCardRenderer {
    @MainActor
    static func qrImage(text: String, size: CGFloat = 220) -> UIImage? {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(text.utf8)
        filter.correctionLevel = "M"
        guard let ci = filter.outputImage else { return nil }
        let scale = size / ci.extent.width
        let scaled = ci.transformed(by: CGAffineTransform(scaleX: scale, y: scale))
        let context = CIContext()
        guard let cg = context.createCGImage(scaled, from: scaled.extent) else { return nil }
        return UIImage(cgImage: cg)
    }

    @MainActor
    static func image(date: LocalDate, almanac: AlmanacDay, quote: DaodejingQuote?, theme: D1Theme) -> UIImage? {
        let view = ShareCardView(date: date, almanac: almanac, quote: quote, theme: theme)
        let renderer = ImageRenderer(content: view)
        renderer.scale = 3
        return renderer.uiImage
    }

    @MainActor
    static func jpegData(date: LocalDate, almanac: AlmanacDay, quote: DaodejingQuote?, theme: D1Theme) -> Data? {
        image(date: date, almanac: almanac, quote: quote, theme: theme)?.jpegData(compressionQuality: 0.9)
    }
}

struct ShareCardView: View {
    let date: LocalDate
    let almanac: AlmanacDay
    let quote: DaodejingQuote?
    let theme: D1Theme
    private let size = CGSize(width: 360, height: 450)

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("历象").d1SerifFont(20, weight: .semibold).foregroundStyle(theme.accentStrong)
                Spacer()
                Text("\(date.month)月\(date.day)日 · \(almanac.lunar.monthDayText)")
                    .d1Font(11).foregroundStyle(theme.ink3)
            }
            Text(quote?.quote ?? "道可道，非常道")
                .d1Kaiti(26).foregroundStyle(theme.ink).lineLimit(3)
            Text(quote?.zh ?? "")
                .d1Font(11).foregroundStyle(theme.ink2).lineLimit(3)
            Text("《道德经》第\(quote?.chapter ?? 1)章 · 王弼本（公版）")
                .d1Font(9).foregroundStyle(theme.ink3)
            Spacer()
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("历象 · 中国历法").d1Font(10, weight: .semibold).foregroundStyle(theme.ink2)
                    Text("App Store 搜索「历象」").d1Font(9).foregroundStyle(theme.ink3)
                }
                Spacer()
                if let qr = ShareCardRenderer.qrImage(text: "https://apps.apple.com/app/id6833252283", size: 110) {
                    Image(uiImage: qr).interpolation(.none).resizable().frame(width: 110, height: 110)
                }
            }
        }
        .padding(22)
        .frame(width: size.width, height: size.height, alignment: .topLeading)
        .background(LinearGradient(colors: [theme.bg1, theme.bg2, theme.bg3], startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}
