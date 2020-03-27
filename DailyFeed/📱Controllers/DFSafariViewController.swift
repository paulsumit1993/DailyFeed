//
//  DFSafariViewController.swift
//  DailyFeed
//
//  Created by Sumit Paul on 29/12/16.
//

import UIKit
import SafariServices

class DFSafariViewController: SFSafariViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            self.preferredControlTintColor = .label
        } else {
            self.preferredControlTintColor = .black
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
