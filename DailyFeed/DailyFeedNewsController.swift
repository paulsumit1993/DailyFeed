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
    
    var resultsSearchController = UISearchController(searchResultsController: nil)
    
    //MARK: IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    //MARK: View Controller Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.resultsSearchController = {
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.hidesNavigationBarDuringPresentation = false
            controller.searchBar.placeholder = "Search NEWS..."
            controller.searchBar.searchBarStyle = .Prominent
            controller.searchBar.tintColor = UIColor.whiteColor()
            controller.searchBar.sizeToFit()
            
            self.navigationItem.titleView = controller.searchBar
            navigationController.interactivePopGestureRecognizer.delegate = nil;
            
            return controller
            }()
        
        activityIndicator.startAnimating()
        
        self.collectionView?.registerNib(UINib(nibName: "DailyFeedItemCell", bundle: nil), forCellWithReuseIdentifier: "DailyFeedItemCell")

        //Populate CollectionView Data
        loadNewsData("the-wall-street-journal")
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    

    
    //MARK: Load data from network
    func loadNewsData(source: String) {
        
        DailyFeedModel.getNewsItems(source) { (newsItem, error) in
            
            if let news = newsItem {
               // _ = news.map { self.newsItems.append($0) }
                self.newsItems = news
                dispatch_async(dispatch_get_main_queue(), { 
                    self.activityIndicator.stopAnimating()
                    self.collectionView?.reloadData()
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
           self.activityIndicator.startAnimating()
           self.newsSourceUrl = sourceVC.selectedItem?.urlsToLogos
           loadNewsData(sourceId)
        }
    }
    
}

//MARK: CollectionView Delegate Methods
extension DailyFeedNewsController: UICollectionViewDelegateFlowLayout, UISearchResultsUpdating {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.resultsSearchController.active {
            return self.filteredNewsItems.count
        }
        else {
            return self.newsItems.count
        }
    }
 
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        self.performSegueWithIdentifier("newsDetailSegue", sender: cell)
        
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DailyFeedItemCell", forIndexPath: indexPath) as! DailyFeedItemCell
        
        if self.resultsSearchController.active {
            
            cell.newsItemTitleLabel.text = filteredNewsItems[indexPath.row].title
            cell.newsItemSourceLabel.text = filteredNewsItems[indexPath.row].author
            cell.newsItemImageView.downloadedFromLink(filteredNewsItems[indexPath.row].urlToImage)
            
        } else {
            
            cell.newsItemTitleLabel.text = newsItems[indexPath.row].title
            cell.newsItemSourceLabel.text = newsItems[indexPath.row].author
            cell.newsItemImageView.downloadedFromLink(newsItems[indexPath.row].urlToImage)
        }
        
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind {
            
        case UICollectionElementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "newsHeaderCell", forIndexPath: indexPath) as! NewHeaderCollectionReusableView
            
            headerView.newSourceImageView.downloadedFromLink(self.newsSourceUrl!)
            headerView.layer.masksToBounds = true
            
            return headerView
            
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "newsFooterCell", forIndexPath: indexPath) 
            
            return footerView
            
        default:
            
            return UICollectionReusableView()
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        guard let width = self.collectionView?.bounds.width, let height = self.collectionView?.bounds.height else { return CGSize(width: 10, height: 10) }
        
        return CGSize(width: (width / 2) - 10, height: (height / 4) - 5)
    }
    
    
    

    //MARK: SearchController Delegate
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        
        filteredNewsItems.removeAll(keepCapacity: false)
        
        if let searchString = searchController.searchBar.text {
            let searchResults = newsItems.filter { $0.title.lowercaseString.containsString(searchString.lowercaseString) || $0.author.lowercaseString.containsString(searchString.lowercaseString) }
            filteredNewsItems = searchResults
            
            self.collectionView?.reloadData()
        }
    }
}
