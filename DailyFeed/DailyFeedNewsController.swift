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
    
    let spinningActivityIndicator = TSActivityIndicator()
    
    let container = UIView()
    
    let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.backgroundColor = UIColor.black
        refresh.tintColor = UIColor.white
        return refresh
    }()
    
    let imageHeight:CGFloat = 200.0
    
    let OffsetSpeed: CGFloat = 10.0
    
    //MARK: View Controller Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Setup UI
        setupUI()
        
        //Populate CollectionView Data
        loadNewsData("the-wall-street-journal")
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        self.navigationItem.title = "Your Feed"
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil;
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK: Setup CollectionView
    func setupCollectionView() {
        self.collectionView?.register(UINib(nibName: "DailyFeedItemCell", bundle: nil), forCellWithReuseIdentifier: "DailyFeedItemCell")
        self.collectionView?.alwaysBounceVertical = true
        self.collectionView?.addSubview(refreshControl)
        self.refreshControl.addTarget(self, action: #selector(DailyFeedNewsController.refreshData(_:)), for: UIControlEvents.valueChanged)
    }
    
    //MARK: Setup Spinner
    func setupSpinner() {
        spinningActivityIndicator.setupTSActivityIndicator(container)
    }
    
    //MARK: refresh news Source data
    func refreshData(_ sender: UIRefreshControl) {
        loadNewsData(self.source)
    }
    
    //MARK: Load data from network
    func loadNewsData(_ source: String) {
        
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        DailyFeedModel.getNewsItems(source) { (newsItem, error) in
            
            guard error == nil, let news = newsItem else {
                DispatchQueue.main.async(execute: {
                    self.spinningActivityIndicator.stopAnimating()
                    self.container.removeFromSuperview()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.showError(error?.localizedDescription ?? "", message: "") { (completed) in
                         self.refreshControl.endRefreshing()   
                       }
                    })
                return
            }
            self.newsItems = news
            DispatchQueue.main.async(execute: {
                self.collectionView?.reloadData()
                self.refreshControl.endRefreshing()
                self.spinningActivityIndicator.stopAnimating()
                self.container.removeFromSuperview()
                UIApplication.shared.endIgnoringInteractionEvents()
            })
        }
    }
    
    //MARK: Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NewsDetailViewController {
            
            guard let cell = sender as? UICollectionViewCell else { return }
            
            guard let indexpath = self.collectionView?.indexPath(for: cell) else { return }

                vc.receivedNewItem = newsItems[indexpath.row]
        }
    }
    
    //MARK: Unwind from Source View Controller
    @IBAction func unwindToDailyNewsFeed(_ segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? NewsSourceViewController, let sourceId = sourceVC.selectedItem?.id {
            setupSpinner()
            self.spinningActivityIndicator.startAnimating()
            self.newsSourceUrl = sourceVC.selectedItem?.urlsToLogos
            self.source = sourceId
            loadNewsData(source)
        }
    }
}
