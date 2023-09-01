import Foundation

class DetailedViewViewModel: ObservableObject {
    let manager = CoreDataManager.shared
    
    func remove(_ book: BookMO) {
        do {
            try manager.delete(book)
        } catch {
            print(error)
        }
    }
}
