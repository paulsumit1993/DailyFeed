//
//  DailySourceItemCell.swift
//  DailyFeed
//
//  Created by TrianzDev on 11/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit

class DailySourceItemCell: UITableViewCell {

    @IBOutlet weak var sourceImageView: TSImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle  = .none
    }

}
