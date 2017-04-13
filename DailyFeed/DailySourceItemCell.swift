//
//  DailySourceItemCell.swift
//  DailyFeed
//
//  Created by Sumit Paul on 11/01/17.
//

import UIKit

class DailySourceItemCell: UITableViewCell {

    @IBOutlet weak var sourceImageView: TSImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle  = .none
    }
    
}
