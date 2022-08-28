
import SwiftUI

struct SlidesRow: View {
    var slide: Slides
        
    var body: some View {
        HStack {
            slide.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 45, height: 45)
                .padding(5)
                .background(Color.white)

            VStack(alignment: .leading, spacing: 3.0) {
                Group {
                    Text(slide.name)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.titleColor)
                    Text(slide.description)
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(.titleColor)
                }

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.white)
        }
        .addBorder()
        .padding(.horizontal)
    }
}

struct SlidesRow_Previews: PreviewProvider {
    static var previews: some View {
        SlidesRow(slide: Slides.empty)
            .previewLayout(.sizeThatFits)
    }
}
