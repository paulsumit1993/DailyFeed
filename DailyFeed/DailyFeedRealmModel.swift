//
//  DailyFeedRealmModel.swift
//  DailyFeed
//
//  Created by TrianzDev on 22/02/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import RealmSwift

class DailyFeedRealmModel: Object {
    
    dynamic var title: String = ""
    dynamic var author: String = ""
    dynamic var publishedAt: String = ""
    dynamic var urlToImage: String = ""
    dynamic var articleDescription: String = ""
    dynamic var url: String = ""
    
    //Helper to convert DailyFeedModel to DailyFeedRealmModel
    
    class func toDailyFeedRealmModel(from: DailyFeedModel) -> DailyFeedRealmModel {
        let item = DailyFeedRealmModel()
        item.title = from.title
        item.articleDescription = from.description
        item.author = from.author
        item.url = from.url
        item.urlToImage = from.urlToImage
        item.publishedAt = from.publishedAt
        return item
    }
}
