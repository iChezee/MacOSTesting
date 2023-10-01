import SwiftUI
import DependencyInjection
import DataManagment

// TODO: Move to SwiftData
@main
struct BookCollectionApp: App {
    let container = DependencyInjection.shared
    @Injected var dataManagment: DataManagment
    @ObservedObject var selectedStateModel = SelectedViewState()

    let dataModelName = "BookCollection"
    
    init() {
        registerDependecies()
    }

    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            MacMainView()
            #elseif os(iOS)
            iOSMainView()
            #endif
        }
        .environment(\.managedObjectContext, dataManagment.viewContext)
        .environmentObject(selectedStateModel)
    }
    
    func registerDependecies() {
        container.register(DataManagment.self ) { _ in
            return PersistenceController.init(modelName: dataModelName)
        }
    }
}
