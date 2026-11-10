import SwiftUI
import WebKit

/// 只渲染已校验的本地 HTML：禁用 JS、阻止外部导航（F7 技术契约）
struct WebViewReader: UIViewRepresentable {
    var html: String

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
        context.coordinator.lastHTML = html
        webView.loadHTMLString(html, baseURL: nil)
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if context.coordinator.lastHTML != html {
            context.coordinator.lastHTML = html
            webView.loadHTMLString(html, baseURL: nil)
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
