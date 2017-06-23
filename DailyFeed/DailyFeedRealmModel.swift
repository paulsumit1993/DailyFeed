//
//  DailyFeedRealmModel.swift
//  DailyFeed
//
//  Created by Sumit Paul on 22/02/17.
//

import Foundation
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
