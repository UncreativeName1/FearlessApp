
import SwiftUI

struct LearnView: View {
    @Binding var isFullscreenMode: Bool

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                
                VStack {
                    addContentTitle()
                    SlidesList(isFullscreenMode: $isFullscreenMode)
                }
                .padding(.top, 80) /// Add top space from top bar
                .background(Color.secondaryColor)
                .clipped()
            }
            .navigationTitle(Page.learn.name)
            .navigationBarHidden(true)
        }
    }
    
}

extension LearnView {
    
    fileprivate func addContentTitle() -> some View {
        return VStack(alignment: .leading, spacing: 0) {
            /// Category title name
            Text(FLTexts.learnTitle)
                .foregroundColor(.white)
                .font(.system(size: 25, weight: .bold))
            
            /// Category Description and Image
            HStack(alignment: .top, spacing: 5) {
                Text(FLTexts.learnDescription)
                    .foregroundColor(.white)
                    .font(.system(size: 15, weight: .regular))
                
                addContentTitleImage()
            }
        }
        .padding()
        .background(Color.primaryColor)
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    fileprivate func addContentTitleImage() -> some View {
        return ZStack {
            /// Add behind shadow of Category image
            Rectangle()
                .fill(Color.secondaryColor)
                .offset(x: 10, y: -10)

            /// Add Category image
            FLImages.learnTitle.image
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: 90, height: 90)
                .padding(5)
                .background(Color.white)
        }
        .fixedSize()
        .padding(.trailing, 5)
    }
    
}

struct LearnView_Previews: PreviewProvider {
    static var previews: some View {
        LearnView(isFullscreenMode: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}

