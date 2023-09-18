import Foundation
import CoreData

// TODO: Rewrite to abstract objects to make it testable
protocol CoreDataManager {
    associatedtype Object = NSManagedObject
    var mainContext: NSManagedObjectContext { get }
    
    func addItem<Object>(type: Object.Type, name: String, parameters: [String: Any]) async throws -> Result<Object, Error>
    func makeRelations(book: NSManagedObjectID, author: NSManagedObjectID, genre: NSManagedObjectID) async throws
    
    func getAuthorBy(name: String) async -> Result<AuthorMO, Error>
    func getGenreBy(title: String) async -> Result<GenreMO, Error>
    func getBookBy(title: String) async -> Result<BookMO, Error>
    
    func delete(_ genre: GenreMO) throws
    func delete(_ author: AuthorMO) throws
    func delete(_ book: BookMO) throws
    func clearData() throws
}
