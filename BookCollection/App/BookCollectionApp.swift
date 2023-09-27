import SwiftUI
import DependencyInjection
import DataManagment

@main
struct BookCollectionApp: App {
    @Injected var dataManagment: DataManagment
    let container = DependencyInjection.shared
    let dataModelName = "BookCollection"
    
    init() {
        registerDependecies()
    }

    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            MacMainView()
                .environment(\.managedObjectContext, dataManagment.viewContext)
            #elseif os(iOS)
            iOSMainView()
                .environment(\.managedObjectContext, dataManagment.viewContext)
            #endif
        }
    }
    
    func registerDependecies() {
        container.register(DataManagment.self ) { _ in
            return PersistenceController.init(modelName: dataModelName)
        }
    }
}
