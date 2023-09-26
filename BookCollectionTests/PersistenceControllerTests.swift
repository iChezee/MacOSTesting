import XCTest
@testable import BookCollection

class PersistenceControllerTests: XCTestCase {
    var persistenceController: PersistenceControllerImpl {
        PersistenceControllerImpl(inMemory: true)
    }
    var parameters: [String: Any] {
        ["title": "Title",
         "text": "Text"]
    }
    
    func testAddItem() async throws {
        let persistenceController = persistenceController
        do {
            guard let object = try await persistenceController.addItem(Book.self, parameters: parameters).get() as? Book else {
                XCTFail("Wrong object")
                return
            }
            let context = object.managedObjectContext
            guard let contextualObject = context?.object(with: object.objectID) as? Book else {
                return
            }
            
            XCTAssertNotNil(contextualObject)
            XCTAssertEqual(contextualObject.title, parameters["title"] as? String)
            XCTAssertEqual(contextualObject.text, parameters["text"] as? String)
        } catch {
            XCTFail("Failed to add an item: \(error)")
        }
    }
    
    func testDeleteObject() async throws {
        let persistenceController = persistenceController
        guard let object = try await persistenceController.addItem(Book.self, parameters: parameters).get() as? Book else {
            XCTFail("Wrong object")
            return
        }
        let context = object.managedObjectContext
        guard let contextualObject = context?.object(with: object.objectID) as? Book else {
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
    
    func testClearData() throws {
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
    func prepopulatedObjects(at context: NSManagedObjectContext) -> [Book] {
        var objects = [Book]()
        for index in 0...3 {
            let book = NSEntityDescription.insertNewObject(forEntityName: Book.entityName, into: context) as! Book
            book.title = "\(index)"
            objects.append(book)
        }
        try? context.save()
        
        return objects
    }
}
