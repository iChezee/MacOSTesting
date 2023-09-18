import XCTest
@testable import MacOSAssignment

final class AddBookPopoverViewTests: XCTestCase {
    let timeout = 0.2
    
    var startApplicationWithourAnimations: XCUIApplication {
        let app = XCUIApplication()
        app.launchEnvironment = ["DISABLE_ANIMATIONS": "1"]
        app.launch()

        return app
    }
    
    // swiftlint:disable:next large_tuple
    var openPopover: (app: XCUIApplication,
                      bookTextField: XCUIElement,
                      authorTextField: XCUIElement,
                      genreTextField: XCUIElement,
                      addItemButton: XCUIElement,
                      closeButton: XCUIElement) {
        let app = startApplicationWithourAnimations
        
        let addButton = app.buttons[AccLabels.MainView.addButton]
        XCTAssertTrue(addButton.waitForExistence(timeout: timeout))
        addButton.tap()
        
        let bookTextField = app.textFields[AccLabels.AddBookPopover.bookTextField]
        let authorTextField = app.textFields[AccLabels.AddBookPopover.authorTextField]
        let genreTextField = app.textFields[AccLabels.AddBookPopover.genreTextField]
        let addItemButton = app.buttons[AccLabels.AddBookPopover.addButton]
        let closeButton = app.buttons[AccLabels.AddBookPopover.closeButton]
        
        XCTAssertTrue(bookTextField.waitForExistence(timeout: timeout))
        XCTAssertTrue(authorTextField.waitForExistence(timeout: timeout))
        XCTAssertTrue(genreTextField.waitForExistence(timeout: timeout))
        XCTAssertTrue(addItemButton.waitForExistence(timeout: timeout))
        XCTAssertTrue(closeButton.waitForExistence(timeout: timeout))
        
        return (app, bookTextField, authorTextField, genreTextField, addItemButton, closeButton)
    }

    func test_popoverStayOpened_when_addingDataIsInvalid() {
        let (app, bookTextField, authorTextField, genreTextField, addItemButton, closeButton) = openPopover
        
        let bookName = "asdf"
        let authorName = "*+,-"
        let genreName = "asdf"
        
#if os(iOS)
        bookTextField.tap()
        bookTextField.setText(bookName, application: app)

        authorTextField.tap()
        authorTextField.setText(authorName, application: app)

        genreTextField.tap()
        genreTextField.setText(genreName, application: app)
#elseif os(macOS)
        bookTextField.tap()
        bookTextField.typeText(bookName)
        
        authorTextField.tap()
        authorTextField.typeText(authorName)
        
        genreTextField.tap()
        genreTextField.typeText(genreName)
#endif
        
        addItemButton.tap()
        
        XCTAssertTrue(bookTextField.exists)
        XCTAssertTrue(authorTextField.exists)
        XCTAssertTrue(genreTextField.exists)
        XCTAssertTrue(addItemButton.exists)
        XCTAssertTrue(closeButton.exists)
    }
    
    func test_closePopover_when_addingDataIsValid() {
        let (app, bookTextField, authorTextField, genreTextField, addItemButton, closeButton) = openPopover
        
        let bookName = "asdf"
        let authorName = "asdf"
        let genreName = "asdf"
        
#if os(iOS)
        bookTextField.tap()
        bookTextField.setText(bookName, application: app)
        
        authorTextField.tap()
        authorTextField.setText(authorName, application: app)
        
        genreTextField.tap()
        genreTextField.setText(genreName, application: app)
#elseif os(macOS)
        bookTextField.click()
        bookTextField.typeText(bookName)
        
        authorTextField.click()
        authorTextField.typeText(authorName)
        
        genreTextField.click()
        genreTextField.typeText(genreName)
#endif
        
        addItemButton.tap()
        
        XCTAssertFalse(bookTextField.exists)
        XCTAssertFalse(authorTextField.exists)
        XCTAssertFalse(genreTextField.exists)
        XCTAssertFalse(addItemButton.exists)
        XCTAssertFalse(closeButton.exists)
    }
    
    func test_closePopoverSuccess_when_closeTapped() {
        let (_, bookTextField, authorTextField, genreTextField, addItemButton, closeButton) = openPopover
        
        closeButton.tap()
        XCTAssertFalse(bookTextField.exists)
        XCTAssertFalse(authorTextField.exists)
        XCTAssertFalse(genreTextField.exists)
        XCTAssertFalse(addItemButton.exists)
        XCTAssertFalse(closeButton.exists)
    }
}
