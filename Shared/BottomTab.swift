
import SwiftUI

struct BottomTab: View {
    @StateObject var viewRouter: ViewRouter
    
    let assignedPage: Page
    let systemIconName, tabName: String
     
    var body: some View {
        Image(systemIconName)
            .renderingMode(.template)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .font(.system(.title))
        
    }
 }
