//
//  BookmarkItemsCell.swift
//  DailyFeed
//
//  Created by Sumit Paul on 14/02/17.
//

import UIKit
import RealmSwift

class BookmarkItemsCell: UICollectionViewCell {

    var cellTapped: ((UICollectionViewCell) -> Void)?

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
    
    func configure(with newsitems: DailyFeedRealmModel) {
        self.newsArticleTitleLabel.text = newsitems.title
        self.newsArticleAuthorLabel.text = newsitems.author
        self.newsArticleTimeLabel.text = newsitems.publishedAt.dateFromTimestamp?.relativelyFormatted(short: true)
        self.newsArticleImageView.downloadedFromLink(newsitems.urlToImage)
    }
    
    @IBAction func deleteBookmarkArticle(_ sender: UIButton) {
        cellTapped?(self)
    }

}
