//
//  UIViewControllerExtension.swift
//  DailyFeed
//
//  Created by Miguel Revetria on 12/9/15.
//  Copyright (c) 2016 Xmartlabs SRL ( http://xmartlabs.com )
//

import UIKit

public extension UIViewController {
    
    /// shows an UIAlertController alert with error title and message
    public func showError(title: String, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        if !NSThread.currentThread().isMainThread {
            dispatch_async(dispatch_get_main_queue()) { [weak self] in
                self?.showError(title, message: message, handler: handler)
            }
            return
        }
        
        let attributedString = NSAttributedString(string: title, attributes: [ NSForegroundColorAttributeName : UIColor.lightGrayColor() ])
        let controller = UIAlertController(title: "", message: "", preferredStyle: .Alert)
        controller.setValue(attributedString, forKey: "attributedTitle")
        controller.view.tintColor = UIColor.blackColor()
        controller.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .Default, handler: handler))
        presentViewController(controller, animated: true, completion: nil)
    }
    
}