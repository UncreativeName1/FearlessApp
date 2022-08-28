
import Foundation
import SwiftUI

struct RecordRow: View {
    var todo: Todo
    var index:Int
        
    var body: some View {
        ZStack {
            HStack {
                FLImages.speaker.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 45, height: 45)
                    .padding(5)
                    .background(Color.white)
                
                VStack(alignment: .leading, spacing: 3.0) {
                    Group {
                        Text("Recording \(index)")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.titleColor)
                        
                        HStack() {
                            Text(FLFormatter.MonthDayYearFormatter.string(from: todo.created.defaultValue()))
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.titleColor)
                            Spacer()
                            
                            Text(todo.duration.toTime.defaultValue())
                                .font(.system(size: 13, weight: .regular))
                                .foregroundColor(.titleColor)
                                .frame(alignment:.trailing)
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.white)
            }
            .fixedSize(horizontal: false, vertical: true)
            .addBorder()

            /// Add navigation button for go to the next screen
            NavigationLink(destination: RecordingDetailView(todo: todo, index: index)) {
                EmptyView()
            }.buttonStyle(PlainButtonStyle())
            .opacity(0)
        }
    }
    
}

struct RecordRow_Previews: PreviewProvider {
    static var previews: some View {
        RecordRow(todo: Todo(), index: 0)
            .previewLayout(.sizeThatFits)
    }
}
