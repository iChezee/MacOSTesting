import SwiftUI
import DataManagment

@main
struct BookCollectionApp: App {
    let persistenceController: PersistenceController
    
    init() {
        persistenceController = DataManagment(modelName: "BookCollection").wrappedValue
    }

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
