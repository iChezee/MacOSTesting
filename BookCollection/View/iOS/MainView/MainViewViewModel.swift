import Foundation
import DataManagment

class MainViewViewModel {
    let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController) {
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
