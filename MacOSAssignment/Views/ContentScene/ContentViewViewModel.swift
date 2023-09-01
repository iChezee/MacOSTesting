import Foundation

class ContentViewViewModel: ObservableObject {
    let manager = CoreDataManager.shared
    
    func remove(_ author: AuthorMO) {
        do {
            try manager.delete(author)
        } catch {
            print(error)
        }
    }
}
