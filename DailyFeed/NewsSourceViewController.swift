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
    
    var selectedItem: DailySourceModel? = nil
    
    var resultsSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.placeholder = "Search Sources..."
        controller.searchBar.tintColor = UIColor.black
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.sizeToFit()
        return controller
    }()
    
    let spinningActivityIndicator = TSActivityIndicator()
    
    let container = UIView()
    
    let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.black
        refresh.tintColor = UIColor.white
        return refresh
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup UI
        setupUI()
        
        //Populate TableView Data
        loadSourceData()
        
        //setup TableView
        setupTableView()
        
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
    
    //MARK: Setup TableView
    func setupTableView() {
        self.sourceTableView.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(NewsSourceViewController.refreshData(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    //MARK: Setup Spinner
    func setupSpinner() {
        spinningActivityIndicator.setupTSActivityIndicator(container)
    }
    
    //MARK: refresh news Source data
    func refreshData(_ sender: UIRefreshControl) {
        loadSourceData()
    }
    
    //MARK: Load data from network
    func loadSourceData() {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        DailySourceModel.getNewsSource { (newsItem, error) in
            
            
            guard error == nil, let news = newsItem else {
                DispatchQueue.main.async(execute: {
                    self.refreshControl.endRefreshing()
                    self.spinningActivityIndicator.stopAnimating()
                    self.container.removeFromSuperview()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.showError(error?.localizedDescription ?? "", message: "") { (completed) in
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                return
            }
            
            self.sourceItems = news
            DispatchQueue.main.async(execute: {
                self.refreshControl.endRefreshing()
                self.sourceTableView.reloadData()
                self.spinningActivityIndicator.stopAnimating()
                self.container.removeFromSuperview()
                UIApplication.shared.endIgnoringInteractionEvents()
            })
        }
    }
    
    //MARK: TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultsSearchController.isActive {
            return self.filteredSourceItems.count
        }
        else {
            return self.sourceItems.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourceCell", for: indexPath)
        
        if self.resultsSearchController.isActive {
            cell.textLabel?.text = filteredSourceItems[indexPath.row].name
        }
        else {
            cell.textLabel?.text = sourceItems[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.resultsSearchController.isActive {
            self.selectedItem = filteredSourceItems[indexPath.row]
        }
        else {
            self.selectedItem = sourceItems[indexPath.row]
        }
        
        self.performSegue(withIdentifier: "sourceUnwindSegue", sender: self)
    }
    
    //MARK: SearchBar Delegate
    func updateSearchResults(for searchController: UISearchController) {
        
        filteredSourceItems.removeAll(keepingCapacity: false)
        
        if let searchString = searchController.searchBar.text {
            let searchResults = sourceItems.filter { $0.name.lowercased().contains(searchString.lowercased()) }
            filteredSourceItems = searchResults
            
            self.sourceTableView.reloadData()
        }
    }
}
