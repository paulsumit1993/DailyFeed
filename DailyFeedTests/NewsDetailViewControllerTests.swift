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
        
        vc.receivedNewItem = DailyFeedModel(json: TestData.FeedModelJSON)
        
        _ = vc.view
    }
    
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testUIStatusBarStyle() {
        XCTAssertEqual(vc.preferredStatusBarStyle, UIStatusBarStyle.lightContent)
    }
    
    func testfadeUIElements() {
        vc.fadeUIElements(with: 0.0)
        XCTAssertEqual(vc.backButton.alpha, 0.0)
        XCTAssertEqual(vc.shareButton.alpha, 0.0)
        XCTAssertEqual(vc.swipeLeftButton.alpha, 0.0)
        
    }
    
    func testVCDismissal() {
        vc.dismissButtonTapped()
        print(vc.view)
        XCTAssertNil(vc.view)
    }
    
    
    func testVCDismissal2() {
        vc.dismissSwipeAction()
        XCTAssertNil(vc.view)
    }
    
    func testscreenShotMethodNotNil() {
        let image = vc.captureScreenShot()
        XCTAssertNotNil(image)
        if type(of: image) == UIImage?.self {
            XCTAssertTrue(true)
        } else {
            XCTAssertFalse(true)
        }
        
    }
    
}
