import SwiftUI

@main
struct MacOSAssignmentApp: App {
    let context = CoreDataManager.shared.mainContext
    @ObservedObject var selectionModel = SelectionModel.shared
    
    init() {
        #if !os(macOS)
        let env = ProcessInfo.processInfo.environment
        if env["DISABLE_ANIMATIONS"] == "1" {
            UIView.setAnimationsEnabled(false)
        }
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                MainView().environment(\.managedObjectContext, context)
            } content: {
                if selectionModel.selectedGenre != nil {
                    ContentView().environment(\.managedObjectContext, context)
                } else {
                    ZStack { }
                }
            } detail: {
                if selectionModel.selectedAuthor != nil {
                    DetailedView().environment(\.managedObjectContext, context)
                } else {
                    ZStack { }
                }
            }
        }
    }
}
