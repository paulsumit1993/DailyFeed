//
//  DailySourceItemListLayout.swift
//  DailyFeed
//
//  Created by TrianzDev on 20/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit


class DailySourceItemListLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    /**
     Sets up the layout for the collectionView. 0 distance between each cell, and vertical layout
     */
    func setupLayout() {
        minimumInteritemSpacing = 0
        minimumLineSpacing = 5
        scrollDirection = .vertical
    }
    
    func itemHeight() -> CGFloat {
        return (collectionView!.bounds.height / 5) - 3
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.bounds.width)
    }
    
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: itemWidth(), height: itemHeight())
        }
        get {
            return CGSize(width: itemWidth(), height: itemHeight())
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}
