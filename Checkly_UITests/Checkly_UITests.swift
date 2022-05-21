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
        app.secureTextFields["type your password"].typeText("12345678")

        app.buttons["Login"].tap()
        
        XCTAssert(app.staticTexts["Logged in as aleenwaelss@gmail.com"].waitForExistence(timeout: 20))
        
    }
    
    func test_login_session(){
        app.staticTexts["Sign in"].waitForExistence(timeout: 5)
        app.textFields["type your email"].tap()
        app.textFields["type your email"].typeText("aleenwaelss@gmail.com")

        app.secureTextFields["type your password"].tap()
        app.secureTextFields["type your password"].typeText("12345678")

        app.buttons["Login"].tap()
        
        XCTAssert(app.alerts.element.staticTexts["Unable to login, make sure to sign out of any other device."].waitForExistence(timeout: 5))
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
    
    func test_edit_profile_with_valid_phone_number(){
        app.buttons["Profile"].tap()
        app.progressIndicators.element.waitForExistence(timeout: 10)
        app.buttons["Edit profile"].tap()
        app.staticTexts["type your phone number"].waitForExistence(timeout: 5)
        app.textFields["type your phone number"].tap()
        app.textFields["type your phone number"].clearAndEnterText(text: "0555123456")
        app.buttons["Save"].tap()
        XCTAssert(app.staticTexts["Profile"].waitForExistence(timeout: 20))
    }
    
    func test_edit_profile_with_invalid_phone_number(){
        app.buttons["Profile"].tap()
        app.progressIndicators.element.waitForExistence(timeout: 10)
        app.buttons["Edit profile"].tap()
        app.staticTexts["type your phone number"].waitForExistence(timeout: 5)
        app.textFields["type your phone number"].tap()
        app.textFields["type your phone number"].clearAndEnterText(text: "123456")
        app.buttons["Save"].tap()
        XCTAssert(app.alerts.element.staticTexts["The phone number must start with 05"].waitForExistence(timeout: 2))
    }
    
    func test_generate_meeting_with_valid_data(){
        app.buttons["Calendar"].tap()
        app.buttons["Generate Meeting"].tap()
        // set up meeting title
        app.textFields["type title of the meeting"].tap()
        app.textFields["type title of the meeting"].typeText("Meeting Test")
        // set up meeting location
        app.textFields["type the location"].tap()
        app.textFields["type the location"].typeText("www.zoom.com")
        app.keyboards.buttons["return"].tap()
        // set up meeting date
        app.datePickers["Start Date"].tap()
        app.datePickers.collectionViews.buttons["Today, Saturday, April 30"].tap()
        app.datePickers["Start Date"].tap()
        // set up start time to 7:00 PM
        app.datePickers["Start time"].tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "7")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        app.datePickers["Start time"].tap()
        // set up end time to 8:30 PM
        app.datePickers["End time"].tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "8")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "30")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        app.datePickers["End time"].tap()
        // set up meeting agenda
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.tap()
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.typeText("Sample Meeting Agenda")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        // select meeting type
        app.buttons["Online"].tap()
        // add meeting participants
        app.buttons["Add Participants"].tap()
        let tablesQuery = app.tables
        tablesQuery.cells["Account, Norah AlSalem, Full Stack Developer, circle"].children(matching: .other).element(boundBy: 0).tap()
        tablesQuery.cells["Account, Steve Jacobson, Developer, circle"].children(matching: .other).element(boundBy: 0).tap()
        app.buttons[" Save"].tap()
        app.buttons["Save"].tap()
        XCTAssert(app.staticTexts["Meeting Test"].waitForExistence(timeout: 10))
    }
    
    func test_generate_meeting_with_invalid_start_time(){
        app.buttons["Calendar"].tap()
        app.buttons["Generate Meeting"].tap()
        // set up meeting title
        app.textFields["type title of the meeting"].tap()
        app.textFields["type title of the meeting"].typeText("Meeting Test")
        // set up meeting location
        app.textFields["type the location"].tap()
        app.textFields["type the location"].typeText("www.zoom.com")
        app.keyboards.buttons["return"].tap()
        // set up meeting date
        app.datePickers["Start Date"].tap()
        app.datePickers.collectionViews.buttons["Today, Friday, April 29"].tap()
        app.datePickers["Start Date"].tap()
        // set up start time to 7:00 PM
        app.datePickers["Start time"].tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "9")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        app.datePickers["Start time"].tap()
        // set up end time to 8:30 PM
        app.datePickers["End time"].tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "8")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "30")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        app.datePickers["End time"].tap()
        // set up meeting agenda
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.tap()
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.typeText("Sample Meeting Agenda")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        // select meeting type
        app.buttons["Online"].tap()
        // add meeting participants
        app.buttons["Add Participants"].tap()
        let tablesQuery = app.tables
        tablesQuery.cells["Account, Norah AlSalem, Full Stack Developer, circle"].children(matching: .other).element(boundBy: 0).tap()
        tablesQuery.cells["Account, Steve Jacobson, Developer, circle"].children(matching: .other).element(boundBy: 0).tap()
        app.buttons[" Save"].tap()
        app.buttons["Save"].tap()
        XCTAssert(app.alerts.element.staticTexts["Please enter a valid time"].waitForExistence(timeout: 2))
    }
    
    func test_generate_meeting_with_invalid_end_time(){
        app.buttons["Calendar"].tap()
        app.buttons["Generate Meeting"].tap()
        // set up meeting title
        app.textFields["type title of the meeting"].tap()
        app.textFields["type title of the meeting"].typeText("Meeting Test")
        // set up meeting location
        app.textFields["type the location"].tap()
        app.textFields["type the location"].typeText("www.zoom.com")
        app.keyboards.buttons["return"].tap()
        // set up meeting date
        app.datePickers["Start Date"].tap()
        app.datePickers.collectionViews.buttons["Today, Friday, April 29"].tap()
        app.datePickers["Start Date"].tap()
        // set up start time to 7:00 PM
        app.datePickers["Start time"].tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "7")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        app.datePickers["Start time"].tap()
        // set up end time to 8:30 PM
        app.datePickers["End time"].tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "7")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        app.datePickers["End time"].tap()
        // set up meeting agenda
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.tap()
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.typeText("Sample Meeting Agenda")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        // select meeting type
        app.buttons["Online"].tap()
        // add meeting participants
        app.buttons["Add Participants"].tap()
        let tablesQuery = app.tables
        tablesQuery.cells["Account, Norah AlSalem, Full Stack Developer, circle"].children(matching: .other).element(boundBy: 0).tap()
        tablesQuery.cells["Account, Steve Jacobson, Developer, circle"].children(matching: .other).element(boundBy: 0).tap()
        app.buttons[" Save"].tap()
        app.buttons["Save"].tap()
        XCTAssert(app.alerts.element.staticTexts["Please enter a valid time"].waitForExistence(timeout: 2))
    }
    
    func test_generate_meeting_with_empty_meeting_title(){
        app.buttons["Calendar"].tap()
        app.buttons["Generate Meeting"].tap()
        // set up meeting title
        app.textFields["type title of the meeting"].tap()
        app.textFields["type title of the meeting"].typeText("")
        // set up meeting location
        app.textFields["type the location"].tap()
        app.textFields["type the location"].typeText("www.zoom.com")
        app.keyboards.buttons["return"].tap()
        // set up meeting date
        app.datePickers["Start Date"].tap()
        app.datePickers.collectionViews.buttons["Today, Friday, April 29"].tap()
        app.datePickers["Start Date"].tap()
        // set up start time to 7:00 PM
        app.datePickers["Start time"].tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "7")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        app.datePickers["Start time"].tap()
        // set up end time to 8:30 PM
        app.datePickers["End time"].tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "8")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        app.datePickers["End time"].tap()
        // set up meeting agenda
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.tap()
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.typeText("Sample Meeting Agenda")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        // select meeting type
        app.buttons["Online"].tap()
        // add meeting participants
        app.buttons["Add Participants"].tap()
        let tablesQuery = app.tables
        tablesQuery.cells["Account, Norah AlSalem, Full Stack Developer, circle"].children(matching: .other).element(boundBy: 0).tap()
        tablesQuery.cells["Account, Steve Jacobson, Developer, circle"].children(matching: .other).element(boundBy: 0).tap()
        app.buttons[" Save"].tap()
        app.buttons["Save"].tap()
        XCTAssert(app.alerts.element.staticTexts["All fields are required"].waitForExistence(timeout: 2))
    }
    
    func test_generate_meeting_with_empty_meeting_location(){
        app.buttons["Calendar"].tap()
        app.buttons["Generate Meeting"].tap()
        // set up meeting title
        app.textFields["type title of the meeting"].tap()
        app.textFields["type title of the meeting"].typeText("Meeting Test")
        // set up meeting location
        app.textFields["type the location"].tap()
        app.textFields["type the location"].typeText("")
        app.keyboards.buttons["return"].tap()
        // set up meeting date
        app.datePickers["Start Date"].tap()
        app.datePickers.collectionViews.buttons["Today, Friday, April 29"].tap()
        app.datePickers["Start Date"].tap()
        // set up start time to 7:00 PM
        app.datePickers["Start time"].tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "7")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        app.datePickers["Start time"].tap()
        // set up end time to 8:30 PM
        app.datePickers["End time"].tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "8")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        app.datePickers["End time"].tap()
        // set up meeting agenda
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.tap()
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.typeText("Sample Meeting Agenda")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        // select meeting type
        app.buttons["Online"].tap()
        // add meeting participants
        app.buttons["Add Participants"].tap()
        let tablesQuery = app.tables
        tablesQuery.cells["Account, Norah AlSalem, Full Stack Developer, circle"].children(matching: .other).element(boundBy: 0).tap()
        tablesQuery.cells["Account, Steve Jacobson, Developer, circle"].children(matching: .other).element(boundBy: 0).tap()
        app.buttons[" Save"].tap()
        app.buttons["Save"].tap()
        XCTAssert(app.alerts.element.staticTexts["All fields are required"].waitForExistence(timeout: 2))
    }
    
    func test_generate_meeting_with_empty_meeting_agenda(){
        app.buttons["Calendar"].tap()
        app.buttons["Generate Meeting"].tap()
        // set up meeting title
        app.textFields["type title of the meeting"].tap()
        app.textFields["type title of the meeting"].typeText("Meeting Test")
        // set up meeting location
        app.textFields["type the location"].tap()
        app.textFields["type the location"].typeText("www.zoom.com")
        app.keyboards.buttons["return"].tap()
        // set up meeting date
        app.datePickers["Start Date"].tap()
        app.datePickers.collectionViews.buttons["Today, Friday, April 29"].tap()
        app.datePickers["Start Date"].tap()
        // set up start time to 7:00 PM
        app.datePickers["Start time"].tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "9")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        app.datePickers["Start time"].tap()
        // set up end time to 8:30 PM
        app.datePickers["End time"].tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "10")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        app.datePickers["End time"].tap()
        // set up meeting agenda
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.tap()
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.typeText("")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        // select meeting type
        app.buttons["Online"].tap()
        // add meeting participants
        app.buttons["Add Participants"].tap()
        let tablesQuery = app.tables
        tablesQuery.cells["Account, Norah AlSalem, Full Stack Developer, circle"].children(matching: .other).element(boundBy: 0).tap()
        tablesQuery.cells["Account, Steve Jacobson, Developer, circle"].children(matching: .other).element(boundBy: 0).tap()
        app.buttons[" Save"].tap()
        app.buttons["Save"].tap()
        XCTAssert(app.alerts.element.staticTexts["All fields are required"].waitForExistence(timeout: 2))
    }
    
    func test_generate_meeting_with_no_participants(){
        app.buttons["Calendar"].tap()
        app.buttons["Generate Meeting"].tap()
        // set up meeting title
        app.textFields["type title of the meeting"].tap()
        app.textFields["type title of the meeting"].typeText("Meeting Test")
        // set up meeting location
        app.textFields["type the location"].tap()
        app.textFields["type the location"].typeText("www.zoom.com")
        app.keyboards.buttons["return"].tap()
        // set up meeting date
        app.datePickers["Start Date"].tap()
        app.datePickers.collectionViews.buttons["Today, Friday, April 29"].tap()
        app.datePickers["Start Date"].tap()
        // set up start time to 7:00 PM
        app.datePickers["Start time"].tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "9")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        app.datePickers["Start time"].tap()
        // set up end time to 8:30 PM
        app.datePickers["End time"].tap()
        app.datePickers.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "10")
        app.datePickers.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "00")
        app.datePickers.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: "PM")
        app.datePickers["End time"].tap()
        // set up meeting agenda
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.tap()
        scrollViewsQuery.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.typeText("Sample Meeting Agenda")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        // select meeting type
        app.buttons["Online"].tap()
        app.buttons["Save"].tap()
        XCTAssert(app.alerts.element.staticTexts["Please add at least one attendee"].waitForExistence(timeout: 2))
    }
    
    func test_notify_manager_of_attending_late_alert(){
        app.buttons["Services"].tap()
        app.buttons["Notify Manager"].tap()
        app.staticTexts["I'll be late"].tap()
        XCTAssert(app.alerts.element.staticTexts["Are you sure you want to inform your manager of being late?"].waitForExistence(timeout: 2))
    }
    
    func test_notify_manager_of_attending_early_alert(){
        app.buttons["Services"].tap()
        app.buttons["Notify Manager"].tap()
        app.staticTexts["I'll be early"].tap()
        XCTAssert(app.alerts.element.staticTexts["Are you sure you want to inform your manager of being early?"].waitForExistence(timeout: 2))
    }
    
    func test_request_leave_with_valid_data(){

        app.buttons["Services"].tap()
        app.buttons["Submit Request"].waitForExistence(timeout: 10)
        app.buttons["Submit Request"].tap()
        // select leave start date
        app.datePickers["from date"].tap()
        app.datePickers.collectionViews.buttons["Today, Saturday, April 30"].tap()
        app.datePickers["from date"].tap()
        // select leave end date
        app.datePickers["to date"].tap()
        app.datePickers.collectionViews.buttons["Today, Saturday, April 30"].tap()
        app.datePickers["to date"].tap()
        // select leave type
        app.staticTexts["Sick Leave"].tap()
        // add notes
        app.textViews["notes"].tap()
        app.textViews["notes"].typeText("Sick Leaves Notes")
        // select supporting document
        app.buttons["Select Supporting Document"].tap()
        app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.images["Photo, August 09, 2012, 12:55 AM"]/*[[".otherElements[\"Photos\"].scrollViews.otherElements",".otherElements[\"Photo, March 30, 2018, 10:14 PM, Photo, August 09, 2012, 12:55 AM, Photo, August 09, 2012, 12:29 AM, Photo, August 08, 2012, 9:52 PM, Photo, October 10, 2009, 12:09 AM, Photo, March 13, 2011, 3:17 AM\"].images[\"Photo, August 09, 2012, 12:55 AM\"]",".images[\"Photo, August 09, 2012, 12:55 AM\"]",".scrollViews.otherElements"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app.staticTexts["submit"].tap()
        XCTAssert(app.alerts.element.staticTexts["Your request has been submitted"].waitForExistence(timeout: 2))
    }
    
    func test_request_leave_with_no_supporting_documents(){
        app.buttons["Services"].tap()
        app.buttons["Submit Request"].tap()
        // select leave start date
        app.datePickers["from date"].tap()
        app.datePickers.collectionViews.buttons["Today, Saturday, April 30"].tap()
        app.datePickers["from date"].tap()
        // select leave end date
        app.datePickers["to date"].tap()
        app.datePickers.collectionViews.buttons["Today, Saturday, April 30"].tap()
        app.datePickers["to date"].tap()
        // select leave type
        app.staticTexts["Sick Leave"].tap()
        // add notes
        app.textViews["notes"].tap()
        app.textViews["notes"].typeText("Sick Leaves Notes")
        app.staticTexts["submit"].tap()
        XCTAssert(app.alerts.element.staticTexts["Please select a supporting document"].waitForExistence(timeout: 2))
    }
    
    func test_reset_password_with_valid_email(){
        app.buttons["Forgot password?"].tap()
        app.textFields["type your email"].tap()
        app.textFields["type your email"].typeText("aleenwaelss@gmail.com")
        app.buttons["Reset"].tap()
        XCTAssert(app.alerts.element.staticTexts["Check your inbox for a reset message"].waitForExistence(timeout: 2))
    }
    
    func test_reset_password_with_invalid_email(){
        app.buttons["Forgot password?"].tap()
        app.textFields["type your email"].tap()
        app.textFields["type your email"].typeText("Aleen")
        app.buttons["Reset"].tap()
        XCTAssert(app.alerts.element.staticTexts["Your email does not match our records. Please try again or contact your organization."].waitForExistence(timeout: 2))
    }
    
    
    func test_take_participants_attendance_alert(){
        app.buttons["Calendar"].tap()
        let scrollViewsQuery = app.scrollViews
        app.buttons["meeting card"].waitForExistence(timeout: 10)
        let meeting = scrollViewsQuery.otherElements.buttons["meeting card"]
        meeting.tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 0).tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 0).swipeUp(velocity: .fast)
        app.buttons["Take Attendance"].waitForExistence(timeout: 10)
        app.buttons["Take Attendance"].tap()
        let tablesQuery = app.tables
        app.buttons["Save"].tap()
        XCTAssert(app.alerts.element.staticTexts["You did not select any participant, this will mark all participants as \"Absent\", Do you want to proceed?"].waitForExistence(timeout: 2))
    }
    
    func test_take_participants_attendance(){
        app.buttons["Calendar"].tap()
        let scrollViewsQuery = app.scrollViews
        app.buttons["meeting card"].waitForExistence(timeout: 10)
        let meeting = scrollViewsQuery.otherElements.buttons["meeting card"]
        meeting.tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 0).tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 0).swipeUp(velocity: .fast)
        app.buttons["Take Attendance"].waitForExistence(timeout: 10)
        app.buttons["Take Attendance"].tap()
        let tablesQuery = app.tables
        tablesQuery.cells["Shahad Saeed, circle, Database Engineer"].children(matching: .other).element(boundBy: 0).tap()
        tablesQuery.cells["Account, Mary Jane, circle, Software Engineer"].children(matching: .other).element(boundBy: 0).tap()
        app.buttons["Save"].tap()
        app.staticTexts["Take attendance test"].waitForExistence(timeout: 10)
        XCTAssert(app.staticTexts["Take attendance test"].waitForExistence(timeout: 10))
    }
    
    func test_generate_meeting_MoM_with_empty_decisions(){
        app.buttons["Calendar"].tap()
        let scrollViewsQuery = app.scrollViews
        app.buttons["meeting card"].waitForExistence(timeout: 10)
        let meeting = scrollViewsQuery.otherElements.buttons["meeting card"]
        meeting.tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 0).tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 0).tap()
        app.buttons["Generate MoM"].waitForExistence(timeout: 10)
        app.buttons["Generate MoM"].tap()
        app.buttons["Save"].tap()
        XCTAssert(app.alerts.element.staticTexts["Decisions field cannot be empty"].waitForExistence(timeout: 2))
    }
    
    func test_generate_meeting_MoM_with_valid_data(){
        app.buttons["Calendar"].tap()
        let scrollViewsQuery = app.scrollViews
        app.buttons["meeting card"].waitForExistence(timeout: 10)
        let meeting = scrollViewsQuery.otherElements.buttons["meeting card"]
        meeting.tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 0).tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 0).tap()
        app.windows.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button).element(boundBy: 0).swipeUp(velocity: .fast)
        app.buttons["Generate MoM"].waitForExistence(timeout: 10)
        app.buttons["Generate MoM"].tap()
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.staticTexts["Enter Decisions"].tap()
        app.scrollViews.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.tap()
        app.scrollViews.otherElements.containing(.staticText, identifier:"Title").children(matching: .textView).element.typeText("Test Generate MoM")
        app.toolbars["Toolbar"].buttons["Done"].tap()
        app.buttons["Save"].tap()
        XCTAssert(app.staticTexts["Take attendance test"].waitForExistence(timeout: 10))
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
