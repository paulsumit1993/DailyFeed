//
//  DailySourceItemLayout.swift
//  DailyFeed
//
//  Created by TrianzDev on 20/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit

class DailySourceItemLayout: UICollectionViewFlowLayout {
    
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     Sets up the layout for the collectionView. 0 distance between each cell, and vertical layout
     */
    func setupLayout() {
        
        minimumInteritemSpacing = 0
        minimumLineSpacing = 7
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: 5, left: 6, bottom: 0, right: 6)
        headerReferenceSize = CGSize(width: 200, height: 20)
        footerReferenceSize = CGSize(width: 200, height: 20)
    }
    
    func itemHeight() -> CGFloat {
        return (collectionView!.bounds.width / 2) - 10
    }
    
    func itemWidth() -> CGFloat {
        return (collectionView!.bounds.width / 2) - 10
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
