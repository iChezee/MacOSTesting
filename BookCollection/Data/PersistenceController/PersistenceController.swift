import CoreData

protocol PersistenceController {
    associatedtype ObjectType = Any
    var viewContext: NSManagedObjectContext { get }
    
    init(inMemory: Bool)
    
    func addItem(_ objectType: ObjectType.Type, parameters: [String: Any]) async throws -> Result<ObjectType, Error>
    func delete(object: NSManagedObject) throws
    func clearData() throws
}
