//
//  BookmarkViewController.swift
//  DailyFeed
//
//  Created by TrianzDev on 09/02/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit
import RealmSwift

class BookmarkViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var bookmarkCollectionView: UICollectionView!

    var newsItems: Results<DailyFeedModel>!
    
    var notificationToken: NotificationToken? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkCollectionView?.register(UINib(nibName: "DailyFeedItemListCell", bundle: nil),
                                         forCellWithReuseIdentifier: "DailyFeedItemListCell")
        observeDatabase()
    }

    func observeDatabase() {
        let realm = try! Realm()

        newsItems = realm.objects(DailyFeedModel.self)
        
        notificationToken = newsItems.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            guard let collectionview = self?.bookmarkCollectionView else { return }
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookmarkSourceSegue" {
            if let vc = segue.destination as? NewsDetailViewController {
            guard let cell = sender as? UICollectionViewCell else { return }
            guard let indexpath = self.bookmarkCollectionView.indexPath(for: cell) else { return }
            vc.receivedNewsItem = newsItems[indexpath.row]
            }
        }
    }
    
    deinit {
        notificationToken?.stop()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - CollectionView Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyFeedItemListCell", for: indexPath) as? DailyFeedItemListCell
        newsCell?.newsArticleTitleLabel.text = newsItems[indexPath.row].title
        newsCell?.newsArticleAuthorLabel.text = newsItems[indexPath.row].author
        newsCell?.newsArticleTimeLabel.text = newsItems[indexPath.row].publishedAt.dateFromTimestamp?.relativelyFormatted(short: true)
        newsCell?.newsArticleImageView.downloadedFromLink(newsItems[indexPath.row].urlToImage)
        return newsCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bookmarkCollectionView.bounds.width, height: bookmarkCollectionView.bounds.height / 5)
    }
    
     func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.performSegue(withIdentifier: "bookmarkSourceSegue", sender: cell)
        
    }
}
