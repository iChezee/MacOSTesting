import CoreData

class PersistenceControllerImpl: PersistenceController {
    typealias ObjectType = NSManagedObject
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
    func addItem(_ objectType: ObjectType.Type, parameters: [String: Any]) async throws -> Result<ObjectType, Error> {
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
            return .success(entity)
        }
    }
    
    func getObject(by id: NSManagedObjectID, context: NSManagedObjectContext) -> NSManagedObject {
        context.object(with: id)
    }
    
    func getObject(by value: Any, key: String, entity: ObjectType.Type, context: NSManagedObjectContext) throws -> ObjectType? {
        let request = NSFetchRequest<ObjectType>(entityName: entity.entityName)
        request.predicate = NSPredicate(format: "%K == %@", key, value as! CVarArg)
        request.fetchLimit = 1
        
        return try context.fetch(request).first
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
