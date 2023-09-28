import XCTest
import DataManagment
@testable import BookCollection

final class AuthorsListViewModelTests: XCTestCase {
    var setup: (viewModel: AuthorsListViewModel, controller: DataManagment) {
        let mockController = MockPersistenceCotnroller(bundle: .main, modelName: "BookCollection")
        return (AuthorsListViewModel(dataManagement: mockController), mockController)
    }
    
    func testSuccess_When_AddAuthor() async {
        let viewModel = setup.viewModel
        let success = await viewModel.add("Add")
        XCTAssertTrue(success)
    }
    
    func testFailed_When_AddAuthor() async {
        let viewModel = setup.viewModel
        let success = await viewModel.add("@")
        XCTAssertFalse(success)
    }
    
    func testSuccess_When_FindObject() async throws {
        let setup = setup
        let viewModel = setup.viewModel
        let controller = setup.controller
        let name = "Find"
        let success = await viewModel.add(name)
        XCTAssertTrue(success)
        
        guard let object = try controller.getObject(by: name, key: #keyPath(Author.name), entity: Author.self, context: controller.viewContext) else {
            XCTFail("Object did not added")
            throw(CocoaError(.coreData))
        }
        
        XCTAssertNotNil(object)
    }
    
    func testFailed_When_FindObject() async {
        let setup = setup
        let viewModel = setup.viewModel
        let controller = setup.controller
        let success = await viewModel.add("Find")
        XCTAssertTrue(success)
        
        do {
            let object = try controller.getObject(by: "Failed", key: #keyPath(Author.name), entity: Author.self, context: controller.viewContext)
            XCTAssertNil(object)
        } catch {
            XCTAssertTrue(viewModel.hasError)
            XCTAssertEqual(error.localizedDescription, viewModel.error?.localizedDescription)
        }
    }
    
    func testSuccess_When_DeleteAuthor() async throws {
        let setup = setup
        let viewModel = setup.viewModel
        let controller = setup.controller
        let name = "Delete"
        let success = await setup.viewModel.add(name)
        XCTAssertTrue(success)
        
        guard let object = try controller.getObject(by: name, key: #keyPath(Author.name), entity: Author.self, context: controller.viewContext) else {
            XCTFail("Object did not added")
            throw(CocoaError(.coreData))
        }
        
        await viewModel.delete(author: object)
        let removedObject = try controller.getObject(by: name, key: #keyPath(Author.name), entity: Author.self, context: controller.viewContext)
        XCTAssertNil(removedObject)
    }
    
    func testFailed_When_DeleteAuthor() async throws {
        let setup = setup
        let viewModel = setup.viewModel
        let controller = setup.controller
        
        let entity = Author(context: controller.viewContext)
        await viewModel.delete(author: entity)
        XCTAssertTrue(viewModel.hasError)
    }
}
