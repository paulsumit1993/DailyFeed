//
//  DailyFeedUITests.swift
//  DailyFeedUITests
//
//  Created by Sumit Paul on 27/12/16.
//

import XCTest

class DailyFeedUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }
    
    func testArticle() {
        let app = XCUIApplication()
        snapshot("0Launch")
        app.collectionViews.cells.otherElements.containing(.staticText, identifier:"Newsit").children(matching: .other).element.tap()
        snapshot("0Launch")
        app.buttons["Μία ώρα πριν - Περισσότερα..."].tap()
        snapshot("0Launch")
    }
    
    func testSources()  {
        let app = XCUIApplication()
        snapshot("0Launch")
        app.navigationBars["Νέα της ημέρας"].buttons["sources"].tap()
        snapshot("0Launch")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
