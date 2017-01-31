//
//  SFsafaricontrollerTests.swift
//  DailyFeed
//
//  Created by Sumit Paul on 13/01/17.
//

import XCTest
@testable import DailyFeed

class SFsafaricontrollerTests: XCTestCase {

    var sfvc: MySafariViewController?
    override func setUp() {
        super.setUp()
        sfvc = MySafariViewController(url: URL(string: "https://www.google.com")!)
        sfvc?.viewDidLoad()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testSFVCTintColor() {
        if #available(iOS 10.0, *) {
            XCTAssertEqual(sfvc?.preferredControlTintColor, .black)
        }
    }

    func testWhetherStatusBarStyleisDefaultWhenViewIsLoaded() {
        sfvc?.viewWillAppear(true)
        XCTAssertEqual(sfvc?.preferredStatusBarStyle, UIStatusBarStyle.default)
    }

}
