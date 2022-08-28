
import SwiftUI

extension View {
    
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
    
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
    
    func addBorder(padding: CGFloat = 10, color: Color = .primaryColor, radius: CGFloat = 10) -> some View {
        self
        .padding(padding)
        .background(color)
        .cornerRadius(radius)
    }
}
