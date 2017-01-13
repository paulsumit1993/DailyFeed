//
//  DailyFeedModelTests.swift
//  DailyFeed
//
//  Created by TrianzDev on 13/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import XCTest
@testable import DailyFeed

typealias JSON = [String: AnyObject]


class DailyFeedModelTests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDailyFeedModel() {
        
        //Mock Data
        let json: JSON = [
                          "title": "The Nintendo Switch will launch on March 3rd for $299"  as AnyObject,
                          "author": "Andrew Webster" as AnyObject,
                          "publishedAt": "2017-01-13T04:03:09Z" as AnyObject,
                          "urlToImage": "http://www.theverge.com/2017/1/12/14237060/nintendo-switch-console-launch-date-price-announced" as AnyObject,
                          "description": "Nintendo has finally revealed the price and release date for its much-anticipated Switch console: it’s launching on March 3rd worldwide, and in North America the console will be available for..." as AnyObject,
                          "url":"http://www.theverge.com/2017/1/12/14237060/nintendo-switch-console-launch-date-price-announced" as AnyObject
                         ]
        
        let corruptJson: JSON = [
            "title": "The Nintendo Switch will launch on March 3rd for $299"  as AnyObject,
            "author": "Andrew Webster" as AnyObject,
            "urlToImage": "http://www.theverge.com/2017/1/12/14237060/nintendo-switch-console-launch-date-price-announced" as AnyObject,
            "description": "Nintendo has finally revealed the price and release date for its much-anticipated Switch console: it’s launching on March 3rd worldwide, and in North America the console will be available for..." as AnyObject,
        ]
        
        let model = DailyFeedModel(json: json)
        
        XCTAssertNotNil(model)
        
        XCTAssertEqual(model?.title, "The Nintendo Switch will launch on March 3rd for $299")
        XCTAssertEqual(model?.author, "Andrew Webster")
        XCTAssertEqual(model?.publishedAt, "2017-01-13T04:03:09Z")
        XCTAssertEqual(model?.urlToImage, "http://www.theverge.com/2017/1/12/14237060/nintendo-switch-console-launch-date-price-announced")
        XCTAssertEqual(model?.description, "Nintendo has finally revealed the price and release date for its much-anticipated Switch console: it’s launching on March 3rd worldwide, and in North America the console will be available for...")
        XCTAssertEqual(model?.url, "http://www.theverge.com/2017/1/12/14237060/nintendo-switch-console-launch-date-price-announced")
        
        //Test with corrupt data
        XCTAssertNil(DailyFeedModel(json: corruptJson))
    }
    
    func testGetNewsItems() {
        
        var dataModel = [DailyFeedModel]()
        let exp = expectation(description: "Get News atricles")
        
        DailyFeedModel.getNewsItems("fortune") { (items, error) in
            guard let items = items else {
                XCTFail("Could not parse dailyfeed items")
                return
            }
            dataModel = items
            exp.fulfill()
        }
        
        self.waitForExpectations(timeout: 6) { error in
            XCTAssertNil(error, "Fatal Error")
            XCTAssertGreaterThan(dataModel.count, 0)
        }
        
    }
    
    
}
