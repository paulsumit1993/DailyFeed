//
//  DailySourceModel.swift
//  DailyFeed
//
//  Created by Sumit Paul on 30/12/16.
//

//Data Model
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
