import CoreData

protocol PersistenceController {
    var viewContext: NSManagedObjectContext { get }
    
    init(inMemory: Bool)
    
    @discardableResult
    func addItem<T>(_ objectType: T.Type, parameters: [String: Any]) async throws -> Result<T, Error>
    
    func getObject(by id: NSManagedObjectID, context: NSManagedObjectContext) -> NSManagedObject
    func getObject<T>(by value: Any, key: String, entity: T.Type, context: NSManagedObjectContext) throws -> T?
    func delete(object: NSManagedObject) throws
    func clearData() throws
}
