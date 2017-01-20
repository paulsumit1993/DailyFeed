//
//  DailyFeedNewsController+Extension.swift
//  DailyFeed
//
//  Created by TrianzDev on 03/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit


//MARK: CollectionView Delegate Methods
extension DailyFeedNewsController: UICollectionViewDelegateFlowLayout {
    
    
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
            return self.newsItems.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        self.performSegue(withIdentifier: "newsDetailSegue", sender: cell)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DailyFeedItemCell", for: indexPath) as! DailyFeedItemCell
            
            cell.newsItemTitleLabel.text = newsItems[indexPath.row].title
            cell.newsItemSourceLabel.text = newsItems[indexPath.row].author
            cell.newsItemImageView.downloadedFromLink(newsItems[indexPath.row].urlToImage)
   
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "newsHeaderCell", for: indexPath) as! NewHeaderCollectionReusableView
            
            headerView.newSourceImageView.downloadedFromLink(self.newsSourceUrlLogo!)
            headerView.layer.masksToBounds = true
            
            return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "newsFooterCell", for: indexPath)
            
            return footerView
            
        default:
            
            return UICollectionReusableView()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let width = self.collectionView?.bounds.width else { return CGSize(width: 10, height: 10) }
        
        return CGSize(width: (width / 2) - 10, height: (width / 2) - 5)
    }

    //MARK: ScrollViewDidScroll
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //  print("inside scroll")
        
        if let visibleCells = self.collectionView?.visibleCells as? [DailyFeedItemCell] {
            for parallaxCell in visibleCells {
                let yOffset = (((self.collectionView?.contentOffset.y)! - parallaxCell.frame.origin.y) / imageHeight) * OffsetSpeed
                parallaxCell.offset(CGPoint(x: 0.0, y: yOffset))
            }
        }
    }
}
