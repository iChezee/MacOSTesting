import CoreData

class PersistenceControllerImpl: PersistenceController {
    static let shared = PersistenceControllerImpl()
    
    var viewContext: NSManagedObjectContext { container.viewContext }
    
    private var container: NSPersistentContainer

    required init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "BookCollection")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    @discardableResult
    func addItem<T>(_ objectType: T.Type, parameters: [String: Any]) async throws -> Result<T, Error> {
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
            return .success(entity as! T)
        }
    }
    
    func getObject<T>(by id: NSManagedObjectID, context: NSManagedObjectContext) -> T where T: NSManagedObject {
        context.object(with: id) as! T
    }
    
    func getObject<T>(by value: Any, key: String, entity: T.Type, context: NSManagedObjectContext) throws -> T? {
        guard let ObjectType = T.self as? NSManagedObject.Type else {
            return nil
        }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: ObjectType.entityName)
        request.predicate = NSPredicate(format: "%K == %@", key, value as! CVarArg)
        request.fetchLimit = 1
        
        return try context.fetch(request).first as? T
    }
    
    func delete(object: NSManagedObject) throws {
        viewContext.delete(object)
        try viewContext.save()
    }
    
    func clearData() throws {
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
        container.loadPersistentStores { (_, _) in }
    }
}
