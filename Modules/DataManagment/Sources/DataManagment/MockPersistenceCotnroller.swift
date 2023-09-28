import CoreData

public class MockPersistenceCotnroller: DataManagment {
    public var viewContext: NSManagedObjectContext { container.viewContext }
    var mockData = [String: [NSManagedObject]]()
    
    private var container: NSPersistentContainer
    
    required public init(inMemory: Bool = true, bundle: Bundle = DataModel.bundle, modelName: String = "") {
        guard let dataModel = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            fatalError("Failed to load ObjectModel")
        }
        container = NSPersistentContainer(name: modelName, managedObjectModel: dataModel)
        container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null") // swiftlint:disable:this force_unwrapping
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
    public func addItem<T>(_ objectType: T.Type, parameters: [String: Any]) async throws -> Result<T, Error> {
        let entityName = String(describing: objectType.self)
        let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: viewContext)
        
        for (key, value) in parameters {
            entity.setValue(value, forKey: key)
        }
        
        if mockData[entityName] == nil {
            mockData[entityName] = []
        }
        mockData[entityName]?.append(entity)
        
        return .success(entity as! T) // swiftlint:disable:this force_cast
    }
    
    public func getObject(by id: NSManagedObjectID, context: NSManagedObjectContext) -> NSManagedObject? {
        for key in mockData.keys {
            if let object = mockData[key]?.first(where: { $0.objectID == id }) {
                return object
            }
        }
        return nil
    }
    
    public func getObject<T>(by value: AnyHashable, key: String, entity: T.Type, context: NSManagedObjectContext) throws -> T? {
        let entityName = String(describing: entity.self)
        
        let object = mockData[entityName]?.first(where: { object in
            if let matchValue = object.value(forKey: key) as? AnyHashable,
               matchValue == value {
                return true
            }
            
            return false
        })
        
        return object as? T
    }
    
    public func delete(object: NSManagedObject) throws {
        guard let entityName = object.entity.name else {
            throw(CocoaError(.coreData))
        }
        
        if mockData[entityName]?.first(where: { $0.objectID == object.objectID }) != nil {
            mockData[entityName]?.removeAll(where: { $0.objectID == object.objectID })
        } else {
            throw(CocoaError(.coreData))
        }
    }
    
    public func clearData() throws {
        mockData.removeAll()
    }
}
