
import SwiftUI

@main
struct FearlessApp: App {

    @StateObject var viewRouter = ViewRouter()
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView(viewRouter: viewRouter)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
