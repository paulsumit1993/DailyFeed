//
//  BookmarkItemsCell.swift
//  DailyFeed
//
//  Created by TrianzDev on 14/02/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit

class BookmarkItemsCell: UICollectionViewCell {

    var cellTapped: ((UICollectionViewCell) -> Void)? = nil

    @IBOutlet weak var newsArticleImageView: TSImageView! {
        didSet {
            newsArticleImageView.layer.cornerRadius = 5.0
            newsArticleImageView.layer.borderColor = UIColor(white: 0.1, alpha: 0.1).cgColor
            newsArticleImageView.layer.borderWidth = 0.5
            newsArticleImageView.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var newsArticleTitleLabel: UILabel!
    @IBOutlet weak var newsArticleAuthorLabel: UILabel!
    @IBOutlet weak var newsArticleTimeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 4
    }
    
    @IBAction func deleteBookmarkArticle(_ sender: UIButton) {
        cellTapped?(self)
    }

}
