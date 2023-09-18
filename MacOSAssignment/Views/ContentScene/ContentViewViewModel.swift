import Foundation

class ContentViewViewModel: ObservableObject {
    let coreDataManager: any CoreDataManager
    
    init(coreDataManager: any CoreDataManager = CoreDataManagerImplementation.shared) {
        self.coreDataManager = coreDataManager
    }
    
    func remove(_ author: AuthorMO) {
        do {
            try coreDataManager.delete(author)
        } catch {
            print(error)
        }
    }
}
