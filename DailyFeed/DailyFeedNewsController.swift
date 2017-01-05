//
//  ViewController.swift
//  DailyFeed
//
//  Created by TrianzDev on 27/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit

class DailyFeedNewsController: UICollectionViewController {
    
    //MARK: Variable declaration
    
    var newsItems = [DailyFeedModel]()
    
    var filteredNewsItems = [DailyFeedModel]()
    
    var newsSourceUrl: String? = "http://i.newsapi.org/the-wall-street-journal-s.png"
    
    var source: String = "the-wall-street-journal"
    
    var resultsSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = false
        controller.searchBar.placeholder = "Search NEWS..."
        controller.searchBar.searchBarStyle = .Prominent
        controller.searchBar.tintColor = UIColor.whiteColor()
        controller.searchBar.barTintColor = UIColor.blackColor()
        controller.searchBar.sizeToFit()
        return controller
    }()
    
    let spinningActivityIndicator = TSActivityIndicator()
    
    let container = UIView()
    
    let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.blackColor()
        refresh.tintColor = UIColor.whiteColor()
        return refresh
    }()
    
    let imageHeight:CGFloat = 200.0
    
    let OffsetSpeed: CGFloat = 7.0
 
    //MARK: View Controller Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup UI
        setupUI()
        
        //Populate CollectionView Data
        loadNewsData("the-wall-street-journal")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK: Setup UI
    func setupUI() {
        
        setupNavigationBar()
        
        setupCollectionView()
        
        setupSpinner()
    }
    
    //MARK: Setup navigation
    func setupNavigationBar() {
        self.resultsSearchController.searchResultsUpdater = self
        self.navigationItem.titleView = resultsSearchController.searchBar
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK: Setup CollectionView
    func setupCollectionView() {
        self.collectionView?.registerNib(UINib(nibName: "DailyFeedItemCell", bundle: nil), forCellWithReuseIdentifier: "DailyFeedItemCell")
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(DailyFeedNewsController.refreshData(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    //MARK: Setup Spinner
    func setupSpinner() {
        spinningActivityIndicator.setupTSActivityIndicator(container)
    }
    
    //MARK: refresh news Source data
    func refreshData(sender: UIRefreshControl) {
        loadNewsData(self.source)
    }
    
    //MARK: Load data from network
    func loadNewsData(source: String) {
        
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        DailyFeedModel.getNewsItems(source) { (newsItem, error) in
            
            if let news = newsItem {
                self.newsItems = news
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView?.reloadData()
                    self.refreshControl.endRefreshing()
                    self.spinningActivityIndicator.stopAnimating()
                    self.container.removeFromSuperview()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                })
            }
        }
    }

    //MARK: Prepare for Segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? NewsDetailViewController {
            
            guard let cell = sender as? UICollectionViewCell else { return }
            
            guard let indexpath = self.collectionView?.indexPathForCell(cell) else { return }
            
            if self.resultsSearchController.active {
                vc.receivedNewItem = filteredNewsItems[indexpath.row]
            } else {
                vc.receivedNewItem = newsItems[indexpath.row]
            }
        }
    }
    
    //MARK: Unwind from Source View Controller
    @IBAction func unwindToDailyNewsFeed(segue: UIStoryboardSegue) {
        if let sourceVC = segue.sourceViewController as? NewsSourceViewController, sourceId = sourceVC.selectedItem?.id {
            setupSpinner()
            self.spinningActivityIndicator.startAnimating()
            self.newsSourceUrl = sourceVC.selectedItem?.urlsToLogos
            self.source = sourceId
            loadNewsData(source)
        }
    }
}