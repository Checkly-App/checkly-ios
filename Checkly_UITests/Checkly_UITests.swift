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
    
    func test_successful_login(){
        
        XCTAssert(app.staticTexts["Sign in"].exists)
        
        app.textFields["type your email"].tap()
        app.textFields["type your email"].typeText("aleenwaelss@gmail.com")

        app.secureTextFields["type your password"].tap()
        app.secureTextFields["type your password"].typeText("123456")
        app.keyboards.buttons["return"].tap()

        app.buttons["Login"].tap()
        
        XCTAssert(app.staticTexts["Logged in as aleenwaelss@gmail.com"].waitForExistence(timeout: 20))
        
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
    
    func login() {
        app.textFields["type your email"].tap()
        app.textFields["type your email"].typeText("aleenwaelss@gmail.com")

        app.secureTextFields["type your password"].tap()
        app.secureTextFields["type your password"].typeText("123456")
        app.keyboards.buttons["return"].tap()

        app.buttons["Login"].tap()
//        app.buttons["sign out"].tap()
    }
    
}
