//
//  ViewController.swift
//  DailyFeed
//
//  Created by Sumit Paul on 27/12/16.
//

import UIKit
import Lottie
import DZNEmptyDataSet
import PromiseKit

class DailyFeedNewsController: UICollectionViewController {

    // MARK: - Variable declaration

    var newsItems: [DailyFeedModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
                self.collectionView?.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
            }
        }
    }
    
    var source: String {
        get {
            guard let defaultSource = UserDefaults().string(forKey: "source") else {
                return "general"
            }

            return defaultSource
        }
        
        set {
           UserDefaults().set(newValue, forKey: "source")
        }
    }

    let spinningActivityIndicator = TSSpinnerView()

    let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()
    
    var selectedIndexPath: IndexPath?
    
    let transition = NewsDetailPopAnimator()
    
    var selectedCell = UICollectionViewCell()
    
    var isLanguageRightToLeft = Bool()

    // MARK: - IBOutlets

    @IBOutlet weak var toggleButton: UIButton!

    // MARK: - View Controller Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup UI
        setupUI()
        //Populate CollectionView Data
        loadNewsData(source)
        Reach().monitorReachabilityChanges()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    let navBarSourceImage: TSImageView = {
        let image = TSImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        return image
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        traitCollectionDidChange(traitCollection)
    }

    // MARK: - Setup UI
    func setupUI() {
        setupNavigationBar()
        setupCollectionView()
    }

    // MARK: - Setup navigationBar
    func setupNavigationBar() {
        let sourceMenuButton = UIBarButtonItem(image: #imageLiteral(resourceName: "sources"), style: .plain, target: self, action: #selector(sourceMenuButtonDidTap))
        navigationItem.rightBarButtonItem = sourceMenuButton
        //navBarSourceImage.image = UIImage.init(named: "logo") // .downloadedFromLink(NewsAPI.getSourceNewsLogoUrl(source: self.source), contentMode: .scaleAspectFit)
        //navigationItem.titleView = navBarSourceImage
        navigationItem.title = NSLocalizedString("category_\(self.source)", comment: self.source) // "\(Locale.current.localizedString(forRegionCode: Locale.current.regionCode!)!)"
    }

    // MARK: - Setup CollectionView
    func setupCollectionView() {
        collectionView?.register(UINib(nibName: "DailyFeedItemCell", bundle: nil),
                                 forCellWithReuseIdentifier: "DailyFeedItemCell")
        collectionView?.refreshControl = refreshControl
        refreshControl.addTarget(self,
                                 action: #selector(DailyFeedNewsController.refreshData(_:)),
                                 for: UIControl.Event.valueChanged)
        collectionView?.emptyDataSetDelegate = self
        collectionView?.emptyDataSetSource = self
        if #available(iOS 11.0, *) {
            collectionView?.dragDelegate = self
            collectionView?.dragInteractionEnabled = true
        }
    }

    // MARK: - Setup Spinner
    func setupSpinner() {
        spinningActivityIndicator.setupTSSpinnerView()
    }

    // MARK: - refresh news Source data
    @objc func refreshData(_ sender: UIRefreshControl) {
        loadNewsData(self.source)
    }

    // MARK: - Load data from network
    func loadNewsData(_ source: String) {
        switch Reach().connectionStatus() {
        
        case .offline, .unknown:
            self.showError("Internet connection appears to be offline", message: nil, handler: { _ in
                self.refreshControl.endRefreshing()
            })
            
        case .online(_):
            
            if !self.refreshControl.isRefreshing {
                setupSpinner()
            }
            
            spinningActivityIndicator.start()
            
            firstly {
                NewsAPI.getNewsItems(category: source)
            }.done { result in
                self.newsItems = result.articles
                self.navigationItem.title = NSLocalizedString("category_\(self.source)", comment: self.source) 
                // self.navBarSourceImage.downloadedFromLink(NewsAPI.getSourceNewsLogoUrl(source: self.source), contentMode: .scaleAspectFit)
            }.ensure(on: .main) {
                self.spinningActivityIndicator.stop()
                self.refreshControl.endRefreshing()
                }.catch(on: .main) { err in
                self.showError(err.localizedDescription)
            }
        }
    }
    
    deinit {
        collectionView?.delegate = nil
        collectionView?.dataSource = nil
    }

    // MARK: - sourceMenuButton Action method

    @objc func sourceMenuButtonDidTap() {
        self.performSegue(withIdentifier: "newsSourceSegue", sender: self)
    }

    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newsDetailSegue" {
            if let vc = segue.destination as? NewsDetailViewController {
            guard let cell = sender as? UICollectionViewCell else { return }
            guard let indexpath = self.collectionView?.indexPath(for: cell) else { return }
            
                vc.transitioningDelegate = self
                vc.modalPresentationStyle = .formSheet
                vc.receivedNewsItem = DailyFeedRealmModel.toDailyFeedRealmModel(from: newsItems[indexpath.row])
                vc.receivedItemNumber = indexpath.row + 1
                // vc.receivedNewsSourceLogo = NewsAPI.getSourceNewsLogoUrl(source: self.source)
                vc.isLanguageRightToLeftDetailView = isLanguageRightToLeft
            }
        }
    }

    // MARK: - Unwind from Source View Controller
    @IBAction func unwindToDailyNewsFeed(_ segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? NewsSourceViewController, let sourceId = sourceVC.selectedItem?.category {
            let status = Reach().connectionStatus()
            isLanguageRightToLeft = sourceVC.selectedItem?.isoLanguageCode.direction == .rightToLeft
            switch status {
            case .unknown, .offline:
                self.showErrorWithDelay(NSLocalizedString("Your Internet Connection appears to be offline.", comment: "Your Internet Connection appears to be offline."))
            case .online(.wwan), .online(.wiFi):
                self.source = sourceId
                loadNewsData(source)
            }
        }
    }
}

extension DailyFeedNewsController {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        switch (traitCollection.verticalSizeClass, traitCollection.horizontalSizeClass) {
            
        case (.regular, .regular), (.compact, .regular), (.compact, .compact):
            collectionView?.collectionViewLayout.invalidateLayout()
            collectionView?.collectionViewLayout = DailySourceItemiPadLayout()
            
        default:
            collectionView?.collectionViewLayout.invalidateLayout()
            collectionView?.collectionViewLayout = DailySourceItemLayout()
            
        }
    }
}

extension DailyFeedNewsController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    
    // MARK: - DZNEmptyDataSet Delegate Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("No Content", comment: "No Content")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = NSLocalizedString("Connect to Internet or try another source.", comment: "Connect to Internet or try another source.")
        let attrs = [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "placeholder")
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

extension DailyFeedNewsController: UIViewControllerTransitioningDelegate {
    
    // MARK: - UIViewController Transitioning Delegate Methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.originFrame = selectedCell.superview!.convert(selectedCell.frame, to: nil)
        transition.presenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.presenting = false
        return transition
    }
}


