//
//  BookmarkViewModel.swift
//  DailyFeed
//
//  Created by Kevin Vishal on 08/10/20.
//  Copyright © 2020 trianz. All rights reserved.
//

import UIKit
import RealmSwift

class BookmarkViewModel: NSObject {
    
    /// All news items
    private(set) var newsItems: Results<DailyFeedRealmModel>!
    /// Realm NotificationToken
    private(set) var notificationToken: NotificationToken? = nil
    
    typealias ObserverHandler = ((RealmCollectionChange<Results<DailyFeedRealmModel>>)) -> Void
    
    /// Number of  news items.
    var numberOfNewsItems : Int {
        return newsItems.count
    }
    /// Number of sections in the view.
    func numberOfSections() -> Int {
        return 1
    }
    /// Number of rows in each section.
    func numberOfRowsInSection(section : Int) -> Int {
        return newsItems.count
    }
    /// DailyFeed for each row in section.
    func getDailyFeedForIndex(_ index : Int) -> DailyFeedRealmModel {
        return newsItems[index]
    }
    
    func observeDatabase(_ handler : @escaping ObserverHandler) {
        
        let realm = try! Realm()
        newsItems = realm.objects(DailyFeedRealmModel.self)
        notificationToken = newsItems.observe({ (changes) in
            handler(changes)
        })
    }
    
    ///Delete Feed Item
    func removeDailyFeed(_ feedItem : DailyFeedRealmModel) -> Void {
        let realm = try! Realm()
        try! realm.write {
            realm.delete(feedItem)
        }
    }
    
    ///Add Feed Item
    func addDailyFeed(_ dailyFeedModel : DailyFeedModel?) -> Void {
        let realm = try! Realm()
        guard let dailyfeedmodel = dailyFeedModel else {
            return
        }
        let dailyfeedRealmModel = DailyFeedRealmModel.toDailyFeedRealmModel(from: dailyfeedmodel)
        try! realm.write {
            realm.add(dailyfeedRealmModel, update: .all)
        }
    }
    
    ///Empty Dataset Title
    var noDataErrorTitle : NSAttributedString {
        let str = "No Articles Bookmarked"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    ///Empty Dataset Description
    var noDataErrorDescription : NSAttributedString {
        let str = "Your Bookmarks will appear here."
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
}
