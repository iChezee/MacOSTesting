import XCTest

final class MacOSAssignmentUITests: XCTestCase { }

extension XCUIElement {
    #if os(iOS)
    func setText(_ text: String, application: XCUIApplication) {
        UIPasteboard.general.string = text
        doubleTap()
        application.menuItems["Paste"].tap()
    }
    #endif
}
