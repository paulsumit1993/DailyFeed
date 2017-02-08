//
//  ViewController.swift
//  DailyFeed
//
//  Created by Sumit Paul on 27/12/16.
//

import UIKit

class DailyFeedNewsController: UICollectionViewController {

    // MARK: - Variable declaration

    var newsItems: [DailyFeedModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.performBatchUpdates({
                    self.collectionView?.reloadSections([0])
                }, completion: nil)
            }
        }
    }
    
    var newsSourceUrlLogo: String? {
        get {
            guard let defaultSourceLogo = UserDefaults(suiteName: "group.com.trianz.DailyFeed.today")?.string(forKey: "sourceLogo") else {
                return "http://i.newsapi.org/the-wall-street-journal-m.png"
            }

            return defaultSourceLogo
        }
        set {
            guard let newSource = newValue else { return }
            UserDefaults(suiteName: "group.com.trianz.DailyFeed.today")?.set(newSource, forKey: "sourceLogo")
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

    let spinningActivityIndicator = TSActivityIndicator()

    let refreshControl: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .black
        return refresh
    }()

    // MARK: - IBOutlets

    @IBOutlet weak var toggleButton: UIButton!

    // MARK: - View Controller Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup UI
        setupUI()

        //Populate CollectionView Data
        loadNewsData(source)
    }

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
        let sourceMenuButton = UIButton(type: .custom)
        sourceMenuButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        sourceMenuButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 55, bottom: 0, right: 0)
        sourceMenuButton.setImage(UIImage(named: "logo"), for: .normal)
        sourceMenuButton.imageView?.contentMode = .scaleAspectFit
        sourceMenuButton.addTarget(self, action: #selector(sourceMenuButtonDidTap), for: .touchUpInside)
        navigationItem.titleView = sourceMenuButton
    }

    // MARK: - Setup CollectionView
    func setupCollectionView() {
        collectionView?.register(UINib(nibName: "DailyFeedItemCell", bundle: nil),
                                 forCellWithReuseIdentifier: "DailyFeedItemCell")
        collectionView?.register(UINib(nibName: "DailyFeedItemListCell", bundle: nil),
                                 forCellWithReuseIdentifier: "DailyFeedItemListCell")
        collectionView?.collectionViewLayout = DailySourceItemLayout()
        collectionView?.addSubview(refreshControl)
        refreshControl.addTarget(self,
                                 action: #selector(DailyFeedNewsController.refreshData(_:)),
                                 for: UIControlEvents.valueChanged)
    }

    // MARK: - Setup Spinner
    func setupSpinner() {
        spinningActivityIndicator.setupTSActivityIndicator()
    }

    // MARK: - refresh news Source data
    func refreshData(_ sender: UIRefreshControl) {
        loadNewsData(self.source)
    }

    // MARK: - Load data from network
    func loadNewsData(_ source: String) {
        
        if !self.refreshControl.isRefreshing {
        setupSpinner()
        }

        spinningActivityIndicator.start()
        
        NewsAPI.getNewsItems(source) { (newsItem, error) in
            
            guard error == nil, let news = newsItem else {
                DispatchQueue.main.async {
                    self.spinningActivityIndicator.stop()
                    self.refreshControl.endRefreshing()
                    self.showError(error?.localizedDescription ?? "")
                }
                return
            }
            self.newsItems = news
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.spinningActivityIndicator.stop()
            }

        }
    }

    // MARK: - Toggle Layout
    @IBAction func toggleArticlesLayout(_ sender: UIButton) {

        switch collectionView?.collectionViewLayout {
        case is DailySourceItemLayout:
            toggleButton.setImage(UIImage(named: "grid"), for: .normal)
            switchCollectionViewLayout(for: DailySourceItemListLayout())

        default:
            toggleButton.setImage(UIImage(named: "list"), for: .normal)
            switchCollectionViewLayout(for: DailySourceItemLayout())
        }
    }

    // Helper method for switching layouts and changing collectionview background color
    func switchCollectionViewLayout(for layout: UICollectionViewLayout) {
        collectionView?.collectionViewLayout.invalidateLayout()
        UIView.animate(withDuration: 0.03) {
            self.collectionView?.setCollectionViewLayout(layout, animated: false)
            self.collectionView?.reloadItems(at: (self.collectionView?.indexPathsForVisibleItems)!)
        }
    }

    // MARK: - sourceMenuButton Action method

    func sourceMenuButtonDidTap() {
        self.performSegue(withIdentifier: "newsSourceSegue", sender: self)
    }

    // MARK: - Prepare for Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? NewsDetailViewController {

            guard let cell = sender as? UICollectionViewCell else { return }

            guard let indexpath = self.collectionView?.indexPath(for: cell) else { return }

                vc.receivedNewsItem = newsItems[indexpath.row]
                vc.receivedNewsSourceLogo = newsSourceUrlLogo
        }
    }

    // MARK: - Unwind from Source View Controller
    @IBAction func unwindToDailyNewsFeed(_ segue: UIStoryboardSegue) {
        if let sourceVC = segue.source as? NewsSourceViewController, let sourceId = sourceVC.selectedItem?.sid {
            self.newsSourceUrlLogo = sourceVC.selectedItem?.urlsToLogos
            self.source = sourceId
            loadNewsData(source)
        }
    }
}
