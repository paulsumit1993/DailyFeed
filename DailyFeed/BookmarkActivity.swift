//
//  BookmarkActivity.swift
//  DailyFeed
//
//  Created by TrianzDev on 10/02/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit
import RealmSwift

class BookmarkActivity: UIActivity {
    
    override var activityTitle: String? {
        return "Bookmark"
    }
    
    override var activityImage: UIImage? {
        return #imageLiteral(resourceName: "bookmark")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for activity in activityItems {
            if activity is DailyFeedModel {
                return true
                }
            }
        return false
    }

    
    override func prepare(withActivityItems activityItems: [Any]) {
        for activity in activityItems {
            if let activity = activity as? DailyFeedModel {
                let realm = try! Realm()
                try! realm.write {
                    realm.add(activity)
                }
                break
            }
        }
    }
}
