import Foundation
import CoreData

class CoreDataManagerMock<T>: CoreDataManager where T: NSManagedObject {
    private var addItemError: Error?
    
    var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    var addedItems: [String: Set<String>] = [:]
    
    init(addItemError: Error? = nil) {
        self.addItemError = addItemError
    }
    
    func addItem<T>(type: T.Type, name: String, parameters: [String: Any]) async throws -> Result<T, Error> {
        if let addItemError {
            return .failure(addItemError)
        } else {
            if var typeItems = addedItems[String(describing: T.self)] {
                typeItems.insert(name)
                addedItems[String(describing: T.self)] = typeItems
            } else {
                addedItems[String(describing: T.self)] = [name]
            }
            
            return .success(name as! T)
        }
    }
    
    func makeRelations(book: NSManagedObjectID, author: NSManagedObjectID, genre: NSManagedObjectID) async throws { }
    func getAuthorBy(name: String) async -> Result<AuthorMO, Error> {
        let authorDescription = String(describing: AuthorMO.Type.self)
        if addedItems[authorDescription]?.contains(name) != nil {
            return .success(AuthorMO(context: mainContext))
        } else {
            return .failure(FetchError.nothingIsHere)
        }
    }
    
    func getGenreBy(title: String) async -> Result<GenreMO, Error> {
        let genreDescription = String(describing: GenreMO.Type.self)
        if addedItems[genreDescription]?.contains(title) != nil {
            return .success(GenreMO(context: mainContext))
        } else {
            return .failure(FetchError.nothingIsHere)
        }
    }
    
    func getBookBy(title: String) async -> Result<BookMO, Error> {
        let bookDescription = String(describing: BookMO.Type.self)
        if addedItems[bookDescription]?.contains(title) != nil {
            return .success(BookMO(context: mainContext))
        } else {
            return .failure(FetchError.nothingIsHere)
        }
    }
    
    func delete(_ genre: GenreMO) throws { }
    func delete(_ author: AuthorMO) throws { }
    func delete(_ book: BookMO) throws { }
    func clearData() throws { }
}
