import Foundation

class MainViewViewModel {
    let persistenceController: PersistenceController
    let viewContext = PersistenceControllerImpl.shared.viewContext
    
    init(persistenceController: any PersistenceController = PersistenceControllerImpl.shared) {
        self.persistenceController = persistenceController
    }
    
    @MainActor
    func add(_ name: String) async {
        let parameters = ["name": name]
        do {
            try await persistenceController.addItem(Author.self, parameters: parameters)
        } catch {
            
        }
    }
}
