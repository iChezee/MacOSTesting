import XCTest
@testable import BookCollection

final class AuthorsListViewModelTests: XCTestCase {
    var viewModel: AuthorsListViewModel {
        AuthorsListViewModel()
    }
    
    func testSuccess_When_AddAuthor() async {
        let viewModel = viewModel
        let success = await viewModel.add("Hello")
        XCTAssertTrue(success)
    }
    
    func testFailed_When_AddAuthor() async {
        let viewModel = viewModel
        let success = await viewModel.add("@")
        XCTAssertFalse(success)
    }
}
