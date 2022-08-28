
import SwiftUI

struct TagView: View {
    @State var tag: FLTag
    @Binding var selectedTag: FLTag?

    var body: some View {
        HStack {
            Button(action: {
                selectedTag = tag
            }, label: {
                switch tag.type {
                case .tag:
                    if let text = tag.text?.trim, !text.isEmpty {
                        self.addTitle(text: text)
                    }
                    if (tag.type != .title) {
                        self.addImage()
                    }
                    
                case .title:
                    if let text = tag.text?.trim, !text.isEmpty {
                        self.addTitle(text: text)
                    }
                    
                default:
                    self.addImage()
                }
                
            })
        }
        .padding(10)
        .background((tag.type == .title) ? Color.white : tag.backgroundColor)
        .cornerRadius(10)
        .disabled(tag.type == .title)
    }
    
    fileprivate func addTitle(text: String) -> some View {
        Text(text)
            .foregroundColor((tag.type == .title) ? .black : tag.textColor)
            .font((tag.type == .title) ? tag.font.weight(.medium) : tag.font)
            .lineLimit(1)
    }
    
    fileprivate func addImage() -> some View {
        Image(systemName: (tag.actionType == .add) ? FLImages.plusCircle.name : FLImages.minusCircle.name)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxHeight: 25)
            .foregroundColor(.white)
    }
}

struct TagView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TagView(tag: FLTag(text: "Test", type: .tag, actionType: .add), selectedTag: .constant(FLTag()))
            
            TagView(tag: FLTag(text: "Test", type: .tag, actionType: .remove), selectedTag: .constant(FLTag()))
            
            TagView(tag: FLTag(type: .addNew), selectedTag: .constant(FLTag()))
            
            TagView(tag: FLTag(text: "Test", type: .title), selectedTag: .constant(FLTag()))
        }
        .background(Color.black)
        .previewLayout(.sizeThatFits)

    }
}

