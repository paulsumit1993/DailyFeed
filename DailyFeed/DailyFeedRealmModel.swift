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
}
