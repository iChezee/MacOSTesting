import CoreData

protocol PersistenceController {
    associatedtype ObjectType = Any
    var viewContext: NSManagedObjectContext { get }
    
    init(inMemory: Bool)
    
    func addItem(_ objectType: ObjectType.Type, parameters: [String: Any]) async throws -> Result<ObjectType, Error>
    func getObject(by id: NSManagedObjectID, context: NSManagedObjectContext) -> NSManagedObject
    func getObject(by value: Any, key: String, entity: ObjectType.Type, context: NSManagedObjectContext) throws -> ObjectType?
    func delete(object: NSManagedObject) throws
    func clearData() throws
}
