//
//  TodayViewController.swift
//  News Now
//
//  Created by TrianzDev on 31/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var todayCollectionView: UICollectionView!
    var todayNewsItems = [DailyFeedModel]()
    
    var todaySource: String {
        get {
            guard let defaultSource = UserDefaults(suiteName: "group.com.trianz.DailyFeed.today")?.string(forKey: "source") else {
                return "the-wall-street-journal"
            }
            
            return defaultSource
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        todayCollectionView?.register(TodayImageCollectionViewCell.self,
                                 forCellWithReuseIdentifier: "todayImageCell")

                loadNewsData(todaySource)
        
        if #available(iOSApplicationExtension 10.0, *) {
            self.extensionContext?.widgetLargestAvailableDisplayMode = NCWidgetDisplayMode.expanded
        }
    }

    // MARK: - Load data from network
    func loadNewsData(_ source: String) {
        
        
        DailyFeedModel.getNewsItems(source) { (newsItem, error) in
            
            guard error == nil, let news = newsItem else { return }
            self.todayNewsItems = news
            DispatchQueue.main.async(execute: {
                self.todayCollectionView?.reloadData()
            })
        }
    }


    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        
         completionHandler(NCUpdateResult.newData)
    }
    
    @available(iOSApplicationExtension 10.0, *)
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if (activeDisplayMode == NCWidgetDisplayMode.compact) {
            self.preferredContentSize = maxSize
            print(maxSize.height)
        }
        else {
            print(maxSize.height)
            self.preferredContentSize = CGSize(width: maxSize.width, height: 330)
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayNewsItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let todayCell = collectionView.dequeueReusableCell(withReuseIdentifier: "todayImageCell", for: indexPath) as? TodayImageCollectionViewCell
        todayCell?.todayNewsImageView.downloadedFromLink(todayNewsItems[indexPath.row].urlToImage)
        todayCell?.newsTitleLabel.text = todayNewsItems[indexPath.row].title
        todayCell?.publishedAtLabel.text = todayNewsItems[indexPath.row].publishedAt.dateFromTimestamp?.relativelyFormatted(short: true)
        return todayCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: todayCollectionView.bounds.width, height: 110)
    }
}
