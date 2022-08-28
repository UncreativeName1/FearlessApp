
import SwiftUI
import Introspect

struct SlideDetail: View {
    @Binding var isFullscreenMode: Bool /// If value is true, top and bottom views will be disappear otherwise not.

    let PDFName: String
    var body: some View {
        WebView(request: openPDF(pdfName: PDFName))
            .onAppear(perform: {
                self.isFullscreenMode = true
            })
            .onDisappear(perform: {
                self.isFullscreenMode = false
            })
            .introspectNavigationController { (controller) in
                DispatchQueue.main.async {
                    controller.setNavigationBarHidden(false, animated: true)
                }
            }
    }
}

