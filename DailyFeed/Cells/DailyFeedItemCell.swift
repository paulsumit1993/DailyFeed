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
    @IBOutlet weak var newsItemPublishedAtLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
        
    }
    
    override func prepareForReuse() {
        newsItemImageView.image = nil
    }
    
    func setupCell() {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
        if #available(iOS 13.0, *) {
            self.contentView.layer.borderWidth = 0.2
            self.contentView.layer.borderColor = UIColor.label.cgColor
        }
    }
    
    func configure(with newsitems: DailyFeedModel, ltr: Bool) {
        self.newsItemTitleLabel.text = newsitems.title
        self.newsItemSourceLabel.text = newsitems.author
        self.newsItemPublishedAtLabel.text = newsitems.publishedAt?.dateFromTimestamp?.relativelyFormatted(short: true)
        if let imageURL = newsitems.urlToImage {
            self.newsItemImageView.downloadedFromLink(imageURL)
        }
        if ltr {
            self.newsItemTitleLabel.textAlignment = .right
            self.newsItemSourceLabel.textAlignment = .right
        } else {
            self.newsItemTitleLabel.textAlignment = .left
            self.newsItemSourceLabel.textAlignment = .left
        }
    }
}
