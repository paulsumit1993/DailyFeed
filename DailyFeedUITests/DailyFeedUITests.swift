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
         let cellsQuery = app.collectionViews.cells
      cellsQuery.otherElements.containing(.staticText, identifier:"2h").children(matching: .other).element.tap()
             //app.navigationBars["Νέα της ημέρας"].buttons["sources"].tap()
      snapshot("1Detail")
      /*
      let app = XCUIApplication()
      let cellsQuery = app.collectionViews.cells
      
      
      app/*@START_MENU_TOKEN@*/.staticTexts["An hour ago - Open Web site"]/*[[".buttons[\"An hour ago - Open Web site\"].staticTexts[\"An hour ago - Open Web site\"]",".staticTexts[\"An hour ago - Open Web site\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      
      let bottombrowsertoolbarToolbar = app/*@START_MENU_TOKEN@*/.toolbars["BottomBrowserToolbar"]/*[[".otherElements[\"SafariWindow?View=Narrow&BarsKeptMinimized=false&UUID=1D242D04-94B6-4C95-9F5A-32C34739E427&SupportsTabBar=false\"].toolbars[\"BottomBrowserToolbar\"]",".toolbars[\"BottomBrowserToolbar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
      bottombrowsertoolbarToolbar/*@START_MENU_TOKEN@*/.buttons["TabsButton"]/*[[".buttons[\"Tabs\"]",".buttons[\"TabsButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      bottombrowsertoolbarToolbar.tap()
      app/*@START_MENU_TOKEN@*/.icons["News of the day"]/*[[".otherElements[\"Home screen icons\"]",".icons.icons[\"News of the day\"]",".icons[\"News of the day\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
      app.buttons["back"].tap()
      app.navigationBars["Science"].buttons["sources"].tap()
      app.tables/*@START_MENU_TOKEN@*/.staticTexts["General"]/*[[".cells.staticTexts[\"General\"]",".staticTexts[\"General\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
      cellsQuery.otherElements.containing(.staticText, identifier:"43min").children(matching: .other).element.tap()
      cellsQuery.otherElements.containing(.staticText, identifier:"Τάσος Τεργιάκης: Δείτε πρώτη φορά την υπέροχη γυναίκα του (Photos) - Gossip-tv.gr").children(matching: .other).element.tap()
         */
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
}
