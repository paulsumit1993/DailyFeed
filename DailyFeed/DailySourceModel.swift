//
//  DailySourceModel.swift
//  DailyFeed
//
//  Created by TrianzDev on 30/12/16.
//  Copyright © 2016 trianz. All rights reserved.
//

import UIKit

public struct DailySourceModel {

    public let sid: String
    public let name: String
    public let category: String
    public let urlsToLogos: String

    public init?(json: [String: AnyObject]) {

        guard let sid     = json["id"] as? String,
            let name      = json["name"] as? String,
            let category  = json["category"] as? String,
            let url       = json["urlsToLogos"] as? [String: AnyObject],
            let urlToLogo = url["medium"] as? String else { return nil}

        self.sid          = sid
        self.name        = name
        self.category    = category
        self.urlsToLogos = urlToLogo
    }
}

extension DailySourceModel {
    static func getNewsSource(_ category: String?, _ completion: @escaping ([DailySourceModel]?, NSError?) -> Void) {

        let sourceURL = NewsAPI.sources(category: category).url

        let baseUrlRequest = URLRequest(url: sourceURL)

        var newsItems = [DailySourceModel]()

        URLSession.shared.dataTask(with: baseUrlRequest, completionHandler: { (data, _, error) in

            guard error == nil else {
                completion(nil, error as NSError?)
                return
            }

            guard let data = data else {
                completion(nil, error as NSError?)
                return
            }

            if let jsonData =  try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {

                if let json = jsonData as? [String: AnyObject],
                    let jsonDict = json[NewsAPI.sources(category: nil).jsonKey] as? [[String: AnyObject]] {

                    newsItems = jsonDict.flatMap(DailySourceModel.init)

                    completion(newsItems, nil)
                }
            }
            }) .resume()
    }
}
