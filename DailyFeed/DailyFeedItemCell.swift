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
        self.layer.cornerRadius = 5.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addGradient()
    }
    
    //MARK: Add Gradient to UIImageView
    func addGradient() {
        guard newsItemImageView.layer.sublayers?.count == nil else { return }
    
        newsItemImageView.addGradient([UIColor.clearColor().CGColor, UIColor(white: 0, alpha: 0.6).CGColor], locations: [0.0, 0.75])
        addParallaxToView(newsItemImageView)
        
    }
    
    //MARK: Add Parallax to UIImageView
    func addParallaxToView(vw: UIView) {
        let amount = 10
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }

}
