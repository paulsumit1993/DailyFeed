//
//  DailyFeedItemCell.swift
//  DailyFeed
//
//  Created by Sumit Paul on 28/12/16.
//

import UIKit

class DailyFeedItemCell: UICollectionViewCell {

    @IBOutlet weak var newsItemImageView: TSImageView!
    @IBOutlet weak var newsItemTitleLabel: UILabel!
    @IBOutlet weak var newsItemSourceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true;
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width:5.0,height: 15.0)
        self.layer.shadowRadius = 20.0
        self.layer.shadowOpacity = 1.0
        self.layer.masksToBounds = false;
        //self.layer.shadowPath = UIBezierPath(roundedRect:self.bounds, cornerRadius:self.contentView.layer.cornerRadius).cgPath
        
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        addGradient()
    }
    
    func configure(with newsitems: DailyFeedModel) {
        self.newsItemTitleLabel.text = newsitems.title
        self.newsItemSourceLabel.text = newsitems.author
        self.newsItemImageView.downloadedFromLink(newsitems.urlToImage)
    }


    func addGradient() {
        guard newsItemImageView.layer.sublayers?.count == nil else { return }

        newsItemImageView.addGradient([UIColor(white: 0, alpha: 0.5).cgColor,
                                       UIColor(white: 0, alpha: 0.5).cgColor],
                                      locations: [0.0, 1.0])
    }
}
