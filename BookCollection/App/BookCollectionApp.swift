import SwiftUI

@main
struct BookCollectionApp: App {
    let persistenceController = PersistenceControllerImpl.shared

    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            MacMainView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
            #elseif os(iOS)
            iOSMainView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
            #endif
        }
    }
}
