import XCTest
@testable import BookCollection

final class AuthorsListViewModelTests: XCTestCase {
    var viewModel: AuthorsListViewModel {
        AuthorsListViewModel()
    }
    
    func testExample() async throws {
        let viewModel = viewModel
        await viewModel.add("Hello")
    }
}
