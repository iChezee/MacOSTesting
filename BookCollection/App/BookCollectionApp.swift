import SwiftUI
import DependencyInjection
import ViewRouting
import SwiftData

@main
struct BookCollectionApp: App {
    let container = DependencyInjection.shared
    @StateObject var selectedStateModel = SelectedViewState()
    
    init() {
        registerDependecies()
    }

    var body: some Scene {
        WindowGroup {
            #if os(macOS)
            MacMainView()
            #elseif os(iOS)
            ViewRoot(router: container.resolveRequired(RootRouter.self))
                .preferredColorScheme(.light)
            #endif
        }
        .modelContainer(for: [Author.self, Book.self])
        .environmentObject(selectedStateModel)
    }
    
    func registerDependecies() {
        container.register(ViewRouter<RootRouterViewBuilder>.self) { _ in
            return ViewRouter(for: RootRouterViewBuilder.self, initial: .mainScreen)
        }
    }
}
