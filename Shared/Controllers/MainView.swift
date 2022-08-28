
import SwiftUI

struct MainView: View {
    @Binding var showMenu: Bool
    @Binding var showAccount: Bool
    @Binding var isFullscreenMode: Bool
    @Binding var page: Page

    fileprivate func addAppLogo() -> some View {
        return VStack {
            HStack {
                Group {
                    Spacer()
                    fearless()
                    Spacer()
                }
                .frame(maxHeight: FLSizes.topLogo)
                .padding(.top, (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0))
            }
            .padding(.vertical, 5)

            Divider()
                .frame(height: 5)
                .background(Color.primaryColor)
        }
        .background(Color.white)
        .hidden(self.isFullscreenMode)
        .edgesIgnoringSafeArea(.top)
    }
    
    var body: some View {
        ZStack (alignment: .top) {
            switch self.page {
            case .learn:
                LearnView(isFullscreenMode: $isFullscreenMode)
            case .practice:
                PracticeView()
//            default:
//                Text("Perfect")
//                    .offset(y: 100)// This is also too down(?), make sure to offset
            }
            
            self.addAppLogo()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(showMenu: .constant(false), showAccount: .constant(false), isFullscreenMode: .constant(false), page: .constant(.learn))
    }
}

