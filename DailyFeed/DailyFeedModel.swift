//
//  DailyFeedModel.swift
//  DailyFeed
//
//  Created by Sumit Paul on 27/12/16.
//
import Realm
import RealmSwift

//Data Model
class DailyFeedModel: Object {

    dynamic var title: String = ""
    dynamic var author: String = ""
    dynamic var publishedAt: String = ""
    dynamic var urlToImage: String = ""
    dynamic var articleDescription: String = ""
    dynamic var url: String = ""
}
