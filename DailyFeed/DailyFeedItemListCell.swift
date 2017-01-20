//
//  DailyFeedItemListCell.swift
//  DailyFeed
//
//  Created by TrianzDev on 20/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit

class DailyFeedItemListCell: UICollectionViewCell {

    @IBOutlet weak var newsArticleImageView: TSImageView!
    @IBOutlet weak var newsArticleTitleLabel: UILabel!
    @IBOutlet weak var newsArticleAuthorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
