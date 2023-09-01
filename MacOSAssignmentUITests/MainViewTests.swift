import XCTest
@testable import MacOSAssignment

final class MainViewTests: XCTestCase {
    func startApplicationWithourAnimations() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment = ["DISABLE_ANIMATIONS": "1"]
        app.launch()

        return app
    }
    
    func test_sideBar_when_coldLaunch() throws {
        let app = startApplicationWithourAnimations()
        let addButton = app.buttons[AccLabels.MainView.addButton]
        XCTAssert(addButton.exists)

        addButton.tap()
        let bookTextField = app.textFields[AccLabels.AddBookPopover.bookTextField]
        XCTAssert(bookTextField.exists)
    }

    func test_addingData_when_invalid() {
        let app = startApplicationWithourAnimations()
        let addButton = app.buttons[AccLabels.MainView.addButton]
        addButton.tap()
        
        let bookTextField = app.textFields[AccLabels.AddBookPopover.bookTextField]
        let authorTextField = app.textFields[AccLabels.AddBookPopover.authorTextField]
        let genreTextField = app.textFields[AccLabels.AddBookPopover.genreTextField]
        
#if os(iOS)
        bookTextField.tap()
        bookTextField.setText("asdf", application: app)

        authorTextField.tap()
        authorTextField.setText("*+,-", application: app)

        genreTextField.tap()
        genreTextField.setText("asdf", application: app)
#endif
        
        let addBookButton = app.buttons[AccLabels.AddBookPopover.addButton]
        addBookButton.tap()
        
        XCTAssert(bookTextField.exists)
    }
}
