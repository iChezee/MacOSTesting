import XCTest
@testable import DependencyInjection

final class DependencyInjectionTests: XCTestCase {
  override func setUp() {
    super.setUp()
      DependencyInjection.shared.removeAll()
  }
  
  func testResolved_When_Registered() {
    let diContainer = DependencyInjection.shared
    diContainer.register(FetchService.self) { _ in FetchServiceMock() }
    diContainer.register(DisplayService.self) { service in
      DisplayServiceMock(fetchService: service.resolveRequired(FetchService.self))
    }
    
    let displayService = try? diContainer.resolve(DisplayService.self)
    displayService?.display()
    
    XCTAssertEqual(diContainer.resolveRequired(FetchService.self).fetchName(), "Test Name")
  }
  
  func testResolvedNonOptional_When_Registered() {
    let diContainer = DependencyInjection.shared
    diContainer.register(FetchService.self) { _ in FetchServiceMock() }
    diContainer.register(DisplayService.self) { service in
      DisplayServiceMock(fetchService: service.resolveRequired(FetchService.self))
    }
    
    let displayService = diContainer.resolveRequired(DisplayService.self)
    displayService.display()
    
    XCTAssertEqual(diContainer.resolveRequired(FetchService.self).fetchName(), "Test Name")
  }
  
  func testGiven_RegisteredFirst_When_RegisteringSecond_Then_SecondWillResolve() {
    let diContainer = DependencyInjection.shared
    diContainer.register(FetchService.self) { _ in FetchServiceMock("name1") }
    
    XCTAssertEqual(diContainer.resolveRequired(FetchService.self).fetchName(), "name1")
    
    diContainer.register(FetchService.self) { _ in FetchServiceMock("name2") }
    diContainer.register(DisplayService.self) { service in
      DisplayServiceMock(fetchService: service.resolveRequired(FetchService.self))
    }
    
    let displayService = diContainer.resolveRequired(DisplayService.self)
    displayService.display()
    
    XCTAssertEqual(diContainer.resolveRequired(FetchService.self).fetchName(), "name2")
  }
  
  func testResolve_Then_NilAfterReset() {
    let diContainer = DependencyInjection.shared
    diContainer.register(FetchService.self) { _ in FetchServiceMock() }
    diContainer.register(DisplayService.self) { service in
      DisplayServiceMock(fetchService: service.resolveRequired(FetchService.self))
    }
    
    let displayService = diContainer.resolveRequired(DisplayService.self)
    displayService.display()
    diContainer.removeAll()
    
    XCTAssertThrowsError(try diContainer.resolve(DisplayService.self))
  }
  
  func testResolved_When_NonOptionalFails() {
    let diContainer = DependencyInjection.shared
    diContainer.register(FetchService.self) { _ in FetchServiceMock() }
    
    XCTAssertNoThrow(try diContainer.resolve(FetchService.self))
    XCTAssertThrowsError(try diContainer.resolve(DisplayService.self))
  }
}

extension DependencyInjectionTests {
    class FetchServiceMock: FetchService {
        let name: String
        init(_ name: String = "Test Name") {
            self.name = name
        }
        
        func fetchName() -> String {
            return name
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
