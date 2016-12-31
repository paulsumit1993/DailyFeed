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
            newsImageView.addGradient([UIColor(white: 0, alpha: 0.6).CGColor, UIColor.clearColor().CGColor], locations: [0.0, 0.1])
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
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Hide Navigation bar on tap
        navigationController?.hidesBarsOnTap = true
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
    
    
    //MARK: Open News URL in Safari Browser Action
    @IBAction func openUrlInBrowser(sender: UIButton) {
        
        guard let urlString = receivedNewItem?.url, let url = NSURL(string: urlString) else { return }
        let svc = MySafariViewController(URL: url)
        self.presentViewController(svc, animated: true, completion: nil)
    }


    
}
