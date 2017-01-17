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
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.tintColor = UIColor.black
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
        
        //setup TableView
        setupTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultsSearchController.delegate = nil
        resultsSearchController.searchBar.delegate = nil
    }
    
    //MARK: Setup UI
    func setupUI() {
        setupSearch()
        setupSpinner()
    }
    
    //MARK: Setup SearchBar
    func setupSearch() {
        self.resultsSearchController.searchResultsUpdater = self
        navigationItem.titleView = resultsSearchController.searchBar
    }
    
    //MARK: Setup TableView
    func setupTableView() {
        self.sourceTableView.register(UINib(nibName: "DailySourceItemCell", bundle: nil), forCellReuseIdentifier: "DailySourceItemCell")
    
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
                self.sourceTableView.reloadData()
                self.spinningActivityIndicator.stopAnimating()
                self.container.removeFromSuperview()
                UIApplication.shared.endIgnoringInteractionEvents()
            })
        }
    }
    
    
    //MARK: Status Bar Color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailySourceItemCell", for: indexPath) as! DailySourceItemCell
        
        if self.resultsSearchController.isActive {
            cell.sourceImageView.downloadedFromLink(filteredSourceItems[indexPath.row].urlsToLogos)
        }
        else {
            cell.sourceImageView.downloadedFromLink(sourceItems[indexPath.row].urlsToLogos)
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
