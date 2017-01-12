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
    
    @IBOutlet weak var searchContainerView: UIView!
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
        refresh.backgroundColor = UIColor.white
        refresh.tintColor = UIColor.black
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
        searchContainerView.addSubview(resultsSearchController.searchBar)
        let attributes: [NSLayoutAttribute] = [.top, .bottom, . left, .right]
        NSLayoutConstraint.activate(attributes.map{NSLayoutConstraint(item: self.resultsSearchController.searchBar, attribute: $0, relatedBy: .equal, toItem: self.searchContainerView, attribute: $0, multiplier: 1, constant: 0)})
    }
    
    //MARK: Setup TableView
    func setupTableView() {
        self.sourceTableView.register(UINib(nibName: "DailySourceItemCell", bundle: nil), forCellReuseIdentifier: "DailySourceItemCell")
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
