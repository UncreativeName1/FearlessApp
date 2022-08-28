
import SwiftUI

struct AccountInfo: View {
    var body: some View {
        VStack {
            Spacer()
            Text("Show Account Info Here")
                .padding()
                .foregroundColor(.red)
                .font(.system(size: 30, weight: .light, design: .serif))
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 32/255, green: 32/255, blue: 32/255))
        .edgesIgnoringSafeArea(.all)
    }
}

struct AccountInfo_Previews: PreviewProvider {
    static var previews: some View {
        AccountInfo()
    }
}
