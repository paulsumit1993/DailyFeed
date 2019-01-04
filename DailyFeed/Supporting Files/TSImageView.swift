//
//  TSImageView.swift
//  DailyFeed
//
//  Created by Sumit Paul on 28/12/16.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class TSImageView: UIImageView {

    var imageUrlString: String?

    func downloadedFromLink(_ urlString: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        guard let url = URL(string: urlString) else { return }

        imageUrlString = urlString

        self.image = UIImage(named: "")
        self.animateImageAppearance(0.25, option: UIView.AnimationOptions.curveEaseIn, alpha: 0.4)
        contentMode = mode

        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            self.animateImageAppearance(0.4, option: UIView.AnimationOptions.curveEaseOut, alpha: 1.0)
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
                    self.animateImageAppearance(0.4, option: UIView.AnimationOptions.curveEaseOut, alpha: 1.0)
                }
                imageCache.setObject(imageToCache, forKey: urlString as AnyObject)
                self.animateImageAppearance(0.4, option: UIView.AnimationOptions.curveEaseOut, alpha: 1.0)
            })

            }) .resume()

    }

    //Helper for Image Appear Animation
    fileprivate func animateImageAppearance(_ duration: Double, option: UIView.AnimationOptions, alpha: CGFloat) {

        UIView.animate(withDuration: duration, delay: 0, options: option, animations: {
            self.alpha = alpha
            }, completion: nil)
    }

}
