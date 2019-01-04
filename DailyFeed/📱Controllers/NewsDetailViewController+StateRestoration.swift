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
            coder.encode(newsImage.jpegData(compressionQuality: 1.0), forKey:"newsImage")
        }
        
        if let title = newsTitleLabel.text {
            coder.encode(title, forKey: "title")
        }
        
        if let contentText = contentTextView.text {
            coder.encode(contentText, forKey: "contentText")
        }
        
        if let newsAuthor = newsAuthorLabel.text {
            coder.encode(newsAuthor, forKey: "newsAuthor")
        }
        
        if let publishedDate = receivedNewsItem?.publishedAt {
            coder.encode(publishedDate, forKey: "publishedDate")
        }
        
        if let url = self.articleStringURL {
            coder.encode(url, forKey: "newsURL")
        }
        
        if let newsSourceImage = newsSourceImageView.image {
            coder.encode(newsSourceImage.jpegData(compressionQuality: 1.0), forKey: "newsSourceImage")
        }
        
        super.encodeRestorableState(with: coder)
    }
    
    override func decodeRestorableState(with coder: NSCoder) {
        if let newsImageData = coder.decodeObject(forKey: "newsImage") as? Data {
            newsImageView.image = UIImage(data: newsImageData)
        }
        
        if let title = coder.decodeObject(forKey: "title") as? String {
            newsTitleLabel.text = title
        }
        
        if let contentText = coder.decodeObject(forKey: "contentText") as? String {
            contentTextView.text = contentText
        }
        
        if let newsAuthorText = coder.decodeObject(forKey: "newsAuthor") as? String {
            newsAuthorLabel.text = newsAuthorText
        }
        
        if let publishedAtDate = coder.decodeObject(forKey: "publishedDate") as? String {
            guard let publishedDate = publishedAtDate.dateFromTimestamp?.relativelyFormatted(short: false) else {
                return swipeLeftButton.setTitle("Read More...", for: .normal)
            }
            swipeLeftButton.setTitle("\(publishedDate) • Read More...", for: .normal)
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
