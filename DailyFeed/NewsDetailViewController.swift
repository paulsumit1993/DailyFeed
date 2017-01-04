//
//  NewsDetailViewController.swift
//  DailyFeed
//
//  Created by TrianzDev on 27/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit
import SafariServices

class NewsDetailViewController: UIViewController {
    
    //MARK: News data declaration
    var receivedNewItem = DailyFeedModel?()
    
    //MARK: IBOutlets
    
    @IBOutlet weak var newsImageView: TSImageView! {
        didSet {
            
            newsImageView.downloadedFromLink((receivedNewItem?.urlToImage)!)
            newsImageView.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var newsTitleLabel: UILabel! {
        didSet {
            newsTitleLabel.text = receivedNewItem?.title
        }
    }
    
    @IBOutlet weak var contentTextView: UITextView! {
        didSet {
            contentTextView.text = receivedNewItem?.description
            contentTextView.textColor = UIColor.grayColor()
            contentTextView.font = UIFont.preferredFontForTextStyle(UIFontTextStyleSubheadline)
            contentTextView.sizeToFit()
        }
    }
    
    @IBOutlet weak var newsSourceLabel: UILabel! {
        didSet {
            newsSourceLabel.text = receivedNewItem?.author
        }
    }
    
    //MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add  Back Button
        addBackButton()
        
        //Setting gradient to newsImageView
        newsImageView.addGradient([UIColor(white: 0, alpha: 0.6).CGColor, UIColor.clearColor().CGColor, UIColor(white: 0, alpha: 0.6).CGColor], locations: [0.0, 0.1, 0.95])
        
        //Add parallax to UIImageView
        addParallaxToView(newsImageView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    //MARK: Back Button Init
    func addBackButton() {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back"), forState: UIControlState.Normal)
        backButton.addTarget(self, action: #selector(NewsDetailViewController.dismissButtonTapped), forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    //MARK: Back Button Dismiss action
    func dismissButtonTapped() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    //MARK: Add Parallax to UIImageView
    func addParallaxToView(vw: UIView) {
        let amount = 100
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .TiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .TiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
    
    
    //MARK: Open News URL in Safari Browser Action
    @IBAction func openUrlInBrowser(sender: UIButton) {
        
        guard let urlString = receivedNewItem?.url, let url = NSURL(string: urlString) else { return }
        let svc = MySafariViewController(URL: url)
        self.presentViewController(svc, animated: true, completion: nil)
    }
    
    
    
}
