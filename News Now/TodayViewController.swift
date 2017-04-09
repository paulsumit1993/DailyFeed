//
//  TodayViewController.swift
//  News Now
//
//  Created by TrianzDev on 31/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit
import NotificationCenter
import SafariServices
import RealmSwift

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var todayCollectionView: UICollectionView!
    
    var todayNewsItems: Results<DailyFeedRealmModel>!
    
    var notificationToken: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayCollectionView?.register(UINib(nibName: "TodayImageCollectionViewCell", bundle: nil),
                                 forCellWithReuseIdentifier: "todayImageCell")

        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        }
        observeDatabase()

    }
    
    func observeDatabase() {
        //Realm Shared DB Setup
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.trianz.DailyFeed.today")
        let realmURL = container?.appendingPathComponent("db.realm")
        var config = Realm.Configuration()
        config.fileURL = realmURL
        config.schemaVersion = 3
        config.migrationBlock = { migration, oldSchemaVersion in
            if (oldSchemaVersion < 3) {
                
            }
        }
        Realm.Configuration.defaultConfiguration = config
        let realm = try! Realm()
        todayNewsItems = realm.objects(DailyFeedRealmModel.self)
        notificationToken = todayNewsItems.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let collectionview = self?.todayCollectionView else { return }
            switch changes {
            case .initial:
                collectionview.reloadData()
                break
            case .update( _, let deletions, let insertions, _):
                collectionview.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
                //bookmarkCollectionView
                collectionview.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0) }))
                break
            case .error(let error):
                fatalError("\(error)")
                break
            }
        }
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.view.layoutIfNeeded()
    }


    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        observeDatabase()
        completionHandler(NCUpdateResult.newData)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize
        }
        else {
            self.preferredContentSize = CGSize(width: maxSize.width, height: 330)
        }
    }
    
    deinit {
        notificationToken?.stop()
    }
    
    
    // MARK: - CollectionView Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayNewsItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let todayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayImageCell", for: indexPath) as? TodayImageCollectionViewCell
        todayCell?.configure(with: todayNewsItems, index: indexPath)
        return todayCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: todayCollectionView.bounds.width, height: 110)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let appURL = URL(string: todayNewsItems[indexPath.row].url) {
        self.extensionContext?.open(appURL, completionHandler: nil)
        }
    }
}
