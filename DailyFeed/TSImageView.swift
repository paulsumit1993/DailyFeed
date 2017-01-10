//
//  TSImageView.swift
//  DailyFeed
//
//  Created by TrianzDev on 28/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class TSImageView: UIImageView {
    
    var imageUrlString: String? = nil
    
    func downloadedFromLink(_ urlString: String, contentMode mode: UIViewContentMode = .scaleAspectFill) {
        guard let url = URL(string: urlString) else { return }
        
        imageUrlString = urlString
        
        self.image = nil
        self.animateImageAppearance(0.25, option: UIViewAnimationOptions.curveEaseIn, alpha: 0.4)
        contentMode = mode
        
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            self.animateImageAppearance(0.4, option: UIViewAnimationOptions.curveEaseOut, alpha: 1.0)
            return
        }
        
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async(execute: {
                
                let imageToCache = image
                
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                    self.animateImageAppearance(0.4, option: UIViewAnimationOptions.curveEaseOut, alpha: 1.0)
                }
                imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                self.animateImageAppearance(0.4, option: UIViewAnimationOptions.curveEaseOut, alpha: 1.0)
            })
            
            }) .resume()
        
    }
    
    //Image Appear Animation for Loading Images
    func animateImageAppearance(_ duration: Double, option: UIViewAnimationOptions, alpha: CGFloat) {
        
        UIView.animate(withDuration: duration, delay: 0, options: option, animations: {
            self.alpha = alpha
            }, completion: nil)
    }
    
}
