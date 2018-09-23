//
//  DailySourceItemLayout.swift
//  DailyFeed
//
//  Created by Sumit Paul on 20/01/17.
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

        minimumLineSpacing = 30
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets(top: 20, left: 5, bottom: 0, right: 5)
    }

    var itemHeight: CGFloat {
        return collectionView!.bounds.width
    }

    var itemWidth: CGFloat {
        return collectionView!.bounds.width - 35
    }

    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
        get {
            return CGSize(width: itemWidth, height: itemHeight)
        }
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }
}
