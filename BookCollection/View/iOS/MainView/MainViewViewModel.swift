import Foundation

class MainViewViewModel {
    let viewContext = PersistenceControllerImpl.shared.viewContext
    
    func requestNewBook() {
        Request.makeRequest()
    }
    
    func add(_ name: String) {
        let newItem = Author(context: viewContext)
        newItem.name = name
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
