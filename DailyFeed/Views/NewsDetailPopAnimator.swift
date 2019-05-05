//
//  NewsDetailPopAnimator.swift
//  DailyFeed
//
//  Created by Sumit Paul on 20/08/17.
//

import Foundation
import UIKit

final class NewsDetailPopAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration = 0.5
    var presenting = true
    var originFrame = CGRect.zero
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        let fromView = transitionContext.view(forKey: .from) ?? UIView()
        let toView = transitionContext.view(forKey: .to) ?? UIView()
        let newsDetailView = presenting ? toView : fromView

        let initialFrame = presenting ? originFrame : newsDetailView.frame
        let finalFrame = presenting ? newsDetailView.frame : originFrame
        
        let xScaleFactor = presenting ? initialFrame.width / finalFrame.width : finalFrame.width / initialFrame.width
        let yScaleFactor = presenting ? initialFrame.height / finalFrame.height : finalFrame.height / initialFrame.height
        
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        
        let presentingCornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 10.0 : 0.0
        let cornerRadius = presenting ? CGFloat(presentingCornerRadius) : CGFloat(20.0)
        
        let alpha = presenting ? CGFloat(1.0) : CGFloat(0.0)
        
        if presenting {
            newsDetailView.transform = scaleTransform
            newsDetailView.center = CGPoint(
                x: initialFrame.midX,
                y: initialFrame.midY)
             newsDetailView.layer.cornerRadius = 20.0
             newsDetailView.clipsToBounds = true
            newsDetailView.alpha = 0.0
        }
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(newsDetailView)
        
        let propertyAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.75) {
            newsDetailView.transform = self.presenting ? .identity : scaleTransform
            newsDetailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
            newsDetailView.layer.cornerRadius = cornerRadius
            newsDetailView.alpha = alpha
        }
        
        propertyAnimator.addCompletion { position in
            transitionContext.completeTransition(true)
        }
    
        propertyAnimator.startAnimation()

    }
}
