
import SwiftUI

let numberOfSamples: Int = 30

struct ContentView: View {
    @State var showMenu = false
    @State var showAccount = false
    
    @State var isFullscreenMode = false
    @StateObject var viewRouter: ViewRouter
    
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width < -100 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }

        return GeometryReader { geometry in
            ZStack(alignment: self.showMenu ? .leading : .trailing) {
                /// Add main view
                MainView(showMenu: self.$showMenu, showAccount: self.$showAccount, isFullscreenMode: self.$isFullscreenMode, page: self.$viewRouter.currentPage)
                    .offset(x: self.showMenu ? geometry.size.width/2 : 0)
                    .offset(x: self.showAccount ? 0 - 2*geometry.size.width/3 : 0)
                    .padding(.bottom, self.isFullscreenMode ? 0 : 120) // Add bottom space for display full learn view
                    .background(Color.secondaryColor)
                
                if self.showMenu {
                    MenuView()
                        .frame(width: geometry.size.width/2)
                        .transition(.move(edge: .leading))
                } else if self.showAccount {
                    AccountInfo()
                        .frame(width: 2*geometry.size.width/3)
                        .transition(.move(edge: .trailing))
                }
            }
            .gesture(drag)
            
            /// Add Tab bar items
            VStack {
                Spacer()
                TabBar(viewRouter: self.viewRouter, showMenu: self.$showMenu)
            }
            .hidden(self.isFullscreenMode)
            .edgesIgnoringSafeArea(.bottom)
        }
        .edgesIgnoringSafeArea(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewRouter: ViewRouter())

    }
}

