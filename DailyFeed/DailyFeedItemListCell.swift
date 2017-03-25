//
//  DailyFeedItemListCell.swift
//  DailyFeed
//
//  Created by Sumit Paul on 20/01/17.
//

import UIKit

class DailyFeedItemListCell: UICollectionViewCell {
    
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
    }
    
    func configure(with newsitem: [DailyFeedModel], index: IndexPath) {
        self.newsArticleTitleLabel.text = newsitem[index.row].title
        self.newsArticleAuthorLabel.text = newsitem[index.row].author
        self.newsArticleTimeLabel.text = newsitem[index.row].publishedAt.dateFromTimestamp?.relativelyFormatted(short: true)
        self.newsArticleImageView.downloadedFromLink(newsitem[index.row].urlToImage)
    }
}
