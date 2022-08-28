
import SwiftUI
import WebKit

public func openPDF(pdfName: String) -> URLRequest {
    let path = Bundle.main.path(forResource: pdfName, ofType: "pdf")
    let url = URL(fileURLWithPath: path!)
    return URLRequest(url: url)
}

struct WebView: UIViewRepresentable {
    let request: URLRequest
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    
}
