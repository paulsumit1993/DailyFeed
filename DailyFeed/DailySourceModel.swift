//
//  DailySourceModel.swift
//  DailyFeed
//
//  Created by TrianzDev on 30/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit

public struct DailySourceModel {
    
    public let id: String
    public let name: String
    public let category: String
    public let urlsToLogos: String
    
    public init?(json: [String: AnyObject]) {
        
        guard let id        = json["id"] as? String,
            let name      = json["name"] as? String,
            let category  = json["category"] as? String,
            let url       = json["urlsToLogos"] as? [String: AnyObject],
            let urlToLogo = url["medium"] as? String else { return nil}
        
        self.id          = id
        self.name        = name
        self.category    = category
        self.urlsToLogos = urlToLogo
        
    }
    
}

extension DailySourceModel {
    static func getNewsSource(_ completion: @escaping ([DailySourceModel]?, NSError?) -> Void) {
        
        let baseURL = URL(string: "https://newsapi.org/v1/sources?language=en")!
        
        let baseUrlRequest = URLRequest(url: baseURL)
        
        var newsItems = [DailySourceModel]()
        
        
        URLSession.shared.dataTask(with: baseUrlRequest, completionHandler: { (data, response, error) in
            
            guard error == nil else {
                completion(nil, error as NSError?)
                return
            }
            
            guard let data = data else {
                completion(nil, error as NSError?)
                return
            }
            
            if let jsonData =  try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) {
                
                if let json = jsonData as? [String: AnyObject], let jsonDict = json["sources"] as? [[String: AnyObject]] {
                    
                    newsItems = jsonDict.flatMap(DailySourceModel.init)
                    
                    completion(newsItems, nil)
                }
            }
            }) .resume()
    }
}
