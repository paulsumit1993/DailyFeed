//
//  TodayImageCollectionViewCell.swift
//  DailyFeed
//
//  Created by TrianzDev on 31/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit
import RealmSwift

class TodayImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var todayNewsImageView: TSImageView! {
        didSet {
            todayNewsImageView.layer.cornerRadius = 5.0
        }
    }
    
    @IBOutlet weak var newsTitleLabel: UILabel! {
        didSet {
            if #available(iOSApplicationExtension 10.0, *) {
                newsTitleLabel.textColor = UIColor.black
            }
        }
    }

    @IBOutlet weak var publishedAtLabel: UILabel! {
        didSet {
            if #available(iOSApplicationExtension 10.0, *) {
                publishedAtLabel.textColor = UIColor.black
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        todayNewsImageView.clipsToBounds = true
    }
    
    func configure(with todaynewsitems: Results<DailyFeedRealmModel>, index: IndexPath) {
        self.todayNewsImageView.downloadedFromLink(todaynewsitems[index.row].urlToImage)
        self.newsTitleLabel.text = todaynewsitems[index.row].title
        self.publishedAtLabel.text = todaynewsitems[index.row].publishedAt.dateFromTimestamp?.relativelyFormatted(short: true)
    }
    
}
