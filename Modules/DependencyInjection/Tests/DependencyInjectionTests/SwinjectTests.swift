import XCTest
import Swinject
@testable import DependencyInjection

final class SwinjectTests: XCTestCase {
  func testInitInjection_When_MockedFakeService() {
    let container = Container()
    container.register(FetchService.self) { _ in FetchServiceMock() }
    
    container.register(DisplayService.self) { service in
      DisplayServiceMock.init(fetchService: service.resolve(FetchService.self)!) // swiftlint:disable:this force_unwrapping
    }
    
    
    let displayService = container.resolve(DisplayService.self)
    displayService?.display()
    
    XCTAssertEqual(container.resolve(FetchService.self)?.fetchName(), "Test Name")
  }
}

extension SwinjectTests {
    class FetchServiceMock: FetchService {
        func fetchName() -> String {
            return "Test Name"
        }
    }
    
    class DisplayServiceMock: DisplayService {
        let fetchService: FetchService
        
        init(fetchService: FetchService) {
            self.fetchService = fetchService
        }
        
        func display() {
            let name = fetchService.fetchName()
            print("DisplayServiceImp:display \(name)")
        }
    }
}
