//
//  DailyFeedItemCell.swift
//  DailyFeed
//
//  Created by TrianzDev on 28/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit

class DailyFeedItemCell: UICollectionViewCell {

    @IBOutlet weak var newsItemImageView: TSImageView!
    @IBOutlet weak var newsItemTitleLabel: UILabel!
    @IBOutlet weak var newsItemSourceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        self.layer.cornerRadius = 5.0
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSizeMake(0, 0)
        self.layer.shadowRadius = 1
        self.layer.shouldRasterize = true

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addGradient()
    }
    
    func addGradient() {
        guard newsItemImageView.layer.sublayers?.count == nil else { return }
    
        newsItemImageView.addGradient([UIColor.clearColor().CGColor, UIColor(white: 0, alpha: 0.6).CGColor], locations: [0.0, 0.75])
    }

}
