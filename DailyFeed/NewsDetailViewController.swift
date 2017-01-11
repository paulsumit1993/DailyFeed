//
//  NewsDetailViewController.swift
//  DailyFeed
//
//  Created by TrianzDev on 27/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit
import SafariServices

class NewsDetailViewController: UIViewController, SFSafariViewControllerDelegate {
    
    //MARK: News data declaration
    var receivedNewItem: DailyFeedModel? = nil
    
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
            contentTextView.textColor = UIColor.gray
            contentTextView.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
            contentTextView.sizeToFit()
        }
    }
    
    @IBOutlet weak var newsSourceLabel: UILabel! {
        didSet {
            newsSourceLabel.text = receivedNewItem?.author
        }
    }
    
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.layer.shadowColor = UIColor.black.cgColor
            backButton.layer.shadowRadius = 2.0
            backButton.layer.shadowOpacity = 1.0
            backButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        }
    }
    
    //MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        //Setting gradient to newsImageView
        newsImageView.addGradient([UIColor(white: 0, alpha: 0.6).cgColor, UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.6).cgColor], locations: [0.0, 0.05, 0.95])
        
    }
    
    //MARK: Back Button Dismiss action
    @IBAction func dismissButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissSwipeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: Open News URL in Safari Browser Action
    @IBAction func openNewInSafari(_ sender: UISwipeGestureRecognizer) {
        guard let urlString = receivedNewItem?.url, let url = URL(string: urlString) else { return }
        let svc = MySafariViewController(url: url)
        svc.delegate = self
        self.present(svc, animated: true, completion: nil)
    }
    
}
