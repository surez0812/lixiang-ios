import SwiftUI

// Standalone adaptive host for the approved R7 artwork and timeline.
// Navigation and system bars belong to the application's native containers.
struct FortuneAdaptiveDemoView: View {
    let sign: FortuneSign
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var startedAt: Date?
    @State private var running = false
    @State private var complete = false
    private let accent = Color(red: 0.64, green: 0.24, blue: 0.15)

    var body: some View {
        GeometryReader { proxy in
            let horizontal = proxy.size.width >= 600 && proxy.size.width > proxy.size.height
            if horizontal {
                HStack(spacing: 24) {
                    heading.frame(maxWidth: 260)
                    artworkAndActions
                }
            } else {
                VStack(spacing: 12) { heading; artworkAndActions }
            }
        }
        .padding(20)
        .task(id: running) {
            guard running else { return }
            do { try await Task.sleep(nanoseconds: 1_450_000_000) } catch { return }
            finish()
        }
        .onChange(of: reduceMotion) { _, value in if value && running { finish() } }
        .onDisappear { running = false }
    }

    private var heading: some View {
        VStack(spacing: 8) {
            Text("给心，留一点空").font(.caption).foregroundStyle(.secondary)
            Text("每日一签").font(.system(size: 30, design: .serif))
            Text("先安静片刻，再与今天相遇。").font(.subheadline).foregroundStyle(.secondary)
        }.multilineTextAlignment(.center).frame(maxWidth: .infinity)
    }

    private var artworkAndActions: some View {
        VStack(spacing: 14) {
            GeometryReader { bounds in
                TimelineView(.animation(minimumInterval: 1 / 60, paused: !running)) { context in
                    let ms = startedAt.map { max(0, context.date.timeIntervalSince($0) * 1000) } ?? 0
                    let reveal = complete ? 1 : smooth((ms - 1050) / 400)
                    let lift = smooth((ms - 600) / 450) * -90
                    let shake = ms >= 180 && ms < 600 ? 5 * sin((ms - 180) / 420 * 4 * .pi) * (1 - 0.25 * ((ms - 180) / 420)) : 0
                    let scale = min(bounds.size.width / 300, bounds.size.height / 430)
                    ZStack {
                        approvedFigure(lift: lift)
                            .rotationEffect(.degrees(shake), anchor: UnitPoint(x: 0.5, y: 0.88))
                            .scaleEffect(ms < 180 && running ? 1 - 0.02 * sin(ms / 180 * .pi) : 1, anchor: UnitPoint(x: 0.5, y: 0.88))
                            .scaleEffect(scale)
                            .frame(width: bounds.size.width, height: bounds.size.height)
                            .opacity(1 - reveal)
                        resultReader.opacity(reveal).offset(y: 15 * (1 - reveal))
                            .allowsHitTesting(reveal > 0.99)
                    }.frame(width: bounds.size.width, height: bounds.size.height).clipped()
                }
            }
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 10) { drawButton; skipButton }
                VStack(spacing: 10) { drawButton; skipButton }
            }
            Text("同一天，保留同一结果。").font(.caption2).foregroundStyle(.secondary)
        }
    }

    private var drawButton: some View {
        Button(complete ? "收好今日一签" : "轻摇，遇见今日一签") { if !complete { begin() } }
            .buttonStyle(.borderedProminent).tint(accent).disabled(running)
            .frame(minHeight: 48).frame(maxWidth: .infinity)
    }
    private var skipButton: some View {
        Button("跳过动画") { finish() }.buttonStyle(.bordered).frame(minHeight: 48)
    }
    private var resultReader: some View {
        ScrollView {
            VStack(spacing: 16) {
                Text("第\(sign.no)签 · \(sign.level)").font(.caption)
                Text(sign.title).font(.system(size: 25, design: .serif)).foregroundStyle(accent)
                Text(sign.poem.joined(separator: "\n")).font(.system(size: 21, design: .serif)).lineSpacing(8)
                Divider()
                VStack(alignment: .leading, spacing: 12) {
                    Text("签意").bold().foregroundStyle(accent)
                    Text(sign.explain)
                    Text("今日可做").bold().foregroundStyle(accent)
                    Text(sign.advice)
                }.font(.system(size: 14)).lineSpacing(6).frame(maxWidth: .infinity, alignment: .leading)
            }.padding(30).frame(maxWidth: 380)
        }
        .background { Image("fortune-paper").resizable() }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .frame(maxWidth: 380)
    }
    private func approvedFigure(lift: Double) -> some View {
        ZStack(alignment: .topLeading) {
            Image("fortune-cup").resizable().frame(width: 103, height: 230).position(x: 150.5, y: 280)
            ZStack(alignment: .topLeading) {
                ForEach(0..<4) { index in
                    let height = [205.0, 217, 209, 198][index]
                    Image("fortune-stick").resizable().frame(width: 9, height: height)
                        .rotationEffect(.degrees([-2.0, -1, 1, 2][index]), anchor: UnitPoint(x: 0.5, y: 0.9))
                        .position(x: [136.5, 145.5, 161.5, 170.5][index], y: 320 - height / 2)
                }
                Image("fortune-stick").resizable().frame(width: 10, height: 225).position(x: 150, y: 207.5 + lift)
            }.frame(width: 300, height: 430)
                .mask(alignment: .top) { Rectangle().frame(width: 300, height: 192) }
            Image("fortune-cup").resizable().frame(width: 103, height: 230)
                .mask(alignment: .bottom) { Rectangle().frame(height: 230 * 0.88) }
                .position(x: 150.5, y: 280)
            Ellipse().fill(RadialGradient(colors: [.yellow.opacity(0.5), .clear], center: .center, startRadius: 0, endRadius: 80))
                .frame(width: 26, height: 160).position(x: 148, y: 140).blur(radius: 4)
                .opacity(0.6 * sin(.pi * min(1, max(0, -lift / 90))))
        }.frame(width: 300, height: 430)
    }
    private func begin() {
        guard !running else { return }
        if reduceMotion { withAnimation(.easeOut(duration: 0.15)) { complete = true } }
        else { complete = false; startedAt = Date(); running = true }
    }
    private func finish() { running = false; complete = true }
    private func smooth(_ value: Double) -> Double { let x = min(1, max(0, value)); return x * x * (3 - 2 * x) }
}
