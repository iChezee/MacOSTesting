import CoreData

public protocol DataManagment {
    var viewContext: NSManagedObjectContext { get }
    
    init(inMemory: Bool, bundle: Bundle, modelName: String)
    
    @discardableResult
    func addItem<T>(_ objectType: T.Type, parameters: [String: Any]) async throws -> Result<T, Error>
    
    func getObject(by id: NSManagedObjectID, context: NSManagedObjectContext) -> NSManagedObject?
    func getObject<T>(by value: AnyHashable, key: String, entity: T.Type, context: NSManagedObjectContext) throws -> T?
    func delete(object: NSManagedObject) throws
    func clearData() throws
}
