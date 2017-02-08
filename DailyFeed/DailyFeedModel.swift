//
//  DailyFeedModel.swift
//  DailyFeed
//
//  Created by Sumit Paul on 27/12/16.
//


//Data Model
struct DailyFeedModel: Equatable {

    public let title: String
    public let author: String
    public let publishedAt: String
    public let urlToImage: String
    public let description: String
    public let url: String

    public init?(json: JSONDictionary) {

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
    
    // Equatable Conformance
    
    static func ==(lhs: DailyFeedModel, rhs: DailyFeedModel) -> Bool {
        return lhs.title == rhs.title &&
        lhs.author == rhs.author &&
        lhs.publishedAt == rhs.publishedAt &&
        lhs.urlToImage == rhs.urlToImage &&
        lhs.description == rhs.description &&
        lhs.url == rhs.url
    }
}
