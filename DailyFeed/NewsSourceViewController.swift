//
//  NewsSourceViewController.swift
//  DailyFeed
//
//  Created by TrianzDev on 29/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit

class NewsSourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    // MARK: - IBOutlets
    @IBOutlet weak var sourceTableView: UITableView!
    
    // MARK: - Variable declaration
    var sourceItems = [DailySourceModel]()
    
    var filteredSourceItems = [DailySourceModel]()
    
    var selectedItem: DailySourceModel?

    var categories: [String] = []

    var resultsSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.placeholder = "Search Sources..."
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.tintColor = .black
        controller.searchBar.sizeToFit()
        return controller
    }()
    
    let spinningActivityIndicator = TSActivityIndicator()
    
    //Activity Indicator Container View
    let container = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup UI
        setupUI()

        //Populate TableView Data
        loadSourceData(nil)
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

    // MARK: - Setup UI
    func setupUI() {
        setupSearch()
        setupSpinner()
    }

    // MARK: - Setup SearchBar
    func setupSearch() {
        resultsSearchController.searchResultsUpdater = self
        navigationItem.titleView = resultsSearchController.searchBar
        definesPresentationContext = true
        navigationController?.hidesBarsOnSwipe = true
    }

    // MARK: - Setup TableView
    func setupTableView() {
        sourceTableView.register(UINib(nibName: "DailySourceItemCell",
                                       bundle: nil),
                                 forCellReuseIdentifier: "DailySourceItemCell")
        sourceTableView.tableFooterView = UIView()
    }

    // MARK: - Setup Spinner
    func setupSpinner() {
        spinningActivityIndicator.setupTSActivityIndicator(container)
    }

    // MARK: - Show News Categories

    @IBAction func presentCategories(_ sender: Any) {
        let categoryActivityVC = UIAlertController(title: "Select a Category",
                                                   message: nil,
                                                   preferredStyle: .actionSheet)

        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        _ = categories.map {
            let categoryButton = UIAlertAction(title: $0, style: .default, handler: { action in
                if let category = action.title {
                    self.loadSourceData(category)
                }
            })
            categoryActivityVC.addAction(categoryButton)
        }
        categoryActivityVC.addAction(cancelButton)
        self.present(categoryActivityVC, animated: true, completion: nil)
    }

    // MARK: - Load data from network
    func loadSourceData(_ category: String?) {

        UIApplication.shared.beginIgnoringInteractionEvents()
        DailySourceModel.getNewsSource(category) { (newsItem, error) in
            
            guard error == nil, let news = newsItem else {
                DispatchQueue.main.async(execute: {
                    self.spinningActivityIndicator.stopAnimating()
                    self.container.removeFromSuperview()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.showError(error?.localizedDescription ?? "", message: "") { _ in
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                return
            }
            self.sourceItems = news
            
            // The code below helps in persisting category till the view controller id de-allocated
            if category == nil {
                self.categories = Array(Set(news.map { $0.category }))
            }
            
            DispatchQueue.main.async(execute: {
                self.sourceTableView.reloadData()
                self.spinningActivityIndicator.stopAnimating()
                self.container.removeFromSuperview()
                UIApplication.shared.endIgnoringInteractionEvents()
            })
        }
    }

    // MARK: - Status Bar Color and swutching actions
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden: Bool {
        return navigationController?.isNavigationBarHidden ?? false
    }

    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultsSearchController.isActive {
            return self.filteredSourceItems.count + 1
        } else {
            return self.sourceItems.count + 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DailySourceItemCell",
                                                 for: indexPath) as? DailySourceItemCell

        if indexPath.row == 0 { return DailySourceItemCell() }
        if self.resultsSearchController.isActive {
            cell?.sourceImageView.downloadedFromLink(filteredSourceItems[indexPath.row - 1].urlsToLogos)
        } else {
            cell?.sourceImageView.downloadedFromLink(sourceItems[indexPath.row - 1].urlsToLogos)
        }

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.resultsSearchController.isActive {
            self.selectedItem = filteredSourceItems[indexPath.row - 1]
        } else {
            self.selectedItem = sourceItems[indexPath.row - 1]
        }

        self.performSegue(withIdentifier: "sourceUnwindSegue", sender: self)
    }

    // MARK: - SearchBar Delegate
    func updateSearchResults(for searchController: UISearchController) {

        filteredSourceItems.removeAll(keepingCapacity: false)

        if let searchString = searchController.searchBar.text {
            let searchResults = sourceItems.filter { $0.name.lowercased().contains(searchString.lowercased()) }
            filteredSourceItems = searchResults
            self.sourceTableView.reloadData()
        }
    }
}
