//
//  TodayImageCollectionViewCell.swift
//  DailyFeed
//
//  Created by TrianzDev on 31/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit

class TodayImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var todayNewsImageView: TSImageView! {
        didSet {
            todayNewsImageView.layer.cornerRadius = 5.0
        }
    }
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var publishedAtLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        todayNewsImageView.clipsToBounds = true
    }
    
}
