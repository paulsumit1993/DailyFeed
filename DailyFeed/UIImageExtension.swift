//
//  UIImageExtension.swift
//  DailyFeed
//
//  Created by Sumit Paul on 27/12/16.
//

import UIKit

extension UIImageView {

    func addGradient(_ color: [CGColor], locations: [NSNumber]) {

        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.superview!.frame
        gradient.colors = color
        gradient.locations = locations
        self.layer.addSublayer(gradient)
    }
}
