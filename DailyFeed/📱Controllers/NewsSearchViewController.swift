//
//  NewsSearchViewController.swift
//  DailyFeed
//
//  Created by Sumit Paul on 14/05/19.
//

import UIKit
import PromiseKit
import DZNEmptyDataSet

class NewsSearchViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchResultsUpdating {
    
    var scrollView: UIScrollView {
        return searchCollectionView
    }
    

    // MARK: - IBOutlets
    @IBOutlet weak private var searchCollectionView: UICollectionView!
    
    // MARK: - Variable declaration
    private var searchItems: [DailyFeedModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.searchCollectionView.reloadSections([0])
                self.searchCollectionView.reloadEmptyDataSet()
                self.setupSpinner(hidden: true)
            }
        }
    }
    
    private var selectedCell = UICollectionViewCell()


    private var resultsSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = true
        controller.searchBar.placeholder = "Search Anything..."
        controller.searchBar.searchBarStyle = .prominent
        controller.searchBar.sizeToFit()
        return controller
    }()
    
    private let spinningActivityIndicator = TSSpinnerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setup UI
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard !resultsSearchController.isActive else { return }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.resultsSearchController.searchBar.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resultsSearchController.delegate = nil
        resultsSearchController.searchBar.delegate = nil
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        setupSearch()
        setupCollectionView()
    }
    
    // MARK: - Setup SearchBar
    private func setupSearch() {
        resultsSearchController.searchResultsUpdater = self
        if #available(iOS 11.0, *) {
            navigationItem.searchController = resultsSearchController
            navigationItem.hidesSearchBarWhenScrolling = false
        } else {
            navigationItem.titleView = resultsSearchController.searchBar
        }
        definesPresentationContext = true
    }
    
    // MARK: - Setup TableView
    private func setupCollectionView() {
        searchCollectionView.register(R.nib.dailyFeedItemCell)
        searchCollectionView?.collectionViewLayout = UIDevice.current.userInterfaceIdiom == .phone ? DailySourceItemLayout() : DailySourceItemiPadLayout()
        searchCollectionView.emptyDataSetDelegate = self
        searchCollectionView.emptyDataSetSource = self
    }
    
    // MARK: - Setup Spinner
    private func setupSpinner(hidden: Bool) {
        DispatchQueue.main.async {
            self.spinningActivityIndicator.containerView.isHidden = hidden
            if !hidden {
                self.spinningActivityIndicator.setupTSSpinnerView()
                self.spinningActivityIndicator.start()
            } else {
                self.spinningActivityIndicator.stop()
            }
        }
    }
    
    deinit {
        self.searchCollectionView.delegate = nil
        self.searchCollectionView.dataSource = nil
    }
    
    // MARK: - Status Bar Color and switching actions
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: R.reuseIdentifier.dailyFeedItemCell, for: indexPath)
        cell?.configure(with: searchItems[indexPath.row], ltr: false)
        return cell!

    }
    
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            self.performSegue(withIdentifier: R.segue.newsSearchViewController.newsSearchSegue,
                              sender: cell)
        }
        
    }
    
    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == R.segue.newsSearchViewController.newsSearchSegue.identifier {
            if let vc = segue.destination as? NewsDetailViewController {
                guard let cell = sender as? UICollectionViewCell else { return }
                guard let indexpath = self.searchCollectionView?.indexPath(for: cell) else { return }
                selectedCell = cell
                vc.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .phone ? .fullScreen : .formSheet
                vc.receivedNewsItem = DailyFeedRealmModel.toDailyFeedRealmModel(from: searchItems[indexpath.row])
                vc.receivedItemNumber = indexpath.row + 1
            }
        }
    }

    
    // MARK: - SearchBar Delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        
        searchItems.removeAll(keepingCapacity: false)
        
        if let searchString = searchController.searchBar.text, searchString.count > 3 {
            loadNews(with: searchString)
        }
    }
    
    // MARK: - Load data from network
    func loadNews(with query: String) {
        switch Reach().connectionStatus() {
            
        case .offline, .unknown:
            self.showError("Internet connection appears to be offline", message: nil)
        case .online(_):
            
            
            firstly {
                NewsAPI.searchNews(with: query)
                }.done { result in
                    self.searchItems = result.articles
                }.catch(on: .main) { err in
                    self.showError(err.localizedDescription)
            }
        }
    }

}


extension NewsSearchViewController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        switch (traitCollection.verticalSizeClass, traitCollection.horizontalSizeClass) {
            
        case (.regular, .regular), (.compact, .regular), (.compact, .compact):
            searchCollectionView?.collectionViewLayout.invalidateLayout()
            searchCollectionView?.collectionViewLayout = DailySourceItemiPadLayout()
            
        default:
            searchCollectionView?.collectionViewLayout.invalidateLayout()
            searchCollectionView?.collectionViewLayout = DailySourceItemLayout()
            
        }
    }
}

// MARK: - DZNEmptyDataSet Delegate Methods
extension NewsSearchViewController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Search for Articles above"
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "search")
    }
    
    func imageTintColor(forEmptyDataSet scrollView: UIScrollView!) -> UIColor! {
        return UIColor.lightGray
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}
