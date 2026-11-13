import SwiftUI

// Standalone design reference. Not integrated into or built with the shipping app.
struct FortuneSign: Codable, Identifiable {
    let id: String
    let no: Int
    let level: String
    let title: String
    let poem: [String]
    let explain: String
    let advice: String
    static let preview = FortuneSign(id: "lixiang-036", no: 36, level: "上上", title: "静水流深", poem: ["静水藏深意", "清风入远林", "从容行一事", "日久见初心"], explain: "不必急于证明自己。把一件小事做好，进展会慢慢清晰。", advice: "留出二十分钟，完成一件搁置的小事。")
}

struct FortuneAnimationView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var startedAt: Date?
    @State private var running = false
    @State private var complete = false
    let sign: FortuneSign
    var onSave: (FortuneSign) -> Void = { _ in }
    private let ink = Color(red: 0.21, green: 0.16, blue: 0.12)
    private let red = Color(red: 0.64, green: 0.24, blue: 0.15)

    var body: some View {
        GeometryReader { proxy in
            let canvasScale = min(proxy.size.width / 375, proxy.size.height / 930)
            ZStack(alignment: .topLeading) {
                // Screen reference space is 375x930; real system chrome belongs to the app host.
                HStack {
                    Spacer()
                    Button("跳过动画") { finish() }.disabled(complete)
                }.frame(width: 335, height: 38).position(x: 187.5, y: 69)
                TimelineView(.animation(minimumInterval: 1.0 / 60, paused: !running)) { context in
                    let ms = startedAt.map { max(0, context.date.timeIntervalSince($0) * 1000) } ?? 0
                    let reveal = complete ? 1 : smooth((ms - 1050) / 400)
                    let lift = smooth((ms - 600) / 450) * -90
                    let shake = ms >= 180 && ms < 600 ? 5 * sin((ms - 180) / 420 * 4 * .pi) * (1 - 0.25 * ((ms - 180) / 420)) : 0
                    ZStack(alignment: .topLeading) {
                        VStack(spacing: 8) {
                            Text("给心，留一点空").font(.caption).foregroundStyle(.secondary)
                            Text("每日一签").font(.system(size: 30, design: .serif))
                            Text("先安静片刻，再与今天相遇。").font(.caption)
                        }.frame(width: 335).position(x: 187.5, y: 160).opacity(1 - reveal)
                        // Stage local (0,0) maps to screen reference (37.5,220).
                        objects(lift: lift)
                            .rotationEffect(.degrees(shake), anchor: UnitPoint(x: 0.5, y: 0.88))
                            .scaleEffect(ms < 180 && running ? 1 - 0.02 * sin(ms / 180 * .pi) : 1, anchor: UnitPoint(x: 0.5, y: 0.88))
                            .opacity(1 - reveal)
                            .position(x: 187.5, y: 435)
                        // Result local (0,0) maps to screen reference (17,120), not stage space.
                        resultCard.opacity(reveal).offset(y: 15 * (1 - reveal))
                            .position(x: 187.5, y: 415)
                    }.frame(width: 375, height: 930)
                }
                Button(complete ? "收好今日一签" : "轻摇，遇见今日一签") {
                    if complete { onSave(sign) } else { begin() }
                }
                .buttonStyle(.borderedProminent).tint(red).disabled(running)
                .frame(width: 319, height: 50).position(x: 187.5, y: 769)
                Text("同一天，保留同一结果。\n签语是生活提示，不预言结果。")
                    .font(.caption2).multilineTextAlignment(.center).foregroundStyle(.secondary)
                    .frame(width: 319, height: 48).position(x: 187.5, y: 827)
            }
            .foregroundStyle(ink)
            .frame(width: 375, height: 930)
            .background(Color(red: 1, green: 0.973, blue: 0.925))
            .scaleEffect(canvasScale, anchor: .topLeading)
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .topLeading)
        }
        .task(id: running) {
            guard running else { return }
            do { try await Task.sleep(nanoseconds: 1_450_000_000) } catch { return }
            finish()
        }
        .onDisappear { running = false }
    }

    private func objects(lift: Double) -> some View {
        ZStack(alignment: .topLeading) {
            Image("fortune-cup").resizable().frame(width: 103, height: 230).position(x: 150.5, y: 280)
            ZStack(alignment: .topLeading) {
                ForEach(0..<4) { index in
                    let height = [205.0, 217, 209, 198][index]
                    Image("fortune-stick").resizable()
                        .frame(width: 9, height: height)
                        .rotationEffect(.degrees([-2.0, -1, 1, 2][index]), anchor: UnitPoint(x: 0.5, y: 0.9))
                        .position(x: [136.5, 145.5, 161.5, 170.5][index], y: 320 - height / 2)
                }
                Image("fortune-stick").resizable().frame(width: 10, height: 225)
                    .position(x: 150, y: 207.5 + lift)
            }.frame(width: 300, height: 430)
                .mask(alignment: .top) { Rectangle().frame(width: 300, height: 192) }
            Image("fortune-cup").resizable().frame(width: 103, height: 230)
                .mask(FrontCupMask(topFraction: 0.12))
                .position(x: 150.5, y: 280)
        }.frame(width: 300, height: 430)
    }

    private var resultCard: some View {
        ZStack {
            Image("fortune-paper").resizable().frame(width: 341, height: 590)
            VStack(spacing: 15) {
                Text("第\(sign.no)签 · \(sign.level)").font(.caption)
                Text(sign.title).font(.system(size: 26, design: .serif)).foregroundStyle(red)
                Text(sign.poem.joined(separator: "\n"))
                    .font(.system(size: 21, design: .serif)).lineSpacing(8)
                    .multilineTextAlignment(.center)
                Divider()
                VStack(alignment: .leading, spacing: 8) {
                    Text("签意").bold().foregroundStyle(red)
                    Text(sign.explain)
                    Text("今日可做").bold().foregroundStyle(red)
                    Text(sign.advice)
                }.font(.caption).lineSpacing(5)
            }.padding(.horizontal, 44).padding(.top, 50).padding(.bottom, 45)
        }.accessibilityElement(children: .combine)
    }

    private func begin() {
        guard !running else { return }
        if reduceMotion {
            withAnimation(.easeOut(duration: 0.15)) { complete = true }
        } else {
            complete = false
            startedAt = Date()
            running = true
        }
    }
    private func finish() {
        running = false
        complete = true
    }
    private func smooth(_ value: Double) -> Double {
        let x = min(1, max(0, value))
        return x * x * (3 - 2 * x)
    }
}

private struct FrontCupMask: Shape {
    let topFraction: CGFloat
    func path(in rect: CGRect) -> Path {
        Path(CGRect(x: 0, y: rect.height * topFraction, width: rect.width, height: rect.height * (1 - topFraction)))
    }
}
