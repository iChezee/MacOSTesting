import XCTest
@testable import DependencyInjection

final class PropertyWrapperTests: XCTestCase {
  func testInitInjection_When_PropertyWrapped() {
    let container = DependencyInjection.shared
    container.register(FetchService.self) { _ in FetchServiceMock() }
    container.register(DisplayService.self) { _ in DisplayServiceMock() }

    let displayService = container.resolveRequired(DisplayService.self)
    displayService.display()
    
    XCTAssertEqual(container.resolveRequired(FetchService.self).fetchName(), "Test Name")
  }
}

extension PropertyWrapperTests {
    class FetchServiceMock: FetchService {
        func fetchName() -> String {
            return "Test Name"
        }
    }
    
    class DisplayServiceMock: DisplayService {
        @Injected var fetchService: FetchService
        
        var displayCount: Int = 0
        
        func display() {
            let name = fetchService.fetchName()
            print("DisplayServiceImp:display \(name), count: \(displayCount)")
            displayCount += 1
        }
    }
}
