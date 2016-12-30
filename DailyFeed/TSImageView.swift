//
//  TSImageView.swift
//  DailyFeed
//
//  Created by TrianzDev on 28/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit

let imageCache = NSCache()

class TSImageView: UIImageView {
    
    var imageUrlString = String?()

    func downloadedFromLink(urlString: String, contentMode mode: UIViewContentMode = .ScaleAspectFill) {
        guard let url = NSURL(string: urlString) else { return }
        
        imageUrlString = urlString
        
        self.image = nil
        self.animateImageAppearance(0.25, option: UIViewAnimationOptions.CurveEaseIn, 0.4)
        contentMode = mode
        
        if let imageFromCache = imageCache.objectForKey(urlString) as? UIImage {
            self.image = imageFromCache
            animateImageAppearance()
            return
        }
        
        NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue(), {
                
                let imageToCache = image
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                    self.animateImageAppearance(0.4, option: UIViewAnimationOptions.CurveEaseOut, 1.0)
                }
                imageCache.setObject(imageToCache, forKey: urlString)
                self.animateImageAppearance(0.4, option: UIViewAnimationOptions.CurveEaseOut, 1.0)
            })
            
            }.resume()
        
    }
    
    //Image Appear Animation for Loading Images
    func animateImageAppearance(duration: Double, option: UIViewAnimationOptions, alpha: Double) {
        
        UIView.animateWithDuration(duration, delay: 0, options: duration, animations: {
            self.alpha = alpha
            }, completion: nil)
    }
    
}
