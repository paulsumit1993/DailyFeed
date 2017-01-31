//
//  NewHeaderCollectionReusableView.swift
//  DailyFeed
//
//  Created by Sumit Paul on 30/12/16.
//

import UIKit

class NewHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var newSourceImageView: TSImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        newSourceImageView.layer.shadowColor = UIColor.black.cgColor
        newSourceImageView.layer.shadowOffset = CGSize(width: 0, height: 1)
        newSourceImageView.layer.shadowOpacity = 0.1
        newSourceImageView.layer.shadowRadius = 2.0
    }
}
