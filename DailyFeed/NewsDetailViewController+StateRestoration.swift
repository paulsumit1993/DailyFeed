//
//  NewsDetailViewController+StateRestoration.swift
//  DailyFeed
//
//  Created by Sumit Paul on 31/01/17.
//

import UIKit

extension NewsDetailViewController {
    
    // MARK: - UIStateRestoring Delegate Methods
    
    override func encodeRestorableState(with coder: NSCoder) {
        if let newsImage = newsImageView.image {
            coder.encode(UIImageJPEGRepresentation(newsImage, 1.0), forKey:"newsImage")
        }
        
        if let newsTitle = newsTitleLabel.text {
            coder.encode(newsTitle, forKey: "newsTitle")
        }
        
        if let contentText = contentTextView.text {
            coder.encode(contentText, forKey: "contentText")
        }
        
        if let newsAuthor = newsAuthorLabel.text {
            coder.encode(newsAuthor, forKey: "newsAuthor")
        }
        
        if let publishedDate = swipeLeftButton.titleLabel?.text {
            coder.encode(publishedDate, forKey: "publishedDate")
        }
        
        if let url = self.articleStringURL {
            coder.encode(url, forKey: "newsURL")
        }
        
        if let newsSourceImage = newsSourceImageView.image {
            coder.encode(UIImagePNGRepresentation(newsSourceImage), forKey: "newsSourceImage")
        }
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let newsImageData = coder.decodeObject(forKey: "newsImage") as? Data {
            newsImageView.image = UIImage(data: newsImageData)
        }
        
        if let newsTitleText = coder.decodeObject(forKey: "newsTitle") as? String {
            newsTitleLabel.text = newsTitleText
        }
        
        if let contentText = coder.decodeObject(forKey: "contentText") as? String {
            contentTextView.text = contentText
        }
        
        if let newsAuthorText = coder.decodeObject(forKey: "newsAuthor") as? String {
            newsAuthorLabel.text = newsAuthorText
        }
        
        if let publishedAtDate = coder.decodeObject(forKey: "publishedDate") as? String {
            swipeLeftButton.setTitle(publishedAtDate, for: .normal)
        }
        
        if let urlString = coder.decodeObject(forKey: "newsURL") as? String {
            articleStringURL = urlString
        }
        
        if let newsSourceImageData = coder.decodeObject(forKey: "newsSourceImage") as? Data {
            newsSourceImageView.image = UIImage(data: newsSourceImageData)
        }
        
        super.decodeRestorableState(with: coder)
    }
}
