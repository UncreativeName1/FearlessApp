
import SwiftUI

struct TabBar: View {
    @StateObject var viewRouter: ViewRouter
    @Binding var showMenu: Bool

    var body: some View {
       
        HStack(spacing: 0) {
            ForEach(Page.allCases, id: \.rawValue) { page in
                BottomTab(viewRouter: viewRouter, assignedPage: page, systemIconName: page.imageName, tabName: page.name)
                    .disabled(showMenu ? true : false)
                    .frame(maxWidth: .infinity, maxHeight: FLSizes.tabBar)
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                    .foregroundColor(viewRouter.currentPage == page ? Color.primaryColor : Color.secondaryColor)
                    .background(viewRouter.currentPage == page ? Color.secondaryColor : Color.clear)
                    .cornerRadius(10)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 5))
                    .padding(.vertical)
                    .contentShape(Rectangle()) //Tap: Whole area selectable
                    .onTapGesture {
                        viewRouter.currentPage = page
                    }
            }
        }
        .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0)
        .background(Color.primaryColor)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar(viewRouter: ViewRouter(), showMenu: .constant(false))
            .previewLayout(.sizeThatFits)
    }
}
