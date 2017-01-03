//
//  DailyFeedNewsController+Extension.swift
//  DailyFeed
//
//  Created by TrianzDev on 03/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit


//MARK: CollectionView Delegate Methods
extension DailyFeedNewsController: UICollectionViewDelegateFlowLayout, UISearchResultsUpdating {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.resultsSearchController.active {
            return self.filteredNewsItems.count
        }
        else {
            return self.newsItems.count
        }
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        self.performSegueWithIdentifier("newsDetailSegue", sender: cell)
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DailyFeedItemCell", forIndexPath: indexPath) as! DailyFeedItemCell
        
        if self.resultsSearchController.active {
            
            cell.newsItemTitleLabel.text = filteredNewsItems[indexPath.row].title
            cell.newsItemSourceLabel.text = filteredNewsItems[indexPath.row].author
            cell.newsItemImageView.downloadedFromLink(filteredNewsItems[indexPath.row].urlToImage)
            
        } else {
            
            cell.newsItemTitleLabel.text = newsItems[indexPath.row].title
            cell.newsItemSourceLabel.text = newsItems[indexPath.row].author
            cell.newsItemImageView.downloadedFromLink(newsItems[indexPath.row].urlToImage)
        }
        
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "newsHeaderCell", forIndexPath: indexPath) as! NewHeaderCollectionReusableView
            
            headerView.newSourceImageView.downloadedFromLink(self.newsSourceUrl!)
            headerView.layer.masksToBounds = true
            
            return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "newsFooterCell", forIndexPath: indexPath)
            
            return footerView
            
        default:
            
            return UICollectionReusableView()
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        guard let width = self.collectionView?.bounds.width else { return CGSize(width: 10, height: 10) }
        
        return CGSize(width: (width / 2) - 10, height: (width / 2) - 5)
    }
    
    
    
    
    //MARK: SearchController Delegate
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        filteredNewsItems.removeAll(keepCapacity: false)
        
        if let searchString = searchController.searchBar.text {
            let searchResults = newsItems.filter { $0.title.lowercaseString.containsString(searchString.lowercaseString) || $0.author.lowercaseString.containsString(searchString.lowercaseString) }
            filteredNewsItems = searchResults
            
            self.collectionView?.reloadData()
        }
    }
}
