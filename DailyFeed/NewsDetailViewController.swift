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
            newsImageView.addGradient([UIColor(white: 0, alpha: 0.6).cgColor, UIColor.clear.cgColor, UIColor(white: 0, alpha: 0.6).cgColor], locations: [0.0, 0.05, 0.85])
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
    
    @IBOutlet weak var shareButton: UIButton! {
        didSet {
            shareButton.layer.shadowColor = UIColor.black.cgColor
            shareButton.layer.shadowRadius = 2.0
            shareButton.layer.shadowOpacity = 1.0
            shareButton.layer.shadowOffset = CGSize(width: 0, height: 1)
        }
    }
    
    @IBOutlet weak var swipeLeftButton: UIButton!
    
    //MARK: View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide Nav bar
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    
    //MARK: Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: Back Button Dismiss action
    @IBAction func dismissButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func dismissSwipeAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: share article
    @IBAction func shareArticle(_ sender: UIButton) {
        
        fadeUIElements(with: 0.0)
        
        let delay = DispatchTime.now() + 0.11
        DispatchQueue.main.asyncAfter(deadline: delay) {
            
            guard let articleURL = self.receivedNewItem?.url, let articleImage = self.screenShotMethod() else { return }
            
            let activityVC = UIActivityViewController(activityItems: [articleURL, articleImage], applicationActivities: nil)
            
            activityVC.excludedActivityTypes = [UIActivityType.saveToCameraRoll, UIActivityType.copyToPasteboard,UIActivityType.airDrop,UIActivityType.addToReadingList,UIActivityType.assignToContact,UIActivityType.postToTencentWeibo,UIActivityType.postToVimeo,UIActivityType.print ,UIActivityType.postToWeibo]
            
            activityVC.completionWithItemsHandler = {(activityType, completed: Bool, _, _) in
                self.fadeUIElements(with: 1.0)
            }
            
            self.present(activityVC, animated: true, completion: nil)
        }
        
    }
    
    //Helper to toggle UI elements before and after screenshot capture
    fileprivate func fadeUIElements(with alpha: CGFloat) {
        UIView.animate(withDuration: 0.1, animations: {
            self.backButton.alpha = alpha
            self.shareButton.alpha = alpha
            self.swipeLeftButton.alpha = alpha
            
        })
    }
    
    //Helper method to generate article screenshots
    fileprivate func screenShotMethod() -> UIImage? {
        //Create the UIImage
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
        
    }
    
    //MARK: Open News URL in Safari Browser Action
    @IBAction func openNewInSafari(_ sender: UISwipeGestureRecognizer) {
        guard let urlString = receivedNewItem?.url, let url = URL(string: urlString) else { return }
        let svc = MySafariViewController(url: url)
        svc.delegate = self
        self.present(svc, animated: true, completion: nil)
    }
    
}
