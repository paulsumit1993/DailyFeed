//
//  DailyFeedRealmModel.swift
//  DailyFeed
//
//  Created by Sumit Paul on 22/02/17.
//

import Foundation
import RealmSwift


final class DailyFeedRealmModel: Object {
        
    @objc dynamic var title: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var publishedAt: String = ""
    @objc dynamic var urlToImage: String = ""
    @objc dynamic var articleDescription: String = ""
    @objc dynamic var url: String = ""
    
    override static func primaryKey() -> String? {
        return "title"
    }
    
    //Helper to convert DailyFeedModel to DailyFeedRealmModel
    
    class func toDailyFeedRealmModel(from: DailyFeedModel) -> DailyFeedRealmModel {
        let item = DailyFeedRealmModel()
        item.title = from.title
        
        if let artDescription = from.articleDescription {
            item.articleDescription = artDescription
            
        }
        
        if let writer = from.author {
            item.author = writer
            
        }
        
        if let publishedTime = from.publishedAt {
            item.publishedAt = publishedTime
        }
        
        if let url = from.url {
            item.url = url
        }
        
        if let imageFromUrl = from.urlToImage {
            item.urlToImage = imageFromUrl
        }
        
        return item
    }
}
