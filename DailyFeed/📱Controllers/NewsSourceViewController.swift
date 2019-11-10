//
//  NewsSourceViewController.swift
//  DailyFeed
//
//  Created by Sumit Paul on 29/12/16.
//

import UIKit
import DZNEmptyDataSet
import PromiseKit

class NewsSourceViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    // MARK: - IBOutlets
    @IBOutlet weak var sourceTableView: UITableView!
    
    @IBOutlet weak var categoryButton: UIBarButtonItem!
    
    @IBOutlet weak var languageButton: UIBarButtonItem!
    
    // MARK: - Variable declaration
    var sourceItems: [DailySourceModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.sourceTableView.reloadSections([0], with: .automatic)
                self.setupSpinner(hidden: true)
            }
        }
    }
    
    var filteredSourceItems: [DailySourceModel] = [] {
        didSet {
            self.sourceTableView.reloadSections([0], with: .automatic)
        }
    }
    
    var selectedItem: DailySourceModel?
    
    var categories: [String] = []
    
    var languages: [String] = []
    
    var areFiltersPopulated: Bool = false

    /*
    var resultsSearchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.dimsBackgroundDuringPresentation = false
        controller.hidesNavigationBarDuringPresentation = true
        controller.searchBar.placeholder = NSLocalizedString("Search Sources...", comment: "Search Sources...")
        controller.searchBar.searchBarStyle = .minimal
        controller.searchBar.tintColor = .black
        controller.searchBar.sizeToFit()
        return controller
    }()  */
    
    let spinningActivityIndicator = TSSpinnerView()
    
    // MARK: - ViewController Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setup UI
        setupUI()
        self.navigationItem.rightBarButtonItems?.remove(at: 1) // hide lang button
        self.navigationItem.rightBarButtonItems?.remove(at: 0) // hide lang button
        //Populate TableView Data
        loadSourceData(nil, language: nil)
        //setup TableView
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //resultsSearchController.delegate = nil
        //resultsSearchController.searchBar.delegate = nil
    }

    // MARK: - Setup UI
    func setupUI() {
        
        setupSearch()
        
    }

    // MARK: - Setup SearchBar
    func setupSearch() {
        //resultsSearchController.searchResultsUpdater = self
        if #available(iOS 11.0, *) {
            //navigationItem.searchController = resultsSearchController
            navigationItem.hidesSearchBarWhenScrolling = true
        } else {
            //navigationItem.titleView = resultsSearchController.searchBar
        }
        //definesPresentationContext = true
    }

    // MARK: - Setup TableView
    func setupTableView() {
        sourceTableView.register(UINib(nibName: "DailySourceItemCell",bundle: nil), forCellReuseIdentifier: "DailySourceItemCell")
        sourceTableView.tableFooterView = UIView()
    }

    // MARK: - Setup Spinner
    func setupSpinner(hidden: Bool) {
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

    @IBAction func presentCategories(_ sender: Any) {
        let categoryActivityVC = UIAlertController(title: NSLocalizedString("Select a Category", comment: "Select a Category"),
                                                   message: nil,
                                                   preferredStyle: .actionSheet)

        let cancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"),
                                         style: .cancel,
                                         handler: nil)
        
        categoryActivityVC.addAction(cancelButton)

        _ = categories.map {
            let categoryButton = UIAlertAction(title: $0, style: .default, handler: { action in
                if let category = action.title {
                    self.loadSourceData(category, language: nil)
                }
            })
            categoryActivityVC.addAction(categoryButton)
        }
        
        // Popover for iPad only
        
        let popOver = categoryActivityVC.popoverPresentationController
        popOver?.barButtonItem = categoryButton
        popOver?.sourceRect = view.bounds
        self.present(categoryActivityVC, animated: true, completion: nil)
    }

    // MARK: - Show news language-s

    @IBAction func presentNewsLanguages(_ sender: UIBarButtonItem) {
        let languageActivityVC = UIAlertController(title: NSLocalizedString("Select a language", comment: "Select a language"),
                                                   message: nil,preferredStyle: .actionSheet)
        
        let cancelButton = UIAlertAction(title: NSLocalizedString("Cancel", comment: "Cancel"),
                                         style: .cancel, handler: nil)

        languageActivityVC.addAction(cancelButton)

        for lang in languages {
            let langStr: String = lang.languageStringFromISOCode
            if langStr == lang { continue }
            let languageButton = UIAlertAction(title: langStr, style: .default, handler: { _ in
                self.loadSourceData(nil, language: lang)
            })
            languageActivityVC.addAction(languageButton)
        }
        
        // Popover for iPad only
        
        let popOver = languageActivityVC.popoverPresentationController
        popOver?.barButtonItem = languageButton
        popOver?.sourceRect = view.bounds
        self.present(languageActivityVC, animated: true, completion: nil)
    }
    
    // MARK: - Load data from network
    func loadSourceData(_ category: String?, language: String?) {
        setupSpinner(hidden: false)
        firstly {
            NewsAPI.getNewsSource(category, language: language)
        }.done { result in
            self.sourceItems = result.sources
            // The code below helps in persisting category and language items till the view controller is de-allocated
            if !self.areFiltersPopulated {
                self.categories = Array(Set(result.sources.map { $0.category }))
                self.languages = Array(Set(result.sources.map { $0.isoLanguageCode }))
                if let lcode = Locale.current.languageCode, !self.languages.contains(lcode) {
                    self.languages.insert(lcode, at: 0)
                }
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
        //if self.resultsSearchController.isActive {
        //    return self.filteredSourceItems.count
        //} else {
            return self.sourceItems.count
        //}
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SourceCell",
                                                 for: indexPath) as? SourceTableCellTableViewCell

        //if self.resultsSearchController.isActive {
            //cell?.sourceImageView.downloadedFromLink(NewsAPI.getSourceNewsLogoUrl(source: filteredSourceItems[indexPath.row].sid))
        //} else {
            //cell?.sourceImageView.downloadedFromLink(NewsAPI.getSourceNewsLogoUrl(source: sourceItems[indexPath.row].sid))
        //}
        cell?.categoryLabel.text = //self.resultsSearchController.isActive ? filteredSourceItems[indexPath.row].description :
            sourceItems[indexPath.row].description
        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //if self.resultsSearchController.isActive {
        //    self.selectedItem = filteredSourceItems[indexPath.row]
        //} else {
            self.selectedItem = sourceItems[indexPath.row]
        //}
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
