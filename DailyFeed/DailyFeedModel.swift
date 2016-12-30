//
//  File.swift
//  DailyFeed
//
//  Created by TrianzDev on 27/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import Foundation

//Data Model
public struct DailyFeedModel {
    
    public let title: String
    public let author: String
    public let publishedAt: String
    public let urlToImage: String
    public let description: String
    public let url: String
    
    public init?(json: AnyObject) {
        
        guard let title = json["title"] as? String,
        let author      = json["author"] as? String,
        let publishedAt = json["publishedAt"] as? String,
        let urlToImage  = json["urlToImage"] as? String,
        let description = json["description"] as? String,
        let url         = json["url"] as? String else { return nil }
        
        self.title       = title
        self.author      = author
        self.publishedAt = publishedAt
        self.urlToImage  = urlToImage
        self.description = description
        self.url         = url
    }
    
}



extension DailyFeedModel {
    
    static func getNewsItems(source: String, completion: ([DailyFeedModel]?, NSError?) -> Void) {
        
        let baseURL = NSURL(string: "https://newsapi.org/v1/articles?source=\(source)&apiKey=53b8c0ba0ea24a199f790d660b73675f")!
        
        let baseUrlRequest = NSURLRequest(URL: baseURL)
        
        var newsItems = [DailyFeedModel]()
        
        
        NSURLSession.sharedSession().dataTaskWithRequest(baseUrlRequest) { (data, response, error) in
            
            if let jsonData =  try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) {
                
                if let json = jsonData as? [String: AnyObject], let jsonDict = json["articles"] as? NSArray {
                    
                    newsItems = jsonDict.flatMap(DailyFeedModel.init)
                    
                    completion(newsItems, nil)
                    
                }
            }
            }.resume()
    }
}