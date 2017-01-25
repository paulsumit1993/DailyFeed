//
//  TestData.swift
//  DailyFeed
//
//  Created by TrianzDev on 19/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import Foundation

typealias JSON = [String: AnyObject]

struct  TestData {
    static let FeedModelJSON: JSON = [
        "title": "The Nintendo Switch will launch on March 3rd for $299"  as AnyObject,
        "author": "Andrew Webster" as AnyObject,
        "publishedAt": "2017-01-13T04:03:09Z" as AnyObject,
        "urlToImage": "http://www.theverge.com/2017/1/12/14237060/nintendo-switch-console-launch-date-price-announced" as AnyObject,
        "description": "Nintendo has finally revealed the price and release date for its much-anticipated Switch console" as AnyObject,
        "url": "http://www.theverge.com/2017/1/12/14237060/nintendo-switch-console-launch-date-price-announced" as AnyObject
    ]

    static let CorruptFeedModelJSON: JSON = [
        "title": "The Nintendo Switch will launch on March 3rd for $299"  as AnyObject,
        "author": "Andrew Webster" as AnyObject,
        "urlToImage": "http://www.theverge.com/2017/1/12/14237060/nintendo-switch-console-launch-date-price-announced" as AnyObject,
        "description": "Nintendo has finally revealed the price and release date for its much-anticipated Switch console" as AnyObject
        ]

    static let FeedSourceJSON: JSON =  [
        "id": "abc-news-au"  as AnyObject,
        "name": "ABC News (AU)" as AnyObject,
        "category": "general" as AnyObject,
        "urlsToLogos": [
            "small": "http://i.newsapi.org/abc-news-au-s.png",
            "medium": "http://i.newsapi.org/abc-news-au-m.png",
            "large": "http://i.newsapi.org/abc-news-au-l.png"
            ] as AnyObject
    ]

    static let CorruptfeedSourceJSON: JSON = [
        "id": "abc-news-au"  as AnyObject,
        "category": "general" as AnyObject,
        "urlsToLogos": [
            "small": "http://i.newsapi.org/abc-news-au-s.png",
            "medium": "http://i.newsapi.org/abc-news-au-m.png",
            "large": "http://i.newsapi.org/abc-news-au-l.png"
            ] as AnyObject
    ]

}
