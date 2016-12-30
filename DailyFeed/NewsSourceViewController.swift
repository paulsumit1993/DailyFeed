//
//  NewsSourceViewController.swift
//  DailyFeed
//
//  Created by TrianzDev on 29/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit

class NewsSourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var sourceTableView: UITableView!
    
    var sourceItems = [DailySourceModel]()
    
    var selectedItem = DailySourceModel?()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DailySourceModel.getNewsSource { (newsItem, error) in
            print(newsItem)
            if let news = newsItem {
                news.map { self.sourceItems.append($0) }
                dispatch_async(dispatch_get_main_queue(), {
                    self.sourceTableView.reloadData()
                })
            }
        }
        
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sourceItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SourceCell", forIndexPath: indexPath)
        
        cell.textLabel?.text = sourceItems[indexPath.row].name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedItem = sourceItems[indexPath.row]
        self.performSegueWithIdentifier("sourceUnwindSegue", sender: self)
    }
}
