//
//  TSActivityIndicator.swift
//  DailyFeed
//
//  Created by TrianzDev on 03/01/17.
//  Copyright © 2017 trianz. All rights reserved.
//

import UIKit

class TSActivityIndicator: UIActivityIndicatorView {

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK: Add Custom activity indicator
    func setupTSActivityIndicator(container: UIView) {
        let window = UIApplication.sharedApplication().keyWindow
        container.frame = UIScreen.mainScreen().bounds
        container.backgroundColor = UIColor(hue: 0/360, saturation: 0/100, brightness: 0/100, alpha: 0.1)
        
        let loadingView: UIView = UIView()
        loadingView.frame = CGRectMake(0, 0, 80, 80)
        loadingView.center = container.center
        loadingView.backgroundColor = UIColor.blackColor()
        loadingView.clipsToBounds = true
        loadingView.layer.cornerRadius = 5
        
        self.frame = CGRectMake(0, 0, 40, 40)
        self.hidesWhenStopped = true
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        self.color = UIColor.whiteColor()
        self.center = CGPointMake(loadingView.frame.size.width / 2, loadingView.frame.size.height / 2)
        loadingView.addSubview(self)
        container.addSubview(loadingView)
        window?.addSubview(container)
        self.startAnimating()
    }


}
