//
//  TSActivityIndicator.swift
//  DailyFeed
//
//  Created by Sumit Paul on 03/01/17.
//

import UIKit

class TSActivityIndicator: UIActivityIndicatorView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: Add Custom activity indicator
    func setupTSActivityIndicator(_ container: UIView) {
        let window = UIApplication.shared.keyWindow
        container.frame = UIScreen.main.bounds
        container.backgroundColor = UIColor(hue: 0/360, saturation: 0/100, brightness: 0/100, alpha: 0.1)
        let loadingView: UIView = UIView()
        loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        
        //Add parallax to loading indicator
        addParallaxToView(vw: loadingView, amount: 20)
        loadingView.center = container.center
        loadingView.backgroundColor = .black
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 5

        self.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        self.hidesWhenStopped = true
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        self.color = .white
        self.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
        loadingView.addSubview(self)
        container.addSubview(loadingView)
        window?.addSubview(container)
        self.startAnimating()
    }
    
     fileprivate func addParallaxToView(vw: UIView, amount: Int) {
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
}
