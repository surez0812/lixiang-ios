import SwiftUI
import WebKit

/// 只渲染已校验的本地 HTML：禁用 JS、阻止外部导航（F7 技术契约）
struct WebViewReader: UIViewRepresentable {
    var html: String
    var isDark: Bool = false
    var backgroundHex: String = "#FBF5EC"
    var inkHex: String = "#3A3028"
    var ink2Hex: String = "#5C544A"

    /// 不依赖 prefers-color-scheme：按 D1 token 显式注入纸底/墨字，避免 light 主题被渲染成黑底白字
    private var themedHTML: String {
        let paper = isDark ? "#241C16" : backgroundHex
        let ink = isDark ? "#F3E8DA" : inkHex
        let ink2 = isDark ? "#C7B5A2" : ink2Hex
        let style = """
        <style id="d1-theme">
        html, body { background: \(paper) !important; color-scheme: \(isDark ? "dark" : "light") !important; }
        body { color: \(ink2) !important; }
        h1, h2, h3, strong { color: \(ink) !important; }
        p, li, figcaption, footer { color: \(ink2) !important; }
        .img { background: \(isDark ? "rgba(232,168,134,.14)" : "rgba(222,155,120,.14)") !important; color: \(isDark ? "#9A8774" : "#8A7462") !important; }
        a { color: \(isDark ? "#E8A886" : "#C97B5A") !important; }
        </style>
        """
        return html.replacingOccurrences(of: "</head>", with: style + "</head>")
    }

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences.allowsContentJavaScript = false
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.navigationDelegate = context.coordinator
        webView.isOpaque = true
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
        webView.scrollView.isScrollEnabled = false
        webView.overrideUserInterfaceStyle = isDark ? .dark : .light
        context.coordinator.lastHTML = html
        webView.loadHTMLString(themedHTML, baseURL: nil)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        webView.overrideUserInterfaceStyle = isDark ? .dark : .light
        if context.coordinator.lastHTML != html {
            context.coordinator.lastHTML = html
            webView.loadHTMLString(themedHTML, baseURL: nil)
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }

    final class Coordinator: NSObject, WKNavigationDelegate {
        var lastHTML: String?
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction,
                     decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .other, navigationAction.request.url == nil {
                decisionHandler(.allow); return
            }
            decisionHandler(navigationAction.navigationType == .other ? .allow : .cancel)
        }
    }
}
