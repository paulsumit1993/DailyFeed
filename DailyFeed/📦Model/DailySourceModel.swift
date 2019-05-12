//
//  DailySourceModel.swift
//  DailyFeed
//
//  Created by Sumit Paul on 30/12/16.
//

//Data Model

struct Sources: Codable {
    public let sources: [DailySourceModel]
}

struct DailySourceModel: Codable {
    public let sid: String
    public let name: String
    public let category: String
    public let description: String
    public let isoLanguageCode: String
    public let country: String
    
    private enum CodingKeys: String, CodingKey {
        case sid = "id"
        case name, category, description, country
        case isoLanguageCode = "language"
    }
}
