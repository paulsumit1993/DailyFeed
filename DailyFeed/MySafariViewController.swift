//
//  MySafariViewController.swift
//  DailyFeed
//
//  Created by TrianzDev on 29/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit
import SafariServices

class MySafariViewController: SFSafariViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 10.0, *) {
            self.preferredControlTintColor = UIColor.black
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
}
