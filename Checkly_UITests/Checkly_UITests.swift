//
//  Checkly_UITests.swift
//  Checkly_UITests
//
//  Created by a w on 28/04/2022.
//

import XCTest

class Checkly_UITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    func test_login_with_empty_credentials(){
        
        app.buttons["Login"].tap()
    
        XCTAssert(app.alerts.element.staticTexts["Credentials should not be empty"].waitForExistence(timeout: 2))
    }
    
    func test_login_with_invalid_email(){
        
        app.textFields["type your email"].tap()
        app.textFields["type your email"].typeText("aleenwaelss")

        app.secureTextFields["type your password"].tap()
        app.secureTextFields["type your password"].typeText("123456")

        app.buttons["Login"].tap()
        
        XCTAssert(app.alerts.element.staticTexts["Email or password are incorrect. Try again."].waitForExistence(timeout: 2))
    }
    
    func test_login_with_invalid_password(){
        app.textFields["type your email"].tap()
        app.textFields["type your email"].typeText("aleenwaelss@gmail.com")

        app.secureTextFields["type your password"].tap()
        app.secureTextFields["type your password"].typeText("123")

        app.buttons["Login"].tap()
        
        XCTAssert(app.alerts.element.staticTexts["Email or password are incorrect. Try again."].waitForExistence(timeout: 2))
    }
    
    func test_successful_login(){
        
        XCTAssert(app.staticTexts["Sign in"].exists)
        
        app.textFields["type your email"].tap()
        app.textFields["type your email"].typeText("aleenwaelss@gmail.com")

        app.secureTextFields["type your password"].tap()
        app.secureTextFields["type your password"].typeText("123456")

        app.buttons["Login"].tap()
        
        XCTAssert(app.staticTexts["Logged in as aleenwaelss@gmail.com"].waitForExistence(timeout: 20))
        
    }
    
    func login() {
        app.textFields["type your email"].tap()
        app.textFields["type your email"].typeText("aleenwaelss@gmail.com")

        app.secureTextFields["type your password"].tap()
        app.secureTextFields["type your password"].typeText("12345678")
        app.keyboards.buttons["return"].tap()

        app.buttons["Login"].tap()
//        app.buttons["sign out"].tap()
    }
    
    func test_edit_profile_with_valid_name(){
        app.buttons["Profile"].tap()
        app.progressIndicators.element.waitForExistence(timeout: 15)
        app.buttons["Edit profile"].tap()
        app.staticTexts["type your name"].waitForExistence(timeout: 5)
        app.textFields["type your name"].tap()
        app.textFields["type your name"].clearAndEnterText(text: "Aleen AlSuhaibani")
        app.buttons["Update"].tap()
        XCTAssert(app.staticTexts["Aleen AlSuhaibani"].waitForExistence(timeout: 20))
    }
    
    func test_edit_profile_with_empty_name(){
        app.buttons["Profile"].tap()
        app.progressIndicators.element.waitForExistence(timeout: 15)
        app.buttons["Edit profile"].tap()
        app.staticTexts["type your name"].waitForExistence(timeout: 5)
        app.textFields["type your name"].tap()
        app.textFields["type your name"].clearAndEnterText(text: "")
        app.buttons["Update"].tap()
        XCTAssert(app.alerts.element.staticTexts["All fields are required"].waitForExistence(timeout: 2))
    }
    
//    func test_edit_profile_with_valid_password(){
//        app.buttons["Profile"].tap()
//        app.progressIndicators.element.waitForExistence(timeout: 10)
//        app.buttons["Edit profile"].tap()
//        app.staticTexts["type your new password"].waitForExistence(timeout: 5)
//        app.secureTextFields["type your new password"].tap()
//        app.secureTextFields["type your new password"].typeText("12345678")
//        app.keyboards.buttons["return"].tap()
//        app.secureTextFields["type the confirm password"].tap()
//        app.secureTextFields["type the confirm password"].typeText("12345678")
//        app.keyboards.buttons["return"].tap()
//        app.buttons["Update"].tap()
//        XCTAssert(app.staticTexts["Edit profile"].waitForExistence(timeout: 20))
//    }
    func test_edit_profile_with_valid_password(){
        app.buttons["Profile"].tap()
        app.progressIndicators.element.waitForExistence(timeout: 10)
        app.buttons["Edit profile"].tap()
        app.staticTexts["type your new password"].waitForExistence(timeout: 5)
        app.secureTextFields["type your new password"].tap()
        app.secureTextFields["type your new password"].typeText("12345678")
        app.keyboards.buttons["return"].tap()
        app.secureTextFields["type the confirm password"].tap()
        app.secureTextFields["type the confirm password"].typeText("12345678")
        app.keyboards.buttons["return"].tap()
        app.buttons["Save"].tap()
        app.buttons["Back"].tap()
        app.buttons["sign out"].tap()
        login()
        XCTAssert(app.staticTexts["Logged in as aleenwaelss@gmail.com"].waitForExistence(timeout: 20))
    }
    
    func test_edit_profile_with_empty_new_password(){
        app.buttons["Profile"].tap()
        app.progressIndicators.element.waitForExistence(timeout: 10)
        app.buttons["Edit profile"].tap()
        app.staticTexts["type your new password"].waitForExistence(timeout: 5)
        app.secureTextFields["type the confirm password"].tap()
        app.secureTextFields["type the confirm password"].typeText("123")
        app.keyboards.buttons["return"].tap()
        app.buttons["Save"].tap()
        XCTAssert(app.alerts.element.staticTexts["The new password and the confirm password must be the same"].waitForExistence(timeout: 2))
    }
    
    func test_edit_profile_with_empty_confirm_password(){
        app.buttons["Profile"].tap()
        app.progressIndicators.element.waitForExistence(timeout: 10)
        app.buttons["Edit profile"].tap()
        app.staticTexts["type your new password"].waitForExistence(timeout: 5)
        app.secureTextFields["type your new password"].tap()
        app.secureTextFields["type your new password"].typeText("123")
        app.buttons["Save"].tap()
        XCTAssert(app.alerts.element.staticTexts["The new password and the confirm password must be the same"].waitForExistence(timeout: 2))
    }
    
}

extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        self.typeText(deleteString)
        self.typeText(text)
    }
}
