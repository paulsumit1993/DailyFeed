//
//  TodayViewController.swift
//  DailyToday
//
//  Created by Filippos Sakellaropoulos on 17/9/19.
//  Copyright © 2019 trianz. All rights reserved.
//

import UIKit
import PromiseKit
import NotificationCenter

class TodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NCWidgetProviding {
  
  @IBOutlet weak var tableView: UITableView!
  fileprivate var data: Array<DailyFeedModel> = Array()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
      if #available(iOSApplicationExtension 10.0, *) {
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
      }
      loadData(nil)
    }
  
  func numberOfTableRowsToDisplay() -> Int {
    if self.extensionContext?.widgetActiveDisplayMode == .expanded { return 5 }
    else {return 1 }
  }
        
  func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> (UIEdgeInsets) {
    return UIEdgeInsets.zero
  }
  
  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
      super.viewWillTransition(to: size, with: coordinator)

      let updatedVisibleCellCount = numberOfTableRowsToDisplay()
      let currentVisibleCellCount = self.tableView.visibleCells.count
      let cellCountDifference = updatedVisibleCellCount - currentVisibleCellCount

      // If the number of visible cells has changed, animate them in/out along with the resize animation.
      if cellCountDifference != 0 {
          coordinator.animate(alongsideTransition: { [unowned self] (UIViewControllerTransitionCoordinatorContext) in
              self.tableView.performBatchUpdates({ [unowned self] in
                  // Build an array of IndexPath objects representing the rows to be inserted or deleted.
                  let range = (1...abs(cellCountDifference))
                  let indexPaths = range.map({ (index) -> IndexPath in
                      return IndexPath(row: index, section: 0)
                  })

                  // Animate the insertion or deletion of the rows.
                  if cellCountDifference > 0 {
                      self.tableView.insertRows(at: indexPaths, with: .fade)
                  } else {
                      self.tableView.deleteRows(at: indexPaths, with: .fade)
                  }
              }, completion: nil)
          }, completion: nil)
      }
  }
 
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      // Open the main app at the correct page for the day tapped in the widget.
    if let appURL = URL(string: "dailyfeed://?index=\(indexPath.row)") {
          extensionContext?.open(appURL, completionHandler: nil)
      }

      // Don't leave the today extension with a selected row.
      tableView.deselectRow(at: indexPath, animated: true)
  }
  
  @available(iOSApplicationExtension 10.0, *)
  func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
    if activeDisplayMode == .expanded {
      preferredContentSize = CGSize(width: maxSize.width, height: 350)
    }
    else if activeDisplayMode == .compact {
      preferredContentSize =  maxSize
    }
  }
  typealias CompletionHandler = (NCUpdateResult) -> Void
  
    func widgetPerformUpdate(completionHandler: (@escaping CompletionHandler)) {
        // Perform any setup necessary in order to update the view.
      loadData(completionHandler)
    }
  
  func loadData(_ completionHandler: CompletionHandler?) {
      firstly {
         NewsAPI.getNewsItems(category: "general")
      }.done { result in
         DispatchQueue.main.async  {
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
          self.data = result.articles
          self.tableView.reloadData()
        guard let newsItem = result.articles.first else {
            completionHandler?(NCUpdateResult.failed)
            return
          }
        let prevTitle = UserDefaults.standard.string(forKey: "title")
        if prevTitle == newsItem.title  {
           completionHandler?(NCUpdateResult.noData)
           return
        }
        UserDefaults.standard.set(newsItem.title, forKey: "title")
        completionHandler?(NCUpdateResult.newData)
      }
      }.catch { _ in completionHandler?(NCUpdateResult.failed) }
  }

  
  // MARK: - TableView Data Source
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return numberOfTableRowsToDisplay()
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellIdentifier", for: indexPath)
    
    let newsItem = data.count>indexPath.row ? data[indexPath.row] : nil
    let imView = cell.contentView.viewWithTag(1) as! UIImageView
    let titleLabel = cell.contentView.viewWithTag(2) as! UILabel
    if let imageURL = newsItem?.urlToImage { TSImageView.downloadSimple(imageURL, for:imView) }
    titleLabel.text = newsItem?.title ?? ""
    //let newsArticleAuthorLabel = cell.contentView.viewWithTag(3) as! UILabel
    //newsArticleAuthorLabel.text = newsItem.author ?? ""
    return cell
  }
    
}
