import XCTest
import CoreData
@testable import DataManagment

class PersistenceControllerTests: XCTestCase {
    var persistenceController: PersistenceController {
        PersistenceController(inMemory: true, bundle: DataModel.bundle, modelName: "DataModel")
    }
    
    var parameters: [String: Any] {
        [
            "title": "Title",
            "text": "Text"
        ]
    }
    
    func testSuccess_When_AddItem() async throws {
        let persistenceController = persistenceController
        do {
            let relationObject = try await persistenceController.addItem(RelationItem.self, parameters: [:]).get()
            
            var parameters = parameters
            parameters["relationItem"] = relationObject
            
            let object = try await persistenceController.addItem(TestItem.self, parameters: parameters).get()
            guard let contextualObject = persistenceController.viewContext.object(with: object.objectID) as? TestItem else {
                return
            }
            
            XCTAssertNotNil(contextualObject)
            XCTAssertEqual(contextualObject.title, parameters["title"] as? String)
            XCTAssertEqual(contextualObject.text, parameters["text"] as? String)
            XCTAssertEqual(contextualObject.relationItem?.objectID, relationObject.objectID)
        } catch {
            XCTFail("Failed to add an item: \(error)")
        }
    }
    
    func testSuccessGetObject_When_Search() throws {
        let persistenceController = persistenceController
        let context = persistenceController.viewContext
        guard let firstObject = prepopulatedObjects(at: context).first else {
            XCTFail("Failed to prepopulate objects")
            return
        }
        let searchedByIdObject = persistenceController.getObject(by: firstObject.objectID, context: context) as? TestItem
        XCTAssertEqual(firstObject, searchedByIdObject)
        XCTAssertEqual(firstObject.title, searchedByIdObject?.title)
        do {
            guard let searcheByKeyValueObject = try persistenceController.getObject<TestItem>(by: firstObject.title ?? "",
                                                                                          key: String(describing: #keyPath(TestItem.title)),
                                                                                          entity: TestItem.self,
                                                                                          context: context) else {
                XCTFail("There is no object")
                return
            }
            
            XCTAssertEqual(firstObject, searcheByKeyValueObject)
            XCTAssertEqual(firstObject.title, searcheByKeyValueObject.title)
        } catch {
            XCTFail("Failed to search object: \(error)")
        }
    }
    
    func testSuccess_When_DeleteObject() async throws {
        let persistenceController = persistenceController
        let object = try await persistenceController.addItem(TestItem.self, parameters: parameters).get()
        guard let contextualObject = persistenceController.viewContext.object(with: object.objectID) as? TestItem else {
            XCTFail("Failed to get object")
            return
        }
        XCTAssertEqual(contextualObject.title, parameters["title"] as? String)
        XCTAssertEqual(contextualObject.text, parameters["text"] as? String)
        do {
            try persistenceController.delete(object: contextualObject)
            XCTAssertFalse(persistenceController.viewContext.hasChanges)
        } catch {
            XCTFail("Failed to delete object: \(error)")
        }
    }
    
    func testSuccess_When_ClearData() throws {
        let persistenceController = persistenceController
        let context = persistenceController.viewContext
        let objects = prepopulatedObjects(at: context)
        do {
            XCTAssertEqual(context.registeredObjects.count, objects.count)
            try persistenceController.clearData()
            XCTAssertEqual(context.registeredObjects.count, 0)
        } catch {
            XCTFail("Failed to clear data: \(error)")
        }
    }
}

extension PersistenceControllerTests {
    func prepopulatedObjects(at context: NSManagedObjectContext) -> [TestItem] {
        var objects = [TestItem]()
        for index in 0...3 {
            // swiftlint:disable:next force_cast
            let item = NSEntityDescription.insertNewObject(forEntityName: TestItem.entityName, into: context) as! TestItem
            item.title = "\(index)"
            objects.append(item)
        }
        try? context.save()
        
        return objects
    }
}
