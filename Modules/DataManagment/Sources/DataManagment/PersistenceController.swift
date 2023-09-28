import CoreData

public class PersistenceController: DataManagment {
    public var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    private var container: NSPersistentContainer
    
    required public init(inMemory: Bool = false, bundle: Bundle = .main, modelName: String) {
        guard let dataModel = NSManagedObjectModel.mergedModel(from: [bundle]) else {
            fatalError("Failed to init ObjectModel")
        }
        container = NSPersistentContainer(name: modelName, managedObjectModel: dataModel)
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null") // swiftlint:disable:this force_unwrapping
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    @discardableResult
    public func addItem<T>(_ objectType: T.Type, parameters: [String: Any]) async throws -> Result<T, Error> {
        return try await container.performBackgroundTask { context in
            let entityName = String(describing: objectType.self)
            let entity = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
            for key in parameters.keys {
                if let value = parameters[key] as? NSManagedObject {
                    let object = context.object(with: value.objectID)
                    entity.setValue(object, forKey: key)
                } else {
                    entity.setValue(parameters[key], forKey: key)
                }
            }
            try context.save()
            return .success(entity as! T) // swiftlint:disable:this force_cast
        }
    }
    
    public func getObject<T>(by id: NSManagedObjectID, context: NSManagedObjectContext) -> T? where T: NSManagedObject {
        context.object(with: id) as? T
    }
    
    public func getObject<T>(by value: AnyHashable, key: String, entity: T.Type, context: NSManagedObjectContext) throws -> T? {
        guard let objectType = T.self as? NSManagedObject.Type else {
            return nil
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: objectType.entityName)
        request.predicate = NSPredicate(format: "%K == %@", key, value as CVarArg)
        request.fetchLimit = 1
        
        return try context.fetch(request).first as? T
    }
    
    public func delete(object: NSManagedObject) throws {
        let object = viewContext.object(with: object.objectID)
        viewContext.delete(object)
        try viewContext.save()
    }
    
    public func clearData() throws {
        let storeCoordinator = container.persistentStoreCoordinator
        
        for store in storeCoordinator.persistentStores {
            guard let url = store.url else {
                continue
            }
            try storeCoordinator.destroyPersistentStore(
                at: url,
                ofType: store.type,
                options: nil
            )
        }
        
        container = NSPersistentContainer(name: "BookCollection")
        container.loadPersistentStores { _, _ in }
    }
}
