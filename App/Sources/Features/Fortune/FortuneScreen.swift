import SwiftUI

/// 每日一签：1450ms 冻结动作时间线；标题在动画组外常驻；结果全显、无结果内部滚动。
/// 动作数学对应 ApprovedFortuneCore.js / AnimationTimeline.json（press 180 / shake 600 / lift 1050 / reveal 1450）。
struct FortuneScreen: View {
    @Environment(\.d1) private var theme
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.horizontalSizeClass) private var hSize
    @Environment(\.verticalSizeClass) private var vSize
    @StateObject private var engine = FortuneEngine()
    @State private var phase: Phase = .idle
    @State private var startedAt: Date?
    @State private var sign: FortuneSign?
    @State private var done = false
    @State private var showReduceNote = false
    @State private var debugFrame: Double? = nil
    var onBack: (() -> Void)? = nil

    enum Phase: Equatable { case idle, running, result }

    private let duration = 1.45

    var body: some View {
        GeometryReader { geo in
            let wide = geo.size.width > geo.size.height && geo.size.width >= 700
            Group {
                if wide { wideLayout(geo) } else { portraitLayout(geo) }
            }
        }
        .background(ScreenBackground())
        .toolbar(.hidden, for: .tabBar)
        .onAppear {
            engine.load()
            #if DEBUG
            let args = ProcessInfo.processInfo.arguments
            if let i = args.firstIndex(of: "-LixiangFortuneFrame"), i + 1 < args.count, let ms = Double(args[i + 1]) {
                debugFrame = ms
                sign = engine.sign(for: Date())
                phase = ms >= 1450 ? .result : .running
                if ms >= 1450 { done = true }
            } else if args.contains("-LixiangFortuneAuto") {
                draw()
            }
            #endif
        }
    }

    // MARK: layouts
    private func portraitLayout(_ geo: GeometryProxy) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 18) {
                header(alignment: .center)
                visualArea(height: min(geo.size.height * 0.34, 300))
                resultArea
                controls
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
        }
    }

    private func wideLayout(_ geo: GeometryProxy) -> some View {
        VStack(spacing: 12) {
            HStack(alignment: .center, spacing: 24) {
                VStack(alignment: .leading, spacing: 10) {
                    header(alignment: .leading)
                    Spacer(minLength: 0)
                    resultArea
                    Spacer(minLength: 0)
                }
                .frame(width: geo.size.width * 0.40, alignment: .leading)
                visualArea(height: min(geo.size.height * 0.60, 460))
                    .frame(maxWidth: .infinity)
            }
            // 底部全宽主按钮 + 右侧跳过（R14 iPad Landscape 稿）
            HStack(spacing: 12) {
                Button(action: draw) {
                    Text(buttonTitle).d1Font(16, weight: .semibold).frame(maxWidth: .infinity, minHeight: 50)
                }
                .buttonStyle(.borderedProminent).tint(theme.accentStrong)
                .disabled(phase == .running || done)
                .opacity(done ? 0.55 : 1)
                Button("跳过动画") { finish() }
                    .d1Font(14).foregroundStyle(theme.ink2)
                    .frame(minWidth: 110, minHeight: 50)
                    .overlay(Capsule().strokeBorder(theme.line))
                    .disabled(phase != .running)
                    .opacity(phase == .running ? 1 : 0.4)
            }
            .frame(maxWidth: 900)
            Text("同一天，保留同一结果。").d1Font(10).foregroundStyle(theme.ink3)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
    }

    private func header(alignment: HorizontalAlignment) -> some View {
        VStack(alignment: alignment, spacing: 6) {
            Text("每日一签")
                .d1Font(12, weight: .semibold)
                .tracking(2)
                .foregroundStyle(theme.ink3)
            Text("给心，留一点空")
                .d1SerifFont(30)
                .foregroundStyle(theme.ink)
                .fixedSize(horizontal: false, vertical: true)
            Text("先安静片刻，再与今天相遇。")
                .d1Font(13)
                .foregroundStyle(theme.ink2)
        }
        .frame(maxWidth: .infinity, alignment: alignment == .leading ? .leading : .center)
        .multilineTextAlignment(alignment == .leading ? .leading : .center)
    }

    private func visualArea(height: CGFloat) -> some View {
        TimelineView(.animation(minimumInterval: 1.0 / 60.0, paused: phase != .running)) { context in
            let elapsed = elapsedMs(context.date)
            ZStack {
                Circle()
                    .fill(theme.accent.opacity(0.10))
                    .frame(width: height * 0.9, height: height * 0.9)
                    .blur(radius: 30)
                    .opacity(glowOpacity(elapsed))

                // 签筒
                Image("fortune-cup")
                    .resizable().scaledToFit()
                    .frame(height: height * 0.55)
                    .offset(y: height * 0.20)
                    .scaleEffect(pressScale(elapsed))

                // 签条升起
                Image("fortune-stick")
                    .resizable().scaledToFit()
                    .frame(height: height * 0.62)
                    .rotationEffect(.degrees(shakeAngle(elapsed)))
                    .offset(y: height * 0.02 - 90 * liftProgress(elapsed))

                // 签纸/结果过渡
                Image("fortune-paper")
                    .resizable().scaledToFit()
                    .frame(height: height * 0.6)
                    .opacity(revealProgress(elapsed))
                    .offset(y: 8 * (1 - revealProgress(elapsed)))
            }
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .opacity(phase == .result ? 0 : max(0, 1 - revealProgress(elapsed)))
            .accessibilityHidden(true)
        }
    }

    private var resultArea: some View {
        Group {
            if phase == .result, let sign {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(spacing: 8) {
                        Text("第\(sign.no)签 · \(sign.level)")
                            .d1Font(12, weight: .semibold)
                            .foregroundStyle(theme.ink2)
                        Spacer(minLength: 0)
                    }
                    Text(sign.title)
                        .d1SerifFont(30)
                        .foregroundStyle(theme.ink)
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(sign.poem, id: \.self) { line in
                            Text(line).d1SerifFont(19).foregroundStyle(theme.ink)
                        }
                    }
                    .padding(.vertical, 4)
                    Text("签意").d1Font(11, weight: .semibold).tracking(1.5).foregroundStyle(theme.ink3)
                    Text(sign.explain).d1Font(15).lineSpacing(6).foregroundStyle(theme.ink)
                    Text("今日可做").d1Font(11, weight: .semibold).tracking(1.5).foregroundStyle(theme.ink3)
                    Text(sign.advice).d1Font(15).lineSpacing(6).foregroundStyle(theme.ink)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(18)
                .background(theme.paper, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay(RoundedRectangle(cornerRadius: 22, style: .continuous).strokeBorder(theme.line, lineWidth: 1))
                .transition(.opacity)
            } else if let error = engine.loadError {
                Text(error).d1Font(14).foregroundStyle(theme.ink2)
            } else {
                Text("同一天，保留同一结果。")
                    .d1Font(13)
                    .foregroundStyle(theme.ink3)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var controls: some View {
        VStack(spacing: 10) {
            Button(action: draw) {
                Text(buttonTitle)
                    .d1Font(16, weight: .semibold)
                    .frame(maxWidth: .infinity, minHeight: 48)
            }
            .buttonStyle(.borderedProminent)
            .tint(theme.accentStrong)
            .disabled(phase == .running || done)
            .opacity(done ? 0.55 : 1)

            if phase == .running {
                Button("跳过动画") { finish() }
                    .d1Font(13)
                    .foregroundStyle(theme.ink2)
                    .frame(minHeight: 44)
            }
            if phase == .result {
                Button("回到待机") { reset() }
                    .d1Font(13)
                    .foregroundStyle(theme.ink2)
                    .frame(minHeight: 44)
            }
            if reduceMotion {
                Text("已开启减少动态效果，直接展示结果。")
                    .d1Font(11)
                    .foregroundStyle(theme.ink3)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var buttonTitle: String {
        switch phase {
        case .idle: return "轻摇，遇见今日一签"
        case .running: return "与今天相遇…"
        case .result: return done ? "今日一签已收好" : "收好今日一签"
        }
    }

    // MARK: actions / math
    private func draw() {
        guard phase != .running else { return }
        if phase == .result { done = true; return }
        sign = engine.sign(for: Date())
        if reduceMotion {
            finish(); return
        }
        startedAt = Date()
        phase = .running
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: UInt64(duration * 1_000_000_000))
            if phase == .running { finish() }
        }
    }

    private func finish() {
        guard let sign = sign ?? engine.sign(for: Date()) else { return }
        self.sign = sign
        withAnimation(.easeOut(duration: 0.18)) {
            phase = .result
            done = true
        }
        startedAt = nil
    }

    private func reset() {
        phase = .idle
        done = false
        startedAt = nil
        withAnimation(.easeOut(duration: 0.15)) { sign = nil }
    }

    private func elapsedMs(_ date: Date) -> Double {
        if let debugFrame { return debugFrame }
        guard let startedAt else { return phase == .result ? 1450 : 0 }
        return min(1450, max(0, date.timeIntervalSince(startedAt) * 1000))
    }
    private func clamp(_ x: Double) -> Double { min(1, max(0, x)) }
    private func ease(_ x: Double) -> Double { let t = clamp(x); return t * t * (3 - 2 * t) }
    private func pressScale(_ ms: Double) -> Double { ms < 180 ? 1 - 0.02 * sin(.pi * ms / 180) : 1 }
    private func shakeAngle(_ ms: Double) -> Double {
        guard ms >= 180, ms < 600 else { return 0 }
        let s = clamp((ms - 180) / 420)
        return 5 * sin(s * 4 * .pi) * (1 - 0.25 * s)
    }
    private func liftProgress(_ ms: Double) -> Double { ease((clamp((ms - 600) / 450))) }
    private func revealProgress(_ ms: Double) -> Double { ease((clamp((ms - 1050) / 400))) }
    private func glowOpacity(_ ms: Double) -> Double {
        guard ms > 600, ms < 1050 else { return 0 }
        return sin(.pi * liftProgress(ms)) * 0.6
    }
}
