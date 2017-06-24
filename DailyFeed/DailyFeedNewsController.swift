//
//  ViewController.swift
//  DailyFeed
//
//  Created by Sumit Paul on 27/12/16.
//

import UIKit
import Lottie
import DZNEmptyDataSet

class DailyFeedNewsController: UICollectionViewController {

    // MARK: - Variable declaration

    var newsItems: [DailyFeedModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    var source: String {
        get {
            guard let defaultSource = UserDefaults(suiteName: "group.com.trianz.DailyFeed.today")?.string(forKey: "source") else {
                return "the-wall-street-journal"
            }

            return defaultSource
        }
        
        set {
           UserDefaults(suiteName: "group.com.trianz.DailyFeed.today")?.set(newValue, forKey: "source")
        }
    }

    let spinningActivityIndicator = TSSpinnerView()

    let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        return refresh
    }()
    
    var selectedIndexPath: IndexPath?

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
    
    let navBarSourceImage: TSImageView = {
        let image = TSImageView(frame: CGRect(x: 0, y: 0, width: 100, height: 36))
        return image
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Setup UI
    func setupUI() {
        setupNavigationBar()
        setupCollectionView()
    }

    // MARK: - Setup navigationBar
    func setupNavigationBar() {
        let sourceMenuButton = UIBarButtonItem(title: "Sources", style: .plain, target: self, action: #selector(sourceMenuButtonDidTap))
        //sourceMenuButton.tintColor = .white
        navigationItem.rightBarButtonItem = sourceMenuButton
        navBarSourceImage.downloadedFromLink(NewsAPI.fetchSourceNewsLogo(source: self.source), contentMode: .scaleAspectFit)
        navigationItem.titleView = navBarSourceImage
    }

    // MARK: - Setup CollectionView
    func setupCollectionView() {
        collectionView?.register(UINib(nibName: "DailyFeedItemCell", bundle: nil),
                                 forCellWithReuseIdentifier: "DailyFeedItemCell")
        collectionView?.collectionViewLayout = UIDevice.current.userInterfaceIdiom == .phone ? DailySourceItemLayout() : DailySourceItemiPadLayout()
        collectionView?.addSubview(refreshControl)
        refreshControl.addTarget(self,
                                 action: #selector(DailyFeedNewsController.refreshData(_:)),
                                 for: UIControlEvents.valueChanged)
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
           NewsAPI.getNewsItems(source, completion: { results in
                switch results {
                case .Success(let value):
                    self.newsItems = value.articles
                    DispatchQueue.main.async {
                    self.navBarSourceImage.downloadedFromLink(NewsAPI.fetchSourceNewsLogo(source: self.source), contentMode: .scaleAspectFit)
                    self.refreshControl.endRefreshing()
                    self.spinningActivityIndicator.stop()
                   }
                case .Failure(let error):
                    DispatchQueue.main.async {
                        self.spinningActivityIndicator.stop()
                        self.refreshControl.endRefreshing()
                        self.showError(error.localizedDescription)
                    }
                }
            })
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
            
                vc.receivedNewsItem = DailyFeedRealmModel.toDailyFeedRealmModel(from: newsItems[indexpath.row])
                vc.receivedItemNumber = indexpath.row + 1
                vc.receivedNewsSourceLogo = NewsAPI.fetchSourceNewsLogo(source: self.source)
            }
        }
    }

    // MARK: - Unwind from Source View Controller
    @IBAction func unwindToDailyNewsFeed(_ segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? NewsSourceViewController, let sourceId = sourceVC.selectedItem?.sid {
            let status = Reach().connectionStatus()
            switch status {
            case .unknown, .offline:
                self.showErrorWithDelay("Your Internet Connection appears to be offline.")
            case .online(.wwan), .online(.wiFi):
                self.source = sourceId
                loadNewsData(source)
            }
        }
    }
}


extension DailyFeedNewsController: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    
    // MARK: - DZNEmptyDataSet Delegate Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Content 😥"
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Connect to Internet or try another source."
        let attrs = [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)]
        return NSAttributedString(string: str, attributes: attrs)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "placeholder")
    }
    
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}

