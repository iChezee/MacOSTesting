import XCTest
@testable import MacOSAssignment

final class MainViewViewModelTests: XCTestCase {
    var viewModel: (MainViewViewModel, CoreDataManagerMock<String>) {
        let mockManager = CoreDataManagerMock<String>()
        return (MainViewViewModel(coreDataManager: mockManager), mockManager)
    }
    
    func test_success_when_addItem() async throws {
        let (viewModel, coreDataManager) = viewModel
        
        let title = "asdf"
        let author = "fdsa"
        let genre = "ssss"
        viewModel.addBook(title: title, authorName: author, genreTitle: genre)
        XCTAssertNotNil(coreDataManager.addedItems[title])
        XCTAssertNotNil(coreDataManager.addedItems[author])
        XCTAssertNotNil(coreDataManager.addedItems[genre])
    }
}
