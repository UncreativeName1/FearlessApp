
import SwiftUI

struct fearless: View {
    var body: some View {
        Image("fearless")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200)
    }
}

struct fearless_Previews: PreviewProvider {
    static var previews: some View {
        fearless()
    }
}
