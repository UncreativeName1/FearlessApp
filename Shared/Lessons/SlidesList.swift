
import SwiftUI

struct SlidesList: View {
    @Binding var isFullscreenMode: Bool
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(slides) { slide in
                    NavigationLink(destination: SlideDetail(isFullscreenMode: $isFullscreenMode, PDFName: slide.pdfName)) {
                        SlidesRow(slide: slide)
                    }
                }
            }
        }
    }
}

struct SlidesList_Previews: PreviewProvider {
    static var previews: some View {
        SlidesList(isFullscreenMode: .constant(false))
    }
}


