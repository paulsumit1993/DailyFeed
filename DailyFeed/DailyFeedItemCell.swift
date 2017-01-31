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
        self.layer.cornerRadius = 5.0
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        addGradient()
    }

    func addGradient() {
        guard newsItemImageView.layer.sublayers?.count == nil else { return }

        newsItemImageView.addGradient([UIColor(white: 0, alpha: 0.5).cgColor,
                                       UIColor(white: 0, alpha: 0.5).cgColor],
                                      locations: [0.0, 1.0])
    }
}
