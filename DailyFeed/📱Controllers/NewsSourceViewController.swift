//
//  NewsSourceViewController.swift
//  DailyFeed
//
//  Created by Sumit Paul on 29/12/16.
//

import UIKit
import DZNEmptyDataSet
import PromiseKit
import PullToReach

class NewsSourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, PullToReach {
    
    var scrollView: UIScrollView {
        return sourceTableView
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak private var sourceTableView: UITableView!
    
    private lazy var categoryBarButton =
        UIBarButtonItem(image: R.image.filter(), style: .plain,
                        target: self, action: #selector(NewsSourceViewController.presentCategories))
    
    private lazy var languageBarButton =
        UIBarButtonItem(image: R.image.language(), style: .plain,
                        target: self, action: #selector(NewsSourceViewController.presentNewsLanguages))
    
    private lazy var countryBarButton =
        UIBarButtonItem(image: R.image.country(), style: .plain,
                        target: self, action: #selector(NewsSourceViewController.presentCountries))
    
    private lazy var closeBarButton =
        UIBarButtonItem(image: R.image.close(), style: .plain,
                        target: self, action: #selector(NewsSourceViewController.dismissViewController))
    
    // MARK: - Variable declaration
    private var sourceItems: [DailySourceModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.sourceTableView.reloadSections([0], with: .automatic)
                self.setupSpinner(hidden: true)
            }
        }
    }
    
    private var filteredSourceItems: [DailySourceModel] = [] {
        didSet {
            self.sourceTableView.reloadSections([0], with: .automatic)
        }
    }
    
    var selectedItem: DailySourceModel?
    
    private var categories: [String] = []
    
    private var languages: [String] = []
    
    private var countries: [String] = []
    
    private var areFiltersPopulated: Bool = false

    private var resultsSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = true
        controller.searchBar.placeholder = "Search Sources..."
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.sizeToFit()
        return controller
    }()
    
    private let spinningActivityIndicator = TSSpinnerView()
    
    // MARK: - ViewController Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSourceData(sourceRequestParams: NewsSourceParameters())
        setupPullToReach()
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
    private func setupUI() {
        setupSearch()
        setupTableView()
    }
    
    private func setupPullToReach() {
        self.navigationItem.rightBarButtonItems = [
            closeBarButton,
            categoryBarButton,
            languageBarButton,
            countryBarButton
        ]
        self.activatePullToReach(on: navigationItem)
    }

    // MARK: - Setup SearchBar
    private func setupSearch() {
        resultsSearchController.searchResultsUpdater = self
        if #available(iOS 11.0, *) {
            navigationItem.searchController = resultsSearchController
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            navigationItem.titleView = resultsSearchController.searchBar
        }
        definesPresentationContext = true
    }

    // MARK: - Setup TableView
    private func setupTableView() {
        sourceTableView.register(R.nib.dailySourceItemCell)
        sourceTableView.tableFooterView = UIView(frame: CGRect.init(x: 0, y: 0, width: sourceTableView.bounds.width, height: 50))
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
        self.sourceTableView.delegate = nil
        self.sourceTableView.dataSource = nil
    }

    // MARK: - Show News Categories

    @objc private func presentCategories() {
        let categoryActivityVC = UIAlertController(title: "Select a Category",
                                                   message: nil,
                                                   preferredStyle: .actionSheet)

        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        categoryActivityVC.addAction(cancelButton)

        _ = categories.map {
            let categoryButton = UIAlertAction(title: $0, style: .default, handler: { [weak self] action in
                if let category = action.title {
                    let newsSourceParams = NewsSourceParameters(category: category)
                    self?.loadSourceData(sourceRequestParams: newsSourceParams)
                }
            })
            categoryActivityVC.addAction(categoryButton)
        }
        
        // Popover for iPad only
        
        let popOver = categoryActivityVC.popoverPresentationController
        popOver?.barButtonItem = categoryBarButton
        popOver?.sourceRect = view.bounds
        self.present(categoryActivityVC, animated: true, completion: nil)
    }

    // MARK: - Show news languages

    @objc private func presentNewsLanguages() {
        let languageActivityVC = UIAlertController(title: "Select a language",
                                                   message: nil,
                                                   preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)

        languageActivityVC.addAction(cancelButton)

        for lang in languages {
            let languageButton = UIAlertAction(title: lang.languageStringFromISOCode, style: .default, handler: { [weak self] _ in
                let newsSourceParams = NewsSourceParameters(language: lang)
                self?.loadSourceData(sourceRequestParams: newsSourceParams)
            })
            languageActivityVC.addAction(languageButton)
        }
        
        // Popover for iPad only
        
        let popOver = languageActivityVC.popoverPresentationController
        popOver?.barButtonItem = languageBarButton
        popOver?.sourceRect = view.bounds
        self.present(languageActivityVC, animated: true, completion: nil)
    }
    
    @objc private func presentCountries() {
        let countriesActivityVC = UIAlertController(title: "Select a country",
                                                   message: nil,
                                                   preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler: nil)
        
        countriesActivityVC.addAction(cancelButton)
        
        for country in countries {
            let countryButton = UIAlertAction(title: country.formattedCountryDescription, style: .default, handler: { [weak self] _ in
                self?.countryBarButton.image = nil
                self?.countryBarButton.title = country.countryFlagFromCountryCode
                let newsSourceParams = NewsSourceParameters(country: country)
                self?.loadSourceData(sourceRequestParams: newsSourceParams)
            })
            countriesActivityVC.addAction(countryButton)
        }
        
        // Popover for iPad only
        
        let popOver = countriesActivityVC.popoverPresentationController
        popOver?.barButtonItem = countryBarButton
        popOver?.sourceRect = view.bounds
        self.present(countriesActivityVC, animated: true, completion: nil)
    }
    
    @objc private func dismissViewController() {
        self.performSegue(withIdentifier: "sourceUnwindSegue", sender: self)
    }
    
    // MARK: - Load data from network
    private func loadSourceData(sourceRequestParams: NewsSourceParameters) {
        setupSpinner(hidden: false)
        firstly {
            NewsAPI.getNewsSource(sourceRequestParams: sourceRequestParams)
        }.done { result in
            self.sourceItems = result.sources
            // The code below helps in persisting category and language items till the view controller is de-allocated
            if !self.areFiltersPopulated {
                self.categories = Array(Set(result.sources.map { $0.category }))
                self.languages = Array(Set(result.sources.map { $0.isoLanguageCode }))
                self.countries = Array(Set(result.sources.map { $0.country }))
                self.areFiltersPopulated = true
            }
        }.ensure {
            self.setupSpinner(hidden: true)
        }.catch { err in
            self.showError(err.localizedDescription) { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    // MARK: - Status Bar Color and switching actions
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }

    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultsSearchController.isActive {
            return self.filteredSourceItems.count
        } else {
            return self.sourceItems.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.dailySourceItemCell, for: indexPath)
        if self.resultsSearchController.isActive {
            cell?.sourceImageView.downloadedFromLink(NewsAPI.getSourceNewsLogoUrl(source: filteredSourceItems[indexPath.row].sid))
        } else {
            cell?.sourceImageView.downloadedFromLink(NewsAPI.getSourceNewsLogoUrl(source: sourceItems[indexPath.row].sid))
        }
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.resultsSearchController.isActive {
            self.selectedItem = filteredSourceItems[indexPath.row]
        } else {
            self.selectedItem = sourceItems[indexPath.row]
        }
        self.performSegue(withIdentifier: "sourceUnwindSegue", sender: self)
    }
    
  
    // MARK: - SearchBar Delegate

    func updateSearchResults(for searchController: UISearchController) {

        filteredSourceItems.removeAll(keepingCapacity: false)

        if let searchString = searchController.searchBar.text {
            let searchResults = sourceItems.filter { $0.name.lowercased().contains(searchString.lowercased()) }
            filteredSourceItems = searchResults
        }
    }
}
