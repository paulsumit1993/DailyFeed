//
//  UIImageExtension.swift
//  DailyFeed
//
//  Created by TrianzDev on 27/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func addGradient(color: [CGColor], locations: [NSNumber]) {
    
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.superview!.bounds
        gradient.colors = color
        gradient.locations = locations
        self.layer.addSublayer(gradient)
        
    }
    
}