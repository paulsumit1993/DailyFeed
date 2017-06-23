//
//  NewsDetailViewController.swift
//  DailyFeed
//
//  Created by Sumit Paul on 27/12/16.
//

import UIKit
import SafariServices
import RealmSwift

class NewsDetailViewController: UIViewController, SFSafariViewControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Variable declaration
    
    var receivedNewsItem: DailyFeedRealmModel?
    
    var receivedNewsSourceLogo: String?
    
    var articleStringURL: String?
    
    var receivedItemNumber: Int?

    // MARK: - IBOutlets
    @IBOutlet weak var newsImageView: TSImageView! {
        didSet {
            newsImageView.layer.masksToBounds = true
            guard let imageURL = receivedNewsItem?.urlToImage else { return }
            newsImageView.downloadedFromLink(imageURL)
        }
    }

    @IBOutlet weak var newsTitleLabel: UILabel! {
        didSet {
            newsTitleLabel.text = receivedNewsItem?.title
        }
    }

    @IBOutlet weak var contentTextView: UITextView! {
        didSet {
            contentTextView.text = receivedNewsItem?.articleDescription
            contentTextView.textColor = .gray
            contentTextView.font = UIFont.preferredFont(forTextStyle: .subheadline)
            contentTextView.sizeToFit()
        }
    }

    @IBOutlet weak var newsAuthorLabel: UILabel! {
        didSet {
            newsAuthorLabel.text = receivedNewsItem?.author
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

    @IBOutlet weak var swipeLeftButton: UIButton! {
        didSet {
            guard let publishedDate = receivedNewsItem?.publishedAt.dateFromTimestamp?.relativelyFormatted(short: false) else {
                return swipeLeftButton.setTitle("Read More...", for: .normal)
            }
            swipeLeftButton.setTitle("\(publishedDate) • Read More...", for: .normal)
            switch Reach().connectionStatus() {
            case .unknown, .offline:
                swipeLeftButton.isEnabled = false
                swipeLeftButton.backgroundColor = .lightGray
                
            case .online(_):
                swipeLeftButton.isEnabled = true
            }
        }
    }

    @IBOutlet weak var newsSourceImageView: TSImageView! {
        didSet {
            guard let newsSourceLogo = receivedNewsSourceLogo else { return }
            newsSourceImageView.downloadedFromLink(newsSourceLogo)

        }
    }
    
    @IBOutlet weak var newsItemNumberLabel: UILabel! {
        didSet {
            guard let newsItemNumber = receivedItemNumber else { return }
            newsItemNumberLabel.text = String(newsItemNumber)
            newsItemNumberLabel.clipsToBounds = true
            newsItemNumberLabel.layer.cornerRadius = 5.0
        }
    }

    
    // MARK: - View Controller Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        //Hide Nav bar
        navigationController?.setNavigationBarHidden(true, animated: true)
        // Setting the newsImageView gradient
        newsImageView.addGradient([UIColor(white: 0, alpha: 0.6).cgColor, UIColor.clear.cgColor,
                                   UIColor(white: 0, alpha: 0.6).cgColor],
                                  locations: [0.0, 0.05, 0.85])

        //Setting articleStringURL for state restoration
        articleStringURL = receivedNewsItem?.url
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        newsImageView.updateNewsImageView(25.0)
    }
    
    // MARK: - Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    // MARK: - Back Button Dismiss action
    @IBAction func dismissButtonTapped() {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - Back dismiss swipe
    @IBAction func swipeToDismiss(_ sender: UISwipeGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - share article
    @IBAction func shareArticle(_ sender: UIButton) {

        fadeUIElements(with: 0.0)

        let delay = DispatchTime.now() + 0.11
        DispatchQueue.main.asyncAfter(deadline: delay) {

            guard let shareURL = self.articleStringURL,
                let articleImage = self.captureScreenShot(),
                let articleToBookmarkData = self.receivedNewsItem else {return}
            
            let bookmarkactivity = BookmarkActivity()
            
            bookmarkactivity.bookMarkSuccessful = {
                self.showErrorWithDelay("Bookmarked Successfully!")
            }
            
            let activityVC = UIActivityViewController(activityItems: [shareURL, articleImage, articleToBookmarkData],
                                                      applicationActivities: [bookmarkactivity])
            
            activityVC.excludedActivityTypes = [.saveToCameraRoll,
                                                .copyToPasteboard,
                                                .airDrop,
                                                .addToReadingList,
                                                .assignToContact,
                                                .postToTencentWeibo,
                                                .postToVimeo,
                                                .print,
                                                .postToWeibo]

            activityVC.completionWithItemsHandler = {(activityType, completed: Bool, _, _) in
                self.fadeUIElements(with: 1.0)
            }
            
            // Popover for iPad only

            let popOver = activityVC.popoverPresentationController
            popOver?.sourceView = self.shareButton
            popOver?.sourceRect = self.shareButton.bounds
            self.present(activityVC, animated: true, completion: nil)
        }
    }

    // Helper to toggle UI elements before and after screenshot capture
     func fadeUIElements(with alpha: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.backButton.alpha = alpha
            self.shareButton.alpha = alpha
            self.swipeLeftButton.alpha = alpha
        }
    }

    // Helper method to generate article screenshots
     func captureScreenShot() -> UIImage? {
        //Create the UIImage
        let bounds = UIScreen.main.bounds
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
        self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image

    }

    @IBAction func openArticleInSafari(_ sender: UIButton) {
        openInSafari()
    }

    // Helper method to open articles in Safari
    func openInSafari() {
        guard let articleString = articleStringURL, let url = URL(string: articleString) else { return }
        let svc = MySafariViewController(url: url)
        svc.delegate = self
        self.present(svc, animated: true, completion: nil)
    }
}
