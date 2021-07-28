//
//  BookmarkViewController.swift
//  DailyFeed
//
//  Created by Sumit Paul on 09/02/17.
//

import UIKit
import CoreSpotlight
import MobileCoreServices
import DZNEmptyDataSet
import RealmSwift

class BookmarkViewController: UIViewController {
    
    @IBOutlet private weak var bookmarkCollectionView: UICollectionView!
    private var bookmarkViewModel = BookmarkViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookmarkCollectionView.register(R.nib.bookmarkItemsCell)
        bookmarkCollectionView.emptyDataSetDelegate = self
        bookmarkCollectionView.emptyDataSetSource = self
        if #available(iOS 11.0, *) {
            bookmarkCollectionView?.dropDelegate = self
        }
        ///Register  viewmodel observer here
        bookmarkViewModel.observeDatabase { (changes) in
            self.observeForFeeds(changes: changes)
        }
    }
    
    private func observeForFeeds(changes: RealmCollectionChange<Results<DailyFeedRealmModel>>) {
        guard let collectionview = self.bookmarkCollectionView else { return }
        switch changes {
        case .initial:
            collectionview.reloadData()
            break
        case .update( _, let deletions, let insertions, _):
            collectionview.performBatchUpdates({
                collectionview.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0) }))
                collectionview.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
            }, completion: nil)
            
            if self.bookmarkViewModel.numberOfNewsItems == 0 || self.bookmarkViewModel.numberOfNewsItems == 1 { collectionview.reloadEmptyDataSet() }
            break
        case .error(let error):
            fatalError("\(error)")
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.bookmarkViewController.bookmarkSourceSegue.identifier {
            if let vc = segue.destination as? NewsDetailViewController {
                guard let cell = sender as? UICollectionViewCell else { return }
                guard let indexpath = self.bookmarkCollectionView.indexPath(for: cell) else { return }
                vc.receivedItemNumber = indexpath.row + 1
                vc.receivedNewsItem =  bookmarkViewModel.getDailyFeedForIndex(indexpath.row)
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

// MARK: - CollectionView Delegate Methods

extension BookmarkViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookmarkViewModel.numberOfRowsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.bookmarkItemsCell, for: indexPath)
        newsCell?.configure(with: bookmarkViewModel.getDailyFeedForIndex(indexPath.row))
        newsCell?.cellTapped = { cell in
            if let cellToDelete = self.bookmarkCollectionView.indexPath(for: cell)?.row {
                let item = self.bookmarkViewModel.getDailyFeedForIndex(cellToDelete) //self.newsItems[cellToDelete]
                self.bookmarkViewModel.removeDailyFeed(item)
            }
        }
        return newsCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bookmarkCollectionView.bounds.width, height: bookmarkCollectionView.bounds.height / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        self.performSegue(withIdentifier: R.segue.bookmarkViewController.bookmarkSourceSegue, sender: cell)
    }
}

// MARK: - DZNEmptyDataSet Delegate Methods
extension BookmarkViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return bookmarkViewModel.noDataErrorTitle
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        return bookmarkViewModel.noDataErrorDescription
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        return #imageLiteral(resourceName: "bookmark")
    }
    
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView) -> UIColor? {
        return UIColor.lightGray
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        return true
    }
}

// MARK: - Drop Delegate Methods

@available(iOS 11.0, *)
extension BookmarkViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        for coordinatorItem in coordinator.items {
            let itemProvider = coordinatorItem.dragItem.itemProvider
            if itemProvider.canLoadObject(ofClass: DailyFeedModel.self) {
                itemProvider.loadObject(ofClass: DailyFeedModel.self) { (object, error) in
                    DispatchQueue.main.async {
                        self.bookmarkViewModel.addDailyFeed(object as? DailyFeedModel)
                    }
                }
            }
        }
    }
}

