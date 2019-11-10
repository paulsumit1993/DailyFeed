//
//  TodayViewController.swift
//  DailyToday
//
//  Created by Filippos Sakellaropoulos on 17/9/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import UIKit
import PromiseKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
  
    @IBOutlet weak var newsItemImageView: UIImageView!
    @IBOutlet weak var newsItemTitleLabel: UILabel!
   @IBOutlet weak var newsArticleAuthorLabel: UILabel!
    @IBOutlet weak var newsItemImageViewWidth: NSLayoutConstraint!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
      firstly {
        NewsAPI.getNewsItems(category: "general")
      }.done { result in
         DispatchQueue.main.async  {
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        guard let newsItem = result.articles.first else {
            completionHandler(NCUpdateResult.failed)
            return
          }
        let prevTitle = UserDefaults.standard.string(forKey: "title")
        if prevTitle == newsItem.title  {
            
           completionHandler(NCUpdateResult.noData)
           self.newsItemTitleLabel.text = newsItem.title
          self.newsArticleAuthorLabel.text = newsItem.author ?? ""
           if let imageURL = newsItem.urlToImage { TSImageView.downloadSimple(imageURL, for:self.newsItemImageView) }
           return
        }
        UserDefaults.standard.set(newsItem.title, forKey: "title")
        self.newsItemTitleLabel.text = newsItem.title
        self.newsArticleAuthorLabel.text = newsItem.author ?? ""
        if let imageURL = newsItem.urlToImage { TSImageView.downloadSimple(imageURL, for:self.newsItemImageView) }
        completionHandler(NCUpdateResult.newData)
      }
      }.catch { _ in completionHandler(NCUpdateResult.failed) }
  }
  
  func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
    return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) 
  }
  
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
    newsItemImageViewWidth.constant = maxSize.height
  }
    
}
