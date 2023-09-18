import Foundation

class DetailedViewViewModel: ObservableObject {
    let coreDataManager: any CoreDataManager
    
    init(coreDataManager: any CoreDataManager = CoreDataManagerImplementation.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func remove(_ book: BookMO) {
        do {
            try coreDataManager.delete(book)
        } catch {
            print(error)
        }
    }
}
