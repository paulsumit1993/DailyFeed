//
//  NewsSourceViewController.swift
//  DailyFeed
//
//  Created by TrianzDev on 29/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit

class NewsSourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    //MARK: IBOutlets
    @IBOutlet weak var sourceTableView: UITableView!
    
    //MARK: Variable declaration
    var sourceItems = [DailySourceModel]()
    
    var filteredSourceItems = [DailySourceModel]()
    
    var selectedItem = DailySourceModel?()
    
    var resultsSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.placeholder = "Search Sources..."
        controller.searchBar.tintColor = UIColor.blackColor()
        controller.searchBar.searchBarStyle = .Minimal
        controller.searchBar.sizeToFit()
        return controller
    }()
    
    let spinningActivityIndicator = TSActivityIndicator()

    let container = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup UI
        setupUI()
        
        //Populate TableView Data
        loadSourceData()
        
    }
    
    //MARK: Setup UI
    func setupUI() {
        setupSearch()
        setupSpinner()
    }
    
    //MARK: Setup SearchBar
    func setupSearch() {
        self.resultsSearchController.searchResultsUpdater = self
        self.sourceTableView.tableHeaderView = resultsSearchController.searchBar
    }
    
    //MARK: Setup Spinner
    func setupSpinner() {
        spinningActivityIndicator.setupTSActivityIndicator(container)
    }
    
    //MARK: Load data from network
    func loadSourceData() {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        DailySourceModel.getNewsSource { (newsItem, error) in
            if let news = newsItem {
                _ = news.map { self.sourceItems.append($0) }
                dispatch_async(dispatch_get_main_queue(), {
                    self.sourceTableView.reloadData()
                    self.spinningActivityIndicator.stopAnimating()
                    self.container.removeFromSuperview()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                })
            }
        }
    }
    
    //MARK: TableView Delegate Methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultsSearchController.active {
            return self.filteredSourceItems.count
        }
        else {
            return self.sourceItems.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SourceCell", forIndexPath: indexPath)
        
        if self.resultsSearchController.active {
            cell.textLabel?.text = filteredSourceItems[indexPath.row].name
        }
        else {
            cell.textLabel?.text = sourceItems[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.resultsSearchController.active {
            self.selectedItem = filteredSourceItems[indexPath.row]
        }
        else {
            self.selectedItem = sourceItems[indexPath.row]
        }
        
        self.performSegueWithIdentifier("sourceUnwindSegue", sender: self)
    }
    
    //MARK: SearchBar Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        filteredSourceItems.removeAll(keepCapacity: false)
        
        if let searchString = searchController.searchBar.text {
            let searchResults = sourceItems.filter { $0.name.lowercaseString.containsString(searchString.lowercaseString) }
            filteredSourceItems = searchResults
            
            self.sourceTableView.reloadData()
        }
    }
}
