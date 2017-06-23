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

    override func layoutSubviews() {
        super.layoutSubviews()

        addGradient()
    }
    
    func setupCell() {
        self.contentView.layer.cornerRadius = 10.0
        self.contentView.layer.masksToBounds = true
    }
    
    func configure(with newsitems: DailyFeedModel) {
        self.newsItemTitleLabel.text = newsitems.title
        self.newsItemSourceLabel.text = newsitems.author
        self.newsItemPublishedAtLabel.text = newsitems.publishedAt?.dateFromTimestamp?.relativelyFormatted(short: true)
        if let imageURL = newsitems.urlToImage {
            self.newsItemImageView.downloadedFromLink(imageURL)
        }
    }


    func addGradient() {
        guard newsItemImageView.layer.sublayers?.count == nil else { return }

        newsItemImageView.addGradient([UIColor(white: 0, alpha: 0.5).cgColor,
                                       UIColor(white: 0, alpha: 0.5).cgColor],
                                      locations: [0.0, 1.0])
    }
}
