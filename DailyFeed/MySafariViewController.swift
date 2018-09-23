//
//  MySafariViewController.swift
//  DailyFeed
//
//  Created by Sumit Paul on 29/12/16.
//

import UIKit
import SafariServices

class MySafariViewController: SFSafariViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            self.preferredControlTintColor = .black
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
