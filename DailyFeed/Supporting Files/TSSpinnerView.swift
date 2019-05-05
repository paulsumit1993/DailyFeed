//
//  TSSpinnerView
//  DailyFeed
//
//  Created by Sumit Paul on 03/01/17.
//

import UIKit
import Lottie

class TSSpinnerView: UIView {

    let containerView = UIView()
    
    let loadingView = UIView()
    
    let bestView = AnimationView(name: R.file.iconTransitionsJson.name)

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: Add Custom activity indicator
    func setupTSSpinnerView() {
        let window = UIApplication.shared.keyWindow
        containerView.frame = UIScreen.main.bounds
        containerView.backgroundColor = UIColor(hue: 0/360, saturation: 0/100, brightness: 0/100, alpha: 0.1)
        loadingView.frame = CGRect(x: 0, y: 0, width: (window?.bounds.width)! / 4, height: (window?.bounds.width)! / 4)
        
        //Add parallax to loading indicator
        addParallaxToView(vw: loadingView, amount: 20)
        loadingView.center = containerView.center
        loadingView.backgroundColor = .black
        loadingView.clipsToBounds = true
        
        loadingView.layer.cornerRadius = loadingView.bounds.width / 2
        bestView.frame = CGRect(x: 0, y: 0, width: loadingView.frame.size.width, height: loadingView.frame.size.height)
        bestView.loopMode = .loop
        bestView.contentMode = .scaleAspectFill
        loadingView.addSubview(bestView)
        containerView.addSubview(loadingView)
        window?.addSubview(containerView)
    }
    
    func start() {
        bestView.play()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stop() {
        bestView.pause()
        self.containerView.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    
     fileprivate func addParallaxToView(vw: UIView, amount: Int) {
        
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -amount
        horizontal.maximumRelativeValue = amount
        
        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -amount
        vertical.maximumRelativeValue = amount
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        vw.addMotionEffect(group)
    }
}
