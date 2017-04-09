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
    
    func updateNewsImageView(_ cutoff: CGFloat) {
        
        let newsImageMaskLayer = CAShapeLayer()
        self.layer.mask = newsImageMaskLayer
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: self.bounds.height - cutoff))
        newsImageMaskLayer.path = path.cgPath
    }
}
