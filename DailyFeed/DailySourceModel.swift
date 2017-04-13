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
    public let description: String

    public init?(json: JSONDictionary) {

      guard let sid               = json["id"] as? String,
            let name              = json["name"] as? String,
            let category          = json["category"] as? String,
            let description       = json["description"] as? String else { return nil }

        self.sid         = sid
        self.name        = name
        self.category    = category
        self.description = description
    }
    
    // Equatable Conformance

    static func ==(lhs: DailySourceModel, rhs: DailySourceModel) -> Bool {
        return lhs.sid == rhs.sid &&
        lhs.name == rhs.name &&
        lhs.category == rhs.category &&
        lhs.description == rhs.description
    }
}
