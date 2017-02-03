//
//  DailySourceModel.swift
//  DailyFeed
//
//  Created by Sumit Paul on 30/12/16.
//

import UIKit

struct DailySourceModel: Equatable {

    public let sid: String
    public let name: String
    public let category: String
    public let urlsToLogos: String

    public init?(json: JSONDictionary) {

        guard let sid     = json["id"] as? String,
            let name      = json["name"] as? String,
            let category  = json["category"] as? String,
            let url       = json["urlsToLogos"] as? [String: AnyObject],
            let urlToLogo = url["medium"] as? String else { return nil }

        self.sid          = sid
        self.name        = name
        self.category    = category
        self.urlsToLogos = urlToLogo
    }
    
    // Equatable Conformance

    static func ==(lhs: DailySourceModel, rhs: DailySourceModel) -> Bool {
        return lhs.sid == rhs.sid &&
        lhs.name == rhs.name &&
        lhs.category == rhs.category &&
        lhs.urlsToLogos == rhs.urlsToLogos
    }
}

extension DailySourceModel {
    
    
    static func getNewsSource(_ category: String?, _ completion: @escaping ([DailySourceModel]?, Error?) -> Void) {

        guard let sourceURL = NewsAPI.sources(category: category).url else { return }

        let baseUrlRequest = URLRequest(url: sourceURL)
        
        let session = URLSession.shared


        session.dataTask(with: baseUrlRequest, completionHandler: { (data, response, error) in

            var sourceItems = [DailySourceModel]()

            guard error == nil else {
                completion(nil, error)
                return
            }

            guard let data = data else {
                completion(nil, error)
                return
            }

            if let jsonData =  try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                
                if let json = jsonData as? JSONDictionary, let jsonDict = json[NewsAPI.sources(category: nil).jsonKey] as? [JSONDictionary] {
                    
                    sourceItems = jsonDict.flatMap(DailySourceModel.init)
                }
            }
            
            completion(sourceItems, nil)
            
        }).resume()
    }
}
