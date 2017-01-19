//
//  NewsDetailViewControllerTests.swift
//  DailyFeed
//
//  Created by TrianzDev on 19/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import XCTest
@testable import DailyFeed

class NewsDetailViewControllerTests: XCTestCase {
    var vc: NewsDetailViewController!
    var window: UIWindow!
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        vc = storyboard.instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController
    }
    
   
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUIStatusBarStyle() {
       XCTAssertEqual(vc.preferredStatusBarStyle, UIStatusBarStyle.lightContent)
    }
}
