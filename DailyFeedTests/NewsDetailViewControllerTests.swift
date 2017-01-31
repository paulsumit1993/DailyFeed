//
//  NewsDetailViewControllerTests.swift
//  DailyFeed
//
//  Created by Sumit Paul on 19/01/17.
//

import XCTest
@testable import DailyFeed

class NewsDetailViewControllerTests: XCTestCase {
    var nvc: NewsDetailViewController!
    var window: UIWindow!
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        nvc = storyboard.instantiateViewController(withIdentifier: "NewsDetailViewController") as? NewsDetailViewController

        nvc.receivedNewsItem = DailyFeedModel(json: TestData.FeedModelJSON)
        nvc.receivedNewsSourceLogo = "http://i.newsapi.org/the-wall-street-journal-s.png"
        _ = nvc.view
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testUIStatusBarStyle() {
        XCTAssertEqual(nvc.preferredStatusBarStyle, UIStatusBarStyle.lightContent)
    }

    func testfadeUIElements() {
        nvc.fadeUIElements(with: 0.0)
        XCTAssertEqual(nvc.backButton.alpha, 0.0)
        XCTAssertEqual(nvc.shareButton.alpha, 0.0)
        XCTAssertEqual(nvc.swipeLeftButton.alpha, 0.0)
    }

    func testscreenShotMethodNotNilAndOfTypeUIImage() {
        let image = nvc.captureScreenShot()
        XCTAssertNotNil(image)
        if type(of: image) == UIImage?.self {
            XCTAssertTrue(true)
        } else {
            XCTAssertFalse(true)
        }
    }
    
    
}
