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
    
    //MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        //Add  Back Button
        addBackButton()
        //Setting gradient to newsImageView
        newsImageView.addGradient([UIColor(white: 0, alpha: 0.6).cgColor, UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.6).cgColor], locations: [0.0, 0.1, 0.95])
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    //MARK: Back Button Init
    func addBackButton() {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backButton.setImage(UIImage(named: "back"), for: UIControlState())
        backButton.addTarget(self, action: #selector(NewsDetailViewController.dismissButtonTapped), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    //MARK: Back Button Dismiss action
    func dismissButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Open News URL in Safari Browser Action
    @IBAction func openNewInSafari(_ sender: UISwipeGestureRecognizer) {
        guard let urlString = receivedNewItem?.url, let url = URL(string: urlString) else { return }
        let svc = MySafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
    }
    
}
